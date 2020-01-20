import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LogDao {
  String _logFile = "/log.txt";

  Directory _directory;

  LogDao() {
    getApplicationDocumentsDirectory().then((value) {
      _directory = value;
    });
  }

  void saveLogToFile(String log) async {
    print("###error###  " + log);
    if (_directory == null) {
      _directory = await getApplicationDocumentsDirectory();
    }
    File file = File(_directory.path + _logFile);
    var randomAccessFile = await file.open(mode: FileMode.writeOnlyAppend);
    randomAccessFile.writeString(log + "\n");
  }
}
