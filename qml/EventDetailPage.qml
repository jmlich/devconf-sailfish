import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property alias um: usersModel
    property alias title: header.title
    property alias talkName: talkNameLabel.text
    property alias description: descriptionLabel.text

    property string startTime
    property string endTime
    property alias room: roomLabel.text
    property alias roomColor: roomLabel.color

    ListModel {
        id: usersModel;
    }

    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium


            PageHeader {
                id: header;
                title: "event"
            }

            Label {
                id: talkNameLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.primaryColor
                wrapMode: Text.WordWrap

            }

            Label {
                id: timeLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                color: Theme.secondaryColor
                text: startTime + " - " + endTime

            }

            Label {
                id: roomLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                color: Theme.secondaryColor
            }




            Repeater {
                model: usersModel;
                delegate: BackgroundItem{

                    height: Math.max(avatarImage.paintedHeight, nameLabel.paintedHeight + companyLabel.paintedHeight + positionLabel.paintedHeight + 2*Theme.paddingMedium) + 2 * Theme.paddingMedium


                    Image {
                        id: dummyImage;
                        z: avatarImage.z -1;
                        anchors.fill: avatarImage;
                        source: "./blank_boy.png"
                        visible: avatarImage.status !== Image.Ready;
                    }

                    Image {
                        id: avatarImage;
                        anchors.left: parent.left
                        anchors.top: parent.top;
                        source: model.avatar;
                        height: 150;
                        width: 150;
                        anchors.margins: Theme.paddingMedium;

                    }

                    Label {
                        id: nameLabel
                        anchors.top: parent.top;
                        anchors.left: avatarImage.right
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;

                        text: model.name
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        wrapMode: Text.WordWrap

                    }

                    Label {
                        id: companyLabel
                        anchors.left: avatarImage.right
                        anchors.top: nameLabel.bottom
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;
                        text: model.company
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap

                    }
                    Label {
                        id: positionLabel
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;
                        anchors.top: companyLabel.bottom
                        anchors.left: avatarImage.right
                        text: model.position
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap

                    }
                }
            }

            Label {
                id: descriptionLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                color: Theme.secondaryColor
                wrapMode: Text.WordWrap

            }

        }
    }
}
