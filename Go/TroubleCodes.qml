import QtQuick 1.1
import nobdy 0.1

Rectangle {
    id: container
    width: 1200
    height: 640
    color: "black"

    NobdyStream {
        id: troubleCodeStream
        request: VehicleData.DiagnosticTroubleCodes
    }

    Column {
        width: parent.width
        spacing: 5
        Button {
            id: refreshButton
            width: parent.width - 10
            title.text: "Refresh"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                troubleCodeStream.request = VehicleData.DiagnosticTroubleCodes
            }
        }

        Button {
            id: clearButton
            width: parent.width - 10
            title.text: "Clear"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                troubleCodeStream.issueCommand(VehicleServices.ClearDiagnosticTroubleCodes);
            }
        }


        Rectangle {
            width: parent.width / 2
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter
            visible: troubleCodeStream.value.length
            color: "#cc4444"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#cc4444";
                }
                GradientStop {
                    position: 1.00;
                    color: "#000000";
                }
            }

            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "Check engine:"
                    color: "white"
                    font.pixelSize: 20
                }

                Repeater {
                    model: troubleCodeStream.value

                    delegate: Text {
                        text: modelData
                        font.pixelSize: 20
                        color: "white"
                    }

                }
            }
        }
    }
}
