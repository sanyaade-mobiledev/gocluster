#include <QtGui/QApplication>
#include <QNetworkProxyFactory>

#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

	QNetworkProxyFactory::setUseSystemConfiguration(true);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
	viewer.setMainQmlFile(QLatin1String("main.qml"));
    viewer.showExpanded();

    return app->exec();
}
