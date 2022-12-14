#include "objectsrecogfilter.h"

#include <QDir>
#include <QDebug>
#include "private/qvideoframe_p.h"

#include "auxutils.h"

ObjectsRecogFilter::ObjectsRecogFilter()
{
    connect(this, SIGNAL(runTensorFlow(QImage)), this, SLOT(TensorFlowExecution(QImage)));
    connect(&tft,SIGNAL(results(int, QStringList, QList<double>, QList<QRectF>, double)),this,SLOT(processResults(int, QStringList, QList<double>, QList<QRectF>, double)));

    releaseRunning();
    initialized = false;
    emit initializedChanged(initialized);
}

void ObjectsRecogFilter::setCameraOrientation(double o)
{
    camOrientation = o;
}

void ObjectsRecogFilter::setVideoOrientation(double o)
{
    vidOrientation = o;
}

double ObjectsRecogFilter::getCameraOrientation()
{
    return camOrientation;
}

double ObjectsRecogFilter::getVideoOrientation()
{
    return vidOrientation;
}

bool ObjectsRecogFilter::getRunning()
{
    QMutexLocker locker(&mutex);

    bool val = running;
    if (!val) setRunning(true);

    return !val;
}

void ObjectsRecogFilter::setRunning(bool val)
{
    running = val;
}

double ObjectsRecogFilter::getMinConfidence() const
{
    return minConf;
}

void ObjectsRecogFilter::setMinConfidence(double value)
{
    minConf = value;
    tf.setThreshold(minConf);
}

void ObjectsRecogFilter::releaseRunning()
{
    QMutexLocker locker(&mutex);

    setRunning(false);
}

QSize ObjectsRecogFilter::getContentSize() const
{
    return videoSize;
}

void ObjectsRecogFilter::setContentSize(const QSize &value)
{
    videoSize = value;
}

QVideoFilterRunnable *ObjectsRecogFilter::createFilterRunnable()
{
    rfr = new ObjectsRecogFilterRunable(this,tf.getResults());
    return rfr;
}

ObjectsRecogFilterRunable::ObjectsRecogFilterRunable(ObjectsRecogFilter *filter, QStringList res)
{
    m_filter   = filter;
    results    = res;
}

void ObjectsRecogFilterRunable::setResults(int net, QStringList res, QList<double> conf, QList<QRectF> box, double time)
{
    network       = net;
    results       = res;
    confidence    = conf;
    boxes         = box;
    infTime       = time;
}

QImage ObjectsRecogFilterRunable::imageFromVideoFrame(QVideoFrame& buffer)
{
    QImage img;
    QVideoFrame frame(buffer);  // make a copy we can call map (non-const) on
    frame.map(QAbstractVideoBuffer::ReadOnly);
    QImage::Format imageFormat = QVideoFrame::imageFormatFromPixelFormat(
                frame.pixelFormat());
    // BUT the frame.pixelFormat() is QVideoFrame::Format_Jpeg, and this is
    // mapped to QImage::Format_Invalid by
    // QVideoFrame::imageFormatFromPixelFormat
    if (imageFormat != QImage::Format_Invalid) {
        img = QImage(frame.bits(),
                     frame.width(),
                     frame.height(),
                     // frame.bytesPerLine(),
                     imageFormat);
    } else {
        // e.g. JPEG
        int nbytes = frame.mappedBytes();
        img = QImage::fromData(frame.bits(), nbytes);
    }
    frame.unmap();
    return img;
}

