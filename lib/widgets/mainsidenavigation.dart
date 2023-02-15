import 'package:flutter/material.dart';
import 'package:maccave_menager/widgets/mainappbar.dart';
import 'package:maccave_menager/widgets/maindrawer.dart';

class MainSideNavigation extends StatefulWidget {
  const MainSideNavigation({super.key, required this.child});
  final Widget child;
  @override
  State<MainSideNavigation> createState() => _MainSideNavigationState();
}

class _MainSideNavigationState extends State<MainSideNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: widget.child,
      ),
    );
  }
}
