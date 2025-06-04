import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';
import 'package:vdenis/bloc/noticia/noticia_event.dart';
import 'package:vdenis/bloc/noticia/noticia_state.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository _noticiaRepository = di<NoticiaRepository>();
  NoticiaBloc() : super(NoticiaInitial()) {
    on<FetchNoticiasEvent>(_onFetchNoticias);
    on<AddNoticiaEvent>(_onAddNoticia);
    on<UpdateNoticiaEvent>(_onUpdateNoticia);
    on<DeleteNoticiaEvent>(_onDeleteNoticia);
    on<FilterNoticiasByPreferenciasEvent>(_onFilterNoticiasByPreferencias);
    on<ResetNoticiaEvent>(_onResetNoticias);
    on<ActualizarContadorReportesEvent>(_onActualizarContadorReportes);
    on<ActualizarContadorComentariosEvent>(_onActualizarContadorComentarios);
  }

  Future<void> _onFetchNoticias(
    FetchNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    emit(NoticiaLoading());
    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      final preferenciaRepo = di<PreferenciaRepository>();
      List<String> categoriasIds =
          await preferenciaRepo.obtenerCategoriasSeleccionadas();

      List<Noticia> noticiasFiltradas = _filtrarNoticiasPorCategorias(
        noticias,
        categoriasIds,
      );
      emit(NoticiaLoaded(noticiasFiltradas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.cargar));
      }
    }
  }

  Future<void> _onAddNoticia(
    AddNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      final noticiaCreada = await _noticiaRepository.crearNoticia(
        event.noticia,
      );
      final noticiasActualizadas = [...noticiasActuales, noticiaCreada];
      emit(NoticiaCreated(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.crear));
      }
    }
  }

  Future<void> _onUpdateNoticia(
    UpdateNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      final noticiaActualizada = await _noticiaRepository.editarNoticia(
        event.noticia,
      );

      final noticiasActualizadas =
          noticiasActuales.map((noticia) {
            if (noticia.id == noticiaActualizada.id) {
              return noticiaActualizada;
            }

            return noticia;
          }).toList();

      emit(NoticiaUpdated(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
      }
    }
  }

  Future<void> _onDeleteNoticia(
    DeleteNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }
    emit(NoticiaLoading());

    try {
      await _noticiaRepository.eliminarNoticia(event.id);

      final noticiasActualizadas =
          noticiasActuales.where((noticia) => noticia.id != event.id).toList();

      emit(NoticiaDeleted(noticiasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError(e, TipoOperacionNoticia.eliminar));
      }
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferenciasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      try {
        noticiasActuales = await _noticiaRepository.obtenerNoticias();
        List<Noticia> noticiasFiltradas = _filtrarNoticiasPorCategorias(
          noticiasActuales,
          event.categoriasIds,
        );
        emit(
          NoticiaFiltered(
            noticiasFiltradas,
            DateTime.now(),
            event.categoriasIds,
          ),
        );
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.cargar));
        }
      }
    }
  }

  Future<void> _onResetNoticias(
    ResetNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    emit(NoticiaInitial());
  }

  Future<void> _onActualizarContadorReportes(
    ActualizarContadorReportesEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }

    final index = noticiasActuales.indexWhere(
      (noticia) => noticia.id == event.noticiaId,
    );

    if (index >= 0) {
      try {
        await _noticiaRepository.incrementarContadorReportes(
          event.noticiaId,
          event.nuevoContador,
        );

        final noticiaActualizada = noticiasActuales[index].copyWith(
          contadorReportes: event.nuevoContador,
        );

        noticiasActuales[index] = noticiaActualizada;

        emit(NoticiaLoaded(noticiasActuales, DateTime.now()));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
        }
      }
    }
  }

  Future<void> _onActualizarContadorComentarios(
    ActualizarContadorComentariosEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    List<Noticia> noticiasActuales = [];
    if (state is NoticiaLoaded) {
      noticiasActuales = [...(state as NoticiaLoaded).noticias];
    }

    final index = noticiasActuales.indexWhere(
      (noticia) => noticia.id == event.noticiaId,
    );

    if (index >= 0) {
      try {
        await _noticiaRepository.incrementarContadorComentarios(
          event.noticiaId,
          event.nuevoContador,
        );

        final noticiaActualizada = noticiasActuales[index].copyWith(
          contadorComentarios: event.nuevoContador,
        );

        noticiasActuales[index] = noticiaActualizada;

        emit(NoticiaLoaded(noticiasActuales, DateTime.now()));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError(e, TipoOperacionNoticia.actualizar));
        }
      }
    }
  }

  List<Noticia> _filtrarNoticiasPorCategorias(
    List<Noticia> noticias,
    List<String> categoriasIds,
  ) {
    List<Noticia> noticiasRetornadas;
    if (categoriasIds.isEmpty) {
      noticiasRetornadas = noticias;
    } else {
      noticiasRetornadas =
          noticias
              .where(
                (noticia) =>
                    noticia.categoriaId != null &&
                    noticia.categoriaId!.isNotEmpty &&
                    categoriasIds.contains(noticia.categoriaId),
              )
              .toList();
    }
    return noticiasRetornadas;
  }
}
