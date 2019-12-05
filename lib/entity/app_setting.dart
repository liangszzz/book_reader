class AppSetting {
  String booksFile;

  String shelfFile;

  String logFile;

  AppSetting();

  AppSetting.fromJson(Map<String, dynamic> map) {
    this.booksFile = map["booksFile"];
    this.shelfFile = map["shelfFile"];
    this.logFile = map["logFile"];
  }

  Map toJson() {
    Map map = new Map();
    map["booksFile"] = this.booksFile;
    map["shelfFile"] = this.shelfFile;
    map["logFile"] = this.logFile;
    return map;
  }
}
