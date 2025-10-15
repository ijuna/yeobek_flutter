/* tattoo_frontend/apps/app_web/lib/main.dart */
import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:language/language.dart';

void main() => runApp(const AppRoot());

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tattoo Frontend',
      theme: AppTheme.light(),
      localizationsDelegates: AppLang.localizationsDelegates,
      supportedLocales: AppLang.supportedLocales,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLang.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.hello)),
      body: Center(child: PrimaryButton(label: t.hello, onPressed: () {})),
    );
  }
}