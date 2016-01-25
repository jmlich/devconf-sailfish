import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    property int filter_start: 0;
    property int filter_end: filter_start + 24*3600;
    property bool filter_favorites: false;
    property string dayName;
    property int currentTime: Math.floor(new Date().getTime()/1000)

    onFilter_startChanged: {
        var date = new Date(filter_start* 1000);
        dayName = F.dayOfWeek(date.getDay())
    }

    property int slot_first: filter_start;
    property int slot_last: filter_end;
    property int slot_length: 1800; // time in seconds
    property int slot_height: 120;
    property int slot_width: 420;
    property int header_width: 80;

    property int slot_count: Math.ceil((slot_last - slot_first)/slot_length);

    property int rooms_count: 1;

    function roomToIndex(room_name) {

        for (var i = 0; i < roomsModel.count; i++) {
            var item = roomsModel.get(i);
            if (item.name === room_name) {
                return i;
            }
        }
        return -1;
    }

    ListModel {
        id: roomsModel;
    }

    ListModel {
        id: timeModel;
    }

    SilicaFlickable {
        visible: !listView.visible;
        clip: true;
        anchors.fill: parent;
        contentWidth: slot_width * rooms_count + header_width;
        contentHeight: slot_height * (slot_count + 1);

        PullDownMenu {
            MenuItem {
                //% "List View"
                text: qsTrId("switch-to-list-view")
                onClicked: {
                    listView.visible = true;
                }
            }
        }

        Repeater {
            model: roomsModel;
            delegate: BackgroundItem {
                x: header_width + (index * slot_width);
                y: 0;
                height: slot_height;
                width: slot_width;

                Label {
                    anchors.centerIn: parent;
                    text: model.name;
                    font.pointSize: Theme.fontSizeExtraSmall
                    color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
            }
        }


        Repeater {
            model: timeModel;
            delegate: BackgroundItem {

                x: 0;
                y: header_width + (index * slot_height);
                width: header_width;
                height: slot_height;
                Text {
                    anchors.centerIn: parent;
                    text: F.format_time(model.event_start);
                    font.pointSize: Theme.fontSizeExtraSmall
                    color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
            }
        }

        Repeater {
            model: filteredEventModel
            delegate: ScheduleGridDelegate {
                x: header_width + width * roomToIndex(model.room_short)
                y: slot_height * (1+((model.event_start - slot_first)/slot_length))
                width: slot_width;
                height: slot_height * ((model.event_end - model.event_start)/slot_length);


                startTime: model.event_start;
                endTime: model.event_end;
                //                roomShort: model.room_short;
                roomColor:  model.room_color;
                speakers_str: model.speakers_str;
                topic: model.topic
                currentTimestamp: currentTime;
                inFavorites: isInFavorites(model.hash);


                onClicked: {
                    eventDetailPage.title = model.type;
                    eventDetailPage.talkName = model.topic
                    eventDetailPage.description = model.description
                    eventDetailPage.startTime = F.format_time(model.event_start);
                    eventDetailPage.endTime = F.format_time(model.event_end);
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
        }

    }

    SilicaListView {

        id: listView
        visible: false;
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

        PullDownMenu {
            visible: !filter_favorites
            MenuItem {
                //% "Grid View"
                text: qsTrId("switch-to-grid-view")
                onClicked: {
                    listView.visible = false;
                }
            }
        }

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

        roomsModel.clear();

        console.log("updateFilter()");


        if (filter_favorites) {

            listView.visible = true;

            for (var i = 0; i < eventModel.count; i++) {
                var item = eventModel.get(i);

                if ( isInFavorites(item.hash)) {
                    var idx = roomToIndex(item.room_short);
                    if (idx === -1) {
                        roomsModel.append({"name":item.room_short});
                    }
                    filteredEventModel.append(item)
                }
            }
            if (filteredEventModel.count == 0) {
                //                console.error("favoritesModel " + JSON.stringify(favoritesModel));
                favoritesModel = [];
                saveFavorites(favoritesModel);
            }

        } else { // filter according to time

            slot_first = filter_end;
            slot_last = filter_start;

            for (var i = 0; i < eventModel.count; i++) {
                var item = eventModel.get(i);

                if (item.event_start > filter_start && item.event_start < filter_end) {

                    var idx = roomToIndex(item.room_short);

                    if (idx === -1) {
                        roomsModel.append({"name":item.room_short});
                    }

                    if (slot_first > item.event_start) {
                        slot_first = item.event_start;
                    }
                    if (slot_last < item.event_end) {
                        slot_last = item.event_end;
                    }
                    filteredEventModel.append(item)
                }
            }

            rooms_count = roomsModel.count;


            timeModel.clear();
            for (var i = slot_first; i < slot_last; i += slot_length) {
                timeModel.append({"event_start": i})
            }

        }

    }

    function reload(d) {
        var sessions = d.sessions
        eventModel.clear();
        for (var i = 0; i < sessions.length; i++) {
            var item = sessions[i];
            var dayInt = new Date(parseInt(item.event_start, 10) * 1000).getDay();
            item.event_day = F.dayOfWeek(dayInt)

            var obj;
            if ((typeof item.speakers) == (typeof "")) { // this is ugly workarround - this should be object (array of strings)
                obj = eval(item.speakers);
            } else {
                obj = item.speakers;
            }
            item.speakers = JSON.stringify(obj);
            item.speakers_str = F.make_speakers_str(obj); // need to work with object


            item.event_start = parseInt(item.event_start, 10);
            item.event_end = parseInt(item.event_end, 10);

            eventModel.append(sessions[i])
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





