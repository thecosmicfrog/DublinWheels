WorkerScript.onMessage = function(sentMessage) {
    var stationName = sentMessage.station;
    var apiKey = sentMessage.apiKey;
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var stationInfo;

    xmlHttp.open("GET", "https://api.jcdecaux.com/vls/v1/stations?contract=Dublin&apiKey=" + apiKey, true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;

            // Parse response text to usable object.
            stationInfo = JSON.parse(msg);

            if (typeof stationInfo != "undefined") {
                for (var i = 0; i < stationInfo.length; i++) {
                    if (stationInfo[i].address === stationName) {
                        WorkerScript.sendMessage({'stationInfo': stationInfo[i]});
                    }
                }
            }
        }
    }
}
