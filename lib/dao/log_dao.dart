import 'dart:io';

import 'package:book_reader/global/global_info.dart';
import 'package:path_provider/path_provider.dart';

class LogDao {
  static void saveLogToFile(String exception) async {
    print("###error###  " + exception);
    Directory directory = await getExternalStorageDirectory();
    File file = new File(directory.path + GlobalInfo.appSetting.logFile);
    var randomAccessFile = await file.open(mode: FileMode.writeOnlyAppend);
    randomAccessFile.writeString(exception + "\n");
  }
}
