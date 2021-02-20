import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fstar_admin/model/message_data.dart';
import 'package:fstar_admin/utils/net_utils.dart';
import 'package:fstar_admin/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagePage extends StatefulWidget {
  @override
  State createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _refreshController = RefreshController(initialRefresh: true);
  List<MessageData> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _messages[index];
            return ListTile(
              title: Text(item.publishTime),
              onTap: () {
                _handleEdit(item);
              },
              onLongPress: () {
                _handleDelete(item);
              },
              subtitle: Column(
                children: [
                  Text('最小可见构建号 ${item.minVisibleBuildNumber}'),
                  Text('最大可见构建号 ${item.maxVisibleBuildNumber}'),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Divider(),
                  ),
                ]..addAll(item.content.split('-').map((e) => Text(e))),
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var result = await NetUtils().getMessage();
      checkResult(result);
      setState(() {
        _messages =
            (result.data as List).map((e) => MessageData.fromMap(e)).toList();
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      EasyLoading.showError(e.toString());
    }
  }

  void _handleEdit(MessageData messageData) {
    final contentController = TextEditingController();
    final maxVisibleBuildNumberController = TextEditingController();
    final minVisibleBuildNumberController = TextEditingController();
    contentController.text = messageData.content.replaceAll('-', '\n');
    maxVisibleBuildNumberController.text =
        messageData.maxVisibleBuildNumber.toString();
    minVisibleBuildNumberController.text =
        messageData.minVisibleBuildNumber.toString();
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
                  id: messageData.id,
                  content: contentController.text.replaceAll('\n', '-'),
                  publishTime: messageData.publishTime,
                  maxVisibleBuildNumber:
                      int.parse(maxVisibleBuildNumberController.text),
                  minVisibleBuildNumber:
                      int.parse(minVisibleBuildNumberController.text));
              var result = await NetUtils().updateMessage(message);
              checkResult(result);
              Navigator.pop(context);
              _refreshController.requestRefresh();
            }
          } catch (e) {
            EasyLoading.showError(e.toString());
          }
        },
        child: Text('确定'),
      ),
    ).show();
  }

  void _handleDelete(MessageData messageData) {
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
              var result = await NetUtils().deleteMessageById(messageData.id);
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
