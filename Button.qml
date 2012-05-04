// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: button

    property alias title: titleLabel

    signal clicked

    width: 100
    height: 70
    color: "#888686"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: mouseArea.pressed ? "#888686": "#ffffff"
        }
        GradientStop {
            position: 0.43;
            color: "#605e5e"
        }
        GradientStop {
            position: 1.00;
            color: mouseArea.pressed ? "#ffffff": "#888686"
        }
    }
    border.color: "#e2e1e1"

    Text {
        id: titleLabel
        anchors.centerIn: parent
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        text: "Refresh"
        font.pixelSize: 20
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            button.clicked();
        }
    }
}
