import 'dart:convert';
import 'dart:io';

import 'package:book_reader/entity/app_setting.dart';
import 'package:book_reader/global/global_info.dart';

import 'log_dao.dart';

class AppSettingDao {
  static Future<AppSetting> loadAppSetting() async {
    File file = File(await GlobalInfo.getDirectory() + GlobalInfo.settingFile);
    file.createSync();
    String content = file.readAsStringSync();
    AppSetting setting;
    try {
      setting = AppSetting.fromJson(jsonDecode(content));
    } catch (e) {
      LogDao.saveLogToFile(e.toString());
      setting = AppSetting();
      setting.shelfFile = "/shelf.json";
      setting.logFile = "/log.json";
      setting.booksFile = "/books.json";
      saveAppSettingToFile();
    }
    return setting;
  }

  static void saveAppSettingToFile() async {
    File file = File(await GlobalInfo.getDirectory() + GlobalInfo.settingFile);
    file.writeAsStringSync(jsonEncode(GlobalInfo.appSetting));
  }
}
