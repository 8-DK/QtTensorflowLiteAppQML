/**
 * ConstGlobal.cpp
 * Global constals populate in code
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
#include "ConstGlobal.h"
#include <QDebug>
#include "QApplication"
#include "QDesktopWidget"
#include "QScreen"
#include <QMainWindow>

ConstGlobal::ConstGlobal(QObject *parent) : QObject(parent)
{

}

ConstGlobal* ConstGlobal::m_instance;

ConstGlobal* ConstGlobal::getInstance()
{
    if (ConstGlobal::m_instance == nullptr)
    {
        ConstGlobal::m_instance = new ConstGlobal(nullptr);
    }
    return ConstGlobal::m_instance;
}

int ConstGlobal::windowWidth()
{
#ifdef __android__

    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    m_windowWidth = screenGeometry.width();

#else
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    m_windowWidth = screenGeometry.width();
#endif
    return m_windowWidth;
}

int ConstGlobal::windowHeight()
{
#ifdef __android__
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    m_windowHeight = screenGeometry.height();
#else
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    m_windowHeight = screenGeometry.height();
#endif
    return m_windowHeight;
}

QString ConstGlobal::storagePath()
{
#ifdef __android__
    QString androidFolderPath(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/" + "TfLiteFiles");
       QDir androidHomePath(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
       QDir* dir=new QDir(androidFolderPath);
       if (!dir->exists()) {
           qWarning("creating new folder");
           dir->mkpath(".");
       }
       return dir->absolutePath();
#endif
       return ".";
}

double ConstGlobal::getRatio()
{
#ifdef __android__
    m_aspectRatio = (double) m_windowWidth/m_windowHeight;
    m_aspectRatio = m_aspectRatio * 0.4616;
#else
    m_aspectRatio = 1;
#endif
    return m_aspectRatio;
}

double ConstGlobal::getMarginRatio()
{
#ifdef __android__
    m_aspectRatio = (double) m_windowWidth/m_windowHeight;
    m_aspectRatio = 2.1667/m_aspectRatio;
#else
    m_aspectRatio = 1;
#endif
    return m_aspectRatio;
}

double ConstGlobal::getAspectRatio(){
#ifdef __android__
    m_aspectRatio = (double) m_windowWidth/m_windowHeight;
#else
    m_aspectRatio = 1;
#endif
    qDebug()<<"Aspect RRatio: "<<m_aspectRatio;
    return m_aspectRatio;
}

double ConstGlobal::getAspectFactor()
{    double getSmallerSize = 0;
     qDebug()<<"Width:"<<m_windowWidth;
     qDebug()<<"height:"<<m_windowHeight;
     if(m_windowWidth > m_windowHeight){
         getSmallerSize = m_windowHeight;
     }
     else
     {
         getSmallerSize = m_windowWidth;
     }
 #ifdef __android__

      if(getSmallerSize >= 2300)
      {
          return m_windowWidth;
      }
      if(getSmallerSize >= 2000 && getSmallerSize <= 2299)
      {
          return m_windowWidth;
      }
      if(m_windowWidth <= 1920 && m_windowWidth >= 1200)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1999 && getSmallerSize >= 1800)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1799 && getSmallerSize >= 1600)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1599 && getSmallerSize >= 1400)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1399 && getSmallerSize >= 1200)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1199 && getSmallerSize >= 1000)
      {
          qDebug()<<"In 1000";
          return m_windowWidth; // * 0.6;
      }
      if(getSmallerSize <= 999 && getSmallerSize >= 800)
      {
          return m_windowWidth;
      }
      if(getSmallerSize < 800)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 720 && getSmallerSize >= 1600 )
      {
          return m_windowWidth;
      }
#else

      if(getSmallerSize >= 2000)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1999 && getSmallerSize >= 1800)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1799 && getSmallerSize >= 1600)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1599 && getSmallerSize >= 1400)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1399 && getSmallerSize >= 1200)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 1199 && getSmallerSize >= 1000)
      {
          return m_windowWidth;
      }
      if(getSmallerSize <= 999 && getSmallerSize >= 800)
      {
          return m_windowWidth;
      }
      if(getSmallerSize < 800)
      {
          return m_windowWidth;
      }
#endif
      return m_windowWidth;
}

double ConstGlobal::getRectWidth()
{
    m_rectWidth = m_windowWidth * 0.483;
    return m_rectWidth;
}

double ConstGlobal::getRectHeight()
{
#ifdef __android__
    m_rectHeight = m_windowHeight * 0.8;
#else
    m_rectHeight = m_windowHeight * 0.725;
#endif
    return m_rectHeight;
}

double ConstGlobal::defaultButtonWidth()
{
#ifdef __android__
    if(m_windowWidth >= 2300)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth >= 2000 && m_windowWidth <= 2299)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 1920 && m_windowWidth >= 1200)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 1999 && m_windowWidth >= 1800)
    {
        m_defaultButtonWidth = m_windowWidth * 0.1;
    }
    if(m_windowWidth <= 1799 && m_windowWidth >= 1600)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 1599 && m_windowWidth >= 1400)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 1399 && m_windowWidth >= 1200)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 1199 && m_windowWidth >= 1000)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth <= 999 && m_windowWidth >= 800)
    {
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
    if(m_windowWidth < 800){
        m_defaultButtonWidth = m_windowWidth * 0.12;
    }
#else
    if(m_windowWidth >= 2300)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth >= 2000 && m_windowWidth <= 2299)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 1999 && m_windowWidth >= 1800)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 1799 && m_windowWidth >= 1600)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 1599 && m_windowWidth >= 1400)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 1399 && m_windowWidth >= 1200)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 1199 && m_windowWidth >= 1000)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth <= 999 && m_windowWidth >= 800)
    {
        m_defaultButtonWidth = m_windowWidth * 0.08;
    }
    if(m_windowWidth < 800){
        m_defaultButtonWidth = m_windowWidth *0.08;
    }
#endif
    return m_defaultButtonWidth;
}

double ConstGlobal::defaultButtonHeight()
{
#ifdef __android__
    if(m_windowWidth <= 1999 && m_windowWidth >= 1800)
    {
        m_defaultButtonHeight = m_windowHeight * 0.045;
    }
    else
        m_defaultButtonHeight = m_windowHeight * 0.065; //0.07
#else
    if(m_windowWidth >= 2300)
    {
        m_defaultButtonHeight = m_windowWidth * 0.038;
    }
    if(m_windowWidth >= 2000 && m_windowWidth <= 2299)
    {
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
    if(m_windowWidth <= 1999 && m_windowWidth >= 1800)
    {
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
    if(m_windowWidth <= 1799 && m_windowWidth >= 1600)
    {
        m_defaultButtonHeight = m_windowHeight * 0.045;
    }
    if(m_windowWidth <= 1599 && m_windowWidth >= 1400)
    {
        m_defaultButtonHeight = m_windowHeight *0.036;
    }
    if(m_windowWidth <= 1399 && m_windowWidth >= 1200)
    {
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
    if(m_windowWidth <= 1199 && m_windowWidth >= 1000)
    {
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
    if(m_windowWidth <= 999 && m_windowWidth >= 800)
    {
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
    if(m_windowWidth < 800){
        m_defaultButtonHeight = m_windowHeight * 0.038;
    }
#endif
    return m_defaultButtonHeight;
}

double ConstGlobal::defaultButtonRadius()
{
#ifdef __android__
    m_defaultButtonRadius = m_windowHeight * 0.06;
#else
    m_defaultButtonRadius = m_windowHeight * 0.05;
#endif
    return m_defaultButtonRadius;
}

double ConstGlobal::updateButtonWidth()
{
    m_updateButtonWidth = m_windowWidth * 0.145;
    return m_updateButtonWidth;
}

double ConstGlobal::updateButtonHeight()
{
#ifdef __android__
    m_updateButtonHeight = m_windowHeight * 0.07;
#else
    m_updateButtonHeight = m_windowHeight * 0.05;
#endif
    return m_updateButtonHeight;
}

int ConstGlobal::getCameraScrollViewHeight()
{
    if(m_windowHeight == 600)
    {
        m_cameraScrollViewHeight = 2700;
    }
    else if(m_windowHeight == 720)
    {
        m_cameraScrollViewHeight = 3200;
    }
    else if(m_windowHeight == 768)
    {
        m_cameraScrollViewHeight = 3400;
    }
    else if(m_windowHeight == 800)
    {
        m_cameraScrollViewHeight = 3700;
    }
    else if(m_windowHeight == 900)
    {
        m_cameraScrollViewHeight = 4000;
    }
    else if(m_windowHeight == 1024)
    {
        m_cameraScrollViewHeight = 4550;
    }
    else if(m_windowHeight == 1050)
    {
        m_cameraScrollViewHeight = 4700;
    }
    else if(m_windowHeight == 1080)
    {
        m_cameraScrollViewHeight = 4500;
    }
    else
    {
        m_cameraScrollViewHeight = 4500;
    }

    return m_cameraScrollViewHeight;
}


int ConstGlobal::getGeneralSettingsScrollViewHeight()
{
    if(m_windowHeight == 600)
    {
        m_generalSettingsScrollViewHeight = 680;
    }
    else if(m_windowHeight == 720)
    {
        m_generalSettingsScrollViewHeight = 800;
    }
    else if(m_windowHeight == 768)
    {
        m_generalSettingsScrollViewHeight = 785;
    }
    else if(m_windowHeight == 800)
    {
        m_generalSettingsScrollViewHeight = 800;
    }
    else if(m_windowHeight == 900)
    {
        m_generalSettingsScrollViewHeight = 800;
    }
    else if(m_windowHeight == 1024)
    {
        m_generalSettingsScrollViewHeight = 960;
    }
    else if(m_windowHeight == 1050)
    {
        m_generalSettingsScrollViewHeight = 970;
    }
    else if(m_windowHeight == 1080)
    {
        m_generalSettingsScrollViewHeight = 1200;
    }
    else
    {
        m_generalSettingsScrollViewHeight = 1230;
    }

    return m_generalSettingsScrollViewHeight;
}
