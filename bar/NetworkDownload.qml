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
    color: C.Config.theme.on_background
    iconSize: 15
    text: "download"
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: S.SystemState.networkD
    color: C.Config.theme.on_background
  }
}
