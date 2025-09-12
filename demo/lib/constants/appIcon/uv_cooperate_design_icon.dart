import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'app_icon.dart';

final class UvCooperateDesignIcon extends AppIcon {
  @override
  IconData get homePageIconSelected => PhosphorIcons.cards(PhosphorIconsStyle.fill);

  @override
  IconData get homePageIconUnselected => PhosphorIcons.cards();

  @override
  IconData get databasePageIconSelected => PhosphorIcons.fileText(PhosphorIconsStyle.fill);

  @override
  IconData get databasePageIconUnselected => PhosphorIcons.fileText();

  @override
  IconData get settingsPageIconSelected => PhosphorIcons.gear(PhosphorIconsStyle.fill);

  @override
  IconData get settingsPageIconUnselected => PhosphorIcons.gear();

  @override
  IconData get delete => PhosphorIcons.trash();

  @override
  IconData get shareAndroid => PhosphorIcons.shareFat();

  @override
  IconData get shareIos => PhosphorIcons.export();

  @override
  IconData get back => PhosphorIcons.arrowLeft();

  @override
  IconData get home => PhosphorIcons.house();

  @override
  IconData get documents => PhosphorIcons.files();

  @override
  IconData get download => PhosphorIcons.downloadSimple();

  @override
  IconData get downloaded => PhosphorIcons.check();

  // @override
  // IconData get serverConnection => PhosphorIcons.cellTower();

  @override
  IconData get serverConnected => PhosphorIcons.cloudCheck();

  @override
  IconData get serverDisconnected => PhosphorIcons.cloudSlash();

  @override
  IconData get emptyFormList => PhosphorIcons.listPlus();

  @override
  IconData get noImage => PhosphorIcons.imageBroken();

  @override
  IconData get settingsThemeSwitchDark => PhosphorIcons.gear();

  @override
  IconData get settingsThemeSwitchLight => PhosphorIcons.sun();

  @override
  IconData get settingsThemeSwitchSystem => PhosphorIcons.moon();

  @override
  IconData get settingsTheme => PhosphorIcons.palette();

  @override
  IconData get settingsLanguage => PhosphorIcons.globe();

  @override
  IconData get edit => PhosphorIcons.pencilSimple();

  @override
  IconData get time => PhosphorIcons.clock();

  @override
  IconData get done => PhosphorIcons.check();

  @override
  IconData get error => PhosphorIcons.warningCircle();

  @override
  IconData get collapse => PhosphorIcons.caretDown();

  @override
  IconData get expand => PhosphorIcons.caretUp();

  @override
  IconData get help => PhosphorIcons.question();

  @override
  IconData get pdfFile => PhosphorIcons.filePdf();

  @override
  IconData get editDocument => PhosphorIcons.notePencil();

  @override
  IconData get editNote => PhosphorIcons.notePencil();

  @override
  IconData get circleFilled => PhosphorIcons.circle(PhosphorIconsStyle.fill);

  @override
  // TODO: implement mediaPause
  IconData get mediaPause => PhosphorIcons.pause();

  @override
  // TODO: implement mediaPlay
  IconData get mediaPlay => PhosphorIcons.play();

  @override
  // TODO: implement mediaReplay
  IconData get mediaReplay => PhosphorIcons.arrowCounterClockwise();

  @override
  // TODO: implement mediaVolumeUp
  IconData get mediaVolumeUp => PhosphorIcons.speakerHigh();

  @override
  // TODO: implement paragraphText
  IconData get paragraphText => PhosphorIcons.textAlignLeft();

  @override
  // TODO: implement refresh
  IconData get refresh => PhosphorIcons.arrowClockwise();
}
