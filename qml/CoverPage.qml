import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

CoverBackground {
    id: page

    property real coundownTarget
    property bool now_true_next_false: true;
    property alias currentEventsModelAlias: currentEventsModel
    property alias upcommingEventsModelAlias: upcommingEventsModel

    signal forceUpdateDataSource();

//    Image {
//        anchors.fill: parent;
//        source: "devconf-cover.png"
//        opacity: 0.3
//        visible: countdownText.visible;
//    }

    Label {
        id: countdownText
        anchors.centerIn: parent;
        //% "Loading ..."
        text: qsTrId("cover-loading")
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        anchors.margins: Theme.paddingMedium
        anchors.fill: parent;
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        visible: !countdownText.visible && now_true_next_false && (currentEventsModel.count == 0)
        //% "No running event"
        text: qsTrId("cover-no-running-event")
    }

    Label {
        anchors.margins: Theme.paddingMedium
        anchors.fill: parent;
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        visible: !countdownText.visible && !now_true_next_false && (upcommingEventsModel.count == 0)
        //% "See you next year"
        text: qsTrId("cover-no-upcomming-event")
    }


    Column {
        visible: !countdownText.visible
        anchors.fill: parent;

        Repeater {
            model: now_true_next_false ? currentEventsModel : upcommingEventsModel
            delegate: Item {
                width: page.width
                height: eventItem.paintedHeight
                Label {
                    id: eventItem
                    anchors.leftMargin: Theme.paddingSmall
                    anchors.rightMargin: Theme.paddingSmall
                    anchors.left: parent.left
                    anchors.right: parent.right

                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.family: Theme.fontFamily

                    text: F.format_time(model.event_start) + ": " + model.speakers_0 + model.topic;
                    color: model.room_color
                    truncationMode: TruncationMode.Fade;
                    maximumLineCount: 2;
                }
            }


        }
    }

    ListModel {
        id: upcommingEventsModel;
    }

    ListModel {
        id: currentEventsModel;
    }

    ListModel {
        id: allEventsModel;
    }



    CoverActionList {
        enabled: !countdownText.visible && now_true_next_false;

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                now_true_next_false = false;
                forceUpdateDataSource();
            }
        }

    }

    CoverActionList {
        enabled: !countdownText.visible &&  !now_true_next_false

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: {
                now_true_next_false = true;
                forceUpdateDataSource();
            }
        }

    }

    function reload(d) {
        var sessions = d.sessions
        allEventsModel.clear();
        for (var i = 0; i < sessions.length; i++) {
            sessions[i].speakers_str = F.make_speakers_str(sessions[i].speakers);
            sessions[i].speakers_0 = (sessions[i].speakers[0] !== undefined) ? (sessions[i].speakers[0] + "\n") : ""

            sessions[i].speakers = JSON.stringify(sessions[i].speakers);
            allEventsModel.append(sessions[i])
        }


    }


    function updateFilter() {
        currentEventsModel.clear();
        upcommingEventsModel.clear();
        var now = Math.floor(new Date().getTime()/1000);

        var counter = 0;
        for (var i = 0; i < allEventsModel.count; i++) {
            var item = allEventsModel.get(i);
            if (item.event_start < now && item.event_end > now) {
                currentEventsModel.append(item)
            }
            if (item.event_start > now && item.event_end > now) {
                upcommingEventsModel.append(item)
                counter++;
                if (counter > 5) {
                    break;
                }
            }

        }
    }




    Timer {
        interval: countdownText.visible ? 1000 : 30000;
        running: (page.status === Cover.Active)
        repeat: true;
        onTriggered: {
            if (coundownTarget !== undefined) {
                countdownText.visible = !F.isSameDay(coundownTarget);
                if (countdownText.visible) {
                    countdownText.text = F.formatCountdown(coundownTarget)
                }
                updateFilter();
                forceUpdateDataSource();
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            updateFilter();
        }
    }
}


