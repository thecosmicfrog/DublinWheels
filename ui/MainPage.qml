import QtQuick 2.0
import Ubuntu.Components 0.1
import QtLocation 5.0
import QtPositioning 5.2

Page {
    title: i18n.tr("DublinWheels")

    // Always begin by loading the selected stop.
    Component.onCompleted: {
        activityIndicator.running = true
        stationSelector.selectedIndex = getLastStationIndex(lastStation.contents.stationName, stationsModel)
        queryStationsWorker.sendMessage({'station': stationsModel.get(stationSelector.selectedIndex).name})
    }

    WorkerScript {
        id: queryBikesWorker
        source: "../js/getbikes.js"

        onMessage: {
            bikesAvailableLabel.font.pointSize = 28;
            bikesAvailableLabel.text = "<b>" + messageObject.stationInfo.bikes + "</b><br>Bikes";

            spotsAvailableLabel.font.pointSize = 28;
            spotsAvailableLabel.text = "<b>" + messageObject.stationInfo.free + "</b><br>Spots";

            activityIndicator.running = false
        }
    }

    WorkerScript {
        id: queryStationsWorker
        source: "../js/getstations.js"

        onMessage: {
            for (var i = 0; i < messageObject.stations.length; i++) {
                stationsModel.append({ "name": messageObject.stations[i], "description": "" })
            }
        }
    }

    Row {
        id: stationRow

        spacing: -20

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(1)
            margins: units.gu(2)
        }

        OptionSelector {
            id: stationSelector
            text: "<h2>Select Station:</h2>"
            containerHeight: units.gu(21.5)
            expanded: false
            model: stationsModel

            delegate: OptionSelectorDelegate {
                text: name
                subText: description
            }

            onSelectedIndexChanged: {
                activityIndicator.running = true
                queryBikesWorker.sendMessage({'station': stationsModel.get(stationSelector.selectedIndex).name})

                // Save station to U1DB backend for faster access on next app start.
                lastStation.contents = {stationName: stationsModel.get(stationSelector.selectedIndex).name}
            }
        }

        ActivityIndicator {
            id: activityIndicator
        }

        ListModel {
            id: stationsModel
            ListElement { name: "Select a station..."; description: ""; }
        }
    }

    Row {
        id: availabilityRow

        spacing: 5

        anchors {
            left: parent.left
            right: parent.right
            top: stationRow.bottom
            topMargin: units.gu(2)

            margins: units.gu(2)
        }

        UbuntuShape {
            id: bikesAvailable
            width: parent.width / 2
            height: units.gu(16)
            radius: "medium"
            color: "#7dc242"

            Label {
                id: bikesAvailableLabel
                text: ""
                color: "white"

                anchors.centerIn: parent
            }
        }

        UbuntuShape {
            id: spotsAvailable
            width: parent.width / 2
            height: units.gu(16)
            radius: "medium"
            color: "#add8e6"

            Label {
                id: spotsAvailableLabel
                text: ""
                color: "white"

                anchors.centerIn: parent
            }
        }
    }

    Item {
        id: mapRow

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: availabilityRow.bottom

            topMargin: units.gu(1)

            margins: units.gu(1)
        }

        Map {
            id: map

            anchors {
                fill: parent
            }

            center: QtPositioning.coordinate(53.35,-6.26)
            zoomLevel: 13

            plugin: Plugin { name: "osm" }
        }
    }

    tools: Toolbar {
        ToolbarButton {
            id: reloadButton

            text: "Reload"
            iconSource: "../img/reload.png"
            onTriggered: {
                activityIndicator.running = true
                queryBikesWorker.sendMessage({'station': stationsModel.get(stationSelector.selectedIndex).name})
            }
        }
    }
}
