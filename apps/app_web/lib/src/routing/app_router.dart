/* tattoo_frontend/apps/app_web/lib/src/routing/app_router.dart */
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/pages/home/home_page.dart';

GoRouter createRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
