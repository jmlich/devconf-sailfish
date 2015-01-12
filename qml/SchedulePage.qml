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
        delegate: ScheduleDelegate {
            startTime: model.event_start;
            endTime: model.event_end;
            roomShort: model.room_short;
            roomColor:  model.room_color;
            speakers_str: model.speakers_str;
            topic: model.topic


            onClicked: {
                eventDetailPage.title = model.type;
                eventDetailPage.talkName = model.topic
                eventDetailPage.description = model.description
                eventDetailPage.startTime = F.format_time(parseInt(model.event_start, 10));
                eventDetailPage.endTime = F.format_time(parseInt(model.event_end, 10));
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
            sessions[i].speakers_str = F.make_speakers_str(sessions[i].speakers);
            sessions[i].speakers = JSON.stringify(sessions[i].speakers)
            eventModel.append(sessions[i])
        }

    }


}





