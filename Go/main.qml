// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import nobdy 0.1
import amb 0.1
import QtMobility.location 1.2
import Qt.labs.particles 1.0
import QtGStreamer 0.10

Rectangle {
    id: container
    width: 1200
    height: 640
    color: "black"

    property double heading: headingStream.value
    property double rpmValue: rpm.value

    AutomotivePropertyItem {
        id: rpm
        propertyName: "EngineSpeed"
        interfaceName: "org.automotive.engineSpeed"
        objectPath: "/org/automotive/runningstatus/engineSpeed"

        Component.onCompleted: {
            rpm.connect();
        }
    }

    AutomotivePropertyItem {
        id: velocity
        propertyName: "VehicleSpeed"
        interfaceName: "org.automotive.vehicleSpeed"
        objectPath: "/org/automotive/runningstatus/vehicleSpeed"

        Component.onCompleted: {
            velocity.connect();
        }
        onValueChanged: {
            player.setText(velocity.value +"kph ");
        }
    }

    /*NobdyStream {
        id: engineCoolant
        request: VehicleData.EngineCoolantTemp
    }

    NobdyStream {
        id: headingStream
        request: VehicleData.Heading
    }

    NobdyStream {
        id: latitudeStream
        request: VehicleData.Latitude
    }

    NobdyStream {
        id: longitudeStream
        request: VehicleData.Longitude

        onValueChanged: {
            player.setText(velocity.value +"kph " + latitudeStream.value + ", " + longitudeStream.value);
        }
    }

    NobdyStream {
        id: troubleCodeStream
        //request: VehicleData.DiagnosticTroubleCodes
    }*/

    Rectangle {
        id: mapScreen
        width: container.width
        height: container.height
        color: "black"
        anchors.right: guageScreen.left

        LandmarkModel {
            id: gasStations
            importFile: "../POI/california_Automotive.gpx"
            limit: 100
            autoUpdate: true
            onLandmarksChanged: {
                // Direct list access
                for (var index = 0; index < landmarks.length; index++)  {
                    console.log("Index, name:" + index + " , " + landmarks[index].name);
                }
            }
        }

        Map {
            id: map
            plugin: Plugin { name: "nokia" }
            anchors.fill: parent
            size.width: parent.width
            size.height: parent.height
            zoomLevel: 20
            center: Coordinate {

                latitude: latitudeStream.value;
                longitude: longitudeStream.value
                Behavior on latitude {
                    NumberAnimation { duration: 1000 }
                }
                Behavior on longitude {
                    NumberAnimation { duration: 1000 }
                }
            }

            MapCircle {
                id: myPositionMarker
                color: "blue"
                radius: 2
                center: Coordinate {

                    latitude: latitudeStream.value;
                    longitude: longitudeStream.value
                    Behavior on latitude {
                        NumberAnimation { duration: 1000 }
                    }
                    Behavior on longitude {
                        NumberAnimation { duration: 1000 }
                    }
                }
            }

            MapObjectView {
                model: gasStations
                delegate: MapCircle {
                    radius: landmark.radius
                    color: "orange"
                    center: landmark.coordinate
                    Component.onCompleted: {
                        console.log("Drawing map circle for "+landmark.name)
                    }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 80
            text: velocity.value + velocityUnits.text
        }

        Column {
            width: 70
            spacing: 10
            Button {
                width: 70
                title.text: "+"
                title.font.pixelSize: 40
                onClicked: {
                    map.zoomLevel++;
                }
            }

            Button {
                width: 70
                title.text: "-"
                title.font.pixelSize: 40
                onClicked: {
                    map.zoomLevel--;
                }
            }
        }

        Button {
            id: guageScreenButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 100
            title.text: ">"
            title.font.pixelSize: 40
            onClicked: {
                guageScreen.x = 0
            }
        }

    }

    Rectangle {
        id: guageScreen
        width: container.width
        height: container.height
        color: "black"

        Behavior on x {
            NumberAnimation { duration: 500 }
        }

        Particles {
            y: 0
            width: parent.width
            height: parent.height
            source: "assets/star.png"
            lifeSpan: 15000
            count: 300 * (velocity.value / 250)
            angle: heading
            angleDeviation: 36
            velocity: 100 * (rpmValue / 10000)
            velocityDeviation: 10
            ParticleMotionWander {
                xvariance: 30
                pace: 100
            }
        }

        Image {
            id: mainGaugeBackground
            source: "assets/dial-main-bg.png"

            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit

            Rectangle {
                id: rpmNeedle
                visible: rpm.supported
                width: 15
                height: parent.height / 2 - 10
                radius: 10
                x: parent.width / 2
                y: parent.height / 2
                color: "#E89820"
                transform: Rotation {
                    origin.x: rpmNeedle.width / 2
                    origin.y: 0
                    angle: container.rpmValue > 10000 ? 360:(container.rpmValue / 10000 * 180) + 180

                    Behavior on angle {
                        //NumberAnimation { duration: 500 }
                        SpringAnimation { spring: 2; damping: 0.2 }
                    }
                }

            }

            Rectangle {
                id: coolantNeedle
                width: 7
                visible: engineCoolant.supported
                height: parent.height / 2
                radius: 10
                x: parent.width / 2
                y: parent.height / 2
                color: "white"
                transform: Rotation {
                    origin.x: coolantNeedle.width / 2
                    origin.y: 0
                    angle: engineCoolant.value > 165 ? (165/280 * 70 + 90):(engineCoolant.value / 180 * 70) + 90

                    Behavior on angle {
                        //NumberAnimation { duration: 500 }
                        SpringAnimation { spring: 2; damping: 0.2 }
                    }
                }

            }

            Image {
                id: centerImage
                source: "assets/dial-main-center-bg.png"
                anchors.centerIn: parent

                Text {
                    id: velocityText
                    anchors.centerIn: parent
                    text: Math.floor(velocity.value)
                    height: paintedHeight
                    verticalAlignment: Text.AlignBottom
                    font.pixelSize: 90
                    color: "white"
                }

                Text {
                    id: velocityUnits
                    anchors.left: velocityText.right
                    text: "kph"
                    font.pixelSize: 30
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    height: velocityText.height
                    verticalAlignment: Text.AlignBottom
                }
            }

        }

        Image {
            id: headingImage
            source: "assets/dial-main-secondary-bg.png"
            anchors.top: parent.verticalCenter
            x: mainGaugeBackground.x - 53

            Text {
                text: {
                    if(container.heading > 315 && (container.heading > 0 && container.heading < 45))
                        return "N";
                    else if(container.heading <= 315 && container.heading > 225)
                        return "W";
                    else if(container.heading < 225 && container.heading > 135)
                        return "S";
                    else if(container.heading >= 45 && container.heading <= 135)
                        return "E";

                    return "?";
                }

                font.pixelSize: 90
                anchors.centerIn: parent
                color: "white"
            }
        }

        Button {
            id: configureButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 100
            Column {
                y: parent.height / 5
                spacing: parent.height / 8
                width: parent.width

                Repeater {
                    model: 3

                    Rectangle {
                        width: parent.width - 20
                        height: configureButton.height / 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.75
                        color: "black"
                        radius: 1
                    }
                }
            }

            onClicked: {
                modalSurface.item = settingsComponent.createObject(modalSurface);
                modalSurface.visible = true
            }
        }

        Button {
            id: mapsButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 100
            title.text: "<"
            title.font.pixelSize: 40

            onClicked: guageScreen.x = guageScreen.width
        }

        Button {
            id: videoScreenButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 100
            title.text: ">"
            title.font.pixelSize: 40
            onClicked: {
                guageScreen.x = -guageScreen.width
            }
        }

        Button {
            id: checkEngine
            anchors.right: mainGaugeBackground.left
            y: 100
            title.text: "Check engine"
            title.color: "red"
            width: 200
            //visible: troubleCodeStream.value.count
            onClicked: {
                modalSurface.item = troubleCodesComponent.createObject(modalSurface);
                modalSurface.visible = true
            }
        }
    }

    Rectangle {
        id: cameraScreen
        width: container.width
        height: container.height
        color: "blue"
        anchors.left: guageScreen.right

        VideoItem {
            id: video
            anchors.fill: parent
            surface: videoSurface1
        }

        Button {
            id: gaugeButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 100
            title.text: "<"
            title.font.pixelSize: 40

            onClicked: guageScreen.x = 0
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 20
            height: 100
            Button {
                id: stopButton
                height: 100
                title.text: "stop"
                title.font.pixelSize: 40

                onClicked: player.stop();
            }
            Button {
                id: playButton
                height: 100
                title.text: "play"
                title.font.pixelSize: 40

                onClicked: player.play();
            }
        }


    }

    Item {
        id: modalSurface
        anchors.fill: parent
        visible: false
        property Item item: null

        Rectangle {
            anchors.fill: parent
            color: "grey"
            opacity: 0.5

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    modalSurface.item.destroy()
                    modalSurface.visible = false
                }
            }
        }
    }

    Component {
        id: troubleCodesComponent
        TroubleCodes {
            width: parent.width / 2
            anchors.centerIn: parent
        }
    }

    Component {
        id: settingsComponent
        Rectangle {
            width: parent.width / 2
            anchors.centerIn: parent
            height: childrenRect.height + 50
            color: "black"
            radius: 10
            border.color: "#e2e1e1"

            NobdyStream {
                id: connectionState
                request: VehicleData.ProviderConnectionState
            }

            Grid {
                columns: 2
                anchors.centerIn: parent
                //width: parent.width
                //height: parent.height
                spacing: 20
                Text {
                    font.pixelSize: 30
                    color: "white"
                    text: "Connection state"
                }

                Text {
                    font.pixelSize: 30
                    color: "white"
                    text: connectionState.value ? connectionState.value:"unknown"
                }

                Button {
                    title.text: "Connect"
                    onClicked: {
                        connectionState.issueCommand(VehicleServices.ConnectProvider);
                    }
                }

                Button {
                    title.text: "Disconnect"
                    width: 150
                    onClicked: {
                        connectionState.issueCommand(VehicleServices.DisconnectProvider);
                    }
                }

                Text {
                    text: "Video device"
                    font.pixelSize: 30
                    color: "white"
                }

                TextEntry {
                    id: videoDevice
                    text: player.videoDevice
                    height: 50
                    width: 50
                    onAccepted: {
                        player.setVideoDevice(videoDevice.text)
                    }
                }
            }
        }
    }
}
