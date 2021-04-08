import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width  : 1920
    height : 1080
    visible: true
    visibility: Qt.WindowFullScreen // Run with "FullScreen"
    id: windowRoot
    title  : qsTr("Media Player")

    // Declare color property
    property string text_color: "white"
    property string transparent_color: "transparent"

    /** Application background */
    Image {
        id: imgBackground
        source: "Image/background.png"
        fillMode:Image.PreserveAspectFit; clip:true
    }

    /** Container Rectangle consist of Playlist and Media info + Media controler */
    Rectangle {
        id: rectContainer
        color: transparent_color

        //Title
        Rectangle {
            id: rectTitle
            width : imgTitle.implicitWidth
            height: imgTitle.implicitHeight

            // Title background
            Image {
                id: imgTitle
                source: "Image/title.png"
            }

            // Title text
            Text {
                id: textTitle
                text : "Media Player"
                color: text_color
                font.pointSize: 18
                anchors.centerIn: parent
            }
        }

        /** Playlist */
        Rectangle {
            id: rectPlaylist
            width : imgPlaylist.implicitWidth
            height: imgPlaylist.implicitHeight
            color : transparent_color
            anchors.top: rectTitle.bottom

            // Playlist background
            Image {
                id: imgPlaylist
                source: "Image/playlist.png"
            }

            /** Playlist Item */
            Rectangle {
                id: rectPlaylistItem
                width : imgPlaylistItem.implicitHeight
                height: imgPlaylistItem.implicitHeight
                color : transparent_color

                // Playlist item background
                Image {
                    id: imgPlaylistItem
                    source: "Image/playlist_item.png"
                }

                Text {
                    id: textPlaylist
                    x : 10
                    text : qsTr("Playlist item")
                    color: "#B2C3AE"
                    font.pointSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        /** Media Info + Media Controler */
        Rectangle {
            id: rectMedia
            width : windowRoot.width - rectPlaylist.width
            height: windowRoot.height - 80
            anchors.top : rectTitle.bottom
            anchors.left: rectPlaylist.right
            color: transparent_color

            // Text music name
            Text {
                id: textMusicName
                text : qsTr("Music Name")
                font.pointSize: 18
                color: text_color
                anchors.left: rectMedia.left
                anchors.leftMargin: 10
                anchors.top : rectMedia.top
                anchors.topMargin:  15
            }

            // Image music icon
            Image {
                id: imgMusic
                source: "Image/music.png"
                fillMode:Image.PreserveAspectFit; clip:true
                anchors.right:rectMedia.right
                anchors.rightMargin:50
                anchors.top: rectMedia.top
                anchors.topMargin:  20
            }

            // Text number of song
            Text {
                id: textNumOfSong
                text : qsTr("3")
                color: text_color
                font.pointSize: 22
                anchors.top: rectMedia.top
                anchors.topMargin: 15
                anchors.left: imgMusic.right
                leftPadding: 5
            }

            //Text Singer
            Text {
                id: textSinger
                text : qsTr("Singer")
                color: text_color
                font.pointSize: 18
                anchors.left: rectMedia.left
                anchors.leftMargin: 10
                anchors.top : rectMedia.top
                anchors.topMargin:  50
            }


            /** Artist image */
            Item {
                id: itemArtistImage
                y : 100
                width : rectMedia.width
                height: imgHongkong1.implicitHeight
                anchors.left: rectMedia.left
                anchors.leftMargin: 50
                anchors.top : textSinger.bottom
                anchors.topMargin : 80

                /** Shows artist pictures horizontally  */
                Row {
                    spacing: 25
                    Image {
                        id: imgBuiAnhTuan
                        width : imgBuiAnhTuan.implicitWidth
                        height: imgBuiAnhTuan.implicitHeight
                        source: "Image/Bui-Anh-Tuan.png"
                        anchors.verticalCenter: imgHongkong1.verticalCenter
                        anchors.centerIn: itemArtistImage.Center
                    }

                    Image {
                        id: imgHongkong1
                        source: "Image/Hongkong1.png"
                        width : imgHongkong1.implicitWidth
                        height: imgHongkong1.implicitHeight
                    }

                    Image {
                        id: imgHaAnhTuan
                        width : imgHaAnhTuan.implicitWidth
                        height: imgHaAnhTuan.implicitHeight
                        source: "Image/Ha-Anh-Tuan.png"
                        anchors.verticalCenter: imgHongkong1.verticalCenter
                    }
                }
            }

            /** Progress bar */
            Item {
                id: itemProgress
                width : rectMedia.width
                height: 20
                anchors.left: rectMedia.left
                anchors.leftMargin: 50
                anchors.top : itemArtistImage.bottom
                anchors.topMargin : 80

                // Current time
                Text {
                    id: textCurrentTime
                    text : qsTr("00:00")
                    color: text_color
                    font.pointSize: 14
                    anchors.left: itemProgress.left
                    anchors.leftMargin: 50
                }

                // Progress bar background
                Image {
                    id: imgProgressBarBG
                    source: "Image/progress_bar_bg.png"
                    anchors.left: textCurrentTime.right
                    anchors.leftMargin: 10
                    anchors.top : textCurrentTime.top
                    anchors.topMargin : 13
                }

                // Progress bar
                Image {
                    id: imgProgressBar
                    source: "Image/progress_bar.png"
                    width: 45
                    anchors.left: textCurrentTime.right
                    anchors.leftMargin: 10
                    anchors.top : textCurrentTime.top
                    anchors.topMargin : 13
                }

                // Point at current time
                Image {
                    id: imgPoint
                    source: "Image/point.png"
                    anchors.left: imgProgressBar.right
                    anchors.leftMargin: 1
                    anchors.top : textCurrentTime.top
                    anchors.topMargin : 1
                }

                // End time
                Text {
                    id: textEndTime
                    text: qsTr("00:00")
                    color: text_color
                    font.pointSize: 14
                    anchors.left: imgProgressBarBG.right
                    anchors.leftMargin: 10
                }
            }

            /** Media controler */
            Rectangle {
                id: rectMediaControler
                width : textEndTime.x - textCurrentTime.x + 60
                height: btnPlayAndPause.implicitHeight
                color : transparent_color
                anchors.left: itemProgress.left
                anchors.leftMargin: 50
                anchors.top : itemProgress.bottom
                anchors.topMargin : 50

                // Button Shuffle song
                SwitchButton {
                    id: btnShuffle
                    icon_off: "Image/shuffle.png"   // Set the image by status when click on button
                    icon_on : "Image/shuffle-1.png"  // Set the image by status when click on button
                    anchors.left: rectMediaControler.left
                    anchors.verticalCenter: btnPlayAndPause.verticalCenter
                }

                // Button Previous song
                ButtonControl {
                    id: btnPrevious
                    icon_default : "Image/prev.png"         // Set the default image for button
                    icon_pressed : "Image/hold-prev.png"    // Change the image when press on button
                    icon_released: "Image/prev.png"         // Change the image when release the button
                    anchors.verticalCenter: btnPlayAndPause.verticalCenter
                    anchors.right: btnPlayAndPause.left
                    anchors.rightMargin: 1
                }

                // Button Play and Pause
                SwitchButton {
                    id: btnPlayAndPause
                    icon_off: "Image/play.png"                  // Set the image by status when click on button
                    icon_on : "Image/pause.png"                 // Set the image by status when click on button
                    icon_off_pressed: "Image/hold-play.png"     // Set the image by status when press on button
                    icon_on_pressed : "Image/hold-pause.png"    // Set the image by status when press on button
                    anchors.horizontalCenter: rectMediaControler.horizontalCenter
                }

                // Button Next song
                ButtonControl {
                    id: btnNext
                    icon_default : "Image/next.png"         // Set the default image for button
                    icon_pressed : "Image/hold-next.png"    // Set the image when press on button
                    icon_released: "Image/next.png"         // Set the image when release the button
                    anchors.verticalCenter: btnPlayAndPause.verticalCenter
                    anchors.left : btnPlayAndPause.right
                    anchors.leftMargin: 1
                }

                // Button Repeat song
                SwitchButton {
                    id: btnRepeat
                    icon_off: "Image/repeat"            // Change the image by status when click on button
                    icon_on : "Image/repeat1_hold.png"  // Change the image by status when click on button
                    anchors.right: rectMediaControler.right
                    anchors.verticalCenter: btnPlayAndPause.verticalCenter
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("Build & Run Successful!")
    }
}
