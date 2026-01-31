import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      elevation: 0,
      expandedHeight: 112,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
