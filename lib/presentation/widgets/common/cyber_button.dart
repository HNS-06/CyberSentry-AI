import 'package:flutter/material.dart';

class CyberButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const CyberButton({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
