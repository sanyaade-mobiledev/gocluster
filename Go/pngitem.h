#ifndef PNGITEM_H
#define PNGITEM_H

#include <QDeclarativeItem>
#include <QImage>

class PngItem : public QDeclarativeItem
{
	Q_OBJECT
public:
	explicit PngItem(QDeclarativeItem *parent = 0);

	void paint(QPainter *, const QStyleOptionGraphicsItem *, QWidget *);
	
signals:
	
public slots:

private:
	QImage image;
	
};

#endif // PNGITEM_H
