import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/categorias_bloc/categorias_bloc.dart';
import 'package:vdenis/bloc/categorias_bloc/categorias_event.dart';
import 'package:vdenis/bloc/categorias_bloc/categorias_state.dart';
import 'package:vdenis/domain/categoria.dart';

class CategoriaCardHelper {
  static Widget construirCuerpoCategorias(
    BuildContext context, 
    CategoriaState state, {
    required Function(BuildContext, {Categoria? categoria}) mostrarDialogCategoria,
    required Function(BuildContext, Categoria) confirmarEliminarCategoria,
  }) {
    if (state is CategoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (state is CategoriaLoaded) {
      return RefreshIndicator(
          onRefresh: () async {
            context.read<CategoriaBloc>().add(CategoriaInitEvent());
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), // Necesario para pull-to-refresh
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: InkWell(
                      onTap: () => mostrarDialogCategoria(context, categoria: categoria),
                      child: ListTile(
                        title: Text(
                          categoria.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (categoria.descripcion.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Text(categoria.descripcion),
                              ),
                            Text(
                              'ID: ${categoria.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: categoria.descripcion.isNotEmpty,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child:
                              categoria.imagenUrl.isNotEmpty
                                  ? Image.network(
                                    categoria.imagenUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.category,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                  : const Icon(
                                    Icons.category,
                                    color: Colors.grey,
                                  ),
                        ),
                        // Modificar el trailing en el ListTile para incluir botón de edición junto al de eliminar
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón de editar
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => mostrarDialogCategoria(context, categoria: categoria),
                            ),
                            // Botón de eliminar (ya existente)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmarEliminarCategoria(context, categoria),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  );
            },
          )
      );
    } else {
      return Container();
    }
  }
}