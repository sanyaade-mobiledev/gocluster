#ifndef GSTVIDEOPLAYER_H
#define GSTVIDEOPLAYER_H

#include <QObject>
#include <QGst/Pipeline>

class GstVideoPlayer : public QObject
{
    Q_OBJECT
	Q_PROPERTY(QString videoDevice READ videoDevice WRITE setVideoDevice NOTIFY videoDeviceChanged)
	Q_PROPERTY(QString videoFile READ videoFile WRITE setVideoFile NOTIFY videoFileChanged)
public:
    explicit GstVideoPlayer(QObject *parent = 0);
    void setVideoSink(const QGst::ElementPtr & sink);

	QString videoDevice();
	QString videoFile() { return m_baseDir; }

public slots:
    void play();
    void stop();
    void open();

    void setText(QString text);
	void setVideoDevice(QString dev);
	void setVideoFile(QString file) { m_baseDir	= file; }

	void createVideoPipelineDisplay();
	void createRecordVideoPipeline();
	void createVideoFilePiplineDisplay();

signals:
	void videoDeviceChanged();
	void videoFileChanged();

private:
    void openFile(const QString & fileName);
    void onBusMessage(const QGst::MessagePtr & message);

    QGst::PipelinePtr m_pipeline;
    QGst::ElementPtr m_videoSink;
	QGst::ElementPtr m_videoSource;
    QGst::ElementPtr m_textoverlay;
    QString m_baseDir;
    QString mText;
};



#endif // GSTVIDEOPLAYER_H
