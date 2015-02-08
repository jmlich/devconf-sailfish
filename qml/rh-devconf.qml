import QtQuick 2.0
import Sailfish.Silica 1.0
import cz.mlich 1.0

ApplicationWindow {
    initialPage: mainPage
    cover: coverPage

    CoverPage {
        id: coverPage
        onForceUpdateDataSource: {
            dataSource.updateUI();
        }
    }

    MainPage {
        id: mainPage
    }

    AboutPage {
        id: aboutPage;
    }

    SchedulePage {
        id: schedulePage
        onSaveFavorites: {
            dataSource.configSet("favorites",JSON.stringify(favoritesModel));
        }

    }

    EventDetailPage {
        id: eventDetailPage;
        onAddToFavorites: {
            schedulePage.addToFavorites(hash);
        }
        onRemoveFromFavorites: {
            schedulePage.removeFromFavorites(hash);
        }
    }

    MapPage {
        id: mapPage;
        onShowDetail: {
            placesDetailPage.name = name;
            placesDetailPage.description = description;
            placesDetailPage.image = icon;
            placesDetailPage.lat = lat;
            placesDetailPage.lon = lon;
            pageStack.push(placesDetailPage)
        }
    }

    PlaceDetailPage {
        id: placesDetailPage;
        onShowOnMap: {
            mapPage.mapWidget.setCenterLatLon(lat, lon);
            mapPage.map_visible = true;
            pageStack.pop();

        }
    }

    PhotoDetailPage {
        id: photoDetailPage
    }

    Data {
        id: dataSource;
    }


    Component.onCompleted: {
        dataSource.init_data()
    }

    Timer {
        running: true;
        repeat: true;
        interval: 600000; // 10 minutes
        onTriggered: {
            dataSource.updateUI();
        }
    }

    FileReader {
        id: filereader;
    }

    Downloader {
        id: downloader;
    }

}


