WorkerScript.onMessage = function(sentMessage) {
    var stationName = sentMessage.station;
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var stationInfo;

    xmlHttp.open("GET", "http://api.citybik.es/dublinbikes.json", true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;

            // Parse response text to usable object.
            stationInfo = JSON.parse(msg);

            if (typeof stationInfo != "undefined") {
                for (var i = 0; i < stationInfo.length; i++) {
                    if (stationInfo[i].name === stationName) {
                        WorkerScript.sendMessage({'stationInfo': stationInfo[i]});
                    }
                }
            }
        }
    }
}
