import QtQuick 1.1
import QtMobility.location 1.2

Item {
    id: mapScreen

    property variant longitude;
    property variant latitude;

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

            latitude: mapScreen.latitude
            longitude: mapScreen.longitude
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

                latitude: mapScreen.latitude
                longitude: mapScreen.longitude
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
}
