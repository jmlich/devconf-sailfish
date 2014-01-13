# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = rh-devconf

CONFIG += sailfishapp

SOURCES += src/rh-devconf.cpp \
    src/filereader.cpp

OTHER_FILES += qml/rh-devconf.qml \
    qml/CoverPage.qml \
    rpm/rh-devconf.spec \
    rpm/rh-devconf.yaml \
    rh-devconf.desktop \
    qml/data.json \
    qml/Data.qml \
    qml/MainPage.qml \
    qml/RssItemDelegate.qml \
    qml/AboutPage.qml \
    qml/SchedulePage.qml \
    qml/functions.js \
    qml/EventDetailPage.qml

HEADERS += \
    src/filereader.h

