import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fstar_admin/model/changelog.dart';
import 'package:fstar_admin/model/message_data.dart';
import 'package:fstar_admin/page/change_log_page.dart';
import 'package:fstar_admin/page/message_page.dart';
import 'package:fstar_admin/utils/net_utils.dart';
import 'package:fstar_admin/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  State createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      _usernameController.text = value.getString('username');
      _passwordController.text = value.getString('password');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('繁星后台'),
        centerTitle: true,
      ),
      drawer: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Drawer(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: '用户名',
                    filled: true,
                    fillColor: Color.fromRGBO(240, 240, 240, 1),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onSubmitted: (value) {
                    _usernameFocusNode.unfocus();
                    _passwordFocusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: '密码',
                    filled: true,
                    fillColor: Color.fromRGBO(240, 240, 240, 1),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () async {
                      _usernameFocusNode.unfocus();
                      _passwordFocusNode.unfocus();
                      final username = _usernameController.text.trim() ?? '';
                      final password = _passwordController.text.trim() ?? '';
                      try {
                        EasyLoading.show(status: '请稍等');
                        var result = await NetUtils()
                            .login(username: username, password: password);
                        checkResult(result);
                        final data = result.data;
                        final header = data['tokenHeader'];
                        final prefix = data['tokenPrefix'];
                        final token = data['token'];
                        NetUtils().setHeader({header: '$prefix $token'});
                        EasyLoading.dismiss();
                        if (_key.currentState.isDrawerOpen) {
                          Navigator.pop(context);
                        }
                        SharedPreferences.getInstance().then((value) {
                          value
                            ..setString('username', username)
                            ..setString('password', password);
                        });
                      } catch (e) {
                        EasyLoading.showError(e.toString());
                      }
                    },
                    child: Text('登录'),
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('消息'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handleMessage,
          ),
          ListTile(
            title: Text('更新日志'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handleChangelog,
          ),
          ListTile(
            title: Text('更新应用'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handleUpdate,
          ),
          ListTile(
            title: Text('发布消息'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handlePublishMessage,
          ),
          ListTile(
            title: Text('校车时刻表'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handleSchoolBus,
          ),
          ListTile(
            title: Text('校历'),
            trailing: Icon(Icons.chevron_right),
            onTap: _handleSchoolCalendar,
          ),
        ],
      ),
    );
  }

  void _handleSchoolCalendar() async {
    final urlController = TextEditingController();
    try {
      EasyLoading.show(status: '请稍等');
      var result = await NetUtils().getSchoolCalendar();
      checkResult(result);
      final url = result.data;
      urlController.text = url;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: urlController,
          decoration: InputDecoration(
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
      btnOk: ElevatedButton(
        onPressed: () {
          try {
            NetUtils().addSchoolCalendar(urlController.text.trim());
            Navigator.pop(context);
          } catch (e) {
            EasyLoading.showError(e.toString());
          }
        },
        child: Text('确定'),
      ),
    ).show();
  }

  void _handleSchoolBus() async {
    final urlController = TextEditingController();
    try {
      EasyLoading.show(status: '请稍等');
      var result = await NetUtils().getSchoolBus();
      checkResult(result);
      final url = result.data;
      urlController.text = url;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: urlController,
          decoration: InputDecoration(
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
      btnOk: ElevatedButton(
        onPressed: () {
          try {
            NetUtils().addSchoolBus(urlController.text.trim());
            Navigator.pop(context);
          } catch (e) {
            EasyLoading.showError(e.toString());
          }
        },
        child: Text('确定'),
      ),
    ).show();
  }

  void _handleUpdate() async {
    final buildNumberController = TextEditingController();
    final versionController = TextEditingController();
    final descriptionController = TextEditingController();
    final urlController = TextEditingController();
    try {
      EasyLoading.show(status: '请稍等');
      var result = await NetUtils().getCurrentChangelog();
      checkResult(result);
      final currentChangelog = Changelog.fromMap(result.data);
      buildNumberController.text = currentChangelog.buildNumber.toString();
      versionController.text = currentChangelog.version;
      descriptionController.text =
          currentChangelog.description.replaceAll('-', '\n');
      urlController.text = currentChangelog.downloadUrl;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
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
              final changelog = Changelog(
                  version: versionController.text.trim(),
                  buildNumber: int.parse(buildNumberController.text),
                  description: descriptionController.text.replaceAll('\n', '-'),
                  downloadUrl: urlController.text.trim(),
                  id: null);
              var result = await NetUtils().addChangelog(changelog);
              checkResult(result);
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

  void _handleChangelog() {
    pushPage(context, ChangelogPage());
  }

  void _handlePublishMessage() async {
    final contentController = TextEditingController();
    final maxVisibleBuildNumberController = TextEditingController();
    final minVisibleBuildNumberController =
        TextEditingController.fromValue(TextEditingValue(text: '0'));
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
                controller: maxVisibleBuildNumberController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写最大可见构建号';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '最大可见构建号',
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
                controller: minVisibleBuildNumberController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写最小可见构建号';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '最小可见构建号',
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
                controller: contentController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请填写消息内容';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: '消息内容',
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
              final message = MessageData(
                  id: null,
                  content: contentController.text.replaceAll('\n', '-'),
                  publishTime: null,
                  maxVisibleBuildNumber:
                      int.parse(maxVisibleBuildNumberController.text),
                  minVisibleBuildNumber:
                      int.parse(minVisibleBuildNumberController.text));
              var result = await NetUtils().addMessage(message);
              checkResult(result);
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

  void _handleMessage() {
    pushPage(context, MessagePage());
  }
}
