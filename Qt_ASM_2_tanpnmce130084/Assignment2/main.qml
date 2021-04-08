import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtMultimedia 5.12

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    visibility: Qt.WindowFullScreen // Run with "FullScreen"
    title: qsTr("Media Player")

    //AppModel
    ListModel {
        id: appModel
        ListElement { title: "Phố Không Mùa"; singer: "Bùi Anh Tuấn" ; icon: "qrc:/Image/Bui-Anh-Tuan.png"; source: "qrc:/Music/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3" }
        ListElement { title: "Chuyện Của Mùa Đông"; singer: "Hà Anh Tuấn" ; icon: "qrc:/Image/Ha-Anh-Tuan.png"; source: "qrc:/Music/Chuyen-Cua-Mua-Dong-Ha-Anh-Tuan.mp3"}
        ListElement { title: "Hongkong1"; singer: "Nguyễn Trọng Tài" ; icon: "qrc:/Image/Hongkong1.png"; source: "qrc:/Music/Hongkong1-Official-Version-Nguyen-Trong-Tai.mp3" }
    }
    //MediaPlayer
    MediaPlayer{
        id: player
        property bool shuffer: false    // property shuffle song
        property bool repeat : false    // property repeat  song
        onPlaybackStateChanged: {4
            // The song is end
            if (playbackState == MediaPlayer.StoppedState && position == duration){

                // The case the repeat feature is chosen
                if (player.repeat) {
                    // Set source of current song to source of Media Player again
                    player.source = mediaPlaylist.currentItem.myData.source
                    player.play()   // Play media

                } else {    // If the repeat feature is not chosen

                    // The case the shuffle feature is chosen
                    if (player.shuffer) {
                        // Random a new index from media playlist
                        // If the new index is coincide with current index then random again
                        var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                        while (newIndex == mediaPlaylist.currentIndex) {
                            newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                        }

                        mediaPlaylist.currentIndex = newIndex   // Assign new index to current index

                    } else {    // If the shuffle feature is not chosen

                        // The case current index is not last index
                        if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                            // Increase current index by 1
                            mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
                        } else {    // The case current index is last index
                            mediaPlaylist.currentIndex = 0  // Set current index to 0
                        }
                    }
                }
            }
        }
        autoPlay: true
    }

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
        model: appModel
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
                text: title     // Song title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                // Set the index to play the current song with the index of the selected playlist
                mediaPlaylist.currentIndex = index
            }

            // Change background playlist item when click on
            onPressed: {
                playlistItem.source = "qrc:/Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/Image/playlist.png"
            }
        }
        highlight: Image {  // Highlight the current song is playing
            source: "qrc:/Image/playlist_item.png"
            Image {     // Background
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
        onCurrentItemChanged: {
            // Set source of song just changed to source of Media Player
            player.source = mediaPlaylist.currentItem.myData.source;
            player.play();  // Play the song
            // Set the current index of album art with the index of the song just chosen in playlist
            album_art_view.currentIndex = currentIndex
        }
    }
    //Media Info
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: mediaPlaylist.currentItem.myData.title    // Song's title
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
        text: mediaPlaylist.currentItem.myData.singer   // Song's singer
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
        text: mediaPlaylist.count   // The number of song in playlist
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

            // Singer image
            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                source: icon    // singer image get from model
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    album_art_view.currentIndex = index
                }
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
        pathItemCount: 3
        focus: true
        model: appModel
        delegate: appDelegate
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
            // Set current index of album to current index of Playlist
            mediaPlaylist.currentIndex = currentIndex
        }
    }
    //Progress
    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }

    function getTime(time){
        time = time/1000
        var minutes = Math.floor(time / 60);
        var seconds = Math.floor(time - minutes * 60);

        return str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
    }

    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        text: getTime(player.position)  // Current playback position with format mm:ss
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
        from : 0
        to   : player.duration  // Duration of the media
        value: player.position  // Value changes arcording to current playback position
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
            if (player.seekable){
                // Seeks the current playback position to offset (offset is value of progressBar).
                player.seek(progressBar.value)
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: getTime(player.duration)  // Duration of the media
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
        status: player.shuffer
        onClicked: {
            // Change state of shuffle button when click on shuffle feature
            player.shuffer = !player.shuffer
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
            // The case current index of playlist is greater than index 0
            // Decrease current index by 1
            if (mediaPlaylist.currentIndex > 0) {
                mediaPlaylist.currentIndex--

            } else {    // If current index of playlist is 0
                // Set current index of playlist by last index of playlist
                mediaPlaylist.currentIndex = mediaPlaylist.count - 1
            }
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        icon_default: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
        icon_pressed: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image/hold-pause.png" : "qrc:/Image/hold-play.png"
        icon_released: player.playbackState== MediaPlayer.PlayingState ?  "qrc:/Image/play.png" : "qrc:/Image/pause.png"
        onClicked: {
            // Change the playbackState of Player (between Play and Pause) when click on play feature
            player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play()
        }
        Connections {
            target: player
            onPlaybackStateChanged:{
                // The case change song when the media is pausing
                // then change icon of button play to icon pause (media is playing)
                if(player.playbackState == MediaPlayer.PlayingState){
                    play.source = "qrc:/Image/pause.png"
                }
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
            // The case the shuffle feature is chosen
            if (player.shuffer) {

                // Random a new index from media playlist
                // If the new index is coincide with current index then random again
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                while (newIndex == mediaPlaylist.currentIndex) {
                    newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                }

                mediaPlaylist.currentIndex = newIndex   // Assign new index to current index

            } else {    // If the shuffle feature is not chosen

                // The case current index is not last index
                if (mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                    // Increase current index by 1
                    mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;

                } else {    // The case current index is last index
                    mediaPlaylist.currentIndex = 0  // Set current index to 0
                }
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
        status: player.repeat
        onClicked: {
            // Change state of repeat button when click on repeat feature
            player.repeat = !player.repeat
        }
    }
}
