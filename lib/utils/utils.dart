import 'package:flutter/material.dart';
import 'package:fstar_admin/model/f_result.dart';

class FStarResultError extends Error {
  final Object message;

  FStarResultError([this.message = '繁星服务器或客户端错误']);

  @override
  String toString() {
    return message.toString();
  }
}

void checkResult(FResult result) {
  if (result.code != 200) {
    throw FStarResultError(result.message);
  }
}

Future pushPage(BuildContext context, Widget page) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}
