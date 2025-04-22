import 'package:flutter/material.dart';
import 'package:chums_proxy/chums_proxy_lifecycle.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ChumsProxyLifecycle().start();
  runApp(const ProxyApp());
}

