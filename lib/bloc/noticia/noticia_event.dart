import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/noticia.dart';

abstract class NoticiaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NoticiaInitEvent extends NoticiaEvent {}

class FetchNoticiasEvent extends NoticiaEvent {
  FetchNoticiasEvent();
}

class AddNoticiaEvent extends NoticiaEvent {
  final Noticia noticia;

  AddNoticiaEvent(this.noticia);

  @override
  List<Object> get props => [noticia];
}

class UpdateNoticiaEvent extends NoticiaEvent {
  final Noticia noticia;

  UpdateNoticiaEvent(this.noticia);

  @override
  List<Object> get props => [noticia];
}

class DeleteNoticiaEvent extends NoticiaEvent {
  final String id;

  DeleteNoticiaEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterNoticiasByPreferenciasEvent extends NoticiaEvent {
  final List<String> categoriasIds;

  FilterNoticiasByPreferenciasEvent(this.categoriasIds);

  @override
  List<Object> get props => [categoriasIds];
}

class ResetNoticiaEvent extends NoticiaEvent {}

class ActualizarContadorReportesEvent extends NoticiaEvent {
  final String noticiaId;
  final int nuevoContador;

  ActualizarContadorReportesEvent(this.noticiaId, this.nuevoContador);

  @override
  List<Object> get props => [noticiaId, nuevoContador];
}