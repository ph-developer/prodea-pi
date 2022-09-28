import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';

import '../../themes/main_theme.dart';

class BootWidget extends StatelessWidget {
  const BootWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRODEA',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      builder: Asuka.builder,
      routes: {
        '/login': (_) => _buildLoader(),
        '/register': (_) => _buildLoader(),
        '/forgot': (_) => _buildLoader(),
        '/main': (_) => _buildLoader(),
        '/admin': (_) => _buildLoader(),
        '/profile': (_) => _buildLoader(),
      },
      home: _buildLoader(),
    );
  }

  Scaffold _buildLoader() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
