import QtQuick
import QtQuick.Layouts
import Quickshell
import "../config" as C
import "../state" as S
import "../commonwidgets" as CW

RowLayout {
  id: root
  spacing: 3

  Image {
    source: "../assets/exalt-orb.svg"
    Layout.preferredWidth: 16
    Layout.preferredHeight: 16
    sourceSize.width: 16
    sourceSize.height: 16
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: S.Poe2State.divinePrice + " ex"
    color: C.Config.theme.on_surface
  }
}
