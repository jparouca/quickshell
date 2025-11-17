import QtQuick
import QtQuick.Layouts
import "../config" as C
import "../state" as S
import "../commonwidgets" as CW
import "../popup" as P

BarButton {
  id: root

  leftPadding: 7
  rightPadding: leftPadding

  function togglePopup() {
    popup.show = !popup.show;
  }

  onClicked: root.togglePopup()

  RowLayout {
    CW.FontIcon {
      text: "edit_note"
    }

    CW.StyledText {
      Layout.fillWidth: true
      text: S.OneThingState.note || "One thing..."
      elide: Text.ElideRight
      opacity: S.OneThingState.note ? 1.0 : 0.6
    }
  }

  P.PopupHandle {
    id: popup
    reloadableId: "oneThingHandle"

    delegate: P.PopupDelegate {
      owner: root
      hoverable: true
      grab: true
      maxContentHeight: 180

      Rectangle {
        implicitWidth: input.contentWidth + 28
        implicitHeight: 24
        radius: 4
        color: C.Config.applySecondaryOpacity(C.Config.theme.surface_container_low)

        TextInput {
          id: input
          anchors.fill: parent
          anchors.margins: 0
          text: S.OneThingState.note
          color: C.Config.theme.on_surface
          font.pointSize: C.Config.fontSize.normal
          verticalAlignment: TextInput.AlignVCenter
          selectByMouse: true

          onTextChanged: {
            S.OneThingState.note = text;
          }

          onAccepted: {
            popup.show = false;
          }

          Component.onCompleted: {
            if (popup.visible) {
              forceActiveFocus();
              selectAll();
            }
          }

          CW.StyledText {
            visible: input.text.length === 0
            anchors.fill: parent
            text: "one thing"
            opacity: 0.5
            verticalAlignment: Text.AlignVCenter
          }
        }

        Connections {
          target: popup
          function onVisibleChanged() {
            if (popup.visible) {
              input.forceActiveFocus();
              input.selectAll();
            }
          }
        }
      }
    }
  }
}
