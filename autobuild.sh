#!/bin/bash
DATE=`date +%Y%m%d_%H%M`
SCHEME_NAME=tianshidaoyi-b  #名字
SOURCE_PATH=$( CD "$( dirname $0 )" && pwd)
BUILD_TYPE=Debug
IPA_PATH=$SOURCE_PATH/AutoBuild_IPA/$DATE
IPA_NAME=tianshidaoyi-b
UKEY=dbc89012a3c1a26d04959277cdd2b933
API_KEY=a5598e05e8d0f1b90a7b65b86459ae8a

#打包

xcodebuild -workspace $SOURCE_PATH/$SCHEME_NAME.xcworkspace -scheme $SCHEME_NAME \
-configuration $BUILD_TYPE clean build -derivedDataPath $IPA_PATH

if [ -e $IPA_PATH ]; then
    echo "<<<<<<<<< xcodebuild success >>>>>>>>"
else
    echo "********* xcodebuild error >>>>>>>>"
    exit 1
fi

xcrun -sdk iphoneos PackageApplication \
    -v $IPA_PATH/Build/Products/$BUILD_TYPE-iphoneos/$SCHEME_NAME.app \
    -o $IPA_PATH/$IPA_NAME.ipa

if [ -e $IPA_PATH/$IPA_NAME.ipa ]; then
    echo " <<<<<<<<<<< xcrun success >>>>>>>>>>>"
else
    echo "*********** xcrun error ************"
fi

#上传到pgyer
result=$( curl -F "file=@$IPA_PATH/$IPA_NAME.ipa" -F "uKey=$UKEY" -F "_api_key=$API_KEY" https://qiniu-storage.pgyer.com/apiv1/app/upload )
