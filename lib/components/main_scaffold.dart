import 'package:client/values/main_gradient_bg.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? child;
  final double? mainContainerWidh;
  const MainScaffold(
      {super.key, this.appBar, this.child, this.mainContainerWidh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        width: mainContainerWidh,
        decoration: mainContainerDecoration,
        child: child,
      ),
    );
  }
}
