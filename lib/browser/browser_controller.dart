import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RefreshPage extends Intent {
  const RefreshPage();
}

class RefreshAction extends Action<RefreshPage> {
  @override
  void invoke(covariant RefreshPage intent) {
   notifyActionListeners();
  }
}

class StopLoad extends Intent {
  const StopLoad();
}

class StopAction extends Action<StopLoad> {
  @override
  void invoke(covariant StopLoad intent) {
    notifyActionListeners();
  }
}

class GoHome extends Intent {
  const GoHome();
}

class GoHomeAction extends Action<GoHome> {
  @override
  void invoke(covariant GoHome intent) {
    notifyActionListeners();
  }
}


class BrowserController {

  final _refreshAction = RefreshAction();
  final _stopAction = StopAction();
  final _goHomeAction = GoHomeAction();

  final _url = ValueNotifier<String?>(null);
  final _browserUrl = ValueNotifier<String?>(null);

  Action get refreshPageAction => _refreshAction;
  Action get stopLoadAction => _stopAction;
  Action get goHomeAction => _goHomeAction;

  ValueListenable<String?> get url => _url;
  ValueListenable<String?> get browserUrl => _browserUrl;

  load(final String url) {
    _url.value = url;
  }

  setUrl(final Uri? uri) {
    _browserUrl.value = uri?.toString();
  }

  refresh() {
    _refreshAction.invoke(const RefreshPage());
  }

  stop() {
    _stopAction.invoke(const StopLoad());
  }

  goHome() {
    _goHomeAction.invoke(const GoHome());
  }

}
