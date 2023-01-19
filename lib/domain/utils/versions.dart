class AppVC{
  int? version;
  int? subVersion;
  int? subBuild;

  AppVC({
    this.version,
    this.subVersion,
    this.subBuild
  });

  factory AppVC.parse(String version){
    List<String> currentV = version.split(".");
    return AppVC(
      version: int.parse(currentV[0]),
      subVersion: int.parse(currentV[1]),
      subBuild: int.parse(currentV[2])
    );
  }

  @override
  String toString() {
    return "$version.$subVersion.$subBuild";
  }

  bool isHigherThanNow(AppVC appVersion){
    final serverVersion = AppVC(version: version, subVersion: subVersion, subBuild: subBuild);
    List<String> currentV = appVersion.toString().split(".");
    List<String> serverV = serverVersion.toString().split(".");
    bool a = false;
    for (var i = 0 ; i <= 2; i++){
      a = int.parse(serverV[i]) > int.parse(currentV[i]);
      if(int.parse(serverV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }
}