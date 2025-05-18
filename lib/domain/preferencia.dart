import 'package:dart_mappable/dart_mappable.dart';

part 'preferencia.mapper.dart';

@MappableClass()
class Preferencia{
  final String email;
  final List<String> categoriasSeleccionadas;

  const Preferencia({
    required this.email,
    required this.categoriasSeleccionadas,
  });
}