import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable


    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                //% "DevConf"
                title: qsTrId("page-header-devconf")
            }

            SectionHeader {
                //% "About"
                text: qsTrId("section-header-about")
            }


            Repeater {
                model: aboutModel
                delegate: BackgroundItem {
                    id: aboutDelegate
                    Label {
                        x: Theme.paddingLarge
                        text: title
                        anchors.verticalCenter: parent.verticalCenter

                        color: aboutDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor;
                        wrapMode: Text.Wrap;
                        font.pixelSize: Theme.fontSizeMedium

                    }
                    onClicked: {
                        aboutPage.title = model.title;
                        aboutPage.text = model.text;
                        pageStack.push(aboutPage);
                    }

                }
            }

            Repeater {
                model: venueMapModel
                delegate: BackgroundItem {
                    id: venueMapDelegate
                    Label {
                        x: Theme.paddingLarge
                        text: title
                        anchors.verticalCenter: parent.verticalCenter

                        color: venueMapDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor;
                        wrapMode: Text.Wrap;
                        font.pixelSize: Theme.fontSizeMedium

                    }
                    onClicked: {
                        var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(model.image)

                        photoDetailPage.addr = (filereader.file_exists(local_url)) ? local_url : model.image;

                        pageStack.push(photoDetailPage)
                    }

                }
            }



            BackgroundItem {
                id: mapDelegate
                visible: false;
                Label {
                    x: Theme.paddingLarge
                    //% "Map"
                    text: qsTrId("section-about-map")
                    anchors.verticalCenter: parent.verticalCenter

                    color: mapDelegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeMedium

                }
                onClicked: {
                    pageStack.push(mapPage)
                }

            }


            SectionHeader {
                //% "Schedule"
                text: qsTrId("section-header-schedule")
            }

            Repeater {
                model: daysModel
                delegate: BackgroundItem {
                    id: daysDelegate
                    Label {
                        x: Theme.paddingLarge
                        text: name
                        anchors.verticalCenter: parent.verticalCenter

                        color: daysDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor;
                        wrapMode: Text.Wrap;
                        font.pixelSize: Theme.fontSizeMedium

                    }
                    onClicked: {
                        schedulePage.filter_favorites = false;
                        schedulePage.filter_start = timestamp
                        schedulePage.filter_end = timestamp + 24 * 3600
                        schedulePage.updateFilter();

                        pageStack.push(schedulePage)
                    }

                }
            }

            BackgroundItem {
                id: favoritesDelegate
                visible: (schedulePage.favoritesModel.length > 0)
                Label {
                    x: Theme.paddingLarge
                    //% "Favorites"
                    text: qsTrId("section-favorites")
                    anchors.verticalCenter: parent.verticalCenter
                    color: favoritesDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor;

                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeMedium

                }
                onClicked: {
                    schedulePage.filter_favorites = true;
                    schedulePage.updateFilter();
                    pageStack.push(schedulePage)
                }

            }

            SectionHeader {
                //% "Upcomming talks"
                text: qsTrId("section-header-upcomming-talks")
                visible: (currentEvents.count > 0)
            }

            Repeater {
                model: currentEvents;
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
                        eventDetailPage.hash = model.hash;
                        eventDetailPage.inFavorites = schedulePage.isInFavorites(eventDetailPage.hash);

                        pageStack.push(eventDetailPage);
                    }

                }
            }


            SectionHeader {
                //% "News"
                text: qsTrId("section-header-news")
            }

            Repeater {
                id: rssRepeater
                model: rssModel
                delegate: RssItemDelegate {
                    //                    img: (model.avatar !== undefined) ? model.avatar : ""
                    img: model.avatar;
                    title: model.title
                    description: model.description
                    link: model.link
                    date: model.time
                }

            }



        }
    }

    ListModel {
        id: aboutModel
    }

    ListModel {
        id: daysModel;
    }

    ListModel {
        id: rssModel;
    }

    ListModel {
        id: currentEvents
    }

    ListModel {
        id: venueMapModel;
    }



    function reload(d) {

        var aboutArray = d.about;
        aboutModel.clear()
        for (var i = 0; i < aboutArray.length; i++) {
            aboutModel.append(aboutArray[i])
        }

        var daysArray = d.days;
        daysModel.clear();
        for (var i = 0; i < daysArray.length; i++) {
            var ts = parseInt(daysArray[i], 10);
            var date = new Date(ts* 1000);
            var dayName = F.dayOfWeek(date.getDay())
            daysModel.append({'timestamp': parseInt(ts, 10), 'name': dayName})
        }

        var rss = d.rss;
        rssModel.clear();
        for (var i = 0; i < rss.length; i++) {
            rssModel.append(rss[i])
        }

        var now = Math.floor(new Date().getTime()/1000);
        var sessions = d.sessions
        currentEvents.clear();
        var j = 0;
        for (var i = 0; i < sessions.length; i++) {
            var item = sessions[i];
            if (item.event_start > now) {
                sessions[i].speakers_str = F.make_speakers_str(sessions[i].speakers);
                sessions[i].speakers = JSON.stringify(sessions[i].speakers)
                currentEvents.append(sessions[i])
                j++;
            }
            if (j >= 6) {
                break;
            }
        }

        venueMapModel.clear();
        if (d.venueMap !== undefined) {
            var venueMap = d.venueMap;

            for (var i = 0; i < venueMap.length; i++) {
                var item = venueMap[i]
                venueMapModel.append(item);

                var remote_url = item.image
                var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(remote_url)


                if (!filereader.file_exists(local_url)) {
                    downloader.append(remote_url, local_url)
                }


            }
        }


    }


}


