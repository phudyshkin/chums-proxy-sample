import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'browser_controller.dart';

@immutable
class BrowserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BrowserAppBar({super.key});

  @override
  State<BrowserAppBar> createState() => _BrowserAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}

class _BrowserAppBarState extends State<BrowserAppBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final BrowserController _browserController;

  @override
  void initState() {
    super.initState();
    _browserController = context.read<BrowserController>();
    _browserController.browserUrl.addListener(_browserUrlListener);
    _focusNode.addListener(_focusNodeListener);
  }

  _browserUrlListener() {
    _controller.text = _browserController.browserUrl.value ?? '';
  }

  _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      _controller.text =
          _browserController.url.value ??
          _browserController.browserUrl.value ??
          '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_focusNodeListener);
    _focusNode.dispose();
    _browserController.browserUrl.removeListener(_browserUrlListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppBar(
    toolbarHeight: 72,
    actionsPadding: EdgeInsets.only(right: 8),
    leading: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: IconButton(
        // padding: EdgeInsets.zero,
        onPressed: () => _browserController.goHome(),
        icon: Icon(Icons.home),
      ),
    ),
    leadingWidth: 56,
    title: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: (text) => _browserController.load(text),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter address',
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            onPressed: () {
              _controller.text = '';
              _focusNode.requestFocus();
            },
            icon: Icon(Icons.clear, size: 20),
          ),
        ),
      ),
    ),
    titleSpacing: 0,
    actions: [
      IconButton(
        onPressed: () => _browserController.refresh(),
        icon: Icon(Icons.refresh),
      ),
    ],
  );
}
