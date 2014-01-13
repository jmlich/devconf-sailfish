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
                title: qsTr("DevConf.cz")
            }

            SectionHeader {
                text: qsTr("About")
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


            SectionHeader {
                text: qsTr("Schedule")
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
                        schedulePage.filter_start = timestamp
                        schedulePage.filter_end = timestamp + 24 * 3600
                        schedulePage.updateFilter();

                        pageStack.push(schedulePage)
                    }

                }
            }

            SectionHeader {
                text: qsTr("News")
            }

            Repeater {
                id: rssRepeater
                model: rssModel
                delegate: RssItemDelegate {
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


    function reload(d) {

        var aboutArray = d.about;
        aboutModel.clear()
        for (var i = 0; i < aboutArray.length; i++) {
            aboutModel.append(aboutArray[i])
        }

        var daysArray = d.days;
        daysModel.clear();
        for (var i = 0; i < daysArray.length; i++) {
            var ts = daysArray[i];
            var date = new Date(ts* 1000);
            var dayName = F.dayOfWeek(date.getDay())
            daysModel.append({'timestamp': ts, 'name': dayName})
        }

        var rss = d.rss;
        rssModel.clear();
        for (var i = 0; i < rss.length; i++) {
            rssModel.append(rss[i])
        }

    }

}


