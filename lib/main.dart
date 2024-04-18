import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:os_project/pages/alt_homepage.dart';
import 'package:os_project/pages/display_fcfs.dart';
import 'package:os_project/pages/display_page.dart';
import 'package:os_project/pages/homepage.dart';
import 'package:os_project/pages/process_list_page.dart';
import 'package:os_project/pages/timer_page.dart';
import 'package:os_project/provider/process_provider.dart';
import 'package:os_project/themes/light_theme.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProcessProvider>(
      create: (context) => ProcessProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        initialRoute: AltHomePage.id,
        routes: {
          Homepage.id: (context) => Homepage(),
          ProcessListPage.id: (context) => ProcessListPage(),
          DisplayPage.id: (context) => DisplayPage(),
          DisplayFCFS.id: (context) => DisplayFCFS(),
          TimerPage.id: (context) => TimerPage(),
          AltHomePage.id: (context) => AltHomePage()
        },
      ),
    );
  }
}
