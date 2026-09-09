import 'package:flutter/material.dart';

import 'app/navigation/app_router.dart';

void main() {
  runApp(const SuperHumanApp());
}

class SuperHumanApp extends StatelessWidget {
  const SuperHumanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperHuman',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.catalogRoute,
    );
  }
}
