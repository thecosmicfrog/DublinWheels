WorkerScript.onMessage = function(sentMessage) {
    var apiKey = sentMessage.apiKey;
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var parsedMsg;
    var stations = [];

    xmlHttp.open("GET", "https://api.jcdecaux.com/vls/v1/stations?contract=Dublin&apiKey=" + apiKey, true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;

            // Parse response text to usable object.
            parsedMsg = JSON.parse(msg);

            if (typeof parsedMsg != "undefined") {
                for (var i = 0; i < parsedMsg.length; i++) {
                    stations.push(parsedMsg[i]);
                }

                stations.sort(compare);
                WorkerScript.sendMessage({'stations': stations});
            }
        }
    }
}

function compare(a, b) {
    if (a.name < b.name)
        return -1;
    if (a.name > b.name)
        return 1;

    return 0;
}
