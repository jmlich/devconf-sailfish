import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    property alias title: header.title
    property string text

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
            spacing: Theme.paddingLarge
            PageHeader {
                id: header
            }

            Label {
                id: contentLabel
                wrapMode: Text.Wrap;
                font.pixelSize: Theme.fontSizeSmall
                font.family: Theme.fontFamily
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingLarge;
                textFormat: Text.RichText
                text: "<style type='text/css'>a:link{color:"+Theme.highlightColor+"; } a:visited{color:"+Theme.highlightColor+"}</style>  "+ page.text
                onLinkActivated:{
                    Qt.openUrlExternally(link)
                }

            }

        }
    }
}
