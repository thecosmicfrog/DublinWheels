
WorkerScript.onMessage = function(sentMessage) {
    var xmlHttp = new XMLHttpRequest();
    var msg;
    var parsedMsg;
    var stations = [];

    xmlHttp.open("GET", "http://api.citybik.es/dublinbikes.json", true);
    xmlHttp.send(null);

    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            msg = xmlHttp.responseText;

            // Parse response text to usable object.
            parsedMsg = eval("(" + msg + ")");

            if (typeof parsedMsg != "undefined") {
                for (var i = 0; i < parsedMsg.length; i++) {
                    stations.push(parsedMsg[i].name);
                }

                stations.sort();
                WorkerScript.sendMessage({'stations': stations});
            }
        }
    }
}
