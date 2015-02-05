import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0

Page {
    id: page;

    property alias deviceLat: map.currentPositionLat
    property alias deviceLon: map.currentPositionLon
    property alias mapWidget: map;


    property bool map_visible: false;

    signal showDetail(string name, string description, url icon, double lat, double lon);

    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: map_visible ? page.height : (pageHeader.height + listColumn.height)

        PullDownMenu {
            MenuItem {
                text: map_visible ?
                          //% "List"
                          qsTrId("map-page-list") :
                          //% "Map"
                          qsTrId("map-page-map")
                onClicked: {
                    map_visible = !map_visible;
                }
            }
        }

        PageHeader {
            id: pageHeader;
            //% "Places"
            title: qsTrId("map-title")
        }

        Column {
            id: listColumn
            anchors.top: pageHeader.bottom;
            visible: !map_visible;
            width: page.width


            Repeater {
                model: map.places;
                delegate: BackgroundItem {
                    id: delegate;
                    width: page.width
                    height: Theme.itemSizeSmall
                    Image {
                        id: placesDelegate
                        anchors.left: parent.left;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.margins: Theme.paddingSmall;
                        source: model.icon;
                        smooth: true
                        width: Theme.iconSizeMedium;
                        height: Theme.iconSizeMedium;
                        fillMode: Image.PreserveAspectFit

                    }
                    Image {
                        anchors.centerIn: placesDelegate;
                        source: "./images/marker-icon.png"
                        visible:( placesDelegate.status !== Image.Ready)
                        width: Theme.iconSizeMedium;
                        height: Theme.iconSizeMedium;
                        fillMode: Image.PreserveAspectFit
                    }


                    Label {
                        anchors.left: placesDelegate.right
                        anchors.right: parent.right;
                        anchors.top: parent.top;
                        anchors.bottom: parent.bottom;
                        verticalAlignment: Text.AlignVCenter;
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.family: Theme.fontFamily

                        wrapMode: Text.Wrap;
                        text: model.name;
                    }
                    onClicked: {
                        showDetail(model.name, model.description, model.icon, model.lat, model.lon);
                        map.latitude = lat;
                        map.longitude = lon;

                    }
                }
            }
        }


        PinchMap {

            id: map
            anchors.top: pageHeader.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            clip: true;
            visible: map_visible;
            pageActive: map_visible && (page.status === PageStatus.Active)

            onMapItemClicked: {

                remorse.execute(name, function() {
                    showDetail(name, description, icon, lat, lon);
                    map.latitude = lat;
                    map.longitude = lon;
                })

            }

        }
    }

    RemorsePopup {
        id: remorse;
    }


    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true;
        onPositionChanged: {
            var coord = position.coordinate;
            map.currentPositionLat = coord.latitude;
            map.currentPositionLon = coord.longitude;
            map.currentPositionValid = position.latitudeValid
        }
    }

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
