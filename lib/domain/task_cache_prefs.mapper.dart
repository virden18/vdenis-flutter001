// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tarea_cache_prefs.dart';

class TaskCachePrefsMapper extends ClassMapperBase<TareaCachePrefs> {
  TaskCachePrefsMapper._();

  static TaskCachePrefsMapper? _instance;
  static TaskCachePrefsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskCachePrefsMapper._());
      TaskMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskCachePrefs';

  static String _$email(TareaCachePrefs v) => v.email;
  static const Field<TareaCachePrefs, String> _f$email = Field('email', _$email);
  static List<Tarea> _$misTareas(TareaCachePrefs v) => v.misTareas;
  static const Field<TareaCachePrefs, List<Tarea>> _f$misTareas =
      Field('misTareas', _$misTareas);

  @override
  final MappableFields<TareaCachePrefs> fields = const {
    #email: _f$email,
    #misTareas: _f$misTareas,
  };

  static TareaCachePrefs _instantiate(DecodingData data) {
    return TareaCachePrefs(
        email: data.dec(_f$email), misTareas: data.dec(_f$misTareas));
  }

  @override
  final Function instantiate = _instantiate;

  static TareaCachePrefs fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TareaCachePrefs>(map);
  }

  static TareaCachePrefs fromJson(String json) {
    return ensureInitialized().decodeJson<TareaCachePrefs>(json);
  }
}

mixin TaskCachePrefsMappable {
  String toJson() {
    return TaskCachePrefsMapper.ensureInitialized()
        .encodeJson<TareaCachePrefs>(this as TareaCachePrefs);
  }

  Map<String, dynamic> toMap() {
    return TaskCachePrefsMapper.ensureInitialized()
        .encodeMap<TareaCachePrefs>(this as TareaCachePrefs);
  }

  TaskCachePrefsCopyWith<TareaCachePrefs, TareaCachePrefs, TareaCachePrefs>
      get copyWith =>
          _TaskCachePrefsCopyWithImpl<TareaCachePrefs, TareaCachePrefs>(
              this as TareaCachePrefs, $identity, $identity);
  @override
  String toString() {
    return TaskCachePrefsMapper.ensureInitialized()
        .stringifyValue(this as TareaCachePrefs);
  }

  @override
  bool operator ==(Object other) {
    return TaskCachePrefsMapper.ensureInitialized()
        .equalsValue(this as TareaCachePrefs, other);
  }

  @override
  int get hashCode {
    return TaskCachePrefsMapper.ensureInitialized()
        .hashValue(this as TareaCachePrefs);
  }
}

extension TaskCachePrefsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TareaCachePrefs, $Out> {
  TaskCachePrefsCopyWith<$R, TareaCachePrefs, $Out> get $asTaskCachePrefs =>
      $base.as((v, t, t2) => _TaskCachePrefsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCachePrefsCopyWith<$R, $In extends TareaCachePrefs, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Tarea, TaskCopyWith<$R, Tarea, Tarea>> get misTareas;
  $R call({String? email, List<Tarea>? misTareas});
  TaskCachePrefsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TaskCachePrefsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TareaCachePrefs, $Out>
    implements TaskCachePrefsCopyWith<$R, TareaCachePrefs, $Out> {
  _TaskCachePrefsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TareaCachePrefs> $mapper =
      TaskCachePrefsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tarea, TaskCopyWith<$R, Tarea, Tarea>> get misTareas =>
      ListCopyWith($value.misTareas, (v, t) => v.copyWith.$chain(t),
          (v) => call(misTareas: v));
  @override
  $R call({String? email, List<Tarea>? misTareas}) => $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (misTareas != null) #misTareas: misTareas
      }));
  @override
  TareaCachePrefs $make(CopyWithData data) => TareaCachePrefs(
      email: data.get(#email, or: $value.email),
      misTareas: data.get(#misTareas, or: $value.misTareas));

  @override
  TaskCachePrefsCopyWith<$R2, TareaCachePrefs, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TaskCachePrefsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
