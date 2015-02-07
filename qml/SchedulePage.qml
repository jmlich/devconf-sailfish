import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property int filter_start: 0;
    property int filter_end;
    property bool filter_favorites: false;
    property string dayName;
    property int currentTime: Math.floor(new Date().getTime()/1000)

    onFilter_startChanged: {
        var date = new Date(filter_start* 1000);
        dayName = F.dayOfWeek(date.getDay())
    }

    SilicaListView {
        id: listView
        model: filteredEventModel
        anchors.fill: parent
        spacing: Theme.paddingMedium

        header: PageHeader {
            id: pageHeader
            title: filter_favorites ?
                       //% "Favorites"
                       qsTrId("schedule-page-header-favorites") :
                       dayName
        }
        section.property: filter_favorites ? "event_day" : "";
        section.criteria: ViewSection.FullString;

        section.delegate: SectionHeader {
            text: section;
        }

        delegate: ScheduleDelegate {
            startTime: model.event_start;
            endTime: model.event_end;
            roomShort: model.room_short;
            roomColor:  model.room_color;
            speakers_str: model.speakers_str;
            topic: model.topic
            currentTimestamp: currentTime;


            onClicked: {
                eventDetailPage.title = model.type;
                eventDetailPage.talkName = model.topic
                eventDetailPage.description = model.description
                eventDetailPage.startTime = F.format_time(parseInt(model.event_start, 10));
                eventDetailPage.endTime = F.format_time(parseInt(model.event_end, 10));
                eventDetailPage.startDay = model.event_day;
                eventDetailPage.room = model.room;
                eventDetailPage.roomColor = model.room_color
                eventDetailPage.hash = model.hash;
                eventDetailPage.inFavorites = isInFavorites(eventDetailPage.hash);
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
    property variant favoritesModel: [];
    signal saveFavorites(variant arr);

    function updateFilter() {
        filteredEventModel.clear()

        if (filter_favorites) {

            for (var i = 0; i < eventModel.count; i++) {
                var item = eventModel.get(i);
                if ( isInFavorites(item.hash)) {
                    filteredEventModel.append(item)
                }
            }

        } else { // filter according to time

            for (var i = 0; i < eventModel.count; i++) {
                var item = eventModel.get(i);

                if (item.event_start > filter_start && item.event_start < filter_end) {
                    filteredEventModel.append(item)
                }
            }

        }


    }


    function reload(d) {
        var sessions = d.sessions
        eventModel.clear();
        for (var i = 0; i < sessions.length; i++) {
            var item = sessions[i]
            var dayInt = new Date(parseInt(item.event_start, 10) * 1000).getDay();
            item.event_day = F.dayOfWeek(dayInt)
            item.speakers_str = F.make_speakers_str(item.speakers);
            item.speakers = JSON.stringify(item.speakers)
            eventModel.append(item)
        }

    }

    function reloadFavorites(f) {
        favoritesModel = f;
    }

    function isInFavorites(hash) {
        for (var i = 0; i < favoritesModel.length; i++) {
            var item = favoritesModel[i];
            if (item === hash) {
                return true;
            }
        }
        return false;
    }

    function addToFavorites(hash) {
        var obj = [];
        for (var i = 0; i < favoritesModel.length; i++) {
            var item = favoritesModel[i];
            obj.push(item);
        }

        obj.push(hash)
        favoritesModel = obj;

        saveFavorites(favoritesModel);
        updateFilter();

    }

    function removeFromFavorites(hash) {
        var obj = [];
        var list = favoritesModel;
        for (var i = 0; i < list.length; i++) {
            var item = list[i];
            if (item !== hash) {
                obj.push(item);
            }
        }
        favoritesModel = obj;

        saveFavorites(favoritesModel);
        updateFilter();

    }


    Timer {
        repeat: true;
        running: true;
        interval: 120000;
        onTriggered: {
            currentTime = Math.floor(new Date().getTime()/1000);
        }
    }


}





