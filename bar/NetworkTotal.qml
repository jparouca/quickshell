import QtQuick
import QtQuick.Layouts
import "../config" as C
import "../commonwidgets" as CW
import "../state" as S

MouseArea {
  id: mouseArea
  acceptedButtons: Qt.RightButton
  hoverEnabled: true

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  onClicked: {
    S.SystemState.resetNetworkTotal();
  }

  RowLayout {
    id: row
    spacing: 2

    CW.FontIcon {
      Layout.alignment: Qt.AlignVCenter
      color: C.Config.theme.on_background
      iconSize: 15
      text: "data_usage"
    }

    CW.StyledText {
      Layout.alignment: Qt.AlignVCenter
      Layout.fillHeight: true
      text: S.SystemState.networkTotal
      color: C.Config.theme.on_background
    }
  }
}
