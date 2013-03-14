#include "pngitem.h"

#include <QPainter>
#include <QImage>
#include <QImageWriter>
#include <QGraphicsScene>

PngItem::PngItem(QDeclarativeItem *parent) :
	QDeclarativeItem(parent)
{
	image = new QImage(width(), height(), QImage::Format_RGB32);
	image->fill(Qt::green);

	setFlag(QGraphicsItem::ItemHasNoContents, false);

	recordTimer.setInterval(1000/30);
	connect(&recordTimer,SIGNAL(timeout()),this,SLOT(takeSnapshot()));

	connect(this,SIGNAL(widthChanged()),this,SLOT(widthChangedSlot()));

	connect(this,SIGNAL(heightChanged()),this,SLOT(heightChangedSlot()));
}

void PngItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *item, QWidget *widget)
{

	QDeclarativeItem::paint(painter,item,widget);
}

void PngItem::startRecording()
{
	recordTimer.start();
}

void PngItem::stopRecording()
{
	recordTimer.stop();
}


void PngItem::takeSnapshot()
{
	QPainter fakePainter(image);
	scene()->render(&fakePainter);
	QImageWriter writer("snapshot.png");
	writer.setFormat("png");

	writer.write(*image);
}

void PngItem::widthChangedSlot()
{
	delete image;
	image = new QImage(width(),height(),QImage::Format_RGB32);
	image->fill(Qt::green);
}

void PngItem::heightChangedSlot()
{
	delete image;
	image = new QImage(width(),height(),QImage::Format_RGB32);
	image->fill(Qt::green);
}
