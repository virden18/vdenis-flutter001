// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task.dart';

class TaskMapper extends ClassMapperBase<Task> {
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

  static String _$title(Task v) => v.title;
  static const Field<Task, String> _f$title = Field('title', _$title);
  static String _$type(Task v) => v.tipo;
  static const Field<Task, String> _f$type =
      Field('type', _$type, opt: true, def: 'normal');
  static String? _$description(Task v) => v.descripcion;
  static const Field<Task, String> _f$description =
      Field('description', _$description, opt: true);
  static DateTime? _$date(Task v) => v.fecha;
  static const Field<Task, DateTime> _f$date = Field('date', _$date, opt: true);
  static DateTime? _$fechaLimite(Task v) => v.fechaLimite;
  static const Field<Task, DateTime> _f$fechaLimite =
      Field('fechaLimite', _$fechaLimite, opt: true);
  static List<String>? _$pasos(Task v) => v.pasos;
  static const Field<Task, List<String>> _f$pasos =
      Field('pasos', _$pasos, opt: true);

  @override
  final MappableFields<Task> fields = const {
    #title: _f$title,
    #type: _f$type,
    #description: _f$description,
    #date: _f$date,
    #fechaLimite: _f$fechaLimite,
    #pasos: _f$pasos,
  };

  static Task _instantiate(DecodingData data) {
    return Task(
        title: data.dec(_f$title),
        tipo: data.dec(_f$type),
        descripcion: data.dec(_f$description),
        fecha: data.dec(_f$date),
        fechaLimite: data.dec(_f$fechaLimite),
        pasos: data.dec(_f$pasos));
  }

  @override
  final Function instantiate = _instantiate;

  static Task fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Task>(map);
  }

  static Task fromJson(String json) {
    return ensureInitialized().decodeJson<Task>(json);
  }
}

mixin TaskMappable {
  String toJson() {
    return TaskMapper.ensureInitialized().encodeJson<Task>(this as Task);
  }

  Map<String, dynamic> toMap() {
    return TaskMapper.ensureInitialized().encodeMap<Task>(this as Task);
  }

  TaskCopyWith<Task, Task, Task> get copyWith =>
      _TaskCopyWithImpl<Task, Task>(this as Task, $identity, $identity);
  @override
  String toString() {
    return TaskMapper.ensureInitialized().stringifyValue(this as Task);
  }

  @override
  bool operator ==(Object other) {
    return TaskMapper.ensureInitialized().equalsValue(this as Task, other);
  }

  @override
  int get hashCode {
    return TaskMapper.ensureInitialized().hashValue(this as Task);
  }
}

extension TaskValueCopy<$R, $Out> on ObjectCopyWith<$R, Task, $Out> {
  TaskCopyWith<$R, Task, $Out> get $asTask =>
      $base.as((v, t, t2) => _TaskCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCopyWith<$R, $In extends Task, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos;
  $R call(
      {String? title,
      String? type,
      String? description,
      DateTime? date,
      DateTime? fechaLimite,
      List<String>? pasos});
  TaskCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TaskCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Task, $Out>
    implements TaskCopyWith<$R, Task, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Task> $mapper = TaskMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos =>
      $value.pasos != null
          ? ListCopyWith($value.pasos!,
              (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(pasos: v))
          : null;
  @override
  $R call(
          {String? title,
          String? type,
          Object? description = $none,
          Object? date = $none,
          Object? fechaLimite = $none,
          Object? pasos = $none}) =>
      $apply(FieldCopyWithData({
        if (title != null) #title: title,
        if (type != null) #type: type,
        if (description != $none) #description: description,
        if (date != $none) #date: date,
        if (fechaLimite != $none) #fechaLimite: fechaLimite,
        if (pasos != $none) #pasos: pasos
      }));
  @override
  Task $make(CopyWithData data) => Task(
      title: data.get(#title, or: $value.title),
      tipo: data.get(#type, or: $value.tipo),
      descripcion: data.get(#description, or: $value.descripcion),
      fecha: data.get(#date, or: $value.fecha),
      fechaLimite: data.get(#fechaLimite, or: $value.fechaLimite),
      pasos: data.get(#pasos, or: $value.pasos));

  @override
  TaskCopyWith<$R2, Task, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TaskCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
