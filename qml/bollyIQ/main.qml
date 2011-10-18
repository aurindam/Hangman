import QtQuick 1.0
import "Engine.js" as Engine

Rectangle {
    id: mainWindow

    signal movieIQUpdated
    property bool debug : true

    function updateStatusBar() {
        statusBarMovieIQ.text = "Bollywood IQ: " + mainView.movieIQ
    }

    width: 360; height: 480
    Component.onCompleted: {
        movieIQUpdated.connect(updateStatusBar);
        Engine.initializeDatabase();
    }
    Component.onDestruction: Engine.addData(mainView.movieIQ)
    //child Objects

    //Style Elements
    SystemPalette { id: systemPalette; }

    //UI elements
    Flipable {
        id: flipableView

        height: 450
        anchors { top: parent.top; left: parent.left; right: parent.right; }
        front: mainView

        //child Objects
        MainView {
            id: mainView
            debug: mainWindow.debug

        }
    }
    Rectangle {
        id: statusBar

        height: 28
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; topMargin: 1 }
        color: systemPalette.dark;

        //child Objects
        Text {
            id: statusBarMovieIQ

            anchors { left: parent.left; leftMargin: 5 }
            anchors.verticalCenter: parent.verticalCenter
            font { family: "Helvetica"; pointSize: 14; }
            text: "Bollywood IQ: "
        }

        Image {
            id: statusBarPlayStatus

            property bool play: false

            width: 24; height: 24
            anchors { right: parent.right; rightMargin: 5 }
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "play_disabled.png"

            MouseArea {
                id: statusBarPlayStatusMouseArea

                enabled: false
                anchors.fill: parent
                onClicked: {
                    Engine.selectMovieFromDatabaseModel();
                    statusBarPlayStatus.play = false;
                }
            }

            //states
            states : [
                State {
                    name: "Enabled"; when: statusBarPlayStatus.play
                    PropertyChanges { target: statusBarPlayStatus; source: "play.png" }
                    PropertyChanges { target: statusBarPlayStatusMouseArea; enabled: true }
                }
            ]
        }
    }

    //Control elements
    XmlListModel {
        //id
        id: movieDatabaseModel

        query: "/table/rows/row"
        source: "data/movieDatabase"
        XmlRole { name: "name"; query: "value[1]/string()" }
        XmlRole { name: "actor"; query: "value[2]/string()" }
        XmlRole { name: "director"; query: "value[3]/string()" }
        XmlRole { name: "musicDirector"; query: "value[4]/string()" }

     }

    Timer {
        //id
        id: xmlListModelTimer

        interval: 500; running: false; repeat: false
        onTriggered: Engine.checkMovieDatabaseModelStatus()

    }

}
