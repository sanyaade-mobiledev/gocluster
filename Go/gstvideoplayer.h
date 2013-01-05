#ifndef GSTVIDEOPLAYER_H
#define GSTVIDEOPLAYER_H

#include <QObject>
#include <QGst/Pipeline>

class GstVideoPlayer : public QObject
{
    Q_OBJECT
	Q_PROPERTY(QString videoDevice READ videoDevice WRITE setVideoDevice NOTIFY videoDeviceChanged)
public:
    explicit GstVideoPlayer(QObject *parent = 0);
    void setVideoSink(const QGst::ElementPtr & sink);

	QString videoDevice();

public slots:
    void play();
    void stop();
    void open();

    void setText(QString text);
	void setVideoDevice(QString dev);

signals:
	void videoDeviceChanged();

private:
    void openFile(const QString & fileName);
    void createVideoPipelineDisplay();
    void createRecordVideoPipeline();
    void onBusMessage(const QGst::MessagePtr & message);

    QGst::PipelinePtr m_pipeline;
    QGst::ElementPtr m_videoSink;
	QGst::ElementPtr m_videoSource;
    QGst::ElementPtr m_textoverlay;
    QString m_baseDir;
    QString mText;
};



#endif // GSTVIDEOPLAYER_H
