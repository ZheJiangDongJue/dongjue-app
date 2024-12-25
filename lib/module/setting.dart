import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dongjue_application/setting.dart' as m_setting;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('当前版本'),
            //获取当前版本
            trailing: Text(_packageInfo.version),
            onTap: () {
              // 检查最新版本
              checkLatestVersion().then((latestVersion) {
                if (latestVersion != _packageInfo.version) {
                  // 显示更新对话框
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('发现新版本'),
                        content: Text('当前版本:${_packageInfo.version}\n最新版本:$latestVersion\n是否更新?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('更新'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              // 显示下载进度对话框
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text('正在下载'),
                                    content: LinearProgressIndicator(),
                                  );
                                },
                              );

                              try {
                                // 下载并安装APK
                                String apkPath = await downloadApk(latestVersion);
                                Navigator.of(context).pop(); // 关闭进度对话框
                                await installApk(apkPath);
                              } catch (e) {
                                Navigator.of(context).pop(); // 关闭进度对话框
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('更新失败: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已是最新版本')),
                  );
                }
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cached_sharp),
            title: const Text('清除设置'),
            onTap: () {
              // 清除设置
              m_setting.clearSettings();
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.language),
          //   title: const Text('语言'),
          //   trailing: const Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     //  导航到语言设置页面
          //   },
          // ),
          // const Divider(),
          // // ...更多设置项
        ],
      ),
    );
  }
}

checkLatestVersion() async {
  // 从http://192.168.3.31:280/AndroidVersion.txt
  // 获取并返回最新版本
  final dio = Dio();
  final response = await dio.get('http://192.168.3.31:280/AndroidVersion.txt');
  return response.data;
}

downloadApk(String version) async {
  // 从http://192.168.3.31:280/AndroidVersion.txt
  // 下载最新版本
  // 返回下载路径
  try {
    final dio = Dio();
    final url = 'http://192.168.3.31:280/dongjue.apk'; // 添加版本号到URL

    // 获取下载目录
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory(); // 安卓下载目录
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory(); // iOS 下载目录，iOS一般不直接下载APK
      return null; // iOS 不支持下载 APK
    }

    if (directory == null) {
      return null; // 获取目录失败
    }


    // 请求存储权限 (Android)
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isDenied) {
        return null; // 没有权限
      }
    }

    // 创建文件
    final filePath = '${directory.path}/app-$version.apk';
    final file = File(filePath);

    // 使用Dio下载文件
    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        // 可选：更新下载进度
        double progress = (received / total * 100).floorToDouble();
        print('Download progress: $progress%');
      }
    });

    print('Download completed: $filePath');
    return filePath;
  } catch (e) {
    print('Error during download: $e');
    return null;
  }
}

installApk(String apkPath) async {
  // 安装APK
}
