import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fstar_admin/model/changelog.dart';
import 'package:fstar_admin/model/f_result.dart';
import 'package:fstar_admin/model/message_data.dart';

class NetUtils {
  static final NetUtils _netUtils = NetUtils._internal();
  Dio _dio;

  factory NetUtils() {
    return _netUtils;
  }

  NetUtils._internal() {
    _dio = Dio(BaseOptions(
      connectTimeout: 5000,
      baseUrl: 'https://mdreamfever.com:9009',
      // baseUrl: 'http://10.0.2.2:8080',
    ));
  }

  void setHeader(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  Future<FResult> login({String username, String password}) async {
    var response = await _dio
        .post('/v2/auth', data: {'username': username, 'password': password});
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getMessage() async {
    var response = await _dio.get('/v2/message');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> deleteMessageById(int id) async {
    var response = await _dio.delete('/v2/admin/message/$id');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> deleteAllMessage() async {
    var response = await _dio.delete('/message');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> updateMessage(MessageData messageData) async {
    var response =
        await _dio.put('/v2/admin/message', data: messageData.toMap());
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> addMessage(MessageData messageData) async {
    var response =
        await _dio.post('/v2/admin/message', data: messageData.toMap());
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getChangelog() async {
    var response = await _dio.get('/v2/changelog');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getCurrentChangelog() async {
    var response = await _dio.get('/v2/changelog/current_version');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> deleteAllChangelog() async {
    var response = await _dio.delete('/v2/admin/changelog');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> deleteChangelogById(int id) async {
    var response = await _dio.delete('/v2/admin/changelog/$id');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> updateChangelog(Changelog changelog) async {
    var response =
        await _dio.put('/v2/admin/changelog', data: changelog.toMap());
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> addChangelog(Changelog changelog) async {
    var response =
        await _dio.post('/v2/admin/changelog', data: changelog.toMap());
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> countUser() async {
    var response = await _dio.get('/v2/admin/user/count');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> addSchoolBus(String url) async {
    var response = await _dio
        .get('/v2/admin/just/school_bus', queryParameters: {'url': url});
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getSchoolBus() async {
    var response = await _dio.get('/v2/service/just/school_bus');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> addSchoolCalendar(String url) async {
    var response = await _dio
        .get('/v2/admin/just/school_calendar', queryParameters: {'url': url});
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getSchoolCalendar() async {
    var response = await _dio.get('/v2/service/just/school_calendar');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getScore({@required int page, @required int size}) async {
    var response = await _dio
        .get('/v2/admin/score', queryParameters: {'page': page, 'size': size});
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getScoreByStudentNumber(String studentNumber) async {
    var response = await _dio.get('/v2/score/student/$studentNumber');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getUserByPage(
      {@required int page, @required int size}) async {
    var response = await _dio
        .get('/v2/admin/user', queryParameters: {'page': page, 'size': size});
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getAllUser() async {
    var response = await _dio.get('/v2/admin/user/all');
    var result = FResult.fromMap(response.data);
    return result;
  }

  Future<FResult> getVitality() async {
    var response = await _dio.get('/v2/admin/vitality');
    var result = FResult.fromMap(response.data);
    return result;
  }
}
