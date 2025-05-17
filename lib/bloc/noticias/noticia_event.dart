import 'package:equatable/equatable.dart';

sealed class NoticiasEvent extends Equatable {
  const NoticiasEvent();

  @override
  List<Object> get props => [];
}

class NoticiasLoadEvent extends NoticiasEvent {
  const NoticiasLoadEvent();
}

class NoticiasCreateEvent extends NoticiasEvent {
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String categoriaId; // Nuevo campo para categoría

  const NoticiasCreateEvent(
    this.titulo,
    this.descripcion,
    this.fuente,
    this.publicadaEl,
    this.urlImagen,
    this.categoriaId,
  );

  @override
  List<Object> get props => [titulo, descripcion, fuente, publicadaEl, urlImagen, categoriaId];
}

class NoticiasUpdateEvent extends NoticiasEvent {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String categoriaId;

  const NoticiasUpdateEvent(
    this.id, 
    this.titulo,
    this.descripcion,
    this.fuente,
    this.publicadaEl,
    this.urlImagen,
    this.categoriaId,
    );

  @override
  List<Object> get props => [id, titulo, descripcion, fuente, publicadaEl, urlImagen, categoriaId];
}

class NoticiasDeleteEvent extends NoticiasEvent {
  final String id;

  const NoticiasDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}
