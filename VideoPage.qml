/**
 * VideoPage.qml
 * Renders camera ui here and also video file
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
import QtQuick 2.0
import QtMultimedia 5.9
import ConstGlobalLib 1.0
import ObjectsRecognizer 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.3

Item {
    id: root
    objectName: qsTr("Live")
    width: ConstGlobal.windowWidth()
    height: ConstGlobal.windowHeight()
    // Properties
    property double minConfidence
    property string model
    property bool showTime
    property int nThreads
    property bool acceleration
    property bool isFileSelected: false
    property bool isPlaying: false
    // Selected camera index
    property int cameraIndex: 0

    signal openSetings();

    // Start and stop camera
    onVisibleChanged: {
        if (visible) camera.start()
        else camera.stop()
    }

    FileDialog {
        id: fileDialog
        title: "Select video a file"
        folder: shortcuts.movies
        nameFilters: [ "Video files (*.mp4 *.avi)", "All files (*)"]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls[0])
            player.source = fileDialog.fileUrls[0]
            videoOutput.source = player
            player.stop()
            player.play();
            isFileSelected = true
            isPlaying = true
        }
        onRejected: {
            console.log("Canceled")
        }
        Component.onCompleted: visible = true //opens ata startup
    }

    MessageDialog {
        id: messageDialog
        title: "Info"
        text: ""
        onAccepted: {
            messageDialog.close()
        }
    }

    Keys.onReleased:{
        if (event.key === Qt.Key_Space)
        {
                if(isFileSelected)
                {
                    if(isPlaying)
                    {
                        isPlaying =false
                        player.pause()
                    }
                    else
                    {
                        isPlaying = true
                        player.play()
                    }
                }
        }
    }

    Camera{
        id: camera
        property bool availableCamera:  QtMultimedia.availableCameras.length>0
        property bool availableCameras: QtMultimedia.availableCameras.length>1
    }

    MediaPlayer {
        id: player
        autoPlay: true
        onError: {
            if(!hasVideo)
            {
            var msg;
            if(error === 1)
                msg = "A media resource couldn't be resolved. Try AVI format"
            else if(error === 2)
                msg = "The format of a media resource isn't (fully) supported. Playback may still be possible, but without an audio or video component."
            else if(error === 3)
                msg = "A network error occurred."
            else if(error === 4)
                msg = "There are not the appropriate permissions to play a media resource."
            else if(error === 5)
                msg = "A valid playback service was not found, playback cannot proceed."

            messageDialog.text = "Something went wrong!.<br>"+msg+" "+status
            messageDialog.open()
            }
        }
    }

    VideoOutput {
        id: videoOutput
//        anchors.fill: parent
        width: parent.width
        anchors.top : parent.top
        anchors.verticalCenter: parent.verticalCenter
        source: camera
        visible: ( camera.availableCamera && (camera.cameraStatus == Camera.ActiveStatus) ) || isFileSelected
        autoOrientation: true
        fillMode: VideoOutput.PreserveAspectFit
        rotation: initialRotation()

        filters: [objectsRecognitionFilter]
    }


    // Right-hand side buttons
    Rectangle {
        id : buttonBarRight
        anchors.right: parent.right
        anchors.top: parent.top
        width: parent.width*0.1
        height: width * 3
        radius: width/2
        Image {
            id : cameraSwitchButn
//            width: parent.width*0.8
            height: parent.height / 3
            source: "qrc:assets/camera.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            visible: camera.availableCameras
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    videoOutput.source = camera
                    console.log("Camera index: " + cameraIndex)
                    cameraIndex = (cameraIndex+1) % QtMultimedia.availableCameras.length
                    camera.deviceId = QtMultimedia.availableCameras[cameraIndex].deviceId
                    videoOutput.rotation = initialRotation()
                    isFileSelected = false
                }
            }
        }

        Image {
            id : settingSwitchButn
//            width: parent.width*0.8
            height: parent.height / 3
            source: "qrc:assets/setting.png"
            anchors.top: cameraSwitchButn.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("Open settings")
                    openSetings()
                }
            }
        }

        Image {
            id : fileSwitchButn
//            width: parent.width*0.8
            height: parent.height / 3
            source: "qrc:assets/fileIcon.png"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("Open file")
                    fileDialog.open()
                }
            }
        }
    }

    ObjectsRecognizer {
        id: objectsRecognitionFilter
        cameraOrientation: camera.orientation
        videoOrientation: videoOutput.orientation - initialRotation()
        contentSize: Qt.size(videoOutput.width,videoOutput.height)

        minConfidence: root.minConfidence
        model:         root.model
        showTime:      root.showTime
        nThreads:      root.nThreads
        acceleration:  root.acceleration
    }

    // No camera found
    Item{
        anchors.centerIn: parent
        width: parent.width
        visible: (!camera.availableCamera) && !isFileSelected
        Column{
            width: parent.width
            spacing: dp(25)
            anchors.centerIn: parent
            Image {
                width: parent.width * 0.2
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:assets/camera.png"
                fillMode: Image.PreserveAspectFit
            }

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("No camera detected")                
            }
        }
    }

    // Loading camera
    Item{
        anchors.centerIn: parent
        width: parent.width
        visible: (camera.availableCamera && camera.cameraStatus != Camera.ActiveStatus) && !isFileSelected
        Column{
            width: parent.width
            spacing: dp(25)
            anchors.centerIn: parent
            Image {
                id: videoIcon
                width: parent.width * 0.2
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:assets/camera.png"
                fillMode: Image.PreserveAspectFit
                SequentialAnimation {
                       running: true
                       loops: Animation.Infinite
                       NumberAnimation { target: videoIcon; property: "opacity"; from: 1; to: 0; duration: 500 }
                       NumberAnimation { target: videoIcon; property: "opacity"; from: 0; to: 1; duration: 500 }
                 }
            }

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Loading camera") + " ..."
            }
        }
    }

    // BUG: front camera rotation on ios [QTBUG-37955]
    // Qt.platform.os === "ios", system.isIos, Theme.isIos
    function initialRotation()
    {
        return Qt.platform.os === "ios" && camera.position === Camera.FrontFace ? 180 : 0
    }

    function dp(dpVal) {
        var px = Math.round(dpVal * (screenPixelDensity / 160));
        console.log("px: ",dpVal)
        if(Qt.platform.os == "windows" || Qt.platform.os == "mac")
            return px*2;
        else
            return px;
    }
}
