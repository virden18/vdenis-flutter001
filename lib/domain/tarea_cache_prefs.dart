import 'package:dart_mappable/dart_mappable.dart';
import 'package:vdenis/domain/tarea.dart';
part 'task_cache_prefs.mapper.dart';

@MappableClass()
class TareaCachePrefs with TaskCachePrefsMappable {
  final String email;
  final List<Tarea> misTareas;

  const TareaCachePrefs({
    required this.email,
    required this.misTareas,
  });
}