import 'package:flutter/material.dart';

final class LifecycleListener extends StatefulWidget {
  final Widget child;
  final Function(BuildContext, AppLifecycleState) onChanged;

  const LifecycleListener({super.key, required this.child, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _LifecycleListenerState();
}

final class _LifecycleListenerState extends State<LifecycleListener> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.onChanged(context, state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}