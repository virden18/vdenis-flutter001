import 'package:flutter/material.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/constants/constantes.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 8, 
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgetsHelper.buildBoldTitle(tarea.titulo),
                CommonWidgetsHelper.buildSpacing(),
                CommonWidgetsHelper.buildInfoLines(tarea.descripcion ?? ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    CommonWidgetsHelper.buildBoldFooter('${TareasConstantes.fechaLimite} $fechaLimiteDato'),
                    ElevatedButton.icon(
                      onPressed: onBackPressed,
                      icon: Icon(Icons.arrow_back, 
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                      label: Text(
                        'Volver',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}