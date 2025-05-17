import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_event.dart';
import 'package:vdenis/bloc/noticias/noticia_state.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository _noticiaRepository;
  final CategoriaRepository _categoriaRepository;
  
  NoticiaBloc({
    required NoticiaRepository noticiaRepository,
    required CategoriaRepository categoriaRepository,
  })  : _noticiaRepository = noticiaRepository,
        _categoriaRepository = categoriaRepository,
        super(const NoticiaInitial()) {
    on<LoadNoticias>(_onLoadNoticias);
    on<CreateNoticia>(_onCreateNoticia);
    on<UpdateNoticia>(_onUpdateNoticia);
    on<DeleteNoticia>(_onDeleteNoticia);
  }

  Future<void> _onLoadNoticias(
    LoadNoticias event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(const NoticiaLoading());
      
      final noticias = await _noticiaRepository.loadMoreNoticias();
      
      // Si ya teníamos categorías cargadas, mantenerlas
      Map<String, String> categoriasCache = {};
      if (state is NoticiaLoaded) {
        categoriasCache = (state as NoticiaLoaded).categoriasCache;
      } else {
        // Cargar categorías si no las teníamos
        try {
          final categorias = await _categoriaRepository.getCategorias();
          for (final categoria in categorias) {
            if (categoria.id != null) {
              categoriasCache[categoria.id!] = categoria.nombre;
            }
          }
        } catch (e) {
          debugPrint('Error cargando categorías: $e');
        }
      }
      
      emit(NoticiaLoaded(
        noticias: noticias,
        lastUpdated: DateTime.now(),
        categoriasCache: categoriasCache,
      ));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(
          message: e.message,
          statusCode: e.statusCode ?? 0,
        ));
      } else {
        emit(NoticiaError(
          message: e.toString(),
          statusCode: 0,
        ));
      }
    }
  }

  Future<void> _onCreateNoticia(
    CreateNoticia event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(const NoticiaLoading());
      
      await _noticiaRepository.createNoticia(event.noticia);
      
      add(const LoadNoticias());
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(
          message: e.message,
          statusCode: e.statusCode ?? 0,
        ));
      } else {
        emit(NoticiaError(
          message: e.toString(),
          statusCode: 0,
        ));
      }
    }
  }

  Future<void> _onUpdateNoticia(
    UpdateNoticia event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(const NoticiaLoading());
      
      await _noticiaRepository.updateNoticia(event.id, event.noticia);
      
      add(const LoadNoticias());
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(
          message: e.message,
          statusCode: e.statusCode ?? 0,
        ));
      } else {
        emit(NoticiaError(
          message: e.toString(),
          statusCode: 0,
        ));
      }
    }
  }

  Future<void> _onDeleteNoticia(
    DeleteNoticia event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      emit(const NoticiaLoading());
      
      await _noticiaRepository.deleteNoticia(event.noticia.id);
      
      add(const LoadNoticias());
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(
          message: e.message,
          statusCode: e.statusCode ?? 0,
        ));
      } else {
        emit(NoticiaError(
          message: e.toString(),
          statusCode: 0,
        ));
      }
    }
  }
}

