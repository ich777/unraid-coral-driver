# Download source
cd ${DATA_DIR}
mkdir -p ${DATA_DIR}/apex
wget -O ${DATA_DIR}/gasket.tar.gz https://coral.googlesource.com/linux-imx/+archive/refs/heads/master/drivers/staging/gasket.tar.gz
tar -C ${DATA_DIR}/apex -xvf ${DATA_DIR}/gasket.tar.gz

# Patch gasket_core.c to be compatible with Kernel 5.10+
sed -i 's/\<ioremap_nocache\>/ioremap_cache/g' ${DATA_DIR}/apex/gasket_core.c

# Compile modules
cd ${DATA_DIR}/linux-${UNAME}
export CONFIG_STAGING_APEX_DRIVER=m
export CONFIG_STAGING_GASKET_FRAMEWORK=m
make modules M=${DATA_DIR}/apex -j${CPU_COUNT}
make INSTALL_MOD_PATH=/CORAL modules_install M=${DATA_DIR}/apex

# Cleanup modules directory
cd /CORAL/lib/modules/${UNAME}
find . -maxdepth 1 -not -name 'extra' -print0 | xargs -0 -I {} rm -R {} 2&>/dev/null

# Create Slackware package
PLUGIN_NAME="Coral"
BASE_DIR="/CORAL"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"
mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp -R $BASE_DIR/* $TMP_DIR/$VERSION/
mkdir $TMP_DIR/$VERSION/install
tee $TMP_DIR/$VERSION/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
$PLUGIN_NAME: $PLUGIN_NAME Package contents:
$PLUGIN_NAME:
$PLUGIN_NAME: Source: https://coral.googlesource.com/linux-imx/+/refs/heads/master/drivers/staging/gasket/
$PLUGIN_NAME:
$PLUGIN_NAME:
$PLUGIN_NAME: Custom $PLUGIN_NAME package for Unraid Kernel v${UNAME%%-*} by ich777
$PLUGIN_NAME:
EOF
${DATA_DIR}/bzroot-extracted-$UNAME/sbin/makepkg -l n -c n $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz
md5sum $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz | awk '{print $1}' > $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz.md5