import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;

  const NeuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Provider.of<PlaylistProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          // Darker shadow on bottom right
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
          // Lighter shadow on top left
          BoxShadow(
            color: Colors.grey.shade800,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          ),
        ],
        borderRadius:
            BorderRadius.circular(12), // Optional: Adjust corner radius
      ),
      child: child,
    );
  }
}
