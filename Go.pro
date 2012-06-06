TEMPLATE = subdirs

SUBDIRS += \
    Go


PROJECT_NAME = GoCluster
VERSION = 0.0.1

dist.commands += sed -i s/^.*Version:.*\\\$$/Version:\\\t$$VERSION/g GoCluster.spec &&
dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION} &&
dist.commands += git clone . $${PROJECT_NAME}-$${VERSION} &&
dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION}/.git &&
dist.commands += tar cjf $${PROJECT_NAME}-$${VERSION}.tar.bz2 $${PROJECT_NAME}-$${VERSION} &&
dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION} &&
dist.commands += echo "make dist complete."
QMAKE_EXTRA_TARGETS += dist
