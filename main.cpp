#include "qtquickcontrolsapplication.h"
#include "documenthandler.h"
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<DocumentHandler>("org.qtproject.tryprayer", 1, 0, "DocumentHandler");
    app.setOrganizationName("Acomb Methodist Church");
    app.setOrganizationDomain("amc.com");
    app.setApplicationName("Try Prayer");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
