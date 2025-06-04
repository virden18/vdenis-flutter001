class AssistantRepository {
  Future<List<String>> generarPasos(String tituloTarea, DateTime? fechaLimite) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final String fechaFormateada = fechaLimite != null
        ? '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}'
        : 'sin fecha límite';

    return [
      'Paso 1: Planificar $tituloTarea antes del $fechaFormateada',
      'Paso 2: Ejecutar $tituloTarea antes del $fechaFormateada',
      'Paso 3: Revisar $tituloTarea antes del $fechaFormateada',
    ];
  }
}