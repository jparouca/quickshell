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
    text: "memory"
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: `${S.SystemState.ram}%`
    color: C.Config.theme.on_background
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: S.SystemState.swap > 0 ? `(${S.SystemState.swap}%)` : ""
    color: C.Config.theme.tertiary
    font.pointSize: C.Config.fontSize.normal * 0.85
    visible: S.SystemState.swap > 0
  }
}
