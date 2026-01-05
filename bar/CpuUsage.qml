import QtQuick
import QtQuick.Layouts
import "../config" as C
import "../commonwidgets" as CW
import "../state" as S

RowLayout {
  id: root
  spacing: 2

  property color color: {
    if (S.SystemState.cpu >= 90) return C.Config.theme.error;
    if (S.SystemState.cpu >= 70) return C.Config.theme.tertiary;
    return C.Config.theme.on_background;
  }

  CW.FontIcon {
    Layout.alignment: Qt.AlignVCenter
    color: root.color
    iconSize: 15
    text: "developer_board"
  }

  CW.StyledText {
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    text: `${S.SystemState.cpu}%`
    color: root.color
  }
}
