import 'package:client/components/app_bar.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:flutter/material.dart';

class InvitesView extends StatelessWidget {
  const InvitesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Invites'),
      body: Container(
        decoration: mainContainerDecoration,
        child: Center(
          child: const Text('No invites yet :('),
        ),
      ),
    );
  }
}
