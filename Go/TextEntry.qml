// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: container
    property alias text: input.text

    signal accepted

    Row {
        height: parent.height
        spacing: 2

        Rectangle {
            radius: 10
            height: parent.height
            width: container.width - button.width - 2
            color: "white"
            border.color: "gray"
            border.width: 1

            TextInput {
                id: input
                font.pixelSize: parent.height / 2
                anchors.fill: parent
                anchors.margins: 5

                onAccepted: container.accepted();
            }
        }

        Button {
            id: button
            height: parent.height
            width: parent.height
            title.text: "Go"
            //title.font.pixelSize: height / 2

            onClicked: {
                container.accepted();
            }
        }
    }
}
