#include <QFile>
#include <QUrl>
#include <QDebug>
#include "filereader.h"

FileReader::FileReader(QObject *parent) :
    QObject(parent)
{
}

QByteArray FileReader::read(const QUrl &filename) {
    return read(filename.toLocalFile());
}


QByteArray FileReader::read(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly))
        return QByteArray();

    return file.readAll();
}

void FileReader::write(const QUrl &filename, QByteArray data) {
    write(filename.toLocalFile(), data);
}

void FileReader::write(const QString &filename, QByteArray data) {
    QFile file (filename);
    if (!file.open(QIODevice::ReadWrite)) {
        return;
    }
    file.write(data);
}

bool FileReader::file_exists(const QUrl &filename) {
    return file_exists(filename.toLocalFile());
}

bool FileReader::file_exists(const QString &filename) {
    return QFile(filename).exists();
}
