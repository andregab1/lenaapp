import 'package:flutter/material.dart';
import 'controllers/player_controller.dart';
import 'screens/home_screen.dart';
import 'screens/now_playing_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/mini_player.dart';

void main() {
  runApp(const NosELenaApp());
}

class NosELenaApp extends StatelessWidget {
  const NosELenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nós',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const RootShell(),
    );
  }
}

/// Just Home + a persistent mini player at the bottom — no bottom nav
/// tabs, since Buscar/Biblioteca had nothing behind them.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final PlayerController _controller = PlayerController();
  final GlobalKey<NavigatorState> _homeNavKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Navigator(
        key: _homeNavKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => HomeScreen(controller: _controller),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => MiniPlayer(
            controller: _controller,
            onTap: () => openNowPlaying(context, _controller),
          ),
        ),
      ),
    );
  }
}
