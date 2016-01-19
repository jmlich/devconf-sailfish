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
    src/filereader.cpp \
    src/networkaccessmanagerfactory.cpp \
    src/customnetworkaccessmanager.cpp \
    src/downloader.cpp

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
    qml/EventDetailPage.qml \
    qml/rh-devconf.qml \
    qml/ScheduleDelegate.qml \
    qml/PinchMap.qml \
    qml/MapPage.qml \
    qml/images/noimage.png \
    qml/images/noimage-loading.png \
    qml/images/noimage-disabled.png \
    qml/images/noimage-cantload.png \
    qml/PhotoDetailPage.qml \
    qml/PlaceDetailPage.qml

HEADERS += \
    src/filereader.h \
    src/networkaccessmanagerfactory.h \
    src/customnetworkaccessmanager.h \
    src/downloader.h

LANGUAGES = cs_CZ en_US

# var, prepend, append
defineReplace(prependAll) {
    for(a,$$1):result += $$2$${a}$$3
    return($$result)
}

LRELEASE = lrelease

TRANSLATIONS = $$prependAll(LANGUAGES, $$PWD/i18n/rh-devconf_,.ts)

updateqm.input = TRANSLATIONS
updateqm.output = $$OUT_PWD/${QMAKE_FILE_BASE}.qm
updateqm.commands = $$LRELEASE -idbased -silent ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_BASE}.qm
updateqm.CONFIG += no_link target_predeps
QMAKE_EXTRA_COMPILERS += updateqm

qmfiles.files = $$prependAll(LANGUAGES, $$OUT_PWD/rh-devconf_,.qm)
qmfiles.path = /usr/share/$${TARGET}/i18n
qmfiles.CONFIG += no_check_exist

INSTALLS += qmfiles

CODECFORTR = UTF-8
CODECFORSRC = UTF-8

QT += positioning

DISTFILES += \
    qml/ScheduleGridDelegate.qml
