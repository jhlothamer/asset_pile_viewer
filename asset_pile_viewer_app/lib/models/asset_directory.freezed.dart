// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_directory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AssetDirectory {
  int get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  List<Keyword> get keywords => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AssetDirectoryCopyWith<AssetDirectory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetDirectoryCopyWith<$Res> {
  factory $AssetDirectoryCopyWith(
          AssetDirectory value, $Res Function(AssetDirectory) then) =
      _$AssetDirectoryCopyWithImpl<$Res, AssetDirectory>;
  @useResult
  $Res call({int id, String path, bool hidden, List<Keyword> keywords});
}

/// @nodoc
class _$AssetDirectoryCopyWithImpl<$Res, $Val extends AssetDirectory>
    implements $AssetDirectoryCopyWith<$Res> {
  _$AssetDirectoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? hidden = null,
    Object? keywords = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<Keyword>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetDirectoryImplCopyWith<$Res>
    implements $AssetDirectoryCopyWith<$Res> {
  factory _$$AssetDirectoryImplCopyWith(_$AssetDirectoryImpl value,
          $Res Function(_$AssetDirectoryImpl) then) =
      __$$AssetDirectoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String path, bool hidden, List<Keyword> keywords});
}

/// @nodoc
class __$$AssetDirectoryImplCopyWithImpl<$Res>
    extends _$AssetDirectoryCopyWithImpl<$Res, _$AssetDirectoryImpl>
    implements _$$AssetDirectoryImplCopyWith<$Res> {
  __$$AssetDirectoryImplCopyWithImpl(
      _$AssetDirectoryImpl _value, $Res Function(_$AssetDirectoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? hidden = null,
    Object? keywords = null,
  }) {
    return _then(_$AssetDirectoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<Keyword>,
    ));
  }
}

/// @nodoc

class _$AssetDirectoryImpl implements _AssetDirectory {
  const _$AssetDirectoryImpl(
      {required this.id,
      required this.path,
      required this.hidden,
      final List<Keyword> keywords = const []})
      : _keywords = keywords;

  @override
  final int id;
  @override
  final String path;
  @override
  final bool hidden;
  final List<Keyword> _keywords;
  @override
  @JsonKey()
  List<Keyword> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'AssetDirectory(id: $id, path: $path, hidden: $hidden, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetDirectoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, path, hidden,
      const DeepCollectionEquality().hash(_keywords));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetDirectoryImplCopyWith<_$AssetDirectoryImpl> get copyWith =>
      __$$AssetDirectoryImplCopyWithImpl<_$AssetDirectoryImpl>(
          this, _$identity);
}

abstract class _AssetDirectory implements AssetDirectory {
  const factory _AssetDirectory(
      {required final int id,
      required final String path,
      required final bool hidden,
      final List<Keyword> keywords}) = _$AssetDirectoryImpl;

  @override
  int get id;
  @override
  String get path;
  @override
  bool get hidden;
  @override
  List<Keyword> get keywords;
  @override
  @JsonKey(ignore: true)
  _$$AssetDirectoryImplCopyWith<_$AssetDirectoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
