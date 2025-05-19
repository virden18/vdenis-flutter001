import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_event.dart';
import 'package:vdenis/bloc/noticias/noticia_state.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaBloc extends Bloc<NoticiasEvent, NoticiasState> {
  final NoticiaRepository _noticiaRepository = di<NoticiaRepository>();
  
  // Variable para saber si hay filtros aplicados
  bool _filtrosAplicados = false;
  bool get filtrosAplicados => _filtrosAplicados;
  
  NoticiaBloc(): super(NoticiasInitial()) {
    on<NoticiasLoadEvent>(_onLoadNoticias);
    on<NoticiasCreateEvent>(_onCreateNoticia);
    on<NoticiasUpdateEvent>(_onUpdateNoticia);
    on<NoticiasDeleteEvent>(_onDeleteNoticia);
    on<FilterNoticiasByPreferencias>(_onFilterNoticiasByPreferencias);
    on<ClearNoticiasFilters>(_onClearFilters);
  }
  Future<void> _onLoadNoticias(NoticiasLoadEvent event, Emitter<NoticiasState> emit) async {
     try {
      final noticias = await _noticiaRepository.getNoticias();
      // Restablecer la bandera, ya que estamos cargando todas las noticias sin filtros
      _filtrosAplicados = false;
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      debugPrint('parada1${e.toString()}');
      emit(NoticiasError('Error al cargar noticias: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onCreateNoticia(
    NoticiasCreateEvent event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final noticiaData = {
        'titulo': event.titulo,
        'descripcion': event.descripcion,
        'fuente': event.fuente,
        'publicadaEl': event.publicadaEl.toIso8601String(),
        'urlImagen': event.urlImagen,
        'categoriaId': event.categoriaId,
      };

      await _noticiaRepository.crearNoticia(noticiaData);

      // Refrescar la lista de noticias después de agregar
      final noticias = await _noticiaRepository.getNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(NoticiasError('Error al agregar noticia: ${e.toString()}',statusCode: statusCode));
    }
  }

  Future<void> _onUpdateNoticia(
    NoticiasUpdateEvent event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final data = {
        'id': event.id,
        'titulo': event.titulo,
        'descripcion': event.descripcion,
        'fuente': event.fuente,
        'publicadaEl': event.publicadaEl.toIso8601String(),
        'urlImagen': event.urlImagen,
        'categoriaId': event.categoriaId,
      };
      await _noticiaRepository.actualizarNoticia(event.id, data);

      // Refrescar la lista de noticias después de actualizar
      final noticias = await _noticiaRepository.getNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(NoticiasError('Error al actualizar noticia: ${e.toString()}',statusCode: statusCode));
    }
  }

  Future<void> _onDeleteNoticia(
    NoticiasDeleteEvent event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      await _noticiaRepository.eliminarNoticia(event.id);

      // Refrescar la lista de noticias después de eliminar
      final noticias = await _noticiaRepository.getNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(NoticiasError('Error al eliminar noticia: ${e.toString()}',statusCode: statusCode));
    }
  }

    Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferencias event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final allNoticias = await _noticiaRepository.getNoticias();

      final filteredNoticias =
          allNoticias
              .where(
                (noticia) => event.categoriasIds.contains(noticia.categoriaId),
              )
              .toList();

      // Marcar que hay filtros aplicados
      _filtrosAplicados = true;
      emit(NoticiasLoaded(filteredNoticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(NoticiasError('Error al filtrar noticias: ${e.toString()}',statusCode: statusCode));
    }
  }
  
  Future<void> _onClearFilters(
    ClearNoticiasFilters event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final noticias = await _noticiaRepository.getNoticias();
      
      // Marcar que no hay filtros aplicados
      _filtrosAplicados = false;
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(NoticiasError('Error al cargar noticias: ${e.toString()}', statusCode: statusCode));
    }
  }
}

