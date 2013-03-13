import QtQuick 1.1

Item {
    width: 800
    height: 600

    property int rpm;
    property int engineCoolant;
    property int velocity;
    property int heading;

    Image {
        id: mainGaugeBackground
        source: "assets/dial-main-bg.png"
        anchors.fill: parent
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit

        Rectangle {
            id: rpmNeedle
            visible: rpm.supported
            width: 0.05 * parent.height
            height: parent.height / 2 - 10
            radius: 10
            x: parent.width / 2
            y: parent.height / 2
            color: "#E89820"
            transform: Rotation {
                origin.x: rpmNeedle.width / 2
                origin.y: 0
                angle: rpm > 10000 ? 360:(rpm / 10000 * 180) + 180

                Behavior on angle {
                    //NumberAnimation { duration: 500 }
                    SpringAnimation { spring: 2; damping: 0.2 }
                }
            }

        }

        Rectangle {
            id: coolantNeedle
            width: 0.01 * parent.height
            visible: engineCoolant.supported
            height: parent.height / 2 - 10
            radius: 10
            x: parent.width / 2
            y: parent.height / 2
            color: "white"
            transform: Rotation {
                origin.x: coolantNeedle.width / 2
                origin.y: 0
                angle: engineCoolant > 165 ? (165/280 * 70 + 90):(engineCoolant / 180 * 70) + 90

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
            width: parent.width / 2
            height: parent.height / 2
            fillMode: Image.PreserveAspectFit

            Text {
                id: velocityText
                anchors.centerIn: parent
                text: velocity ? Math.floor(velocity):"0"
                height: paintedHeight
                verticalAlignment: Text.AlignBottom
                font.pixelSize: parent.height / 4
                color: "white"
            }

            Text {
                id: velocityUnits
                anchors.left: velocityText.right
                text: "kph"
                font.pixelSize: parent.height / 4
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                height: velocityText.height
                verticalAlignment: Text.AlignBottom
                visible: parent.height > 100
            }
        }

    }

    Image {
        id: headingImage
        source: "assets/dial-main-secondary-bg.png"
        anchors.top: parent.verticalCenter
        width: mainGaugeBackground.width / 3.5
        height: mainGaugeBackground.height / 3.5
        fillMode: Image.PreserveAspectFit

        x: mainGaugeBackground.x + width / 4

        Text {
            text: {
                if(heading > 315 && (heading > 0 && heading < 45))
                    return "N";
                else if(heading <= 315 && heading > 225)
                    return "W";
                else if(heading < 225 && heading > 135)
                    return "S";
                else if(heading >= 45 && heading <= 135)
                    return "E";

                return "?";
            }

            font.pixelSize: parent.height / 2
            anchors.centerIn: parent
            color: "white"
        }
    }
}
