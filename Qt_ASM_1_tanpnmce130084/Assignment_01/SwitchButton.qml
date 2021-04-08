import QtQuick 2.12

MouseArea {
    id: root
    property string icon_on: ""
    property string icon_off: ""
    property string icon_on_pressed: ""
    property string icon_off_pressed: ""
    property int status: 0 //0-Off 1-On
    implicitWidth: img.width
    implicitHeight: img.height

    Image {
        id: img
        source: root.status === 0 ? icon_off : icon_on
    }

    /** Handle the mouse events */
    // Handle event when mouse is clicked on
    onClicked: {
        // The normal case (is not the Play and Pause button)
        if (icon_on_pressed === "" && icon_off_pressed === "") {
            // Check status to change status between 1 and 0
            root.status == 0 ? root.status = 1 : root.status = 0
        }
    }

    // Handle event when mouse is pressed on
    onPressed: {
        // The special case (is the Play and Pause button)
        if (icon_on_pressed !== "" && icon_off_pressed !== "") {

            // Check status to display correct type of hold button (Play button or Pause button)
            if (root.status == 0) {
                img.source = icon_off_pressed   // hold-play.png
            } else {
                img.source = icon_on_pressed    // hold-pause.png
            }
        }
    }

    // Handle event when mouse is released
    onReleased: {
        // The special case (is the Play and Pause button)
        if (icon_on_pressed !== "" && icon_off_pressed !== "") {

            // Check status to change correct type of button (Play button or Pause button)
            if (root.status == 0) {
                img.source = icon_on    // pause.png
                root.status = 1
            } else {
                img.source = icon_off   // play.png
                root.status = 0
            }
        }
    }
}
