import QtQuick 1.1
import QtGStreamer 0.10
import amb 0.1
import go 0.1

Item {
    width: 480
    height: 272

    MouseArea {
        anchors.fill: parent
        onClicked: {
            recordButton.visible = !recordButton.visible
        }
    }

    VideoItem {
        id: video
        anchors.fill: parent
        surface: videoSurface1

        Component.onCompleted: {
            player.videoFile = "out.ogg"
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
            player.setText(velocityItem.value +"kph ");
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

    AutomotivePropertyItem {
        id: dblogging
        propertyName: "DatabaseLogging"
        interfaceName: "org.automotive.DatabaseLogging"
        objectPath: "/org/automotive/custom/DatabaseLogging"

        Component.onCompleted: {
            dblogging.connect();

        }

        onValueChanged: {
            if(value)
            {
                player.createRecordVideoPipeline()
                player.play();
            }
            else {
                player.stop();
            }
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

    Button {
        id: recordButton
        visible: false
        anchors.centerIn: parent
        width: 100
        height: 75
        title.text: dblogging.value ? "Stop":"Record"

        onClicked: {
            dblogging.value = !dblogging.value
        }
    }


}
