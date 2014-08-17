import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

ToolbarItems {
    ToolbarButton {
        id: aboutButton

        action: Action {
            text: "About"
            iconSource: "../img/about_icon.svg"
            onTriggered: PopupUtils.open(aboutComponent, aboutButton)
        }
    }

    Component {
        id: aboutComponent

        Popover {
            id: aboutPopover

            Label {
                text: ""
                wrapMode: Text.WordWrap

                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.gu(1)
                }
            }
        }
    }
}
