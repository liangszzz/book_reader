class Chapter {
  String name;

  String netPath;

  String savePath;

  Chapter();

  Chapter.fromJson(Map<String, dynamic> map) {
    this.name = map["name"];
    this.netPath = map["netPath"];
    this.savePath = map["savePath"];
  }

  Map toJson() {
    Map map = new Map();
    map["name"] = this.name;
    map["netPath"] = this.netPath;
    map["savePath"] = this.savePath;
    return map;
  }
}
