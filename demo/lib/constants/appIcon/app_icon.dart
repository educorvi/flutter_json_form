import 'package:flutter/material.dart';

abstract class AppIcon {
  IconData get homePageIconSelected;

  IconData get homePageIconUnselected;

  IconData get databasePageIconSelected;

  IconData get databasePageIconUnselected;

  IconData get settingsPageIconSelected;

  IconData get settingsPageIconUnselected;

  IconData get delete;

  IconData get shareIos;

  IconData get shareAndroid;

  IconData get back;

  IconData get home;

  IconData get documents;

  IconData get download;

  IconData get downloaded;

  // IconData get serverConnection;

  IconData get serverConnected;

  IconData get serverDisconnected;

  IconData get emptyFormList;

  IconData get noImage;

  IconData get settingsThemeSwitchSystem;

  IconData get settingsThemeSwitchLight;

  IconData get settingsThemeSwitchDark;

  IconData get settingsTheme;

  IconData get settingsLanguage;

  IconData get edit;

  IconData get time;

  IconData get done;

  IconData get error;

  IconData get expand;

  IconData get collapse;

  IconData get help;

  IconData get pdfFile;

  IconData get editNote;

  IconData get editDocument;

  IconData get circleFilled;

  IconData get refresh;

  IconData get paragraphText;

  IconData get mediaPause;

  IconData get mediaPlay;

  IconData get mediaReplay;

  IconData get mediaVolumeUp;

  IconData shareIcon(BuildContext context) {
    return _platformDependant(context, ios: shareIos, android: shareAndroid);
  }

  /// return different things depending on the architecture ios or android. Provide which variables should be returned
  T _platformDependant<T>(BuildContext context, {required T ios, required T android}) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }
}
