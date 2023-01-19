import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../domain/model/application.dart';
import '../../domain/utils/extensions.dart';

class APIRepository{
  static Future<Application?> fetchApplicationData() async{
    Response? res;
    try{
      res = await Client().get(
        Uri.parse("https://api.npoint.io/6b70829f4a5bf753523c")
      ).timeout(const Duration(seconds: 2));
      printFullResponse(res);
      if(res.statusCode != 200){
        return null;
      }
      else {
        return await compute(parseApp, res.body);
      }
    }
    on TimeoutException catch (_) {
      debugPrint("TIMEOUT REQUEST");
      return null;
    }
    catch(e){
      debugPrint(e.toString());
      return null;
    }
  }

  static Application parseApp(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Application.fromJson(parsed['keeper']);
  }
}