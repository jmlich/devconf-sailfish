import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property int filter_start: 0;
    property int filter_end;
    property string headerTitle

    onFilter_startChanged: {
        var date = new Date(filter_start* 1000);
        headerTitle= F.dayOfWeek(date.getDay())
    }




    SilicaListView {
        id: listView
        model: filteredEventModel
        anchors.fill: parent
        spacing: Theme.paddingMedium

        header: PageHeader {
            id: pageHeader
            title: headerTitle
        }
        delegate: BackgroundItem {
            id: delegate
            height: Math.max(startTimeLabel.height + endTimeLabel.height + Theme.paddingMedium, roomLabel.height, topicLabel.height) + 2 * Theme.paddingMedium


            Label {
                id: startTimeLabel
                text: F.format_time(model.event_start);
                font.pixelSize: Theme.fontSizeTiny;
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                anchors.left: parent.left;
                anchors.top: parent.top;
                anchors.margins: Theme.paddingMedium

            }
            Label {
                id: endTimeLabel
                text: F.format_time(model.event_end);
                font.pixelSize: Theme.fontSizeTiny;
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
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
                text: model.room_short
                color:  model.room_color;
            }


            Label {
                id: topicLabel
                anchors.left: roomLabel.right
                anchors.right: parent.right
                anchors.top: parent.top;
                anchors.margins: Theme.paddingMedium

                text: (model.speakers_str !== "")
                      ? (model.speakers_str + ": " + model.topic)
                      : model.topic
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                wrapMode: Text.Wrap;
            }

            onClicked: {
                eventDetailPage.title = model.type;
                eventDetailPage.talkName = model.topic
                eventDetailPage.description = model.description
                eventDetailPage.startTime = F.format_time(model.event_start);
                eventDetailPage.endTime = F.format_time(model.event_end);
                eventDetailPage.room = model.room;
                eventDetailPage.roomColor = model.room_color
                eventDetailPage.um.clear()
                var speakersArray = JSON.parse(model.speakers);
                for (var i = 0; i < speakersArray.length; i++) {
                    var detail = dataSource.getSpeakerDetail(speakersArray[i])
                    eventDetailPage.um.append(detail)
                }

                pageStack.push(eventDetailPage);

            }
        }
        VerticalScrollDecorator {}
    }

    ListModel {
        id: eventModel
    }

    ListModel {
        id: filteredEventModel
    }


    function updateFilter() {
        filteredEventModel.clear()
        for (var i = 0; i < eventModel.count; i++) {
            var item = eventModel.get(i);
            if (item.event_start > filter_start && item.event_start < filter_end) {
                filteredEventModel.append(item)
            }
        }
    }

    function reload(d) {
        var sessions = d.sessions
        eventModel.clear();
        for (var i = 0; i < sessions.length; i++) {

            var str = "";
            var speakersArray = sessions[i].speakers
            for (var j = 0; j < speakersArray.length; j++) {
                str += speakersArray[j];
                if ((speakersArray.length-1) != j) {
                    str += ", ";
                }
            }
            sessions[i].speakers_str = str;
            sessions[i].speakers = JSON.stringify(speakersArray);

            eventModel.append(sessions[i])
        }

    }


}





