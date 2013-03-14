#ifndef PNGITEM_H
#define PNGITEM_H

#include <QDeclarativeItem>
#include <QImage>
#include <QProcess>
#include <QTimer>

class PngItem : public QDeclarativeItem
{
	Q_OBJECT
public:
	explicit PngItem(QDeclarativeItem *parent = 0);

	void paint(QPainter *, const QStyleOptionGraphicsItem *, QWidget *);
	
signals:
	
public slots:
	void startRecording();
	void stopRecording();

private slots:
	void takeSnapshot();
	void widthChangedSlot();
	void heightChangedSlot();

private:
	QImage *image;
	QProcess ffmpeg;
	QTimer recordTimer;
	
};

#endif // PNGITEM_H
