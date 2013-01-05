
#include "gstvideoplayer.h"

#include <QtCore/QUrl>
#include <QtGui/QFileDialog>
#include <QSettings>
#include <QGlib/Connect>
#include <QGlib/Error>
#include <QGst/ElementFactory>
#include <QGst/Bus>
#include <QGst/Message>
#include <QGst/Pad>
#include <QGst/GhostPad>
#include <QGst/Fraction>

GstVideoPlayer::GstVideoPlayer(QObject *parent) :
	QObject(parent)
{
}

void GstVideoPlayer::setVideoSink(const QGst::ElementPtr & sink)
{
	m_videoSink = sink;
	stop();
	createRecordVideoPipeline();
	//play();
}

QString GstVideoPlayer::videoDevice()
{
	if(m_videoSource)
		return m_videoSource->property("device").toString();
}

void GstVideoPlayer::play()
{
	if (m_pipeline) {
		m_pipeline->setState(QGst::StatePlaying);
	}
}

void GstVideoPlayer::stop()
{
	if (m_pipeline) {
		m_pipeline->setState(QGst::StateNull);
	}
}

void GstVideoPlayer::open()
{
	// parent() is the QDeclarativeView here
	QString fileName = QFileDialog::getOpenFileName(qobject_cast<QWidget*>(parent()),
													tr("Open a Movie"), m_baseDir);

	if (!fileName.isEmpty()) {
		openFile(fileName);
	}
}

void GstVideoPlayer::setText(QString text)
{
	mText = text;
	if(m_textoverlay)
		m_textoverlay->setProperty("text", mText);
}

void GstVideoPlayer::setVideoDevice(QString dev)
{
	if(m_videoSource)
		m_videoSource->setProperty("device",dev);
	QSettings settings;
	settings.setValue("videoDevice", dev);
}

void GstVideoPlayer::openFile(const QString & fileName)
{
	m_baseDir = QFileInfo(fileName).path();

	stop();

	play();
}

void GstVideoPlayer::createVideoPipelineDisplay()
{
	delete m_pipeline;
	m_pipeline = QGst::ElementFactory::make("camerabin").dynamicCast<QGst::Pipeline>();
	if(m_pipeline)
	{
		QGst::BinPtr myBin = QGst::Bin::create("myBin");

		m_textoverlay = QGst::ElementFactory::make("textoverlay");

		m_textoverlay->setProperty("text", mText);
		m_textoverlay->setProperty("font-desc", "Sans 20");
		m_textoverlay->setProperty("shaded-background",true);

		myBin->add(m_textoverlay);


		QGst::PadPtr pad = m_textoverlay->getStaticPad("video_sink");
		QGst::GhostPadPtr ghostPad = QGst::GhostPad::create(pad);

		myBin->addPad(ghostPad);

		myBin->add(m_videoSink);

		m_textoverlay->link(m_videoSink);

		m_pipeline->setProperty("viewfinder-sink", myBin);

		m_pipeline->setProperty("viewfinder-sink",m_videoSink);

		//watch the bus for messages
		QGst::BusPtr bus = m_pipeline->bus();
		bus->addSignalWatch();
		QGlib::connect(bus, "message", this, &GstVideoPlayer::onBusMessage);

	}
	else
	{
		qCritical()<<"Failed to create pipeline";
	}
}

void GstVideoPlayer::createRecordVideoPipeline()
{
	delete m_pipeline;

	m_pipeline = QGst::Pipeline::create();

	//m_videoSource = QGst::ElementFactory::make("autovideosrc");
	m_videoSource = QGst::ElementFactory::make("v4l2src");
	QGst::ElementPtr screenQueue = QGst::ElementFactory::make("queue");
	QGst::ElementPtr videoQueue = QGst::ElementFactory::make("queue");
	QGst::ElementPtr tee = QGst::ElementFactory::make("tee");
	QGst::ElementPtr encoder = QGst::ElementFactory::make("theoraenc");
	QGst::ElementPtr mux = QGst::ElementFactory::make("oggmux");
	QGst::ElementPtr sink = QGst::ElementFactory::make("filesink");
	//QGst::ElementPtr screenSink = QGst::ElementFactory::make("autovideosink");
	QGst::ElementPtr screenSink = m_videoSink;

	QSettings settings;

	m_videoSource->setProperty("device", settings.value("videoDevice","/dev/video0").toString());

	videoDeviceChanged();

	encoder->setProperty("bitrate",512);
	encoder->setProperty("speed-level", 2);

	m_textoverlay = QGst::ElementFactory::make("textoverlay");

	m_textoverlay->setProperty("text", mText);
	m_textoverlay->setProperty("font-desc", "Sans 20");

	sink->setProperty("location", "out.ogg");

	m_pipeline->add(m_videoSource, m_textoverlay, tee, screenQueue, screenSink, videoQueue, encoder, mux, sink);

	QGst::CapsPtr caps = QGst::Caps::createSimple("video/x-raw-yuv");
	//caps->setValue("format", QGst::Fourcc('U','Y','V','Y'));
	caps->setValue("width", 640);
	caps->setValue("height", 480);
	caps->setValue("bpp", 24);
	caps->setValue("framerate", QGst::Fraction(30,1));

	m_videoSource->link(m_textoverlay, caps);
	m_textoverlay->link(tee);

	tee->link(screenQueue);
	screenQueue->link(screenSink);

	tee->link(videoQueue);
	videoQueue->link(encoder);
	encoder->link(mux);
	mux->link(sink);

	//connect the bus
	m_pipeline->bus()->addSignalWatch();
	QGlib::connect(m_pipeline->bus(), "message", this, &GstVideoPlayer::onBusMessage);

}

void GstVideoPlayer::onBusMessage(const QGst::MessagePtr & message)
{
	switch (message->type()) {
	case QGst::MessageEos: //End of stream. We reached the end of the file.
		stop();
		break;
	case QGst::MessageError: //Some error occurred.
		qCritical() << message.staticCast<QGst::ErrorMessage>()->error();
		stop();
		break;
	default:
		break;
	}
}
