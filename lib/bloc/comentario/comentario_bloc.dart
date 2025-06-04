import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/bloc/comentario/comentario_state.dart';
import 'package:vdenis/data/comentario_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository _comentarioRepository = di<ComentarioRepository>();
  final _noticiaRepository = di<NoticiaRepository>();

  ComentarioBloc() : super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<BuscarComentarios>(_onBuscarComentarios);
    on<OrdenarComentarios>(_onOrdenarComentarios);
    on<AddReaccion>(_onAddReaccion);
    on<AddSubcomentario>(_onAddSubcomentario);
    on<ActualizarContadorComentarios>(_onActualizarContadorComentarios);
  }

  Future<void> _onLoadComentarios(
    LoadComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);
      emit(
        ComentarioLoaded(comentarios: comentarios, noticiaId: event.noticiaId),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onAddComentario(
    AddComentario event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    try {
      final comentario = await _comentarioRepository.agregarComentario(
        event.comentario,
      );
      final comentariosActualizadas = [...comentariosActuales, comentario];
      emit(
        ComentarioLoaded(
          comentarios: comentariosActualizadas,
          noticiaId: event.noticiaId,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onBuscarComentarios(
    BuscarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    final comentariosFiltrados =
        comentariosActuales.where((comentario) {
          return comentario.texto.toLowerCase().contains(
                event.terminoBusqueda.toLowerCase(),
              ) ||
              comentario.autor.toLowerCase().contains(
                event.terminoBusqueda.toLowerCase(),
              ) ||
              comentario.fecha.toLowerCase().contains(
                event.terminoBusqueda.toLowerCase(),
              );
        }).toList();

    emit(
      ComentariosFiltrados(
        comentarios: comentariosFiltrados,
        noticiaId: event.noticiaId,
        terminoBusqueda: event.terminoBusqueda,
      ),
    );
  }

  Future<void> _onOrdenarComentarios(
    OrdenarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    if (state is ComentarioLoaded) {
      final currentState = state as ComentarioLoaded;
      final List<Comentario> comentarios = List<Comentario>.from(
        currentState.comentarios,
      );

      comentarios.sort((a, b) {
        return event.ascendente
            ? a.fecha.compareTo(b.fecha) 
            : b.fecha.compareTo(a.fecha); 
      });

      emit(
        ComentariosOrdenados(
          comentarios: comentarios,
          noticiaId: currentState.noticiaId,
          criterioOrden: event.ascendente ? 'fecha:asc' : 'fecha:desc',
        ),
      );
    } else {
      emit(
        ComentarioError(
          ApiException(
            'No hay comentarios cargados para ordenar',
            statusCode: 404,
          ),
        ),
      );
    }
  }

  Future<void> _onAddReaccion(
    AddReaccion event,
    Emitter<ComentarioState> emit,
  ) async {
    final currentState = state;
    emit(ReaccionLoading());
    try {
      final comentarioResponse = await _comentarioRepository
          .reaccionarComentario(event.comentarioId, event.tipoReaccion);
      if (currentState is ComentarioLoaded) {
        final comentarios = List<Comentario>.from(currentState.comentarios);
        final comentarioIndex = comentarios.indexWhere(
          (c) => c.id == event.comentarioId,
        );

        if (comentarioIndex != -1) {
          comentarios[comentarioIndex] = comentarioResponse;
          emit(
            ComentarioLoaded(
              comentarios: comentarios,
              noticiaId: currentState.noticiaId,
            ),
          );
        } else {
          final comentariosActualizados =
              comentarios.map((comentario) {
                final subcomentarios = comentario.subcomentarios ?? [];
                final subIndex = subcomentarios.indexWhere(
                  (sc) => sc.id == event.comentarioId,
                );
                if (subIndex != -1) {
                  subcomentarios[subIndex] = comentarioResponse;
                  return subcomentarios[subIndex];
                }
                return comentario;
              }).toList();
          emit(
            ComentarioLoaded(
              comentarios: comentariosActualizados,
              noticiaId: currentState.noticiaId,
            ),
          );
        }
      }
    } catch (e) {
      emit(ComentarioError(e is ApiException ? e : ApiException(e.toString())));
    }
  }

  Future<void> _onAddSubcomentario(
    AddSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    try {
      final subComentario = await _comentarioRepository.agregarSubcomentario(
        event.subcomentario,
      );

      final comentarioPadreIndex = comentariosActuales.indexWhere(
        (c) => c.id == event.subcomentario.idSubComentario,
      );

      comentariosActuales[comentarioPadreIndex] =
          comentariosActuales[comentarioPadreIndex].copyWith(
            subcomentarios: [
              ...?comentariosActuales[comentarioPadreIndex].subcomentarios,
              subComentario,
            ],
          );

      add(LoadComentarios(event.subcomentario.noticiaId));
      emit(
        ComentarioLoaded(
          comentarios: comentariosActuales,
          noticiaId: event.subcomentario.noticiaId,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onActualizarContadorComentarios(
    ActualizarContadorComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      await _noticiaRepository.incrementarContadorComentarios(
        event.noticiaId,
        event.cantidad,
      );
      emit(
        ContadorComentariosActualizado(
          noticiaId: event.noticiaId,
          contadorComentarios: event.cantidad,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }
}