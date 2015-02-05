import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

BackgroundItem {

    id: scheduleDelegate
    height: Math.max(startTimeLabel.height + endTimeLabel.height + Theme.paddingMedium, roomLabel.height, topicLabel.height) + 2 * Theme.paddingMedium

    property int startTime;
    property int endTime;
    property string roomShort;
    property alias roomColor: roomLabel.color;
    property string speakers_str;
    property string topic;

    Label {
        id: startTimeLabel
        text: F.format_time(startTime);
        font.pixelSize: Theme.fontSizeTiny;
        font.family: Theme.fontFamily

        color: scheduleDelegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium

    }
    Label {
        id: endTimeLabel
        text: F.format_time(endTime);
        font.pixelSize: Theme.fontSizeTiny;
        font.family: Theme.fontFamily
        color: scheduleDelegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        anchors.left: parent.left;
        anchors.top: startTimeLabel.bottom
        anchors.margins: Theme.paddingMedium

    }

    Label {
        id: roomLabel
        anchors.left: startTimeLabel.right
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium
        font.pixelSize: Theme.fontSizeLarge;
        font.family: Theme.fontFamilyHeading
        font.weight: Font.Bold
        text: "|"
    }


    Label {
        id: topicLabel
        anchors.left: roomLabel.right
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium

        text: (speakers_str !== "") ? (speakers_str + ": " + topic) : topic
        color: scheduleDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        wrapMode: Text.Wrap;
        textFormat: Text.RichText;
    }


}
