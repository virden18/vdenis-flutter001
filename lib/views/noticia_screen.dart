import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/categoria/categoria_bloc.dart';
import 'package:vdenis/bloc/categoria/categoria_event.dart';
import 'package:vdenis/bloc/categoria/categoria_state.dart';
import 'package:vdenis/bloc/noticia/noticia_bloc.dart';
import 'package:vdenis/bloc/noticia/noticia_event.dart';
import 'package:vdenis/bloc/noticia/noticia_state.dart';
import 'package:vdenis/bloc/preferencia/preferencia_bloc.dart';
import 'package:vdenis/bloc/preferencia/preferencia_event.dart';
import 'package:vdenis/components/floating_add_button.dart';
import 'package:vdenis/components/formulario_noticia.dart';
import 'package:vdenis/components/last_updated_header.dart';
import 'package:vdenis/components/noticia_card.dart';
import 'package:vdenis/components/reporte_dialog.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/categoria_helper.dart';
import 'package:vdenis/helpers/dialog_helper.dart';
import 'package:vdenis/helpers/modal_helper.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';
import 'package:vdenis/helpers/snackbar_manager.dart';
import 'package:vdenis/views/categoria_screen.dart';
import 'package:vdenis/views/preferencia_screen.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    final preferenciasBloc = BlocProvider.of<PreferenciaBloc>(context, listen: false);
    preferenciasBloc.add(LoadPreferences());

    final noticiasBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);
    noticiasBloc.add(FetchNoticiasEvent());
      
    return BlocProvider<CategoriaBloc>(
      create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
      child: _NoticiaScreenContent(),
    );
  }
}

class _NoticiaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoticiaBloc, NoticiaState>(
      listener: (context, state) {
        switch (state) {
          case NoticiaError():
            SnackBarHelper.manejarError(
              context,
              state.error,
            );
          case NoticiaCreated():
            SnackBarHelper.mostrarExito(
              context,
              mensaje: NoticiasConstantes.successCreated,
            );
          case NoticiaUpdated():
            SnackBarHelper.mostrarExito(
              context,
              mensaje: NoticiasConstantes.successUpdated,
            );
          case NoticiaDeleted():
            SnackBarHelper.mostrarExito(
              context,
              mensaje: NoticiasConstantes.successDeleted,
            );
          case NoticiaFiltered():
            SnackBarHelper.mostrarExito(
              context,
              mensaje: "Noticias filtradas correctamente",
            );
          case NoticiaLoaded():
            if (state.noticias.isEmpty) {
              SnackBarHelper.mostrarInfo(
                context,
                mensaje: NoticiasConstantes.listaVacia,
              );
            } else{
              SnackBarHelper.mostrarExito(
                context,
                mensaje: 'Noticias cargadas correctamente',
              );
            }
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is NoticiaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Volver',
            ),
            title: const Text(NoticiasConstantes.tituloApp),
            centerTitle: true,
            actions: [              
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrar por categorías',
                onPressed: () async {
                  final noticiaBloc = context.read<NoticiaBloc>();
                  await Navigator.push(
                    context,                    
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: noticiaBloc,
                        child: const PreferenciaScreen(),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.category),
                tooltip: 'Categorías',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoNoticias(context, state)),
            ],
          ),
          floatingActionButton: BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, categoriaState) {
              return FloatingAddButton(
                onPressed: () async {
                  if (categoriaState is! CategoriaLoaded) {
                    context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cargando categorías...')),
                    );
                    return;
                  }

                  final List<Categoria> categorias = categoriaState.categorias;

                  final noticia = await ModalHelper.mostrarDialogo<Noticia>(
                    context: context,
                    title: 'Agregar Noticia',
                    child: FormularioNoticia(categorias: categorias),
                  );
                  if (noticia != null && context.mounted) {
                    context.read<NoticiaBloc>().add(
                      AddNoticiaEvent(noticia),
                    );
                  }
                },
                tooltip: 'Agregar Noticia',
              );
            },              
          ),
        );        
      }
    );
  }

  Widget _construirCuerpoNoticias(
    BuildContext context,
    NoticiaState state,
  ) {
    if (state is NoticiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiaError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<NoticiaBloc>().add(FetchNoticiasEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (state is NoticiaLoaded) {
      final categoriaState = context.watch<CategoriaBloc>().state;
      List<Categoria> categorias = [];
      
      if (categoriaState is CategoriaLoaded) {
        categorias = categoriaState.categorias;
      }
      if (state.noticias.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            if (context.mounted) {
              context.read<NoticiaBloc>().add(FetchNoticiasEvent());
            }
          },
          child: ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(),
            itemCount: state.noticias.length,
            itemBuilder: (context, index) {
              final noticia= state.noticias[index];
              return Dismissible(
                key: Key(noticia.id ?? UniqueKey().toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await DialogHelper.mostrarConfirmacion(
                    context: context,
                    titulo: 'Confirmar eliminación',
                    mensaje: '¿Estás seguro de que deseas eliminar esta noticia?',
                    textoCancelar: 'Cancelar',
                    textoConfirmar: 'Eliminar',
                  );
                },
                onDismissed: (direction) {
                  context.read<NoticiaBloc>().add(DeleteNoticiaEvent(noticia.id!));
                },                child: NoticiaCard(
                  noticia: noticia,
                  onReport: () {
                    ReporteDialog.mostrarDialogoReporte(
                      context: context, 
                      noticia: noticia,
                    );
                  },
                  onEdit: () async {
                  if (categorias.isEmpty) {
                    SnackBarHelper.mostrarInfo(
                      context, 
                      mensaje: 'Cargando categorías...'
                    );
                    context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    return;
                  }
                  
                  final noticiaEditada = await ModalHelper.mostrarDialogo<Noticia>(
                    context: context,
                    title: 'Editar Noticia',
                    child: FormularioNoticia(
                      noticia: noticia,
                      categorias: categorias,
                    ),
                  );
                  
                  if (noticiaEditada != null && context.mounted) {
                    final noticiaActualizada = noticiaEditada.copyWith(id: noticia.id);
                    context.read<NoticiaBloc>().add(
                      UpdateNoticiaEvent(noticiaActualizada),
                    );
                  }
                },
                  categoriaNombre: CategoriaHelper.obtenerNombreCategoria(
                    noticia.categoriaId?? '',
                    categorias,
                  ),
                ),
              );   
            } 
          ),       
        );
      } else {
          return RefreshIndicator(
            onRefresh: () async {
              if (context.mounted) {
                context.read<NoticiaBloc>().add(FetchNoticiasEvent());
              }            
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(child: Text(NoticiasConstantes.listaVacia)),
                ),
              ],
            ),
          );
        }
    } else {
      return Container();
    }
  }
}

