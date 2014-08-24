import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db
import "ui"

MainView {
    objectName: "mainView"

    applicationName: "org.thecosmicfrog.dublinwheels"

    //automaticOrientation: true

    width: units.gu(44)
    height: units.gu(78)

    function getArray(obj) {
        var arr = [];

        for (var i = 0; i < obj.length; i++) {
            arr.push(obj[i]);
        }

        return arr;
    }

    function getLastStationIndex(lastStation, stationsModel) {
        for (var i = 0; i < stationsModel.count; i++) {
            if (lastStation === stationsModel.get(i).name)
                return i;
        }

        return 0;
    }

    // U1DB backend to record the last-picked station. Makes it faster for users to get information for their usual station.
    U1db.Database {
        id: db;
        path: "dublinwheels.u1db"
    }

    U1db.Document {
       id: lastStation
       database: db
       docId: "lastStation"
       create: true
       defaults: {
           stationName: ""
       }
    }

    MainPage {
    }
}
