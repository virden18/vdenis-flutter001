import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final Color? backgroundColor;
  final IconData icon;
  final FloatingActionButtonLocation? location;

  const FloatingAddButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Agregar',
    this.backgroundColor,
    this.icon = Icons.add,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      child: Icon(icon),
    );
  }
}
