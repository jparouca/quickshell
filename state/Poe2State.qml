pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string divinePrice: "..."
  property bool isLoading: false

  Process {
    id: apiProc
    running: false
    command: ["sh", "-c", "curl -s -H 'User-Agent: POE2-Quickshell/1.0' 'https://poe2scout.com/api/items/landingSplashInfo' | jq -r '.items[] | select(.text == \"Divine Orb\") | [.priceLogs[] | select(type == \"object\")] | .[0].price'"]

    stdout: SplitParser {
      splitMarker: ""
      onRead: data => {
        const price = parseFloat(data.trim());
        if (isNaN(price)) {
          console.log("POE2: Failed to parse price: " + data);
          divinePrice = "ERR";
        } else {
          divinePrice = price.toFixed(2);
          console.log("POE2: Updated Divine price to " + divinePrice + " ex");
        }
        isLoading = false;
      }
    }

    onExited: (exitCode, exitStatus) => {
      if (exitCode !== 0) {
        console.log("POE2: API fetch failed with exit code " + exitCode);
        divinePrice = "ERR";
      }
      isLoading = false;
    }
  }

  // Initial load
  Timer {
    running: divinePrice == "..."
    interval: 100
    repeat: false
    onTriggered: {
      if (!apiProc.running) {
        isLoading = true;
        apiProc.running = true;
      }
    }
  }

  // Refresh every 2 minutes
  Timer {
    repeat: true
    running: true
    interval: 1000 * 60 * 2  // 2 minutes

    onTriggered: {
      if (!apiProc.running) {
        isLoading = true;
        apiProc.running = true;
      }
    }
  }
}
