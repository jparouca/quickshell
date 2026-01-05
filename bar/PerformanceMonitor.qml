import QtQuick
import QtQuick.Layouts
import "../config" as C

RowLayout {
  id: root
  spacing: 8

  RamUsage {
    id: ramUsage
  }

  CpuUsage {
    id: cpuUsage
  }

  Temperature {
    id: temperature
  }
}
