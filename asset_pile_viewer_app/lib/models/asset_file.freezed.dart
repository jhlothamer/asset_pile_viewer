// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AssetFile {
  int get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  List<Keyword> get keywords => throw _privateConstructorUsedError;
  List<AssetList> get lists => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AssetFileCopyWith<AssetFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetFileCopyWith<$Res> {
  factory $AssetFileCopyWith(AssetFile value, $Res Function(AssetFile) then) =
      _$AssetFileCopyWithImpl<$Res, AssetFile>;
  @useResult
  $Res call(
      {int id,
      String path,
      bool hidden,
      List<Keyword> keywords,
      List<AssetList> lists});
}

/// @nodoc
class _$AssetFileCopyWithImpl<$Res, $Val extends AssetFile>
    implements $AssetFileCopyWith<$Res> {
  _$AssetFileCopyWithImpl(this._value, this._then);

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
    Object? lists = null,
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
      lists: null == lists
          ? _value.lists
          : lists // ignore: cast_nullable_to_non_nullable
              as List<AssetList>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetFileImplCopyWith<$Res>
    implements $AssetFileCopyWith<$Res> {
  factory _$$AssetFileImplCopyWith(
          _$AssetFileImpl value, $Res Function(_$AssetFileImpl) then) =
      __$$AssetFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String path,
      bool hidden,
      List<Keyword> keywords,
      List<AssetList> lists});
}

/// @nodoc
class __$$AssetFileImplCopyWithImpl<$Res>
    extends _$AssetFileCopyWithImpl<$Res, _$AssetFileImpl>
    implements _$$AssetFileImplCopyWith<$Res> {
  __$$AssetFileImplCopyWithImpl(
      _$AssetFileImpl _value, $Res Function(_$AssetFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? hidden = null,
    Object? keywords = null,
    Object? lists = null,
  }) {
    return _then(_$AssetFileImpl(
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
      lists: null == lists
          ? _value._lists
          : lists // ignore: cast_nullable_to_non_nullable
              as List<AssetList>,
    ));
  }
}

/// @nodoc

class _$AssetFileImpl implements _AssetFile {
  const _$AssetFileImpl(
      {required this.id,
      required this.path,
      required this.hidden,
      final List<Keyword> keywords = const [],
      final List<AssetList> lists = const []})
      : _keywords = keywords,
        _lists = lists;

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

  final List<AssetList> _lists;
  @override
  @JsonKey()
  List<AssetList> get lists {
    if (_lists is EqualUnmodifiableListView) return _lists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lists);
  }

  @override
  String toString() {
    return 'AssetFile(id: $id, path: $path, hidden: $hidden, keywords: $keywords, lists: $lists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetFileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(other._lists, _lists));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      path,
      hidden,
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_lists));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetFileImplCopyWith<_$AssetFileImpl> get copyWith =>
      __$$AssetFileImplCopyWithImpl<_$AssetFileImpl>(this, _$identity);
}

abstract class _AssetFile implements AssetFile {
  const factory _AssetFile(
      {required final int id,
      required final String path,
      required final bool hidden,
      final List<Keyword> keywords,
      final List<AssetList> lists}) = _$AssetFileImpl;

  @override
  int get id;
  @override
  String get path;
  @override
  bool get hidden;
  @override
  List<Keyword> get keywords;
  @override
  List<AssetList> get lists;
  @override
  @JsonKey(ignore: true)
  _$$AssetFileImplCopyWith<_$AssetFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
