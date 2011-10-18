import QtQuick 1.0
import "Engine.js" as Engine

Item {
    id: mainView

    signal movieIQUpdated

    property bool debug : false
    property real movieIQ : -1
    property string movieName: ""
    property string movieActors: ""
    property string movieDirector: ""
    property string movieMusicDirector: ""
    property alias movieInputText: movieNameSectionText.text
    property alias missedCharacters: inputBlockMissedCharacters.text
    property alias hangmanBlockState: hangmanBlock.misses
    property alias inputBlockState: inputBlock.enabled
    property alias actorBlockState: actorBlock.enabled
    property alias directorBlockState: directorBlock.enabled
    property alias musicDirectorBlockState: musicDirectorBlock.enabled


    anchors.fill: parent

    //child objects
    Rectangle {
        id: infoSection

        height: 150
        anchors { top: parent.top; left: parent.left; right: parent.right; }
        border { color: "black"; width: 1 }

        //child Objects
        Rectangle {
            id: hangmanBlock

            property int misses: 0

            width: 180
            anchors { top: parent.top; left: parent.left; right: inputBlock.left; bottom: parent.bottom; margins: 5 }

            //child Objects
            Image {
                id: hangmanBlockImage

                anchors.fill: parent
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "img_hangman_0.png"
            }

            //states
            states : [
                State {
                    name: "FirstMiss"; when: hangmanBlock.misses == 1
                    PropertyChanges { target: hangmanBlockImage; source: "img_hangman_1.png" }
                },
                State {
                    name: "SecondMiss"; when: hangmanBlock.misses == 2
                    PropertyChanges { target: hangmanBlockImage; source: "img_hangman_2.png" }
                },
                State {
                    name: "ThirdMiss"; when: hangmanBlock.misses == 3
                    PropertyChanges { target: hangmanBlockImage; source: "img_hangman_3.png" }
                },
                State {
                    name: "FourthMiss"; when: hangmanBlock.misses == 4
                    PropertyChanges { target: hangmanBlockImage; source: "img_hangman_4.png" }
                }
            ]
        }

        Rectangle {
            id: inputBlock

            property bool enabled: false

            width: 180
            anchors { top: parent.top; left: hangmanBlock.right; right: parent.right; bottom: parent.bottom; margins: 5 }

            //child Objects
            Text {
                id: inputBlockCharacter

                anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter
                font { family: "Helvetica"; pointSize: 48; capitalization: Font.AllUppercase }
                color: systemPalette.highlightedText
                focus: false
                text: ""

                Keys.onPressed: if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                                    if (inputBlockCharacter.text.match(/([a-z]|[0-9])/i) !== null) {

                                        Engine.userInput(inputBlockCharacter.text);

                                    }
                                } else {
                                    inputBlockCharacter.text = event.text;
                                }

            }

            Text {
                id: inputBlockMissedCharacters

                width: 160;
                anchors { bottom: parent.bottom; bottomMargin: 5 }
                anchors.horizontalCenter: parent.horizontalCenter
                font { family: "Helvetica"; pointSize: 14; capitalization: Font.AllUppercase }
                color: "red"
                text: ""

            }

            //states
            states : [
                State {
                    name: "Enabled"; when: inputBlock.enabled
                    PropertyChanges { target: inputBlockCharacter; focus: true }
                    PropertyChanges { target: inputBlockCharacter; text: "" }
                    PropertyChanges { target: inputBlockMissedCharacters; text: "" }
                }
            ]
        }
    }

    Rectangle {
        id: movieNameSection

        height: 150
        anchors { top: infoSection.bottom; left: parent.left; right: parent.right; }
        border { color: "black"; width: 1 }

        //child Objects
        Text {
            id: movieNameSectionText

            width: 260
            anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter
            font { family: "Helvetica"; pointSize: 24; capitalization: Font.AllUppercase }
            color: systemPalette.text
            wrapMode: Text.Wrap
            text: ""
        }

    }

    Rectangle {
        id: hintSection

        z: -1
        height: 150
        anchors { top: movieNameSection.bottom; left: parent.left; right: parent.right; }
        border { color: "black"; width: 1 }
        color: systemPalette.midlight

        //child Objects
        Flickable {
            id: hintSectionFlickable

            anchors.fill: parent
            contentHeight: actorBlock.height + directorBlock.height + musicDirectorBlock.height

            //child Objects
            Item {
                id: actorBlock

                property bool enabled: false

                height: 40
                anchors { top: parent.top; left: parent.left; right: parent.right; margins: 5 }

                //child Objects
                Text {
                    id: actorBlockLabel

                    anchors { left: parent.left; leftMargin: 5 }
                    anchors.verticalCenter: parent.verticalCenter
                    font { family: "Helvetica"; pointSize: 14; }
                    text: "Actors: "
                }

                Text {
                    id: actorBlockData

                    anchors { left: actorBlockLabel.right; margins: 5 }
                    font { family: "Helvetica"; pointSize: 14; }
                    text: ""
                }

                MouseArea {
                    id: actorBlockMouseArea

                    anchors.fill: parent
                    onClicked: actorBlock.enabled = true;
                }

                //states
                states : [
                    State {
                        name: "Enabled"; when: actorBlock.enabled
                        PropertyChanges { target: actorBlockData; text: movieActors }
                        StateChangeScript { script: Engine.hintClicked() }
                    }
                ]
            }

            Item {
                id: directorBlock

                property bool enabled: false

                height: 40
                anchors { top: actorBlock.bottom; left: parent.left; right: parent.right; margins: 5 }

                //child Objects
                Text {
                    id: directorBlockLabel

                    anchors { left: parent.left; leftMargin: 5 }
                    anchors.verticalCenter: parent.verticalCenter
                    font { family: "Helvetica"; pointSize: 14; }
                    text: "Director: "
                }

                Text {
                    id: directorBlockData

                    anchors { left: directorBlockLabel.right; margins: 5 }
                    font { family: "Helvetica"; pointSize: 14; }
                    text: ""
                }

                MouseArea {
                    id: directorBlockMouseArea

                    anchors.fill: parent
                    onClicked: directorBlock.enabled = true;
                }

                //states
                states : [
                    State {
                        name: "Enabled"; when: directorBlock.enabled
                        PropertyChanges { target: directorBlockData; text: movieDirector }
                        StateChangeScript { script: Engine.hintClicked() }
                    }
                ]
            }

            Item {
                id: musicDirectorBlock

                property bool enabled: false

                height: 40
                anchors { top: directorBlock.bottom; left: parent.left; right: parent.right; margins: 5 }

                //child Objects
                Text {
                    id: musicDirectorBlockLabel

                    anchors { left: parent.left; leftMargin: 5 }
                    anchors.verticalCenter: parent.verticalCenter
                    font { family: "Helvetica"; pointSize: 14; }
                    text: "Music Director: "
                }

                Text {
                    id: musicDirectorBlockData

                    anchors { left: musicDirectorBlockLabel.right; margins: 5 }
                    font { family: "Helvetica"; pointSize: 14; }
                    text: ""
                }

                MouseArea {
                    id: musicDirectorBlockMouseArea

                    anchors.fill: parent
                    onClicked: musicDirectorBlock.enabled = true;
                }

                //states
                states : [
                    State {
                        name: "Enabled"; when: musicDirectorBlock.enabled
                        PropertyChanges { target: musicDirectorBlockData; text: movieMusicDirector }
                        StateChangeScript { script: Engine.hintClicked() }
                    }
                ]
            }

            //states
            // Only show the scrollbars when the view is moving.
            states: State {
                name: "ShowScrollBar"
                when: hintSectionFlickable.movingVertically
                PropertyChanges { target: verticalScrollBar; opacity: 1 }
            }


            //transitions
            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 400 }
            }
        }

        ScrollBar {
            //id
            id: verticalScrollBar

            anchors.right: hintSectionFlickable.right
            width: 6; height: hintSectionFlickable.height
            opacity: 0
            orientation: Qt.Vertical
            position: hintSectionFlickable.visibleArea.yPosition
            pageSize: hintSectionFlickable.visibleArea.heightRatio

        }

    }

}
