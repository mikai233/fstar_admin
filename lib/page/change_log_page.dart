import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fstar_admin/model/changelog.dart';
import 'package:fstar_admin/model/f_result.dart';
import 'package:fstar_admin/utils/net_utils.dart';
import 'package:fstar_admin/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChangelogPage extends StatefulWidget {
  @override
  State createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  final _refreshController = RefreshController(initialRefresh: true);
  Future<FResult> _changelogFuture;
  List<Changelog> _logs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更新日志'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _logs.length,
          itemBuilder: (BuildContext context, int index) {
            var item = _logs[index];
            return ListTile(
              onTap: () {
                _handleEdit(item);
              },
              onLongPress: () {
                _handleDelete(item);
              },
              title: Text(item.version),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildDescription(item.description),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var result = await NetUtils().getChangelog();
      checkResult(result);
      setState(() {
        _logs = (result.data as List).map((e) => Changelog.fromMap(e)).toList();
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      EasyLoading.showError(e.toString());
      _refreshController.refreshFailed();
    }
  }

  _buildDescription(String description) {
    var descriptions = description.split('-');
    return descriptions.map((e) => Text(e)).toList();
  }

  void _handleEdit(Changelog changelog) async {
    final buildNumberController = TextEditingController();
    final versionController = TextEditingController();
    final descriptionController = TextEditingController();
    final urlController = TextEditingController();
    buildNumberController.text = changelog.buildNumber.toString();
    versionController.text = changelog.version;
    descriptionController.text = changelog.description.replaceAll('-', '\n');
    urlController.text = changelog.downloadUrl;
    final formKey = GlobalKey<FormState>();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: buildNumberController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写构建号';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '构建号',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  fillColor: Color.fromRGBO(250, 250, 250, 1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: versionController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写版本号';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '版本',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  fillColor: Color.fromRGBO(250, 250, 250, 1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: urlController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写下载链接';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '下载链接',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  fillColor: Color.fromRGBO(250, 250, 250, 1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                maxLines: null,
                controller: descriptionController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写更新日志';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '更新日志',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  fillColor: Color.fromRGBO(250, 250, 250, 1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
      btnOk: ElevatedButton(
        onPressed: () async {
          try {
            if (formKey.currentState.validate()) {
              final updateChangelog = Changelog(
                  version: versionController.text.trim(),
                  buildNumber: int.parse(buildNumberController.text),
                  description: descriptionController.text.replaceAll('\n', '-'),
                  downloadUrl: urlController.text.trim(),
                  id: changelog.id);
              var result = await NetUtils().updateChangelog(updateChangelog);
              checkResult(result);
              _refreshController.requestRefresh();
              Navigator.pop(context);
            }
          } catch (e) {
            EasyLoading.showError(e.toString());
          }
        },
        child: Text('确定'),
      ),
    ).show();
  }

  void _handleDelete(Changelog changelog) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        body: Center(
          child: Text(
            '确定删除？',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        btnOk: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () async {
            try {
              var result = await NetUtils().deleteChangelogById(changelog.id);
              checkResult(result);
              Navigator.pop(context);
              _refreshController.requestRefresh();
            } catch (e) {
              EasyLoading.showError(e.toString());
              print(e);
            }
          },
          child: Text('删除'),
        ),
        btnCancel: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
        )).show();
  }
}
