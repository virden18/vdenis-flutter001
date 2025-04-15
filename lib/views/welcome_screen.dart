import 'package:flutter/material.dart';
import 'package:vdenis/components/app_drawer.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldTitle('Bienvenido'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgetsHelper.buildTitle('¡Bienvenido, $username!'),
          ],
        ),
      ),
    );
  }
}
