import 'package:vdenis/core/api_config.dart';

// Constantes generales de la aplicación
class AppConstants {
  static final String baseUrl = ApiConfig.beeceptorBaseUrl;
  static const int timeoutSeconds = 10;
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
}

class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String endpointNoticias = '/noticias';
  static const String endpointComentarios = '/comentarios';
  static const String endpointCategorias = '/categorias';
}

// Constantes para la pantalla de Tareas
class TaskConstants {
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
}

// Constantes para el Juego de Preguntas
class QuestionConstants {
  static const String titleAppQuestions = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScoreQuestions = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de nuevo';
  static const String results = 'Resultados';
}

// Constantes para Cotizaciones (Quotes)
class QuoteConstants {
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 12;
  static const String nombreEmpresa = 'Empresa: ';
}

// Constantes para Noticias y Categorías
class NewsConstants {
  static String get newsEndpoint => '/noticias';
  static String get categoriasUrl => '${AppConstants.baseUrl}/categorias';
  static const String tituloAppNoticias = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVaciaNoticias = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const int tamanoPaginaConst = 10;
  static const double espaciadoAlto = 10;
  static const String urlImagen = 'https://picsum.photos/200/300';
  static const String urlCategoria = 'https://picsum.photos/seed/economia/600/400';
  static const String defaultCategoriaId = 'default';
}

// Constantes para mensajes de error
class ErrorConstants {
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'Noticias no encontradas';
  static const String errorServer = 'Error del servidor';
  static const String errorNoCategory = 'Categoría no encontrada';
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String errorNoInternet = 'Sin conexión a Internet';
  static const String errorInvalidData = 'Datos inválidos';
}

// Constantes para mensajes de éxito
class SuccessConstants {
  static const String successCreated = 'Noticia/Categoría creada';
  static const String successUpdated = 'Noticia/Categoría actualizada';
  static const String successDeleted = 'Noticia/Categoría eliminada';
}