import 'package:vdenis/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/reporte/reporte_event.dart';
import 'package:vdenis/bloc/reporte/reporte_state.dart';
import 'package:vdenis/data/reporte_repository.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository reporteRepository = di<ReporteRepository>();

  ReporteBloc() : super(ReporteInitial()) {
    on<ReporteInitEvent>(_onInit);
    on<ReporteCreateEvent>(_onCreateReporte);
    on<ReporteDeleteEvent>(_onDeleteReporte);
    on<ReporteGetByNoticiaEvent>(_onGetByNoticia);
  }

  Future<void> _onInit(
    ReporteInitEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al cargar reportes: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onCreateReporte(
    ReporteCreateEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
      try {
    final reporte = await reporteRepository.crearReporte(
      noticiaId: event.noticiaId,
      motivo: event.motivo,
    );
    
    // 1. Emitir estado de creación exitosa primero
    emit(ReporteCreated(reporte!));
    
    // 2. Mostrar feedback y luego actualizar datos
    await Future.delayed(const Duration(milliseconds: 100)); // Breve pausa
    final reportesActualizados = await reporteRepository.obtenerReportes();
    
    // 3. Emitir nuevo estado combinado
    emit(ReporteLoadedWithMessage(
      reportes: reportesActualizados,
      message: 'Reporte creado exitosamente',
    ));
    
  } catch (e) {
      // Manejar error
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al crear reporte: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

 

  Future<void> _onDeleteReporte(
    ReporteDeleteEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      await reporteRepository.eliminarReporte(event.id);
      emit(ReporteDeleted(event.id));

      // Recargar la lista después de eliminar
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al eliminar reporte: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }

  Future<void> _onGetByNoticia(
    ReporteGetByNoticiaEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportesPorNoticia(
        event.noticiaId,
      );
      emit(ReportesPorNoticiaLoaded(reportes, event.noticiaId));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ReporteError(
          'Error al obtener reportes por noticia: ${e.toString()}',
          statusCode: statusCode,
        ),
      );
    }
  }
}