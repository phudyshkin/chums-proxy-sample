import 'package:flutter/material.dart';
import 'browser/browser.dart';

class ProxyApp extends StatelessWidget {
  const ProxyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Chums proxy example app',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const Browser(),
  );
}
