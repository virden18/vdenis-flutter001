import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/noticia.dart';

abstract class NoticiaState extends Equatable {
  const NoticiaState();
  
  @override
  List<Object?> get props => [];
}

class NoticiaInitial extends NoticiaState {
  const NoticiaInitial();
}

class NoticiaLoading extends NoticiaState {
  const NoticiaLoading();
}

class NoticiaLoaded extends NoticiaState {
  final List<Noticia> noticias;
  final DateTime lastUpdated;
  final Map<String, String> categoriasCache;

  const NoticiaLoaded({
    required this.noticias,
    required this.lastUpdated,
    required this.categoriasCache,
  });
  
  @override
  List<Object?> get props => [noticias, lastUpdated, categoriasCache];

  NoticiaLoaded copyWith({
    List<Noticia>? noticias,
    DateTime? lastUpdated,
    Map<String, String>? categoriasCache,
  }) {
    return NoticiaLoaded(
      noticias: noticias ?? this.noticias,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      categoriasCache: categoriasCache ?? this.categoriasCache,
    );
  }
}

class NoticiaError extends NoticiaState {
  final String message;
  final int statusCode;

  const NoticiaError({
    required this.message,
    required this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, statusCode];
}
