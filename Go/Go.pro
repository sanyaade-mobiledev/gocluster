
QT += network quick qml declarative opengl
CONFIG += qt plugin link_pkgconfig debug

PKGCONFIG += QtGStreamer-0.10 QtGStreamerUi-0.10 QtGLib-2.0 QtGStreamerUtils-0.10

SOURCES += main.cpp \
    gstvideoplayer.cpp \
    pngitem.cpp

OTHER_FILES += assets/* *.qml \
    TextEntry.qml \
    Guage.qml \
    golight.qml \
    Map.qml

HEADERS += \
    gstvideoplayer.h \
    pngitem.h
