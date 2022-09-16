/**
 * auxutils.cpp
 * used for extra functionality and image format conversions
 *
 * @license The Unlicense, https://github.com/8-DK, oops its opensource here.
 * @version 0.1
 * @author  8-Dk, https://github.com/8-DK
 * @updated 15/09/2022
 */
#include "auxutils.h"

#include <QApplication>
#include <QScreen>
#include <QPainter>
#include <QPen>
#include <QBrush>
#include <QCryptographicHash>
#include <QFileInfo>
#include <QDir>
#include <QStandardPaths>
#include <QThread>
#include <QDebug>
#include <QUrl>

#include "colormanager.h"
#include "ConstGlobal.h"

const QString assetsPath = ":/assets";

QString AuxUtils::getAssetsPath()
{
    return assetsPath;
}

int AuxUtils::numberThreads()
{
    return QThread::idealThreadCount();
}

QString AuxUtils::resolveModelFilePath(QString modelName)
{
    QString file = ConstGlobal::storagePath() + QDir::separator() + modelName;
    QString def  = assetsPath + QDir::separator() + modelName;

    return copyIfNotExistOrUpdate(file,def);
}

QString AuxUtils::urlToFile(QString path)
{
    QUrl url(path);

    if ( url.isValid() && url.isLocalFile())
        return url.toLocalFile();
    return path;
    //return path.replace("file://","");
}

bool AuxUtils::fileExist(QString filename)
{
    QString file = urlToFile(filename);

    if (file.trimmed().isEmpty()) return false;
    return QFile::exists(file);
}

QByteArray AuxUtils::fileMD5(QString filename)
{
    QCryptographicHash md5gen(QCryptographicHash::Md5);
    QFile file(filename);

    if (file.open(QIODevice::ReadOnly))
    {
        md5gen.addData(file.readAll());
        file.close();
        return md5gen.result().toHex();
    }
    return "";
}

QString AuxUtils::copyIfNotExistOrUpdate(QString file, QString defFile)
{
    bool copy = false;

    if (!fileExist(file))
    {
        QFileInfo fInfo(file);
        QDir      fdir = fInfo.absoluteDir();

        if(!fdir.exists())
            if (!fdir.mkpath(fdir.absolutePath()))
                    return "";

        copy = true;
    }
    else
    {
        QByteArray md5source = fileMD5(defFile);
        QByteArray md5dest   = fileMD5(file);

        if (md5source != md5dest)
            copy = true;
    }

    if(copy && !copyFile(defFile,file)) return "";

    qDebug() << "File OK:" << file;
    return file;
}

void AuxUtils::deleteFile(QString filename)
{
    QFile file(urlToFile(filename));

    file.close();
    file.remove() ? qDebug() << "File deleted: " + filename : qDebug() << "Error deleting file: " + filename + ", " +file.errorString();
}

bool AuxUtils::copyFile(QString origin, QString destination)
{
    QString o = urlToFile(origin);
    QString d = urlToFile(destination);

    if (QFile::exists(d)) deleteFile(d);
    if (QFile::copy(o,d))
    {
        qDebug() << "File copied from: " << o << ", to:" << d;
        return true;
    }
    else
    {
        qDebug() << "File could NOT be copied from: " << o << ", to:" << d;
        return false;
    }
}

bool AuxUtils::isBGRvideoFrame(QVideoFrame f)
{
    return f.pixelFormat() == QVideoFrame::Format_BGRA32 ||
           f.pixelFormat() == QVideoFrame::Format_BGRA32_Premultiplied ||
           f.pixelFormat() == QVideoFrame::Format_BGR32  ||
           f.pixelFormat() == QVideoFrame::Format_BGR24  ||
           f.pixelFormat() == QVideoFrame::Format_BGR565 ||
           f.pixelFormat() == QVideoFrame::Format_BGR555 ||
           f.pixelFormat() == QVideoFrame::Format_BGRA5658_Premultiplied;
}

QImage AuxUtils::rotateImage(QImage img, double rotation)
{
    QPoint center = img.rect().center();
    QMatrix matrix;
    matrix.translate(center.x(), center.y());
    matrix.rotate(rotation);

    return img.transformed(matrix);
}

double AuxUtils::dpi()
{
    return QApplication::screens().count() > 0 ? QApplication::screens().first()->logicalDotsPerInch() : 160;
}

// FIXME: Font size in video frames
double AuxUtils::sp(double pixel)
{
    return pixel * (dpi() / 160) * qApp->devicePixelRatio();
}

