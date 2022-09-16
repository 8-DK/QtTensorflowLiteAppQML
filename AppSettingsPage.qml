/**
 * AppSettingsPage.qml
 * Configures TFlite options
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
import QtQuick 2.4
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import ConstGlobalLib 1.0

Item {
    objectName: qsTr("Settings")
    id: root
    width: ConstGlobal.windowWidth()
    height: ConstGlobal.windowHeight()
    // Properties
    property double minConfidence
    property string model
    property bool   showTime
    property int    nThreads
    property bool   acceleration

    signal goBack();

    PopupMessage {
        id: message
        timeout: 5000
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: column.width;
        contentHeight: column.height

        Column{
            id:    column
            width: root.width

            Item{ height: dp(20); width: 1 }

            Text{
                anchors.margins: dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                text: qsTr("Minimum confidence")
            }

            Item{ height: dp(10); width: 1 }

            Slider{
                id: slider
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*dp(20)
                from:  0
                to:    1
                value: minConfidence
                live:  true
                onValueChanged: minConfidence = value
            }

            Text {
                anchors.margins: dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                color: "#18abf5"
                text: Math.round(slider.position * 100) + " %"
            }

            Item{ height: dp(30); width: 1 }

            Row {
                width: parent.width
                spacing: dp(2)

                Item{
                    height: 1
                    width: (parent.width - parent.spacing - tThread.width - iThread.width)*0.5
                }

                Text{
                    id: tThread
                    anchors.leftMargin: dp(30)
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    text: qsTr("Number of threads")
                }

                Button {
                    id: iThread
                    icon.source: "qrc:assets/infocircle.png"
                    icon.color: "#18abf5"
                    onClicked: message.show(sThreads.to + " " + (sThreads.to>1 ? qsTr("cores") : qsTr("core")) + " " + qsTr("detected"))
                }
            }

            //Item{ height: dp(10); width: 1 }

            Slider{
                id: sThreads
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*dp(15)
                from:  1
                to:    auxUtils.numberThreads()
                enabled: to>1
                live:  true
                snapMode: Slider.SnapAlways
                stepSize: 1
                value: nThreads
                onValueChanged: nThreads = value
            }

            Text {
                anchors.leftMargin:  dp(5)
                anchors.rightMargin: dp(5)
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                color: "#18abf5"
                text: sThreads.value + " " + (sThreads.value>1 ? qsTr("threads") : qsTr("thread"))
            }

            Item{
                height: dp(30)
                width:  1
            }

            Row{
                width: parent.width - 2*dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: width - tShowInfTime.width - sShowInfTime.width

                Text {
                    id: tShowInfTime
                    text: qsTr("Show inference time")
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Switch{
                    anchors.verticalCenter: parent.verticalCenter
                    id: sShowInfTime
                    checked: showTime
                    onToggled: showTime = checked
                }
            }

            Item{ height: dp(20); width: 1 }

            Row{
                width: parent.width - 2*dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: width - rAcceleration.width - sAcceleration.width

                Row {
                    id: rAcceleration
                    spacing: dp(2)
                    width: tAcceleration.width + iAcceleration.width + spacing

                    Text {
                        id: tAcceleration
                        text: qsTr("Android Neural Networks")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                    }

                    Button {
                        id: iAcceleration                        
                        icon.source: "qrc:assets/infocircle.png"
                        icon.color: sAcceleration.enabled ? "#18abf5" : "red"
                        onClicked: message.show(qsTr("Only for Android 8.1 or higher"),message.defTimeout,sAcceleration.enabled?message.defColor:"red")
                    }
                }

               Switch{
                    anchors.verticalCenter: parent.verticalCenter
                    id: sAcceleration
                    enabled: Qt.platform.os === "android"
                    checked: enabled ? acceleration : false
                    onToggled: acceleration = checked
                }
            }

            Item{ height: dp(40); width: 1 }

            Text{
                anchors.margins: dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                text: qsTr("Tensorflow Lite model")
            }

            Item{ height: dp(30); width: 1 }

           ButtonGroup { id: group }

            CheckBox{
                id: chkClassification
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*dp(20)
                text: qsTr("Image classification")
                ButtonGroup.group: group
                checked: model === "ImageClassification"
                onCheckedChanged: if (checked) model = "ImageClassification"; else chkDetection.checked = true
            }

            Item{ height: dp(20); width: 1 }

            CheckBox{
                id: chkDetection
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*dp(20)
                text: qsTr("Object detection")
                ButtonGroup.group: group
                checked: model === "ObjectDetection"
                onCheckedChanged: if (checked) model = "ObjectDetection"; else chkClassification.checked = true
            }
            Button {
                id: backBtn
                icon.source: "qrc:assets/backbtn.png"
                icon.color: "#18abf5"
                onClicked: {
                    goBack()
                }
            }
        }
    }

    function dp(dpVal) {
        var px = Math.round(dpVal * (screenPixelDensity / 160));
        if(Qt.platform.os == "windows" || Qt.platform.os == "mac")
            return px*2;
        else
            return px;
    }
}
