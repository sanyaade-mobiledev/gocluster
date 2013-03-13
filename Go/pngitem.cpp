#include "pngitem.h"

PngItem::PngItem(QDeclarativeItem *parent) :
	QDeclarativeItem(parent)
{
	setFlag(QGraphicsItem::ItemHasNoContents, false);


}

void PngItem::paint(QPainter *, const QStyleOptionGraphicsItem *, QWidget *)
{

}
