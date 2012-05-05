import QtQuick 1.1
import nobdy 0.1

Rectangle {
    id: container
    width: 1200
    height: childrenRect.height + 50
    color: "black"
    radius: 10
    border.color: "#e2e1e1"
    NobdyStream {
        id: troubleCodeStream
        request: VehicleData.DiagnosticTroubleCodes
    }

    Column {
        width: parent.width
        spacing: 5

        Text {
            text: "Diagnostic trouble codes:"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            color: "white"
            font.pixelSize: 20
        }

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
            width: parent.width - 10
            height: childrenRect.height + 10
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

                Repeater {
                    model: troubleCodeStream.value

                    delegate: Text {
                        text: modelData
                        font.pixelSize: 30
                        color: "white"
                    }

                }
            }
        }
    }
}
