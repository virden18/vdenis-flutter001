// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tarea.dart';

class TaskMapper extends ClassMapperBase<Tarea> {
  TaskMapper._();

  static TaskMapper? _instance;
  static TaskMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Task';

  static String? _$id(Tarea v) => v.id;
  static const Field<Tarea, String> _f$id = Field('id', _$id, opt: true);
  static String _$titulo(Tarea v) => v.titulo;
  static const Field<Tarea, String> _f$titulo = Field('titulo', _$titulo);
  static String _$tipo(Tarea v) => v.tipo;
  static const Field<Tarea, String> _f$tipo =
      Field('tipo', _$tipo, opt: true, def: 'normal');
  static String? _$descripcion(Tarea v) => v.descripcion;
  static const Field<Tarea, String> _f$descripcion =
      Field('descripcion', _$descripcion, opt: true);
  static DateTime? _$fecha(Tarea v) => v.fecha;
  static const Field<Tarea, DateTime> _f$fecha =
      Field('fecha', _$fecha, opt: true);
  static DateTime? _$fechaLimite(Tarea v) => v.fechaLimite;
  static const Field<Tarea, DateTime> _f$fechaLimite =
      Field('fechaLimite', _$fechaLimite, opt: true);
  static List<String>? _$pasos(Tarea v) => v.pasos;
  static const Field<Tarea, List<String>> _f$pasos =
      Field('pasos', _$pasos, opt: true);

  @override
  final MappableFields<Tarea> fields = const {
    #id: _f$id,
    #titulo: _f$titulo,
    #tipo: _f$tipo,
    #descripcion: _f$descripcion,
    #fecha: _f$fecha,
    #fechaLimite: _f$fechaLimite,
    #pasos: _f$pasos,
  };

  static Tarea _instantiate(DecodingData data) {
    return Tarea(
        id: data.dec(_f$id),
        titulo: data.dec(_f$titulo),
        tipo: data.dec(_f$tipo),
        descripcion: data.dec(_f$descripcion),
        fecha: data.dec(_f$fecha),
        fechaLimite: data.dec(_f$fechaLimite),
        pasos: data.dec(_f$pasos));
  }

  @override
  final Function instantiate = _instantiate;

  static Tarea fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Tarea>(map);
  }

  static Tarea fromJson(String json) {
    return ensureInitialized().decodeJson<Tarea>(json);
  }
}

mixin TaskMappable {
  String toJson() {
    return TaskMapper.ensureInitialized().encodeJson<Tarea>(this as Tarea);
  }

  Map<String, dynamic> toMap() {
    return TaskMapper.ensureInitialized().encodeMap<Tarea>(this as Tarea);
  }

  TaskCopyWith<Tarea, Tarea, Tarea> get copyWith =>
      _TaskCopyWithImpl<Tarea, Tarea>(this as Tarea, $identity, $identity);
  @override
  String toString() {
    return TaskMapper.ensureInitialized().stringifyValue(this as Tarea);
  }

  @override
  bool operator ==(Object other) {
    return TaskMapper.ensureInitialized().equalsValue(this as Tarea, other);
  }

  @override
  int get hashCode {
    return TaskMapper.ensureInitialized().hashValue(this as Tarea);
  }
}

extension TaskValueCopy<$R, $Out> on ObjectCopyWith<$R, Tarea, $Out> {
  TaskCopyWith<$R, Tarea, $Out> get $asTask =>
      $base.as((v, t, t2) => _TaskCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCopyWith<$R, $In extends Tarea, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos;
  $R call(
      {String? id,
      String? titulo,
      String? tipo,
      String? descripcion,
      DateTime? fecha,
      DateTime? fechaLimite,
      List<String>? pasos});
  TaskCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TaskCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Tarea, $Out>
    implements TaskCopyWith<$R, Tarea, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Tarea> $mapper = TaskMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos =>
      $value.pasos != null
          ? ListCopyWith($value.pasos!,
              (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(pasos: v))
          : null;
  @override
  $R call(
          {Object? id = $none,
          String? titulo,
          String? tipo,
          Object? descripcion = $none,
          Object? fecha = $none,
          Object? fechaLimite = $none,
          Object? pasos = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (titulo != null) #titulo: titulo,
        if (tipo != null) #tipo: tipo,
        if (descripcion != $none) #descripcion: descripcion,
        if (fecha != $none) #fecha: fecha,
        if (fechaLimite != $none) #fechaLimite: fechaLimite,
        if (pasos != $none) #pasos: pasos
      }));
  @override
  Tarea $make(CopyWithData data) => Tarea(
      id: data.get(#id, or: $value.id),
      titulo: data.get(#titulo, or: $value.titulo),
      tipo: data.get(#tipo, or: $value.tipo),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      fecha: data.get(#fecha, or: $value.fecha),
      fechaLimite: data.get(#fechaLimite, or: $value.fechaLimite),
      pasos: data.get(#pasos, or: $value.pasos));

  @override
  TaskCopyWith<$R2, Tarea, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TaskCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
