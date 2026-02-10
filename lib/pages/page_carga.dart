import 'dart:async';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _images = [
    'assets/imagenes/logo_equipo.png',
    'assets/imagenes/logo_secundaria.png',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EED2),
      body: Center(
        child: AnimatedSwitcher(
  duration: const Duration(milliseconds: 500),
  switchInCurve: Curves.easeIn,
  switchOutCurve: Curves.easeOut,
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  child: SizedBox(
    key: ValueKey(_currentIndex),
    width: 220,
    height: 220,
    child: Image.asset(
      _images[_currentIndex],
      fit: BoxFit.contain,
    ),
  ),
),

      ),
    );
  }
}
