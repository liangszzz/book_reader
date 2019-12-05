
import 'package:book_reader/dao/app_setting_dao.dart';
import 'package:book_reader/entity/app_setting.dart';
import 'package:path_provider/path_provider.dart';

class GlobalInfo {
  static AppSetting appSetting;

  static String _directory;

  static final String settingFile = "/setting.json";

  //APP 版本
  static final String version = "1.0.0";

  static Future<String> getDirectory() async {
    if (_directory == null) {
      var externalStorageDirectory = await getExternalStorageDirectory();
      _directory = externalStorageDirectory.path;
    }
    return _directory;
  }

  static void loadAppSetting() async {
    appSetting = await AppSettingDao.loadAppSetting();
  }
}
