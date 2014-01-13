import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {

    property alias title: rssTitleLabel.text
    property alias description: rssDescriptionLabel.text
    property int date
    property url link

    id: delegate


    height: contentItem.childrenRect.height + Theme.paddingLarge

    Label {
        id: rssTitleLabel
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right
        anchors.margins: Theme.paddingLarge;



        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: Theme.fontSizeMedium

    }

    Label {
        id: rssDateLabel
        anchors.top: rssTitleLabel.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        horizontalAlignment: Text.AlignRight


        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: Theme.fontSizeMedium
        text: Format.formatDate(new Date(date*1000), Formatter.TimepointRelative)
    }

    Label {
        id: rssDescriptionLabel
        anchors.top: rssDateLabel.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: Theme.paddingLarge;


        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: Theme.fontSizeSmall


    }
    onClicked: {
        Qt.openUrlExternally(link)
    }

}
