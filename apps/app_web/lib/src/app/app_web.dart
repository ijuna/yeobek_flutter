/* tattoo_frontend/apps/app_web/lib/src/app/app_web.dart */
import 'package:flutter/material.dart';
import '../routing/app_router.dart';

class AppWeb extends StatelessWidget {
  const AppWeb({super.key});
  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      title: 'Tattoo Frontend',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
