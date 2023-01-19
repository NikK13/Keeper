class Application{
  String? application;
  AppVersion? iosVer;
  AppVersion? androidVer;

  Application({this.androidVer, this.application, this.iosVer});

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    application: json['application'],
    iosVer: AppVersion.fromJson(json['ios']),
    androidVer: AppVersion.fromJson(json['android']),
  );
}

class AppVersion{
  String? version;

  AppVersion({this.version});

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
    AppVersion(version: json['version']);
}