#This file is part of The Open GApps script of @mfonville.
#
#    The Open GApps scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#

# Static definitions, lists of packages per variant and in the core
gappscore="framework
googlebackuptransport
googlecontactssync
googlefeedback
googleonetimeinitializer
googlepartnersetup
gmscore
gsfcore
gsflogin
setupwizard
vending"

gappsoptional=""

gappssuper="androidforwork
androidpay
dmagent
earth
gcs
hindi
japanese
korean
pinyin
projectfi
street
translate
zhuyin"

gappsstock="cameragoogle
keyboardgoogle
messenger"

gappsfull="books
chrome
cloudprint
docs
drive
ears
fitness
googleplus
keep
movies
music
newsstand
newswidget
playgames
sheets
slides
talkback"

gappsmini="clockgoogle
hangouts
maps
photos
youtube"

gappsmicro="calendargoogle
exchangegoogle
gmail
googlenow
googletts"

gappsnano="facedetect
faceunlock
search
speech"

gappspico="calsync"

stockremove="browser
email
gallery
launcher
mms
picotts"

case "$ARCH" in
  arm64|x86_64)  LIBFOLDER="lib64";;
  *)             LIBFOLDER="lib";;
esac

get_fallback_arch(){
  case "$1" in
    arm)    fallback_arch="all";;
    arm64)  fallback_arch="arm";;
    x86)    fallback_arch="arm";; #by using libhoudini
    x86_64) fallback_arch="x86";; #e.g. chain: x86_64->x86->arm->all
    *)      fallback_arch="$1";; #return original arch if no fallback available
  esac
}

get_supported_variants(){
  case "$1" in
    aroma)          if [ "$API" -ge "22" ]; then
                      supported_variants="pico nano micro mini full stock super";
                    else
                      supported_variants="pico nano micro mini full stock";
                    fi;;
    super)          supported_variants="pico nano micro mini full stock super";;
    stock)          supported_variants="pico nano micro mini full stock";;
    full)           supported_variants="pico nano micro mini full";;
    mini)           supported_variants="pico nano micro mini";;
    micro)          supported_variants="pico nano micro";;
    nano)           supported_variants="pico nano";;
    pico)           supported_variants="pico";;
    *)              supported_variants="";;
  esac
}

get_gapps_list(){
  #Compile the list of applications that will be build for this variant
  gapps_list="$gappscore $gappsoptional"
  for variant in $1; do
    eval "addtogapps=\$gapps$variant"
    gapps_list="$gapps_list $addtogapps"
  done
}

buildtarget() {
preparebuildarea

#Compile the list of applications that will have to be build for this variant
get_gapps_list "$SUPPORTEDVARIANTS"
gapps="$gapps_list"

for app in $gapps; do
  get_package_info "$app"
  if [ -n "$packagename" ]; then
    buildapp "$packagename" "$packagetype/$app" "$packagetarget"
  fi
  for file in $packagefiles; do
    buildfile "$packagetype/$app/common" "$file"
  done
done

EXTRACTFILES="app_densities.txt app_sizes.txt" #is executed as first
}

