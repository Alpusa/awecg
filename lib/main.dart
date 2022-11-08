import 'dart:io';

import 'package:awecg/screen/splash_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'bloc/init_screen/init_screen_bloc.dart';
import 'generated/i18n.dart';
import 'screen/init_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    print("Desktop");
    await DesktopWindow.setMinWindowSize(const Size(800, 600));
  }
  // remove vivisble status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const AppState());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    //..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InitScreenBloc>(
          create: (_) => InitScreenBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/init': (_) {
      return InitScreen();
    },
    '/splash': (_) {
      return SplashScreen();
    },
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const i18n = I18n.delegate;
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Alas TV',
          initialRoute: "/splash",
          routes: routes,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            i18n,
          ],
          supportedLocales: i18n.supportedLocales,
          localeResolutionCallback: i18n.resolution(
            fallback: const Locale("en", "US"),
          ),
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
