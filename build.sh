#!/usr/bin/env bash

set -x

P="floppy_dirk"

LV="11.2"
LZ="https://bitbucket.org/rude/love/downloads/love-${LV}-win32.zip"

#NDK_VER="r14b"
NDK_VER="r17c"

### clean

if [ "$1" == "clean" ]; then
 rm -rf "target"
 exit;
fi


### deploy web version to github pages

if [ "$1" == "deploy" ]; then
 # $2 = premek/forest

 cd "target/${P}-web"
 git init
 git config user.name "autodeploy"
 git config user.email "autodeploy"
 touch .
 git add .
 git commit -m "deploy to github pages"
 git push --force --quiet "https://${GH_TOKEN}@github.com/${2}.git" master:gh-pages

 exit;
fi


##### build #####

find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }

mkdir "target"


### .love

cp -r src target
cd target/src

# compile .ink story into lua table so the runtime will not need lpeg dep.
lua lib/pink/pink/pink.lua parse game.ink > game.lua

zip -9 -r - . > "../${P}.love"
cd -


### .exe

if [ ! -f "target/love-win.zip" ]; then wget "$LZ" -O "target/love-win.zip"; fi
#cp ~/downloads/love-0.10.1-win32.zip "target/love-win.zip"
unzip -o "target/love-win.zip" -d "target"

tmp="target/tmp/"
mkdir -p "$tmp/$P"
cat target/love-"${LV}"*-win32/love.exe target/"${P}".love > "$tmp/${P}/${P}.exe"
cp  target/love-"${LV}"*-win32/*dll target/love-"${LV}"*-win32/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}-win.zip"
cd -
cp "$tmp/${P}-win.zip" "target/"
rm -r "$tmp"


### android (WIP) 
### love2d 11.2 does not seem to be supported for now
if [ "$1" == "android" ]; then

cd target
git clone --single-branch --branch 0.11.x https://bitbucket.org/MartinFelis/love-android-sdl2
wget https://dl.google.com/android/repository/android-ndk-"${NDK_VER}"-linux-x86_64.zip -O android-ndk.zip
echo Installing android NDK...
unzip android-ndk 1> /dev/null 2>&1
ANDROID_NDK=`pwd`/android-ndk-"${NDK_VER}"
export ANDROID_NDK
mkdir android-sdk
cd android-sdk
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O sdk-tools.zip
echo Installing android SDK tools...
unzip sdk-tools.zip 1> /dev/null 2>&1
tools/bin/sdkmanager --update
#yes | tools/bin/sdkmanager "build-tools;28.0.3" "platforms;android-28"
yes | tools/bin/sdkmanager "build-tools;23.0.3" "platforms;android-23"
yes | tools/bin/sdkmanager --licenses 
cd - 
ANDROID_SDK=`pwd`/android-sdk
export ANDROID_SDK
ANDROID_HOME=`pwd`/android-sdk
export ANDROID_HOME
cd love-android-sdl2
chmod +x gradlew
./gradlew build
fi


### web

if [ "$1" == "web" ]; then

cd target
rm -rf love.js *-web*
git clone https://github.com/TannerRogalsky/love.js.git
cd love.js
git checkout 6fa910c2a28936c3ec4eaafb014405a765382e08
git submodule update --init --recursive

cd release-compatibility
python ../emscripten/tools/file_packager.py game.data --preload ../../../target/src/@/ --js-output=game.js
python ../emscripten/tools/file_packager.py game.data --preload ../../../target/src/@/ --js-output=game.js
#yes, two times!
# python -m SimpleHTTPServer 8000
cd ../..
cp -r love.js/release-compatibility "$P-web"
zip -9 -r - "$P-web" > "${P}-web.zip"
# target/$P-web/ goes to webserver
fi
