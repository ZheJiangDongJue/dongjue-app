import 'package:flutter/material.dart';
import './module/login.dart' as m_login;
import './module/functions.dart' as m_functions;
import './setting.dart' as m_setting;

//这个是主函数,所有逻辑从这里开始
void main() {
  WidgetsFlutterBinding.ensureInitialized();//初始化Flutter,本来一直用web调试就一直没加,但是调试安卓的时候报错,加上了就好了
  m_setting.loadSettings(); // 加载设置,可以进内部看下里面
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const m_login.LoginPage(),
        routes: {
          '/login': (context) => const m_login.LoginPage(),
          '/functions': (context) => const m_functions.FunctionsPage(),
        });
  }
}