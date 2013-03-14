import QtQuick 1.1
import QtGStreamer 0.10
import amb 0.1
import go 0.1

Item {
    width: 480
    height: 272


    VideoItem {
        id: video
        anchors.fill: parent
        surface: videoSurface1

        Component.onCompleted: {
            player.videoFile = "file:///home/kev/src/Go/Go/out.ogg"
            player.createVideoFilePiplineDisplay();
            player.play();
        }
    }

    AutomotivePropertyItem {
        id: dbfileItem
        propertyName: "DatabaseFile"
        interfaceName: "org.automotive.DatabaseFile"
        objectPath: "/org/automotive/custom/DatabaseFile"

        Component.onCompleted: {
            dbfileItem.connect();
            value = "mylog.db";
            dblogging.connect();
        }

    }

    AutomotivePropertyItem {
        id: dbplayback
        propertyName: "DatabasePlayback"
        interfaceName: "org.automotive.DatabasePlayback"
        objectPath: "/org/automotive/custom/DatabasePlayback"

        Component.onCompleted: {
            dbplayback.connect();
            value = true

        }

    }

    AutomotivePropertyItem {
        id: rpmItem
        propertyName: "EngineSpeed"
        interfaceName: "org.automotive.EngineSpeed"
        objectPath: "/org/automotive/runningstatus/EngineSpeed"

        Component.onCompleted: {
            rpmItem.connect();
        }

    }

    AutomotivePropertyItem {
        id: velocityItem
        propertyName: "VehicleSpeed"
        interfaceName: "org.automotive.VehicleSpeed"
        objectPath: "/org/automotive/runningstatus/VehicleSpeed"

        Component.onCompleted: {
            velocityItem.connect();
        }

        onValueChanged: {
            console.log("velocity changed: "+value)
        }
    }

    AutomotivePropertyItem {
        id: engineCoolantItem
        propertyName: "EngineCoolant"
        interfaceName: "org.automotive.EngineCoolant"
        objectPath: "/org/automotive/runningstatus/EngineCoolant"

        Component.onCompleted: {
            engineCoolantItem.connect();
        }

    }

    Guage {
        height: 100
        width: 100
        anchors.right: parent.right
        anchors.top: parent.top
        heading: 355
        velocity: velocityItem.value
        rpm: rpmItem.value
        engineCoolant: engineCoolantItem.value
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
