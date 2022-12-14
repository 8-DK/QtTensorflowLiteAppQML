/**
 * objectsrecongfilter.h
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
#ifndef OBJECTSRECOGFILTER_H
#define OBJECTSRECOGFILTER_H

#include <QVideoFilterRunnable>
#include <QMutex>

#include "tensorflowlite.h"
#include "tensorflowthread.h"
#include "private/qvideoframe_p.h"

class ObjectsRecogFilterRunable;

class ObjectsRecogFilter : public QAbstractVideoFilter
{
    Q_OBJECT

    Q_PROPERTY(double cameraOrientation READ getCameraOrientation WRITE setCameraOrientation)
    Q_PROPERTY(double videoOrientation READ getVideoOrientation WRITE setVideoOrientation)
    Q_PROPERTY(double minConfidence READ getMinConfidence WRITE setMinConfidence)
    Q_PROPERTY(QSize contentSize READ getContentSize WRITE setContentSize)
    Q_PROPERTY(QString model READ getModel WRITE setModel)
    Q_PROPERTY(bool showTime READ getShowTime WRITE setShowTime)
    Q_PROPERTY(bool ready READ getInitialized() NOTIFY initializedChanged)
    Q_PROPERTY(bool acceleration READ getAcceleration WRITE setAcceleration)
    Q_PROPERTY(int nThreads READ getNThreads WRITE setNThreads)

private:
    double camOrientation;
    double vidOrientation;
    double minConf;
    bool   running;
    bool   initialized;
    bool   showInfTime;
    int    numThreads;
    bool   accele;
    QMutex mutex;
    QSize  videoSize;
    QString kindNetwork;
    TensorflowLite tf;
    TensorflowThread tft;
    ObjectsRecogFilterRunable *rfr;

signals:
    void runTensorFlow(QImage imgTF);
    void initializedChanged(const bool &value);

public slots:
    void init();
    void setRunning(bool value);

private slots:
    void TensorFlowExecution(QImage imgTF);
    void processResults(int network, QStringList res, QList<double> conf, QList<QRectF> boxes, double time);

public:
    ObjectsRecogFilter();
    QVideoFilterRunnable *createFilterRunnable();
    void setCameraOrientation(double o);
    void setVideoOrientation(double o);
    double getCameraOrientation();
    double getVideoOrientation();
    double getMinConfidence() const;
    void setMinConfidence(double value);
    bool getRunning();
    void releaseRunning();
    QSize getContentSize() const;
    void setContentSize(const QSize &value);
    double getImgHeight() const;
    double getImgWidth() const;
    bool getInitialized() const;
    QString getModel() const;
    void setModel(const QString &value);
    bool getShowTime() const;
    void setShowTime(bool value);
    int getNThreads() const;
    void setNThreads(int value);
    bool getAcceleration() const;
    void setAcceleration(bool value);
};

class ObjectsRecogFilterRunable : public QVideoFilterRunnable
{
    public:
        ObjectsRecogFilterRunable(ObjectsRecogFilter *filter, QStringList res);
        QImage imageFromVideoFrame(QVideoFrame& buffer);
        QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags);
        void setResults(int net, QStringList res, QList<double> conf, QList<QRectF> box, double time);

    private:
        ObjectsRecogFilter *m_filter;
        int           network;
        QStringList   results;
        QList<double> confidence;
        QList<QRectF> boxes;
        double        infTime;
};

#endif // OBJECTSRECOGFILTER_H
