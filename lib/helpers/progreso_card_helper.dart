import 'package:flutter/material.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_state.dart';

class ProgresoCardHelper extends StatelessWidget {
  final TareaContadorState contadorState;

  const ProgresoCardHelper({
    super.key,
    required this.contadorState,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular porcentaje con protección contra división por cero
    final double porcentajeCompletado = contadorState.totalTareas > 0
        ? contadorState.tareasCompletadas / contadorState.totalTareas
        : 0.0;
    
    // Asegurar que el porcentaje no exceda el 100%
    final double porcentajeNormalizado = porcentajeCompletado > 1.0 ? 1.0 : porcentajeCompletado;
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progreso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(porcentajeNormalizado * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: porcentajeNormalizado >= 0.7
                        ? Colors.green
                        : (porcentajeNormalizado >= 0.4 ? Colors.orange : Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: porcentajeNormalizado, // Usar el valor normalizado
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  porcentajeNormalizado >= 0.7
                      ? Colors.green
                      : (porcentajeNormalizado >= 0.4 ? Colors.orange : Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}