import QtQuick
import QtQuick.Layouts
import "../config" as C
import "../commonwidgets" as CW
import "../state" as S

RowLayout {
  id: root
  spacing: 2
  visible: S.SystemState.gamemodeActive

  CW.FontIcon {
    Layout.alignment: Qt.AlignVCenter
    color: C.Config.theme.on_background
    iconSize: 15
    text: "gamepad"
  }
}
