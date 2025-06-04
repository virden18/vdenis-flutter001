import 'package:flutter/material.dart';

class LimiteReportesDialog extends StatelessWidget {
  const LimiteReportesDialog({super.key});

  static Future<void> mostrar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LimiteReportesDialog(),
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 70.0,
        vertical: 24.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [            
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Noticia ya reportada',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Esta noticia ya ha sido reportada por varios usuarios y está siendo revisada.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),              
              child: Text(
                'Entendido',
                style: theme.textTheme.labelLarge
              ),
            ),
          ],
        ),
      ),
    );
  }
}