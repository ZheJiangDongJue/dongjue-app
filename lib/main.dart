import 'package:dongjue_application/globals.dart';
import 'package:dongjue_application/module/change_password.dart';
import 'package:dongjue_application/module/setting.dart';
import 'package:dongjue_application/module/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:dongjue_application/module/login.dart' as m_login;
import 'package:dongjue_application/module/functions.dart' as m_functions;
import 'package:dongjue_application/setting.dart' as m_setting;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

//这个是主函数,所有逻辑从这里开始
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //初始化Flutter,本来一直用web调试就一直没加,但是调试安卓的时候报错,加上了就好了
  await m_setting.loadSettings(); // 加载设置,可以进内部看下里面
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
      ],
      navigatorObservers: [FlutterSmartDialog.observer],
      locale: const Locale('zh'),
      title: '东爵内部App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const m_login.LoginPage(),
      // home: const ControlTestPage(),
      routes: {
        '/login': (context) => const m_login.LoginPage(),
        '/functions': (context) => const m_functions.FunctionsPage(),
        '/usercenter': (context) => const UserCenter(),
        '/setting': (context) => const SettingPage(),
        '/test': (context) => const ControlTestPage(),
        '/changepassword': (context) => const ChangePasswordPage(),
      },
    );
  }
}

class ControlTestPage extends StatefulWidget {
  const ControlTestPage({super.key});

  @override
  State<ControlTestPage> createState() => _ControlTestPageState();
}

class _ControlTestPageState extends State<ControlTestPage> {
  @override
  void initState() {
    super.initState();
    //
  }

  @override
  Widget build(BuildContext context) {
    //初始化各种
    GlobalData().db_config.DbName = "PEM6";
    return Text("test");
  }
}
