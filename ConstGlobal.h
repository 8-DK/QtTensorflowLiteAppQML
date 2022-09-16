/**
 * ConstGlobal.h
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
#ifndef STYLE_H
#define STYLE_H

#include <QObject>
#include <QtDebug>
#include <QQmlProperty>
#include <QQuickItem>
#include <QQmlProperty>
#include <QQuickItem>
#include <QFileInfo>
#include <QFile>
#include <QDir>
#include <QStandardPaths>

class ConstGlobal : public QObject{
    Q_OBJECT
public:
    explicit ConstGlobal(QObject *parent = nullptr);

    static ConstGlobal *getInstance();
    static QObject* getInstance(QQmlEngine *engine, QJSEngine *scriptEngine){Q_UNUSED(engine);Q_UNUSED(scriptEngine);return getInstance();}

    Q_INVOKABLE int windowHeight();
    Q_INVOKABLE int windowWidth();
    static QString storagePath();
    Q_INVOKABLE double getAspectFactor();
    Q_INVOKABLE double getRectWidth();
    Q_INVOKABLE double getRectHeight();

    Q_INVOKABLE double defaultButtonWidth();
    Q_INVOKABLE double defaultButtonHeight();
    Q_INVOKABLE double defaultButtonRadius();
    Q_INVOKABLE double updateButtonWidth();
    Q_INVOKABLE double updateButtonHeight();
    Q_INVOKABLE double getRatio();
    Q_INVOKABLE double getAspectRatio();
    Q_INVOKABLE double getMarginRatio();

    Q_INVOKABLE   int getCameraScrollViewHeight();
    Q_INVOKABLE   int getGeneralSettingsScrollViewHeight();

    Q_INVOKABLE   inline QString blueColor(){return m_getThemeColor;}
    Q_INVOKABLE   inline QString whiteColor(){return m_whiteColor;}
    Q_INVOKABLE   inline QString greenColor() {return m_greenColor;}
    Q_INVOKABLE   inline QString blackColor() {return m_getTextPrimaryColor;}
    Q_INVOKABLE   inline QString lightGrayColor() {return m_lightGrayColor;}
    Q_INVOKABLE   inline QString parrotGreenColor() {return m_parrotGreenColor;}
    Q_INVOKABLE   inline QString darkGrayColor() {return m_getTextSecondaryColor;}
    Q_INVOKABLE   inline QString redColor() {return m_redColor;}

    Q_INVOKABLE   inline QString getThemeColor() {return m_themeColor;}
    Q_INVOKABLE   inline QString getBackgroundPrimaryColor() { return m_backgroundPrimaryColor;}
    Q_INVOKABLE   inline QString getBackgroundSecondaryColor() {return m_backgroundSecondaryColor;}
    Q_INVOKABLE   inline QString getTransparentColor() { return m_transparentColor;}
    Q_INVOKABLE   inline QString getSolidButtonTextColor() { return m_solidButtonTextColor;}
    Q_INVOKABLE   inline QString getTextPrimaryColor() { return m_textPrimaryColor;}
    Q_INVOKABLE   inline QString getTextSecondaryColor() { return m_textSecondaryColor;}
    Q_INVOKABLE   inline QString getThemeAssetPath() { return m_themeAssetPath;}
    Q_INVOKABLE   inline QString getAssetPath() { return "/assets/";}

    Q_INVOKABLE   inline QString getTextFieldDisable() { return m_textFieldDisableColor;}
    Q_INVOKABLE   inline QString getDropshadowColor() {return m_dropShadowColor;}
    Q_INVOKABLE   inline int getDropshadowHorizontalOffset() {return m_dropshadowHorizontalOffset;}
    Q_INVOKABLE   inline int getDropshadowVerticalOffset() {return m_dropshadowVerticalOffset;}
    Q_INVOKABLE   inline int getDropshadowRadius() {return m_dropshadowRadius;}
    Q_INVOKABLE   inline int getDropshadowSamples() {return m_dropshadowSamples;}

    Q_INVOKABLE   inline QString getRectBG1() {return m_rectBG1;}
    Q_INVOKABLE   inline QString getRectBG2() {return m_rectBG2;}

#if ENABLE_OEM_BUILD
    bool m_oem = true;
#else
    bool m_oem = false;
#endif

    QString m_dropShadowColor;
    QString m_themeColor;
    QString m_backgroundPrimaryColor;
    QString m_backgroundSecondaryColor;
    QString m_transparentColor;
    QString m_solidButtonTextColor;

    QString m_textFieldDisableColor;
    QString m_textPrimaryColor ;
    QString m_textSecondaryColor;
    QString m_themeAssetPath;

    QString m_rectBG1;
    QString m_rectBG2;


    int m_dropshadowHorizontalOffset = 2;
    int m_dropshadowVerticalOffset = 2;
    int m_dropshadowRadius = 5;
    int m_dropshadowSamples = 10;

private:
    static ConstGlobal *m_instance;
    int m_windowWidth;
    int m_windowHeight;
    double m_aspectRatio;

    double m_rectWidth;
    double m_rectHeight;

    double m_defaultButtonWidth;
    double m_defaultButtonHeight;
    double m_defaultButtonRadius;
    double m_updateButtonWidth;
    double m_updateButtonHeight;

    double m_rpaSettingsTextEditRadius;
    double m_rpaSettingsTextEditWidth;
    double m_rpaSettingsTextEditHeight;

    int m_textEditPixelSize;
    int m_loginTextEditPixelSize;
    int m_ButtonPixelSize;
    int m_textEditLabelPixelSize;
    int m_rpaSettingsLabelPixelSize;
    int m_smallLabelPixelSize;
    int m_connectedLabelPixelSize;
    int m_minMaxLabelPixelSize;
    int m_mainLabelPixelSize;
    int m_navbarHeadingPixelSize;
    int m_messageBoxTextPixelSize;

    int m_cameraScrollViewHeight;    
    int m_generalSettingsScrollViewHeight;

    QString m_getThemeColor="#48B0E5";
    QString m_whiteColor="#FFFFFF";
    QString m_greenColor = "#26A69A";
    QString m_getTextPrimaryColor = "#3C3C3C";
    QString m_lightGrayColor = "#EDEEF3";
    QString m_parrotGreenColor = "#0FD80B";
    QString m_getTextSecondaryColor = "#666666";
    QString m_redColor = "#ff0000";

public:
    double m_aspectFactor = 1;

};

#endif // STYLE_H
