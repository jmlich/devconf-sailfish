#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>

class FileReader : public QObject
{
    Q_OBJECT
public:
    explicit FileReader(QObject *parent = 0);

    QByteArray read(const QString &filename);
    bool file_exists(const QString &filename);
    void write(const QString &filename, QByteArray data);


    Q_INVOKABLE void write(const QUrl &filename, QByteArray data);
    Q_INVOKABLE bool file_exists(const QUrl &filename);
    Q_INVOKABLE QByteArray read(const QUrl &filename);


signals:

public slots:

};

#endif // FILEREADER_H
