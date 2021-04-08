import QtQuick 2.6
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.8

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    visibility: Qt.WindowFullScreen // Run with "FullScreen"
    title: qsTr("Media Player")
    //Backgroud of Application
    Image {
        id: backgroud
        anchors.fill: parent
        source: "qrc:/Image/background.png"
    }
    //Header
    Image {
        id: headerItem
        source: "qrc:/Image/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Media Player")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
    //Playlist
    Image {
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        source: "qrc:/Image/playlist.png"
        opacity: 0.2
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: playList_bg
        model: mPlaylistModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 675
                height: 193
                source: "qrc:/Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                mPlayer.playlist.currentIndex = mediaPlaylist.currentIndex = index
            }

            onPressed: {
                playlistItem.source = "qrc:/Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
            onCanceled: {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
        }
        highlight: Image {
            source: "qrc:/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/Image/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }
    //Media Info
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: mediaPlaylist.currentItem.myData.title
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: mediaPlaylist.currentItem.myData.singer
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: mediaPlaylist.count
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: headerItem.bottom
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "qrc:/Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            width: 400; height: 400
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                source: albumArt
            }

            MouseArea {
                anchors.fill: parent
                onClicked: album_art_view.currentIndex = mPlayer.playlist.currentIndex = index
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 50
        anchors.top: headerItem.bottom
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: mPlaylistModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 65
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = currentIndex
        }
    }
    //Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        text: player.getTimeInfo(mPlayer.position)
        color: "white"
        font.pixelSize: 24
    }
    Slider{
        id: progressBar
        width: 816
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.left: currentTime.right
        anchors.leftMargin: 20
        from: 0
        to: mPlayer.duration
        value: mPlayer.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/Image/center_point.png"
            }
        }
        onMoved: {
            if (mPlayer.seekable) mPlayer.setPosition(progressBar.value)
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: player.getTimeInfo(mPlayer.duration)
        color: "white"
        font.pixelSize: 24
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        icon_off: "qrc:/Image/shuffle.png"
        icon_on: "qrc:/Image/shuffle-1.png"
        status: mPlayer.playlist.playbackMode === Playlist.Random ? 1 : 0
        onClicked: {
            console.log("Shuffle outside if = " + shuffer.status)
            // If shuffle feature is choosing
            if (mPlayer.playlist.playbackMode === Playlist.Random) {
                console.log("Shuffle inside if = " + shuffer.status)
                // If repeat feature is chosen then repeat the song
                if (repeater.status) mPlayer.playlist.playbackMode = Playlist.CurrentItemInLoop
                // If repeat feature is NOT chosen, the music plays in the song order in the playlist
                else mPlayer.playlist.playbackMode = Playlist.Sequential

            } else {    // If shuffle feature is NOT choosing

                // If repeat feature is chosen then repeat the song
                if (repeater.status) mPlayer.playlist.playbackMode = Playlist.CurrentItemInLoop
                // If repeat feature is NOT chosen, the music plays in random order
                else mPlayer.playlist.playbackMode = Playlist.Random
            }
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: shuffer.right
        anchors.leftMargin: 220
        icon_default: "qrc:/Image/prev.png"
        icon_pressed: "qrc:/Image/hold-prev.png"
        icon_released: "qrc:/Image/prev.png"
        onClicked: {
            if (mediaPlaylist.currentIndex !== 0) {

                if(shuffer.status === 0 && repeater.status === 0){
                    mPlayer.playlist.previous()
                    mPlayer.play()
                } else if(shuffer.status !== 0){
                    if(mediaPlaylist.count > 1) {
                        mPlayer.playlist.playbackMode = Playlist.Random
                        var curIndex = mPlayer.playlist.currentIndex
                        while(mPlayer.playlist.currentIndex === curIndex){
                            mPlayer.playlist.previous()
                        }
                        mPlayer.play()
                    }
                } else if(repeater.status == 1) {
                    mPlayer.playlist.playbackMode = Playlist.Sequential
                    mPlayer.playlist.previous()
                    mPlayer.play()
                }
            } else {
                mediaPlaylist.currentIndex = mPlayer.playlist.currentIndex = mediaPlaylist.count - 1
            }
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        icon_default: mPlayer.state === MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        icon_pressed: mPlayer.state === MediaPlayer.PlayingState ?  "qrc:/Image/hold-pause.png" : "qrc:/Image/hold-play.png"
        icon_released: mPlayer.state === MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        onClicked: {
            mPlayer.state === MediaPlayer.PlayingState ? mPlayer.pause() : mPlayer.play()
        }
        Connections {
            target: mPlayer
            onStateChanged:{
                play.source = mPlayer.state === MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "qrc:/Image/next.png"
        icon_pressed: "qrc:/Image/hold-next.png"
        icon_released: "qrc:/Image/next.png"
        onClicked: {
            if (mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                if(shuffer.status === 0 && repeater.status === 0){
                    mPlayer.playlist.next()
                    mPlayer.play()
                } else if(shuffer.status !== 0){
                    if (mediaPlaylist.count > 1) {
                        var curIndex = mediaPlaylist.currentIndex
                        mPlayer.playlist.playbackMode = Playlist.Random

                        while(mPlayer.playlist.currentIndex === curIndex){
                            mPlayer.playlist.next()
                        }
                        mPlayer.play()
                    }
                } else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1 && repeater.status == 1) {
                    mPlayer.playlist.playbackMode = Playlist.Sequential
                    mPlayer.playlist.next()
                    mPlayer.play()
                }
            } else {
                mediaPlaylist.currentIndex = mPlayer.playlist.currentIndex = 0
                mPlayer.play()
            }
        }
    }
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "qrc:/Image/repeat1_hold.png"
        icon_off: "qrc:/Image/repeat.png"
        status: mPlayer.playlist.playbackMode === Playlist.CurrentItemInLoop ? 1 : 0
        onClicked: {

            // If repeat feature is choosing
            if (mPlayer.playlist.playbackMode === Playlist.CurrentItemInLoop) {
                // If shuffle feature is chosen then random order the playlist
                if (shuffer.status) mPlayer.playlist.playbackMode = Playlist.Random
                // If shuffle feature is NOT chosen, the music plays in the song order in the playlist
                else mPlayer.playlist.playbackMode = Playlist.Sequential
            } else {    // If repeat feature is NOT choosing
                mPlayer.playlist.playbackMode = Playlist.CurrentItemInLoop
            }
        }
    }
    Connections{
        target: mPlayer.playlist
        onCurrentIndexChanged: {
            album_art_view.currentIndex = mPlayer.playlist.currentIndex
        }
    }
}