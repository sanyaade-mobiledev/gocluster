/**************************************************************************
*   Copyright (C) 2012 Intel Corporation                                  *
*                                                                         *
*                                                                         *
*   This file is free software: you can redistribute it and/or modify     *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation, either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
*   It is distributed in the hope that it will be useful                  *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU General Public License for more details.                          *
*                                                                         *
*   You should have received a copy of the GNU General Public License     *
*   If not, see <http://www.gnu.org/licenses/>.                           *
***************************************************************************/

#include <QtGui/QApplication>
#include <QNetworkProxyFactory>

#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QGst/Ui/GraphicsVideoSurface>
#include <QGst/Init>
#include <QGLWidget>

#include "gstvideoplayer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
	QApplication app(argc,argv);
	QGst::init(&argc, &argv);

	QNetworkProxyFactory::setUseSystemConfiguration(true);

	QDeclarativeView viewer;

	if(app.arguments().contains("opengl"))
		viewer.setViewport(new QGLWidget);

	QGst::Ui::GraphicsVideoSurface *surface = new QGst::Ui::GraphicsVideoSurface(&viewer);

	viewer.rootContext()->setContextProperty(QLatin1String("videoSurface1"), surface);

	GstVideoPlayer *player = new GstVideoPlayer(&viewer);
	player->setVideoSink(surface->videoSink());
	viewer.rootContext()->setContextProperty(QLatin1String("player"), player);

	viewer.setSource(QUrl::fromLocalFile("main.qml"));
	viewer.show();

	return app.exec();
}
