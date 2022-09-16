/**
 * main.cpp
 * Pogram entry point stuff
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
#include <QApplication>
#include <QApplication>

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

#include "tensorflowlite.h"
#include "auxutils.h"
#include "objectsrecogfilter.h"
#include "ConstGlobal.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    app.setOrganizationName("8-Dk");
    app.setOrganizationDomain("https://github.com/8-DK");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // Register meta types
    qRegisterMetaType<QList<QRectF>>("QList<QRectF>");

    // Register C++ QML types
    qmlRegisterType<ObjectsRecogFilter>("ObjectsRecognizer", 1, 0, "ObjectsRecognizer");
    qmlRegisterSingletonType<ConstGlobal>("ConstGlobalLib", 1, 0, "ConstGlobal",&ConstGlobal::getInstance);

    engine.rootContext()->setContextProperty("screenPixelDensity", QGuiApplication::primaryScreen()->physicalDotsPerInch());     

    // Global objects
    AuxUtils* auxUtils = new AuxUtils();
    engine.rootContext()->setContextProperty("auxUtils",auxUtils);

    engine.load(url);
    return app.exec();
}
