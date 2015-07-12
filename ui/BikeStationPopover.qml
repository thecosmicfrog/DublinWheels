import QtQuick 2.0
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent

    Popover {
        id: stationPopover

        height: parent.height * 0.4

        Column {
            id: stationColumn

            anchors {
                left: parent.left
                right: parent.right
            }

            ListItem.Header {
                text: name
            }

            ListItem.Standard {
                text: bikes + " bikes available"
            }

            ListItem.Standard {
                text: free + " free spots available"
            }

            ListItem.SingleControl {
                highlightWhenPressed: false

                control: Button {
                    text: "Close"
                    onClicked: PopupUtils.close(stationPopover)
                }
            }
        }
    }
}
