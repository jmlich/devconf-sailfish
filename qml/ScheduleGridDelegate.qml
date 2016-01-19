import QtQuick 2.0
import Sailfish.Silica 1.0



BackgroundItem {
    id: scheduleGridDelegate

    property int startTime;
    property int endTime;
//    property alias roomShort: roomLabel.text;
    property alias roomColor: roomColorLabel.color;
    property string speakers_str;
    property string topic;
    property int currentTimestamp;
    property bool inFavorites: false;

    clip: true;
    Rectangle {
        anchors.fill: parent;
        color: "transparent"
        border.color: inFavorites ? Qt.lighter(Theme.highlightColor) : "transparent";

    }


    Label {
        id: roomColorLabel
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium
        color: Theme.primary_color
        font.pointSize: Theme.fontSizeSmall
        font.family: Theme.fontFamilyHeading
        font.weight: Font.Bold
        text: "|"
    }

    Label {
        anchors.left: roomColorLabel.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: Theme.paddingMedium
        font.pointSize: Theme.fontSizeSmall

        text: (speakers_str !== "") ? (speakers_str + ": " + topic) : topic
        color: (currentTimestamp > endTime)
               ? (scheduleGridDelegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)
                 : (scheduleGridDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor)
        wrapMode: Text.Wrap;
        textFormat: Text.RichText;

    }


}
