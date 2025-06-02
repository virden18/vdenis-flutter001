import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/constants/constantes.dart';

class LastUpdatedHeader extends StatelessWidget {
  final DateTime? lastUpdated;
  
  const LastUpdatedHeader({
    super.key,
    this.lastUpdated,
  });
  
  @override
  Widget build(BuildContext context) {
    if (lastUpdated == null) return const SizedBox.shrink();
    
    final String formattedDate = DateFormat(AppConstantes.formatoFecha).format(lastUpdated!);
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'Última actualización: $formattedDate',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}