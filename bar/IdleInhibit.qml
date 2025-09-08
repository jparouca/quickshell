import QtQuick
import QtQuick.Layouts
import "../config" as C
import "../commonwidgets" as CW
import "../state" as S

RowLayout {
  id: root
  spacing: 2

  CW.FontIcon {
    Layout.alignment: Qt.AlignVCenter
    color: S.SystemState.hypridleRunning ? C.Config.theme.on_background : C.Config.theme.error
    iconSize: 15
    text: "sleep"
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: S.SystemState.hypridleRunning ? "" : "!"
    color: C.Config.theme.error
    visible: !S.SystemState.hypridleRunning
  }
}