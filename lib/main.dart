import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave_menager/firebase_options.dart';
import 'package:maccave_menager/src/drinkscreen/drinkwrite.dart';
import 'package:maccave_menager/src/drinksettingpage.dart';
import 'package:maccave_menager/src/entryscreen/entryread.dart';
import 'package:maccave_menager/src/entryscreen/entrywrite.dart';
import 'package:maccave_menager/src/entrysettingpage.dart';
import 'package:maccave_menager/src/marketscreen/marketwrite.dart';
import 'package:maccave_menager/src/marketsettingpage.dart';
import 'package:maccave_menager/widgets/mainsidenavigation.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MacCaveManiger());
}

enum ScreenTransitionType { fade, slide, none }

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _defaultRouter = GoRouter(
    initialLocation: '/entry',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          print(state.path);
          return MainSideNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/entry',
            pageBuilder: (context, state) {
              return MacCaveCustomTransitionPage(
                  mainChild: const EntrySettingPage(),
                  type: ScreenTransitionType.fade);
            },
            routes: [
              GoRoute(
                path: 'write',
                pageBuilder: (context, state) {
                  return MacCaveCustomTransitionPage(
                      mainChild: const EntryWritePage(),
                      type: ScreenTransitionType.slide);
                },
              ),
              GoRoute(
                name: 'entryread',
                path: 'read/:id',
                pageBuilder: (context, state) {
                  return MacCaveCustomTransitionPage(
                      mainChild: EntryReadPage(
                        entryid: state.params['id']!,
                      ),
                      type: ScreenTransitionType.slide);
                },
              ),
            ],
          ),
          GoRoute(
              path: '/drink',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                    mainChild: const DrinkSettingPage(),
                    type: ScreenTransitionType.fade);
              },
              routes: [
                GoRoute(
                  path: 'write',
                  pageBuilder: (context, state) {
                    return MacCaveCustomTransitionPage(
                        mainChild: const DrinkWritePage(),
                        type: ScreenTransitionType.slide);
                  },
                )
              ]),
          GoRoute(
              path: '/market',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                    mainChild: const MarketSettingPage(),
                    type: ScreenTransitionType.fade);
              },
              routes: [
                GoRoute(
                  path: 'write',
                  pageBuilder: (context, state) {
                    return MacCaveCustomTransitionPage(
                      mainChild: const MarketWritePage(),
                      type: ScreenTransitionType.slide,
                    );
                  },
                )
              ]),
        ],
      )
    ]);

class MacCaveManiger extends StatelessWidget {
  const MacCaveManiger({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      routerConfig: _defaultRouter,
    );
  }
}

class MacCaveCustomTransitionPage extends CustomTransitionPage {
  MacCaveCustomTransitionPage(
      {super.key, required this.mainChild, required this.type})
      : super(
            child: mainChild,
            transitionsBuilder: (context, animation, secondaryAnimation,
                    child) =>
                type == ScreenTransitionType.fade
                    ? CustomFadeTransition(animation: animation, child: child)
                    : type == ScreenTransitionType.slide
                        ? CustomSlideTransition(
                            animation: animation, child: child)
                        : CustomNoTransition(
                            animation: animation, child: child));
  final Widget mainChild;
  final ScreenTransitionType type;
}

class CustomFadeTransition extends FadeTransition {
  const CustomFadeTransition({
    super.key,
    required this.animation,
    required this.child,
  }) : super(
          opacity: animation,
          child: child,
        );
  final Animation<double> animation;
  final Widget child;
}

class CustomSlideTransition extends SlideTransition {
  CustomSlideTransition(
      {super.key, required this.animation, required this.child})
      : super(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child);
  final Animation<double> animation;
  final Widget child;
}

class CustomNoTransition extends SlideTransition {
  CustomNoTransition({super.key, required this.animation, required this.child})
      : super(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset.zero)
                  .chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child);
  final Animation<double> animation;
  final Widget child;
}
