import 'package:flutter/material.dart';

class PreloaderWidget extends StatelessWidget {
  const PreloaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(color: Colors.greenAccent));
  }
}
