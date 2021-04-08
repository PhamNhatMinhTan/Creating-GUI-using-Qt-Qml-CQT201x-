#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "player.h"
#include <QQmlContext>
#include "playlistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Player player;
    engine.rootContext()->setContextProperty("mPlaylistModel",player.m_playlistModel);
    engine.rootContext()->setContextProperty("mPlayer",player.m_player);
    engine.rootContext()->setContextProperty("player",&player);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    player.m_player->play();
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
