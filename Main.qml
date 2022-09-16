/**
 * Main.qml
 * Main UI for application it helps navigate pages
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
//import QtQuick.LocalStorage 2.15 as Storage
import ConstGlobalLib 1.0

ApplicationWindow {
    id: app
    title: "8-DK Qt tflite test app"
    width: ConstGlobal.windowWidth()
    height: ConstGlobal.windowHeight()
    visibility: Window.FullScreen
    visible: true
    // Storage keys
    readonly property string kMinConfidence: "MinConfidence"
    readonly property string kModel:         "Model"
    readonly property string kShowTime:      "ShowTime"
    readonly property string kNThreads:      "NThreads"
    readonly property string kAcceleration:  "Acceleration"

    // Default values
    property double defMinConfidence: 0.5
    property string defModel: "ImageClassification"
    property bool   defShowTime: false
    property int    defNThreads: 1
    property bool   defAcceleration: false

    // Properties
    property double minConfidence
    property string model
    property bool   showTime
    property int    nThreads
    property bool   acceleration

//    // Local storage component
//    Storage {
//        id: storage

//        Component.onCompleted: {
//            minConfidence = getValue(kMinConfidence) !== undefined ? getValue(kMinConfidence) : defMinConfidence
//            model         = getValue(kModel)         !== undefined ? getValue(kModel)         : defModel
//            showTime      = getValue(kShowTime)      !== undefined ? getValue(kShowTime)      : defShowTime
//            nThreads      = getValue(kNThreads)      !== undefined ? getValue(kNThreads)      : defNThreads
//            acceleration  = getValue(kAcceleration)  !== undefined ? getValue(kAcceleration)  : defAcceleration
//        }
//    }

        Component.onCompleted: {
            minConfidence = defMinConfidence
            model         = defModel
            showTime      = defShowTime
            nThreads      = defNThreads
            acceleration  = defAcceleration
        }

    Rectangle{
        id: stackViewRectangle
        anchors.fill: parent
        color: ConstGlobal.getTransparentColor()
        border.color: "red"

        StackView {
            id: mainStackView
            initialItem: videopage
            anchors.fill: parent
            background: Rectangle{
                color: "yellow"
            }
           property VideoPage videopage: VideoPage{
                        id: videoPage
                        minConfidence: app.minConfidence
                        model: app.model
                        showTime: app.showTime
                        nThreads: app.nThreads
                        acceleration: app.acceleration
                        onOpenSetings: {
                            mainStackView.push(mainStackView.appsettingspage)
                        }
            }

            property AppSettingsPage appsettingspage: AppSettingsPage{
                        id: appSettingsPage
                        minConfidence: app.minConfidence
                        model: app.model
                        showTime: app.showTime
                        nThreads: app.nThreads
                        acceleration: app.acceleration

                        onMinConfidenceChanged: {
                            app.minConfidence = appSettingsPage.minConfidence
                            defMinConfidence = app.minConfidence
                        }

                        onModelChanged: {
                            app.model = appSettingsPage.model
                            defModel = app.model
                        }

                        onShowTimeChanged: {
                            app.showTime = appSettingsPage.showTime
                            defShowTime = app.showTime
                        }

                        onNThreadsChanged: {
                            app.nThreads = appSettingsPage.nThreads
                            defNThreads = app.nThreads
                        }

                        onAccelerationChanged: {
                            app.acceleration = appSettingsPage.acceleration
                            defAcceleration = app.acceleration
                        }

                        onGoBack:{
                            mainStackView.pop()
                        }
            }
        }

    }

}