QVideoFrame ObjectsRecogFilterRunable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags)
{
    Q_UNUSED(surfaceFormat);
    Q_UNUSED(flags);

    QImage img;
    bool mirrorHorizontal;
    bool mirrorVertical = false;

    if(input->isValid())
    {
        // Get image from video frame, we need to convert it
        // for unsupported QImage formats, i.e Format_YUV420P
        //
        // When input has an unsupported format the QImage
        // default format is ARGB32
        //
        // NOTE: BGR images are not properly managed by qt_imageFromVideoFrame
        //
        #ifdef __android__
        bool BGRVideoFrame = true;//AuxUtils::isBGRvideoFrame(*input);
#else
        bool BGRVideoFrame = false;
       #endif

        if (BGRVideoFrame)
        {
            input->map(QAbstractVideoBuffer::ReadOnly);
            img = QImage(input->bits(),input->width(),input->height(),QImage::Format_ARGB32).copy();
            input->unmap();
            // WARNING: Mirror only for Android? How to check if this has to be done?
            // surfaceFormat.isMirrored() == false for Android
#ifdef __android__
            mirrorVertical = true;
#endif
        }
        else
        {
            img = qt_imageFromVideoFrame(*input);
//            img = AuxUtils::imageFromVideoFrame(*input);
//              img = imageFromVideoFrame(*input);
        }

        // Check if mirroring is needed
        if (!mirrorVertical) mirrorVertical = surfaceFormat.isMirrored();
        mirrorHorizontal = surfaceFormat.scanLineDirection() == QVideoSurfaceFormat::BottomToTop;
        img = img.mirrored(mirrorHorizontal,mirrorVertical);

        // Check img is valid
        if(true) //(img.format() != QImage::Format_Invalid)
        {           
            // Take into account the rotation
            img = AuxUtils::rotateImage(img,-m_filter->getVideoOrientation());

            // Content size
            QRectF srcRect = AuxUtils::frameMatchImg(img,m_filter->getContentSize());
            QString text = "";

            // If not initialized, intialize with image size
            if (!m_filter->getInitialized())
            {
                m_filter->init();
                results.clear();
                confidence.clear();
                boxes.clear();
                infTime = -1;
            }

            // Get a mutex for creating a thread to execute TensorFlow
            if (m_filter->getRunning())
                emit m_filter->runTensorFlow(img);

            // Image classification network
            if (network == TensorflowLite::knIMAGE_CLASSIFIER)
            {
                // Get current TensorFlow outputs
                QString objStr = results.count()>0    ? results.first()    : "";
                double  objCon = confidence.count()>0 ? confidence.first() : -1;

                // Check if there are results & the minimum confidence level is reached
                if (objStr.length()>0 && objCon >= m_filter->getMinConfidence())
                {
                    // Formatting of confidence value
                    QString confVal = QString::number(objCon * 100, 'f', 2) + " %";

                    // Text
                    text = objStr + '\n' + confVal + '\n';
                }
            }
            // Object detection network
            else if (network == TensorflowLite::knOBJECT_DETECTION)
            {
                // Draw boxes on image
                img = AuxUtils::drawBoxes(img,img.rect(),results,confidence,boxes,m_filter->getMinConfidence(),!BGRVideoFrame);
            }

            // Show inference time
            if (m_filter->getShowTime() && infTime>0)
                text = text + QString::number(infTime) + " ms";

            if (!text.isEmpty())
                img = AuxUtils::drawText(img,srcRect,text);

            // Restore rotation
            img = AuxUtils::rotateImage(img,m_filter->getVideoOrientation());
        }

        // NOTE: for BGR images loaded as RGB
        if (BGRVideoFrame) img = img.rgbSwapped();

        // Return video frame from img
        return  QVideoFrame(img);
    }

    return *input;
}

double ObjectsRecogFilter::getImgHeight() const
{
    return tf.getImgHeight();
}

double ObjectsRecogFilter::getImgWidth() const
{
    return tf.getImgWidth();
}

bool ObjectsRecogFilter::getInitialized() const
{
    return initialized;
}

QString ObjectsRecogFilter::getModel() const
{
    return kindNetwork;
}

// TODO: set modelType literals as constant values,
// they are defined in AppSettingsPage.qml
void ObjectsRecogFilter::setModel(const QString &value)
{
    const QString MODEL_FILE_IMG_CLA  = "imageClassification.tflite";
    const QString MODEL_FILE_OBJ_DET  = "object_detection.tflite";
    const QString LABELS_FILE_IMG_CLA = "imageClassificationLabels.txt";
    const QString LABELS_FILE_OBJ_DET = "object_detection_labels.txt";

    QString assetsPath = AuxUtils::getAssetsPath();
    QString modelFilename;
    QString labelsFilename;
    kindNetwork = value;

    modelFilename  = kindNetwork == "ImageClassification" ? MODEL_FILE_IMG_CLA : MODEL_FILE_OBJ_DET;
    labelsFilename = assetsPath + QDir::separator() + (kindNetwork == "ImageClassification" ? LABELS_FILE_IMG_CLA : LABELS_FILE_OBJ_DET);

    tf.setModelFilename(AuxUtils::resolveModelFilePath(modelFilename));
    tf.setLabelsFilename(labelsFilename);
    initialized = false;
    emit initializedChanged(initialized);
    tft.setTf(&tf);
}

bool ObjectsRecogFilter::getShowTime() const
{
    return showInfTime;
}

void ObjectsRecogFilter::setShowTime(bool value)
{
    showInfTime = value;
}

int ObjectsRecogFilter::getNThreads() const
{
    return numThreads;
}

void ObjectsRecogFilter::setNThreads(int value)
{
    qDebug() << "Filter Num. Threads:" << value;

    if (value != numThreads)
    {
        numThreads = value;
        tf.setNThreads(numThreads);
        initialized = false;
        emit initializedChanged(initialized);
        tft.setTf(&tf);
    }
}

bool ObjectsRecogFilter::getAcceleration() const
{
    return accele;
}

void ObjectsRecogFilter::setAcceleration(bool value)
{
    if (value != accele)
    {
        accele = value;
        tf.setAcceleration(accele);
        emit initializedChanged(initialized);
        tft.setTf(&tf);
    }
}

void ObjectsRecogFilter::init()
{
    initialized = tf.init();
    emit initializedChanged(initialized);
    tft.setTf(&tf);
}

void ObjectsRecogFilter::TensorFlowExecution(QImage imgTF)
{
    tft.run(imgTF);
}

void ObjectsRecogFilter::processResults(int network, QStringList res, QList<double> conf, QList<QRectF> boxes, double time)
{
    rfr->setResults(network,res,conf,boxes,time);
    releaseRunning();
}
