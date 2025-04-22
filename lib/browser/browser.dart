import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'browser_app_bar.dart';
import 'browser_body.dart';
import 'browser_controller.dart';

@immutable
class Browser extends StatelessWidget {
  const Browser({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Provider(
    create: (context) => BrowserController(),
    child: Scaffold(
      appBar: const BrowserAppBar(),
      body: const BrowserBody(),
    ),
  );
}