get_package_info(){
  packagename=""
  packagetype=""
  packagetarget=""
  packagefiles=""
  case "$1" in
    framework)                packagetype="Core"; packagefiles="etc framework";;
    gmscore)                  packagetype="Core"; packagename="com.google.android.gms"; packagetarget="priv-app/PrebuiltGmsCore";;
    googlecontactssync)       packagetype="Core"; packagename="com.google.android.syncadapters.contacts"; packagetarget="app/GoogleContactsSyncAdapter";;
    googlebackuptransport)    packagetype="Core"; packagename="com.google.android.backuptransport"; packagetarget="priv-app/GoogleBackupTransport";;
    googlefeedback)           packagetype="Core"; packagename="com.google.android.feedback"; packagetarget="priv-app/GoogleFeedback";;
    gsfcore)                  packagetype="Core"; packagename="com.google.android.gsf"; packagetarget="priv-app/GoogleServicesFramework";;
    gsflogin)                 packagetype="Core"; packagename="com.google.android.gsf.login"; packagetarget="priv-app/GoogleLoginService";;
    googleonetimeinitializer) packagetype="Core"; packagename="com.google.android.onetimeinitializer"; packagetarget="priv-app/GoogleOneTimeInitializer";;
    googlepartnersetup)       packagetype="Core"; packagename="com.google.android.partnersetup"; packagetarget="priv-app/GooglePartnerSetup";;
    setupwizard)              packagetype="Core"; packagename="com.google.android.setupwizard"; packagetarget="priv-app/SetupWizard";;
    vending)                  packagetype="Core"; packagename="com.android.vending"; packagetarget="priv-app/Phonesky";;

    configupdater)            packagetype="Core"; packagename="com.google.android.configupdater"; packagetarget="priv-app/ConfigUpdater";;
    packageinstaller)         packagetype="Core"; packagename="com.google.android.packageinstaller"; packagetarget="priv-app/GooglePackageInstaller";;

    books)          packagetype="GApps"; packagename="com.google.android.apps.books"; packagetarget="app/Books";;
    calendargoogle) packagetype="GApps"; packagename="com.google.android.calendar"; packagetarget="app/CalendarGooglePrebuilt";;
    calsync)        packagetype="GApps"; packagename="com.google.android.syncadapters.calendar"; packagetarget="app/GoogleCalendarSyncAdapter";;
    cameragoogle)   packagetype="GApps"; packagename="com.google.android.googlecamera"; packagetarget="app/GoogleCamera";;
    chrome)         packagetype="GApps"; packagename="com.android.chrome"; packagetarget="app/Chrome";;
    clockgoogle)    packagetype="GApps"; packagename="com.google.android.deskclock"; packagetarget="app/PrebuiltDeskClockGoogle";;
    cloudprint)     packagetype="GApps"; packagename="com.google.android.apps.cloudprint"; packagetarget="app/CloudPrint2";;
    docs)           packagetype="GApps"; packagename="com.google.android.apps.docs.editors.docs"; packagetarget="app/EditorsDocs";;
    drive)          packagetype="GApps"; packagename="com.google.android.apps.docs"; packagetarget="app/Drive";;
    ears)           packagetype="GApps"; packagename="com.google.android.ears"; packagetarget="app/GoogleEars";;
    exchangegoogle) packagetype="GApps"; packagename="com.google.android.gm.exchange"; packagetarget="app/PrebuiltExchange3Google";;
    facedetect)     packagetype="GApps"; packagefiles="$LIBFOLDER/libfilterpack_facedetect.so";
                    if [ "$LIBFOLDER" = "lib64" ]; then #on 64 bit, we also need the 32 bit lib
                      packagefiles="$packagefiles lib/libfilterpack_facedetect.so";
                    fi;;
    faceunlock)     if [ "$ARCH" = "arm" ] || [ "$ARCH" = "arm64" ]; then #both arm and arm64
                      packagetype="GApps"; packagename="com.android.facelock"; packagetarget="app/FaceLock";
                      packagetype="GApps"; packagefiles="vendor/pittpatt/ $LIBFOLDER/libfacelock_jni.so vendor/$LIBFOLDER/libfrsdk.so";
                      if [ "$LIBFOLDER" = "lib64" ]; then #on 64 bit, we also need the 32 bit lib
                        packagefiles="$packagefiles vendor/lib/libfrsdk.so";
                      fi;
                    fi;;
    fitness)        packagetype="GApps"; packagename="com.google.android.apps.fitness"; packagetarget="app/FitnessPrebuilt";;
    gmail)          packagetype="GApps"; packagename="com.google.android.gm"; packagetarget="app/PrebuiltGmail";;
    googlenow)      packagetype="GApps"; packagename="com.google.android.launcher"; packagetarget="app/GoogleHome";;
    photos)         packagetype="GApps"; packagename="com.google.android.apps.photos"; packagetarget="app/Photos";;
    googleplus)     packagetype="GApps"; packagename="com.google.android.apps.plus"; packagetarget="app/PlusOne";;
    googletts)      packagetype="GApps"; packagename="com.google.android.tts"; packagetarget="app/GoogleTTS";;
    hangouts)       packagetype="GApps"; packagename="com.google.android.talk"; packagetarget="app/Hangouts";;
    keep)           packagetype="GApps"; packagename="com.google.android.keep"; packagetarget="app/PrebuiltKeep";;
    keyboardgoogle) packagetype="GApps"; packagename="com.google.android.inputmethod.latin"; packagetarget="app/LatinImeGoogle";;
    maps)           packagetype="GApps"; packagename="com.google.android.apps.maps"; packagetarget="app/Maps";;
    messenger)      packagetype="GApps"; packagename="com.google.android.apps.messaging"; packagetarget="app/PrebuiltBugle";;
    movies)         packagetype="GApps"; packagename="com.google.android.videos"; packagetarget="app/Videos";;
    music)          packagetype="GApps"; packagename="com.google.android.music"; packagetarget="app/Music2";;
    newsstand)      packagetype="GApps"; packagename="com.google.android.apps.magazines"; packagetarget="app/Newsstand";;
    newswidget)     packagetype="GApps"; packagename="com.google.android.apps.genie.geniewidget"; packagetarget="app/PrebuiltNewsWeather";;
    playgames)      packagetype="GApps"; packagename="com.google.android.play.games"; packagetarget="app/PlayGames";;
    search)         packagetype="GApps"; packagename="com.google.android.googlequicksearchbox"; packagetarget="priv-app/Velvet";;
    sheets)         packagetype="GApps"; packagename="com.google.android.apps.docs.editors.sheets"; packagetarget="app/EditorsSheets";;
    slides)         packagetype="GApps"; packagename="com.google.android.apps.docs.editors.slides"; packagetarget="app/EditorsSlides";;
    speech)         packagetype="GApps"; packagefiles="usr/srec/en-US/";;
    talkback)       packagetype="GApps"; packagename="com.google.android.marvin.talkback"; packagetarget="app/talkback";;
    taggoogle)      packagetype="GApps"; packagename="com.google.android.tag"; packagetarget="priv-app/TagGoogle";;
    webviewgoogle)  packagetype="GApps"; packagename="com.google.android.webview"; packagetarget="app/WebViewGoogle";;
    youtube)        packagetype="GApps"; packagename="com.google.android.youtube"; packagetarget="app/YouTube";;

    androidforwork) packagetype="GApps"; packagename="com.google.android.androidforwork"; packagetarget="priv-app/AndroidForWork";;
    androidpay)     packagetype="GApps"; packagename="com.google.android.apps.walletnfcrel"; packagetarget="app/Wallet";;
    dmagent)        packagetype="GApps"; packagename="com.google.android.apps.enterprise.dmagent"; packagetarget="app/DMAgent";;
    earth)          packagetype="GApps"; packagename="com.google.earth"; packagetarget="app/GoogleEarth";;
    gcs)            packagetype="GApps"; packagename="com.google.android.apps.gcs"; packagetarget="priv-app/GCS";;
    hindi)          packagetype="GApps"; packagename="com.google.android.apps.inputmethod.hindi"; packagetarget="app/GoogleHindiIME";;
    japanese)       packagetype="GApps"; packagename="com.google.android.inputmethod.japanese"; packagetarget="app/GoogleJapaneseInput";;
    korean)         packagetype="GApps"; packagename="com.google.android.inputmethod.korean"; packagetarget="app/KoreanIME";;
    pinyin)         packagetype="GApps"; packagename="com.google.android.inputmethod.pinyin"; packagetarget="app/GooglePinyinIME";;
    projectfi)      packagetype="GApps"; packagename="com.google.android.apps.tycho"; packagetarget="app/Tycho";;
    street)         packagetype="GApps"; packagename="com.google.android.street"; packagetarget="app/Street";;
    translate)      packagetype="GApps"; packagename="com.google.android.apps.translate"; packagetarget="app/TranslatePrebuilt";;
    zhuyin)         packagetype="GApps"; packagename="com.google.android.apps.inputmethod.zhuyin"; packagetarget="app/GoogleZhuyinIME";;

    calculatorgoogle) packagetype="GApps"; packagename="com.google.android.calculator"; packagetarget="app/CalculatorGoogle";;
    contactsgoogle)   packagetype="GApps"; packagename="com.google.android.contacts"; packagetarget="priv-app/GoogleContacts";;
    dialergoogle)     packagetype="GApps"; packagename="com.google.android.dialer"; packagetarget="priv-app/GoogleDialer";;

    swypelibs)       packagetype="Optional"; packagefiles="$LIBFOLDER/libjni_latinimegoogle.so";;

    *)              echo "ERROR! Missing build rule for application with keyword $1"; exit 1;;
  esac
}
