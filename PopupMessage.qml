import QtQuick 2.0
import QtQuick.Controls 2.3
import ConstGlobalLib 1.0
/**
 * PopupMessage.qml
 * Shows information popup
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */

Item{
    id: control
    //z: 1000000
//    parent: app.rootItem
    readonly property int defTimeout: 2500
    readonly property color defColor: "#18abf5"
    property string text
    property font   font
    property int    timeout:      defTimeout
    property color  textColor:    "white"
    property color  baseColor:    defColor
    property color  backColor:    Qt.darker(baseColor)
    property color  borderColor:  Qt.lighter(baseColor)
    property int    borderRadius: dp(10)
    property int    borderWidth:  dp(3)
    property int    opacityTime:  250

    width:  cBack.width
    height: cBack.height

    anchors.bottom:           parent.bottom
    anchors.bottomMargin:     dp(40)
    anchors.horizontalCenter: parent.horizontalCenter

    property int maxWidth: parent.width

    Rectangle {
        id:           cBack
        color:        backColor
        border.color: borderColor
        border.width: borderWidth
        radius:       borderRadius
        width:        cText.width  + dp(25)
        height:       cText.height + dp(15)

        Text {
            id:                  cText
            anchors.centerIn:    parent
            text:                control.text
//            font.family:         Theme.boldFont.name
            color:               textColor
            wrapMode:            Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
        }

        MouseArea{
            anchors.fill: parent
            onClicked: control.enabled = false
        }
    }

    enabled: false
    opacity: enabled ? 1 : 0

    Behavior on opacity { NumberAnimation { duration: opacityTime}}

    Timer{
        id: timer
        interval:    timeout - opacityTime
        onTriggered: enabled = false
    }

    function show(msg, time, bColor)
    {
        if (msg)  text    = msg
        if (time) timeout = time
        else timeout = defTimeout
        if (bColor) baseColor = bColor
        else baseColor = defColor
        cText.width = control.maxWidth
        cBack.width = cText.contentWidth > control.maxWidth - dp(25) - dp(20) ? control.maxWidth - dp(20) : cText.contentWidth + dp(25)
        cText.width = cBack.width - dp(25)
        enabled = true
        timer.restart()
    }

    function hide()
    {
        enabled = false
    }

}
