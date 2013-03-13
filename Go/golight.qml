import QtQuick 1.1
import QtGStreamer 0.10
import amb 0.1

Rectangle {
    width: 480
    height: 272
    color: "black"

    VideoItem {
        id: video
        anchors.fill: parent
        surface: videoSurface1

        Component.onCompleted: {
            player.play();
        }
    }

    Guage {
        height: 100
        width: 100
        anchors.right: parent.right
        anchors.top: parent.top
        heading: 355
    }

    Map {
        height: 100
        width: 100
        anchors.left: parent.left
        anchors.top: parent.top
        latitude: 45.54013
        longitude: -122.95711

    }


}
