// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_list_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AssetListFile {
  int get id => throw _privateConstructorUsedError;
  int get listId => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AssetListFileCopyWith<AssetListFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetListFileCopyWith<$Res> {
  factory $AssetListFileCopyWith(
          AssetListFile value, $Res Function(AssetListFile) then) =
      _$AssetListFileCopyWithImpl<$Res, AssetListFile>;
  @useResult
  $Res call({int id, int listId, String path});
}

/// @nodoc
class _$AssetListFileCopyWithImpl<$Res, $Val extends AssetListFile>
    implements $AssetListFileCopyWith<$Res> {
  _$AssetListFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? path = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetListFileImplCopyWith<$Res>
    implements $AssetListFileCopyWith<$Res> {
  factory _$$AssetListFileImplCopyWith(
          _$AssetListFileImpl value, $Res Function(_$AssetListFileImpl) then) =
      __$$AssetListFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int listId, String path});
}

/// @nodoc
class __$$AssetListFileImplCopyWithImpl<$Res>
    extends _$AssetListFileCopyWithImpl<$Res, _$AssetListFileImpl>
    implements _$$AssetListFileImplCopyWith<$Res> {
  __$$AssetListFileImplCopyWithImpl(
      _$AssetListFileImpl _value, $Res Function(_$AssetListFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? path = null,
  }) {
    return _then(_$AssetListFileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AssetListFileImpl implements _AssetListFile {
  const _$AssetListFileImpl(
      {required this.id, required this.listId, required this.path});

  @override
  final int id;
  @override
  final int listId;
  @override
  final String path;

  @override
  String toString() {
    return 'AssetListFile(id: $id, listId: $listId, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetListFileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, listId, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetListFileImplCopyWith<_$AssetListFileImpl> get copyWith =>
      __$$AssetListFileImplCopyWithImpl<_$AssetListFileImpl>(this, _$identity);
}

abstract class _AssetListFile implements AssetListFile {
  const factory _AssetListFile(
      {required final int id,
      required final int listId,
      required final String path}) = _$AssetListFileImpl;

  @override
  int get id;
  @override
  int get listId;
  @override
  String get path;
  @override
  @JsonKey(ignore: true)
  _$$AssetListFileImplCopyWith<_$AssetListFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
