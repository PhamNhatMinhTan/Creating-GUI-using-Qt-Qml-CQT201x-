#include "translation.h"

Translation::Translation( QGuiApplication *app, QObject *parent)
    : QObject(parent)
{
    translator1 = new QTranslator();
    translator2 = new QTranslator();
}

QString Translation::getEmptyString()
{
    return "";
}

QString Translation::getCurrentLanguage()
{
    return m_currentLanguage;
}

void Translation::setCurrentLanguage(QString language)
{
    m_currentLanguage = language;
    // Change language to US
    if (language == "us") {
        translator1->load("string_us", ":/translator");
        m_app->installTranslator(translator1);
    } else if (language == "vn") {    //// Change language to VN
        translator2->load("string_vn", ":/translator");
        m_app->installTranslator(translator2);
    }
}

void Translation::selectLanguage(QString language)
{
    setCurrentLanguage(language);
    emit languageChanged();
}
