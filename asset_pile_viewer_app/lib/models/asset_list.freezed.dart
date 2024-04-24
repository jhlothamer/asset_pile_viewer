// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AssetList {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get fileCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AssetListCopyWith<AssetList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetListCopyWith<$Res> {
  factory $AssetListCopyWith(AssetList value, $Res Function(AssetList) then) =
      _$AssetListCopyWithImpl<$Res, AssetList>;
  @useResult
  $Res call({int id, String name, int fileCount});
}

/// @nodoc
class _$AssetListCopyWithImpl<$Res, $Val extends AssetList>
    implements $AssetListCopyWith<$Res> {
  _$AssetListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fileCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fileCount: null == fileCount
          ? _value.fileCount
          : fileCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetListImplCopyWith<$Res>
    implements $AssetListCopyWith<$Res> {
  factory _$$AssetListImplCopyWith(
          _$AssetListImpl value, $Res Function(_$AssetListImpl) then) =
      __$$AssetListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int fileCount});
}

/// @nodoc
class __$$AssetListImplCopyWithImpl<$Res>
    extends _$AssetListCopyWithImpl<$Res, _$AssetListImpl>
    implements _$$AssetListImplCopyWith<$Res> {
  __$$AssetListImplCopyWithImpl(
      _$AssetListImpl _value, $Res Function(_$AssetListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fileCount = null,
  }) {
    return _then(_$AssetListImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fileCount: null == fileCount
          ? _value.fileCount
          : fileCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AssetListImpl implements _AssetList {
  const _$AssetListImpl(
      {required this.id, required this.name, required this.fileCount});

  @override
  final int id;
  @override
  final String name;
  @override
  final int fileCount;

  @override
  String toString() {
    return 'AssetList(id: $id, name: $name, fileCount: $fileCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fileCount, fileCount) ||
                other.fileCount == fileCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, fileCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetListImplCopyWith<_$AssetListImpl> get copyWith =>
      __$$AssetListImplCopyWithImpl<_$AssetListImpl>(this, _$identity);
}

abstract class _AssetList implements AssetList {
  const factory _AssetList(
      {required final int id,
      required final String name,
      required final int fileCount}) = _$AssetListImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  int get fileCount;
  @override
  @JsonKey(ignore: true)
  _$$AssetListImplCopyWith<_$AssetListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
