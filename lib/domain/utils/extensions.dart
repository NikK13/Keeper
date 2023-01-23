import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keeper/data/navigator/delegate.dart';

import 'constants.dart';

printFullResponse(Response res){
  final code = res.statusCode;
  final url = res.request!.url;

  final full = "$url: RESPONSE CODE - $code, ${res.headers['content-type']}";
  debugPrint(full);
}

Uint8List? imageBytes(String photo){
  if(photo.isNotEmpty){
    final ph = photo.split(',').last;
    return base64.decode(ph);
  }
  return null;
}

void setLandscapeMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

/*void showCustomDatePicker(BuildContext context, TextEditingController controller) async{
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1960, 1, 1),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: prefsProvider.theme.accentColor!,
            onSurface: Theme.of(context).brightness == Brightness.dark ?
            Colors.white : Colors.grey
          ),
        ),
        child: child!,
      );
    },
  );
  if(date != null){
    controller.text = DateFormat("dd/MM/yyyy").format(date).toString();
  }
}*/

void setPortraitMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void setAllScreensMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

Color accent(context) => Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

void scrollToTheTop(ScrollController scrollController){
  if(scrollController.hasClients){
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeIn
    );
  }
}

Widget getIconButton({required Widget child, required BuildContext context, Function()? onTap, Color? color}) => InkWell(
  splashFactory: NoSplash.splashFactory,
  highlightColor: Colors.transparent,
  onTap: onTap,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18.0),
      color: color ?? (Theme.of(context).brightness == Brightness.light ?
      const Color(0xFFFFFFFF) : const Color(0xFF1F1F1F)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15), //color of shadow
          spreadRadius: Theme.of(context).brightness == Brightness.light ? 2 : 0, //spread radius
          blurRadius: Theme.of(context).brightness == Brightness.light ? 4 : 2, // blur radius
          offset: Theme.of(context).brightness == Brightness.light ?
          const Offset(2, 3) : const Offset(0, 0)
        )
      ]
    ),
    padding: const EdgeInsets.all(8.0),
    child: child
  ),
);

Widget get dialogLine => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
    height: 3.0,
    width: 32.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey.withOpacity(0.3)
    ),
  ),
);

Widget get widgetLine => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
    height: 4.0,
    width: 24.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.white
    ),
  ),
);

void showToastBar(context, text, [IconData icon = Icons.error_outline, bool isSuccess = false]) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.symmetric(
        horizontal: 72,
        vertical: 32
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isLight ? Colors.white :
      const Color(0xFF232323),
      content: Row(
        children: [
          Icon(
            icon,
            color: isSuccess ? Colors.green : Colors.redAccent,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isLight ? Colors.black
                : Colors.white,
              ),
            ),
          ),
        ],
      )
    ),
  );
}

int getIndexByPriority(String priority){
  switch(priority){
    case 'low':
      return 0;
    case 'medium':
      return 1;
    case 'high':
      return 2;
    default:
      return 0;
  }
}

Color? getColorByPriority(String priority){
  switch(priority){
    case "low":
      return Colors.greenAccent.shade700;
    case "medium":
      return Colors.amber;
    case "high":
      return Colors.red;
    default:
      return Colors.amber;
  }
}

String getPriorityByIndex(int index){
  switch(index){
    case 0:
      return 'low';
    case 1:
      return 'medium';
    case 2:
      return 'high';
    default:
      return 'low';
  }
}

String formattedDate(bool is12h, String date){
  DateTime dateTime = DateFormat(dateFormat24h).parse(date).add(const Duration(hours: 1));

  if(is12h){
    final h12Date = DateFormat.jm().format(dateTime);
    return "${date.substring(0, 10)} $h12Date";
  }
  else{
    final h24Date = DateFormat.Hm().format(dateTime);
    return "${date.substring(0, 10)} $h24Date";
  }
}

BoxConstraints getDialogConstraints(BuildContext context, [double size = 0.95]){
  return BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * size
  );
}

extension RouterNavigator on BuildContext {
  void push(String location, [Map<String, dynamic>? extra]) =>
  (Router.of(this).routerDelegate as AppRouterDelegate).push(location, extra);

  void replace(String location, [Map<String, dynamic>? extra]) =>
  (Router.of(this).routerDelegate as AppRouterDelegate).replace(location, extra);

  void pop() => (Router.of(this).routerDelegate as AppRouterDelegate).pop();

  /*void navigate(String location) =>
  (Router.of(this).routerDelegate as AppRouterDelegate).navigateTo(location);*/

  void popRoute() => (Router.of(this).routerDelegate as AppRouterDelegate).popRoute();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addHour(int hour) {
    return replacing(hour: this.hour + hour, minute: minute);
  }

  TimeOfDay addMinutes(int minutes) {
    return replacing(hour: hour, minute: minute + minutes);
  }

  String format12Hour(BuildContext context) {
    TimeOfDay time = replacing(hour: hourOfPeriod);
    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final StringBuffer buffer = StringBuffer();

    buffer
      ..write("${time.hour}:${time.minute > 9 ? time.minute : "0${time.minute}"}")
      ..write(' ')
      ..write(period == DayPeriod.am
        ? localizations.anteMeridiemAbbreviation
        : localizations.postMeridiemAbbreviation);

    return '$buffer';
  }
}

extension DoubleExtension on String {
  double toDBDouble() {
    return double.parse(replaceAll(',', '.'));
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}