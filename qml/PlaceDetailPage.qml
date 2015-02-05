import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property alias name: title_label.text
    property string description;
    property alias image: placesDelegate.source;
    property double lat
    property double lon

    signal showOnMap();


    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: pageHeader.height + title_label.height + description_label.height + Theme.paddingSmall + 2 * Theme.paddingMedium;
        PullDownMenu {
            MenuItem {
                //% "Show on map"
                text: qsTrId("place-detail-menu-show-on-map");
                onClicked: {
                    showOnMap();
                }
            }
            MenuItem {
                //% "Navigate to"
                text: qsTrId("place-detail-menu-navigate-to");
                onClicked: {
                    Qt.openUrlExternally("geo:"+lat+","+lon)
                }
            }
        }

        PageHeader {
            id: pageHeader
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.left: parent.left;
            //% "Place"
            title: qsTrId("place-detail-header-place")
        }

        Image {
            id: placesDelegate
            anchors.left: parent.left;
            anchors.verticalCenter: title_label.verticalCenter;

            anchors.margins: Theme.paddingSmall;
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
            id: title_label
            anchors.margins: Theme.paddingSmall;
            anchors.top: pageHeader.bottom;
            anchors.left: placesDelegate.right;
            anchors.right: parent.right
            wrapMode: Text.Wrap;
            color: Theme.primaryColor
            verticalAlignment: Text.AlignVCenter;
            font.pixelSize: Theme.fontSizeLarge;
            font.family: Theme.fontFamily


        }

        Label {
            id: description_label;
            anchors.margins: Theme.paddingMedium;
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title_label.bottom
            color: Theme.secondaryColor
            wrapMode: Text.Wrap;
            font.pixelSize: Theme.fontSizeMedium;
            font.family: Theme.fontFamily

            textFormat: Text.RichText;
            text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; } a:visited{color:"+Theme.primaryHighlightColor+"}</style>  "+ description
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }

        }

    }
}
