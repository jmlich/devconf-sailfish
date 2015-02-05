import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F;

BackgroundItem {

    id: delegate

    property string title: ""
    property string description: ""
    property int date;
    property url link;
    property alias img: avatarImage.source;

    height: Math.max(rssDateLabel.paintedHeight + rssDescriptionLabel.paintedHeight + 2 * Theme.paddingLarge, 2 * Theme.paddingLarge + avatarImage.height)


    Image {
        id: dummyImage;
        z: avatarImage.z -1;
        anchors.fill: avatarImage;
        source: "./blank_boy.png"
        visible: avatarImage.status !== Image.Ready;
    }

    Image {

        id: avatarImage;
        z: delegate.z+2
        anchors.left: parent.left
        anchors.top: parent.top;
        width: 80;
        height: 80;
        anchors.margins: Theme.paddingMedium;
        fillMode: Image.PreserveAspectCrop;


    }


    Label {
        id: rssDescriptionLabel
        anchors.top: parent.top;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.margins: Theme.paddingMedium;

        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: Theme.fontSizeSmall
        font.family: Theme.fontFamily


        textFormat: Text.RichText;

        text: "<b>" + delegate.title + "</b> " + delegate.description

    }


    Label {
        id: rssDateLabel
        anchors.top: rssDescriptionLabel.bottom;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.topMargin: Theme.paddingMedium
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        horizontalAlignment: Text.AlignRight


        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: Theme.fontSizeMedium
        font.family: Theme.fontFamily

        text: F.format_time_full(date);
    }



    onClicked: {
        Qt.openUrlExternally(link)
    }

}
