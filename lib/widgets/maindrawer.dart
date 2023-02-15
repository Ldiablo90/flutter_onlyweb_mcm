import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'MacCave 매니저 menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('발매정보'),
            onTap: () {
              context.push('/entry');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('위스키 리스트'),
            onTap: () {
              context.push('/drink');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('마켈리스트'),
            onTap: () {
              context.push('/market');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
