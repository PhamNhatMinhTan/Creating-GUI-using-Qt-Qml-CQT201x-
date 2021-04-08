#ifndef TRANSLATION_H
#define TRANSLATION_H
#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)
    Q_PROPERTY(QString currentLanguage READ getCurrentLanguage WRITE setCurrentLanguage NOTIFY languageChanged)
public:
    Translation( QGuiApplication *app, QObject *parent = nullptr);
    QString getEmptyString();
    QString getCurrentLanguage();
    void setCurrentLanguage(QString language);
    Q_INVOKABLE void selectLanguage(QString language);

signals:
    void languageChanged();
    void currentLanguageChanged();
private:
    QTranslator *translator1;
    QTranslator *translator2;
    QGuiApplication *m_app;
    QString m_currentLanguage;
};

#endif // TRANSLATION_H
