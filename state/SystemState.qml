pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string host
  property string uptime
  property string username
  property real ram
  property real swap
  property real cpu
  property string networkD
  property string networkU
  property string networkTotal: netTotalToString(networkTotalBytes)
  property real networkTotalBytes: networkStats.totalBytes
  property string temp
  property string osString
  property bool gamemodeActive: false
  property bool hypridleRunning: false

  function setHypridleStatus(enable) {
    if (enable)
      Quickshell.execDetached(["hypridle"])
    else
      Quickshell.execDetached(["bash", "-c", "killall -9 hypridle"]);
  }

  function netSpeedToInt(input) {
    let bytes = 0;
    if (input[input.length - 1] == 'K')
      bytes = parseInt(input.substr(0, input.length - 1)) * 1000;
    else if (input[input.length - 1] == 'M')
      bytes = parseInt(input.substr(0, input.length - 1)) * 1e+06;
    else
      bytes = parseInt(input);
    return bytes;
  }

  function netSpeedToString(bytes) {
    let str = "";
    if (bytes > 1e+06)
      str = (parseInt(bytes / 100000) / 10) + "M";
    else if (bytes > 1000)
      str = (parseInt(bytes / 100) / 10) + "K";
    else
      str = (bytes) + "B";
    return str;
  }

  function netTotalToString(bytes) {
    let str = "";
    if (bytes > 1e+09)
      str = (parseInt(bytes / 1e+08) / 10) + "GB";
    else if (bytes > 1e+06)
      str = (parseInt(bytes / 100000) / 10) + "MB";
    else if (bytes > 1000)
      str = (parseInt(bytes / 100) / 10) + "KB";
    else
      str = (bytes) + "B";
    return str;
  }

  function resetNetworkTotal() {
    networkTotalBytes = 0;
    networkStats.totalBytes = 0;
  }

  function saveNetworkStats() {
    networkStats.totalBytes = networkTotalBytes;
  }

  Process {
    command: ["cat", "/etc/hostname"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return host = data;
      }
    }
  }

  Process {
    command: ["whoami"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return username = data;
      }
    }
  }

  Process {
    command: ["cat", "/etc/os-release"]
    running: true

    stdout: SplitParser {
      splitMarker: ""
      onRead: data => {
        const lines = data.split("\n");
        for (let l of lines) {
          if (l.indexOf("NAME") == -1)
            continue;

          const first = l.indexOf("\"");
          osString = l.substr(first + 1, l.indexOf("\"", first + 1) - first - 1);

          break;
        }
      }
    }
  }

  Process {
    id: uptimeProc

    command: ["uptime", "-p"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return uptime = data;
      }
    }
  }

  Process {
    id: cpuProc

    command: ["bash", "-c", "top -bn1 | grep '%Cpu' | tail -1 | awk '{print 100-$8}'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return cpu = Math.round(parseInt(data));
      }
    }
  }

  Process {
    id: ramProc

    command: ["bash", "-c", "free | grep Mem | awk '{print int($3/$2 * 100.0)}'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return ram = data;
      }
    }
  }

  Process {
    id: swapProc

    command: ["bash", "-c", "free | grep Swap | awk '{if ($2 > 0) print int($3/$2 * 100.0); else print 0}'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return swap = data;
      }
    }
  }

  Process {
    id: networkProc

    command: ["bash", "-c", "ifstat -t 1"]
    running: true

    stdout: SplitParser {
      splitMarker: ""
      onRead: data => {
        let speedstrs = data.split('\n');
        // drop the first three as they are labels
        speedstrs = speedstrs.slice(3);
        let up = 0;
        let down = 0;
        for (let line of speedstrs) {
          let split = line.split(' ').filter(i => {
            return i;
          });
          if (!isNaN(split[0]))
            continue;

          if (split[5] == undefined)
            continue;

          down += netSpeedToInt(split[5]);
          up += netSpeedToInt(split[7]);
        }
        networkD = `${netSpeedToString(down)}`;
        networkU = `${netSpeedToString(up)}`;

        // Accumulate total bytes (down + up)
        networkTotalBytes += down + up;

        return true;
      }
    }
  }

  Process {
    id: tempProc

    command: ["bash", "-c", "sensors | grep -E '(^Tctl)|(^Core [0-9]+:)' | sed -s -E 's/Core\ [0-9]+:/temp:/g' | awk '{gsub(/[+°C]/,\"\"); print $2}' | sort -nr | head -n 1"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        return temp = Math.round(parseInt(data));
      }
    }
  }

  Process {
    id: gamemodeProc

    command: ["gamemoded", "-s"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        gamemodeActive = data.includes("is active");
      }
    }
  }

  Process {
    id: hypridleProc

    command: ["pgrep", "hypridle"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        hypridleRunning = data.trim().length > 0;
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: () => {
      networkProc.running = true;
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: () => {
      ramProc.running = true;
      swapProc.running = true;
      cpuProc.running = true;
      tempProc.running = true;
      gamemodeProc.running = true;
      hypridleProc.running = true;
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: () => {
      uptimeProc.running = true;
    }
  }

  // Save network stats every 30 seconds
  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: () => {
      saveNetworkStats();
    }
  }

  FileView {
    path: Quickshell.dataPath("network-stats.json")

    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    onLoadFailed: error => {
      if (error == FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: networkStats
      property real totalBytes: 0
    }
  }
}
