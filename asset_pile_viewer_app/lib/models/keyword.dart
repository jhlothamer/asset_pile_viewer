import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyword.freezed.dart';

@freezed
class Keyword with _$Keyword {
  const factory Keyword({
    required int id,
    required String name,
  }) = _Keyword;

  factory Keyword.newKeyword({required String name}) =>
      Keyword(id: 0, name: name);
}