QImage AuxUtils::drawText(QImage image, QRectF rect, QString text, Qt::AlignmentFlag pos, Qt::GlobalColor borderColor, double borderSize, Qt::GlobalColor fontColor, QFont font)
{
    QPainter     p;
    QRectF       r = rect;
    QPainterPath path;
    QPen         pen;
    QBrush       brush;
    QStringList  lines;

    if (p.begin(&image))
    {
        // Configure font
        font.setPixelSize(AuxUtils::sp(FONT_PIXEL_SIZE_TEXT));

        // Configure pen
        pen.setWidthF(borderSize);
        pen.setStyle(Qt::SolidLine);
        pen.setColor(borderColor);
        pen.setCapStyle(Qt::RoundCap);
        pen.setJoinStyle(Qt::RoundJoin);

        // Configure brush
        brush.setStyle(Qt::SolidPattern);
        brush.setColor(fontColor);

        // Get lines
        lines = text.split('\n',QString::SkipEmptyParts);

        // Calculate text position
        QFontMetrics fm(font);
        for(int i=0;i<lines.count();i++)
        {
            // Calculate x0 and y0 positions
            int x = ((r.width()) - fm.width(lines.at(i)))/2;
            int y = pos == Qt::AlignBottom ? (r.height()) - fm.height()*(lines.count()-i) : (fm.height()*(i+1));

            // Add text to path
            path.addText(r.left()+x,r.top()+y,font,lines.at(i));
        }

        // Set pen, brush, font and draw path
        p.setRenderHint(QPainter::Antialiasing);
        p.setPen(pen);
        p.setBrush(brush);
        p.setFont(font);
        p.drawPath(path);
    }

    return image;
}

QRectF AuxUtils::frameMatchImg(QImage img, QSize rectSize)
{
    QSize isize   = img.size();
    rectSize.scale(isize, Qt::KeepAspectRatio);
    QPoint center = img.rect().center();

    return QRectF(center.x()-rectSize.width()*0.5,center.y()-rectSize.height()*0.5,rectSize.width(),rectSize.height());
}

QImage AuxUtils::drawBoxes(QImage image, QRect rect, QStringList captions, QList<double> confidences, QList<QRectF> boxes, double minConfidence, bool rgb)
{
    Q_UNUSED(rect);

    ColorManager cm;
    QPainter p;
    QBrush   brush;
    QPen     pen;
    QFont    font;
    QPen     fPen;
    QBrush   bBrush;
    QPen     bPen;

    if (p.begin(&image))
    {
        // Configure pen
        pen.setStyle(Qt::SolidLine);
        pen.setWidthF(LINE_WIDTH);

        // Configure font pen
        fPen.setStyle(Qt::SolidLine);
        fPen.setColor(Qt::black);

        // Configure back pen
        bPen.setStyle(Qt::SolidLine);

        // Configure brush
        brush.setStyle(Qt::NoBrush);

        // Configure back brush
        bBrush.setStyle(Qt::SolidPattern);

        // Configure font
        font.setCapitalization(QFont::Capitalize);
        font.setPixelSize(AuxUtils::sp(FONT_PIXEL_SIZE_BOX));

        // Configure painter
        p.setRenderHint(QPainter::Antialiasing);
        p.setFont(font);

        QFontMetrics fm(font);

        // Draw each box
        for(int i=0;i<boxes.count();i++)
        {
            // Check min confidence value
            if (confidences[i] >= minConfidence)
            {
                // Draw box
                cm.setRgb(rgb);
                pen.setColor(cm.getColor(captions[i]));
                p.setPen(pen);
                p.setBrush(brush);
                p.drawRect(boxes[i]);

                // Format text
                QString confVal = QString::number(qRound(confidences[i] * 100)) + " %";
                QString text    = captions[i] + " - " + confVal;

                // Text rect
                int width  = fm.width(text)+FONT_WIDTH_MARGIN;
                int height = fm.height();
                int left   = boxes[i].left()>=0 ? boxes[i].left() : boxes[i].right()-width;
                int top    = boxes[i].top()-fm.height()>=0 ? boxes[i].top()-fm.height() : boxes[i].bottom();

                // Text position
                int tLeft = left+FONT_WIDTH_MARGIN/2;
                int tTop  = boxes[i].top()-fm.height()>=0 ? boxes[i].top() - FONT_HEIGHT_MARGIN : boxes[i].bottom() + height - FONT_HEIGHT_MARGIN;

                // Draw text background
                bPen.setColor(pen.color());
                bBrush.setColor(pen.color());
                p.setPen(bPen);
                p.setBrush(bBrush);
                p.drawRect(left,top,width,height);

                // Draw tex
                p.setPen(fPen);
                p.drawText(tLeft,tTop,text);
            }
        }
    }

    return image;
}


QImage AuxUtils::imageFromVideoFrame(const QVideoFrame& buffer)
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
