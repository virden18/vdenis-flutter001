import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String tipoTarea = 'Tipo: ';
  static const String taskTypeNormal = 'normal';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  static const String tareaEliminada = 'Tarea eliminada';
  static const int limitePasos = 2;
  static const int limiteTareas = 10;

  //static constantes Juego de Preguntas
  static const String titleAppQuestions = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScoreQuestions = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de nuevo';
  static const String results = 'Resultados';

  //static constantes Quotes
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 12;
  static const String nombreEmpresa = 'Empresa: ';
  static const String dateFormat = 'dd/MM/yyyy HH:mm';

  // constantes Noticias
  static String get newsUrl => dotenv.env['API_URL'] ?? 'https://crudcrud.com/api/7fa1230a97f842fda251c0aa0980d2f2/noticias';
  static const String tituloAppNoticias = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVaciaNoticias = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPaginaConst = 10;
  static const double espaciadoAlto = 10;
  static const String urlImagen = 'https://picsum.photos/200/300';
}
