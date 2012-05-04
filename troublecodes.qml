import QtQuick 1.1
import nobdy 0.1

Rectangle {
    id: container
    width: 800
    height: 480

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

            Column {
                width: parent.width
                Repeater {
                    //model: troubleCodeStream.value
                    model: ["p1001","0303","34343"]
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
