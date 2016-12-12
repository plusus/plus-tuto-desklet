#!/bin/bash -e

PACKAGE_NAME=plustutodesklet
VERSION_MAJOR=1
VERSION_MINOR=0
VERSION_BUILD=1
VERSION="$VERSION_MAJOR.$VERSION_MINOR-$VERSION_BUILD"
SEP="_"
PACKAGE_NAME_VERSION=$PACKAGE_NAME$SEP$VERSION
ARCHITECTURE=all
PACKAGE_DIR=builddeb/$PACKAGE_NAME_VERSION

echo '### COPYING FILES'
rm -rf $PACKAGE_DIR/*
mkdir -p $PACKAGE_DIR/usr/lib/gdesklets
cp -fr desklet/* $PACKAGE_DIR/usr/lib/gdesklets/

echo '### CREATING DEBIAN FOLDER'
mkdir -p builddeb/$PACKAGE_NAME_VERSION/DEBIAN
# Copy base files
rsync -a debian/ builddeb/$PACKAGE_NAME_VERSION/DEBIAN/

cd builddeb/$PACKAGE_NAME_VERSION

# Generate control file
CONTROL_FILE="DEBIAN/control"
touch DEBIAN/control
echo "Package: ${PACKAGE_NAME}" > "$CONTROL_FILE"
echo "Version: $VERSION" >> "$CONTROL_FILE"
echo "Section: misc" >> "$CONTROL_FILE"
echo "Priority: optional" >> "$CONTROL_FILE"
echo "Architecture: $ARCHITECTURE" >> "$CONTROL_FILE"
echo "Essential: no" >> "$CONTROL_FILE"
echo "Installed-Size: `du -sc usr | grep total | awk '{ print $1 }'`" >> "$CONTROL_FILE"
echo "Maintainer: Samuel Longchamps <samuel.longchamps@usherbrooke.ca>" >> "$CONTROL_FILE"
echo "Homepage: http://plus-us.gel.usherbrooke.ca/plustutodesklet" >> "$CONTROL_FILE"
echo "Depends: plustuto (>= 0.5), python-dbus (>= 1.2), gdesklets (>= 0.36)" >> "$CONTROL_FILE"
echo "Description: Desklet for the PLUS tutorial center application" >> "$CONTROL_FILE"
echo " Allows to launch the tuto center and indicate how many tutorials are to be completed." >> "$CONTROL_FILE"

# Create md5sum
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '"%P" ' | xargs md5sum > DEBIAN/md5sums

cd ..

dpkg-deb -bv $PACKAGE_NAME_VERSION $PACKAGE_NAME_VERSION"_"$ARCHITECTURE".deb"
