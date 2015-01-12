import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtPositioning 5.0

Page {
    id: page;

    property alias deviceLat: map.currentPositionLat
    property alias deviceLon: map.currentPositionLon


    PageHeader {
        id: pageHeader;
        //% "Map"
        title: qsTrId("map-title")
    }


    PinchMap {

        id: map
        anchors.top: pageHeader.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        clip: true;
        pageActive: (page.status === PageStatus.Active)

    }


    //    PositionSource {
    //        id: positionSource
    //        updateInterval: 1000
    //        active: true;
    //        onPositionChanged: {
    //            var coord = position.coordinate;
    //            map.currentPositionLat = coord.latitude;
    //            map.currentPositionLon = coord.longitude;
    //            map.currentPositionValid = position.latitudeValid
    //        }
    //    }

    function reload(d) {
        if (d.places !== undefined) {
            map.places.clear();
            var places = d.places;
            for (var i = 0; i < places.length; i++) {
                var item = places[i];
                map.places.append(item);
            }
        }
    }


}
