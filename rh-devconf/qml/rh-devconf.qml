import QtQuick 2.0
import Sailfish.Silica 1.0


ApplicationWindow
{
    initialPage: mainPage
    cover: coverPage

    CoverPage {
        id: coverPage
    }

    MainPage {
        id: mainPage
    }

    AboutPage {
        id: aboutPage;
    }

    SchedulePage {
        id: schedulePage
    }

    EventDetailPage {
        id: eventDetailPage;
    }


    Data {
        id: dataSource;
    }


    Component.onCompleted: {
       dataSource.init_data()
    }

}


