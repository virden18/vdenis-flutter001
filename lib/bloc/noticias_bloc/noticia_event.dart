import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/noticia.dart';

abstract class NoticiaEvent extends Equatable {
  const NoticiaEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadNoticias extends NoticiaEvent {
  const LoadNoticias();
}

class LoadCategorias extends NoticiaEvent {
  const LoadCategorias();
}

class CreateNoticia extends NoticiaEvent {
  final Noticia noticia;

  const CreateNoticia(this.noticia);
  
  @override
  List<Object?> get props => [noticia];
}

class UpdateNoticia extends NoticiaEvent {
  final String id;
  final Noticia noticia;

  const UpdateNoticia({
    required this.id,
    required this.noticia,
  });
  
  @override
  List<Object?> get props => [id, noticia];
}

class DeleteNoticia extends NoticiaEvent {
  final Noticia noticia;

  const DeleteNoticia(this.noticia);
  
  @override
  List<Object?> get props => [noticia];
}
