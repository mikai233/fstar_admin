import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fstar_admin/page/admin_page.dart';
import 'package:fstar_admin/page/query_page.dart';
import 'package:fstar_admin/utils/net_utils.dart';
import 'package:fstar_admin/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  login();
  runApp(MyApp());
}

void login() {
  SharedPreferences.getInstance().then((value) async {
    final username = value.getString('username');
    final password = value.getString('password');
    if (username != null && password != null) {
      var result =
          await NetUtils().login(username: username, password: password);
      checkResult(result);
      NetUtils().setHeader({
        result.data['tokenHeader']:
            '${result.data['tokenPrefix']} ${result.data['token']}'
      });
    }
  }).catchError((error) {
    EasyLoading.showError(error.toString());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => FlutterEasyLoading(child: child),
      title: '繁星后台',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: _createPageTransitionsTheme(),
      ),
      home: HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        RefreshLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'CN'),
      ],
    );
  }

  _createPageTransitionsTheme() {
    return PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..indicatorSize = 80;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '查询',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: '管理',
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }

  _getPage() {
    switch (_currentIndex) {
      case 0:
        return QueryPage();
        break;
      case 1:
        return AdminPage();
    }
  }
}
