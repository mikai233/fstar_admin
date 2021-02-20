import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fstar_admin/model/f_star_user.dart';
import 'package:fstar_admin/model/score_data.dart';
import 'package:fstar_admin/utils/net_utils.dart';
import 'package:fstar_admin/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_color/random_color.dart';

class QueryPage extends StatefulWidget {
  @override
  State createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> with TickerProviderStateMixin {
  TabController _tabController;
  final _userRefreshController = RefreshController(initialRefresh: true);
  final _scoreRefreshController = RefreshController(initialRefresh: true);
  List<ScoreData> _scoreList = [];
  int _scorePage = 0;
  int _scoreSize = 50;
  final _scoreSearchController = TextEditingController();
  final _scoreSearchFocusNode = FocusNode();
  final _scoreScrollController = ScrollController();
  List<FStarUser> _user = [];
  int _userPage = 0;
  int _userSize = 50;
  int _totalUser = 0;
  int _activeDay = 0;
  int _activeWeek = 0;
  int _activeMonth = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scoreScrollController.addListener(() {
      if (_scoreSearchFocusNode.hasFocus) {
        _scoreSearchFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: TabBar(
          controller: _tabController,
          labelPadding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          tabs: [
            Center(
              child: Text(
                '用户',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Center(
              child: Text(
                '成绩',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildUser(), _buildScore()],
        ),
      ),
    );
  }

  _buildUser() {
    // var brand = devicesMap['brand'];
    // var brandData = _processPieChartData(brand);
    return SmartRefresher(
      controller: _userRefreshController,
      header: WaterDropHeader(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '总用户 $_totalUser',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '日活跃用户 $_activeDay',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '周活跃用户 $_activeWeek',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '月活跃用户 $_activeMonth',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Wrap(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        final androidVersionMap = Map<String, int>();
                        _user.forEach((element) {
                          androidVersionMap.putIfAbsent(
                              element.androidVersion, () => 0);
                          androidVersionMap[element.androidVersion] =
                              androidVersionMap[element.androidVersion] + 1;
                        });
                        var androidVersionData =
                            _processPieChartData(androidVersionMap);
                        var androidVersionHeader = androidVersionData['header'];
                        var androidVersionSelections =
                            androidVersionData['data'];
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '安卓版本',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          children: androidVersionHeader,
                                        ),
                                        PieChart(
                                          PieChartData(
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections:
                                                  androidVersionSelections),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('安卓版本统计'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final brandMap = Map<String, int>();
                        _user.forEach((element) {
                          brandMap.putIfAbsent(element.brand, () => 0);
                          brandMap[element.brand] = brandMap[element.brand] + 1;
                        });
                        var androidVersionData = _processPieChartData(brandMap);
                        var brandHeader = androidVersionData['header'];
                        var brandSelections = androidVersionData['data'];
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '手机品牌',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          children: brandHeader,
                                        ),
                                        PieChart(PieChartData(
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: brandSelections)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('品牌统计'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final platformMap = Map<String, int>();
                        _user.forEach((element) {
                          platformMap.putIfAbsent(element.platform, () => 0);
                          platformMap[element.platform] =
                              platformMap[element.platform] + 1;
                        });
                        var platformData = _processPieChartData(platformMap);
                        var platformHeader = platformData['header'];
                        var platformSelections = platformData['data'];
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '平台',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          children: platformHeader,
                                        ),
                                        PieChart(PieChartData(
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: platformSelections)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('平台统计'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final versionMap = Map<String, int>();
                        _user.forEach((element) {
                          versionMap.putIfAbsent(element.appVersion, () => 0);
                          versionMap[element.appVersion] =
                              versionMap[element.appVersion] + 1;
                        });
                        var versionData = _processPieChartData(versionMap);
                        var versionHeader = versionData['header'];
                        var versionSelections = versionData['data'];
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '客户端版本',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          children: versionHeader,
                                        ),
                                        PieChart(PieChartData(
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: versionSelections)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text('客户端版本统计'),
                    ),
                  ],
                  spacing: 20,
                ),
              ],
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final user = _user[index];
              return ListTile(
                title: Text(user.androidId),
                leading: Text('${index + 1}'),
                subtitle: Column(
                  children: [
                    Text('构建号 ${user.buildNumber}'),
                    Text('手机系统版本 ${user.androidVersion}'),
                    Text('model ${user.model}'),
                    Text('device ${user.device}'),
                    Text('brand ${user.brand}'),
                    Text('product ${user.product}'),
                    Text('platform ${user.platform}')
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              );
            }, childCount: _user.length),
          )
        ],
      ),
      onRefresh: () async {
        try {
          _userPage = 0;
          var result = await NetUtils().getAllUser();
          checkResult(result);
          var totalResult = await NetUtils().countUser();
          checkResult(totalResult);
          var vitality = await NetUtils().getVitality();
          checkResult(vitality);
          setState(() {
            _user =
                (result.data as List).map((e) => FStarUser.fromMap(e)).toList();
            _totalUser = totalResult.data;
            final vitalityData = vitality.data;
            _activeDay = vitalityData['day'];
            _activeWeek = vitalityData['week'];
            _activeMonth = vitalityData['month'];
          });
          _userRefreshController.refreshCompleted();
        } catch (e) {
          EasyLoading.showError(e.toString());
          _userRefreshController.refreshFailed();
        }
      },
    );
  }

  _buildScore() {
    return SmartRefresher(
        controller: _scoreRefreshController,
        header: WaterDropHeader(),
        onRefresh: _onScoreRefresh,
        onLoading: _onScoreLoading,
        enablePullUp: true,
        child: CustomScrollView(
          controller: _scoreScrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Color.fromRGBO(250, 250, 250, 1),
              title: Container(
                height: 35,
                child: TextField(
                  controller: _scoreSearchController,
                  focusNode: _scoreSearchFocusNode,
                  decoration: InputDecoration(
                      labelText: '搜索',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      fillColor: Color.fromRGBO(240, 240, 240, 1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      suffix: TextButton(
                        onPressed: () async {
                          try {
                            if (_scoreSearchController.text.isEmpty) {
                              _scoreRefreshController.requestRefresh();
                              return;
                            }
                            _scoreSearchFocusNode.unfocus();
                            var result = await NetUtils()
                                .getScoreByStudentNumber(
                                    _scoreSearchController.text.trim());
                            checkResult(result);
                            print(result.data);
                            setState(() {
                              _scoreList = (result.data as List)
                                  .map((e) => ScoreData.fromMap(e))
                                  .toList();
                            });
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        },
                        child: Text('搜索'),
                      )),
                ),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                final scoreData = _scoreList[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black38,
                            spreadRadius: .3,
                            blurRadius: .5)
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '学号 ${scoreData.studentNumber}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '课程名 ${scoreData.name}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '成绩 ${scoreData.score}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                );
              }, childCount: _scoreList.length),
            ),
          ],
        ));
  }

  void _onScoreRefresh() async {
    try {
      _scorePage = 0;
      var result =
          await NetUtils().getScore(page: _scorePage, size: _scoreSize);
      checkResult(result);
      setState(() {
        _scoreList = (result.data['content'] as List)
            .map((e) => ScoreData.fromMap(e))
            .toList();
      });
      _scoreRefreshController.refreshCompleted();
    } catch (e) {
      EasyLoading.showError(e.toString());
      _scoreRefreshController.refreshFailed();
    }
  }

  void _onScoreLoading() async {
    try {
      var result =
          await NetUtils().getScore(page: ++_scorePage, size: _scoreSize);
      checkResult(result);
      setState(() {
        _scoreList.addAll(
            (result.data['content'] as List).map((e) => ScoreData.fromMap(e)));
      });
      _scoreRefreshController.loadComplete();
    } catch (e) {
      EasyLoading.showError(e.toString());
      _scoreRefreshController.loadFailed();
    }
  }

  _processPieChartData(Map<String, int> dataMap) {
    var total = dataMap.isEmpty
        ? 0
        : dataMap.values.reduce((value, element) => value + element);
    var randomColor = RandomColor();
    int index = 0;
    var colors = List.generate(
        dataMap.length, (index) => randomColor.randomMaterialColor());
    var pieChartSectionDataList = dataMap.values
        .map((e) => PieChartSectionData(
            color: colors[index++],
            titleStyle: TextStyle(fontSize: 12),
            value: e.toDouble(),
            title:
                '${(e / total < 0.03) ? '' : (e / total * 100).toStringAsFixed(1) + '%'}'))
        .toList();
    var headerList = <Widget>[];
    int index2 = 0;
    dataMap.forEach((key, value) {
      headerList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Container(
                color: colors[index2++],
                width: 20,
                height: 20,
              ),
              Text('$key数量$value')
            ],
          ),
        ),
      );
    });
    return {'header': headerList, 'data': pieChartSectionDataList};
  }
}
