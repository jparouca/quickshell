pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as C

Singleton {
  id: root

  property string note: ""

  // Load and save note from/to file
  readonly property string notePath: {
    const xdgData = Quickshell.env("XDG_DATA_HOME") || (Quickshell.env("HOME") + "/.local/share");
    return xdgData + "/quickshell/onething.txt";
  }

  Component.onCompleted: {
    loadNote();
  }

  onNoteChanged: {
    saveNote();
  }

  function loadNote() {
    const proc = new Process();
    proc.command = ["cat", notePath];
    proc.finished.connect(() => {
      if (proc.exitCode === 0) {
        note = proc.stdout.trim();
      }
    });
    proc.start();
  }

  function saveNote() {
    const proc = new Process();
    proc.command = ["sh", "-c", "mkdir -p \"$(dirname '" + notePath + "')\" && echo \"" + note.replace(/"/g, "\\\"") + "\" > '" + notePath + "'"];
    proc.start();
  }
}
