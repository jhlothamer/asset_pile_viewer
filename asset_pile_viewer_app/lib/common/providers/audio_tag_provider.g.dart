// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_tag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioTagHash() => r'53fd302cc6ab60c6225a34791be5509e2bfa2640';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [audioTag].
@ProviderFor(audioTag)
const audioTagProvider = AudioTagFamily();

/// See also [audioTag].
class AudioTagFamily extends Family<AsyncValue<Tag?>> {
  /// See also [audioTag].
  const AudioTagFamily();

  /// See also [audioTag].
  AudioTagProvider call(
    String filePath,
  ) {
    return AudioTagProvider(
      filePath,
    );
  }

  @override
  AudioTagProvider getProviderOverride(
    covariant AudioTagProvider provider,
  ) {
    return call(
      provider.filePath,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'audioTagProvider';
}

/// See also [audioTag].
class AudioTagProvider extends AutoDisposeFutureProvider<Tag?> {
  /// See also [audioTag].
  AudioTagProvider(
    String filePath,
  ) : this._internal(
          (ref) => audioTag(
            ref as AudioTagRef,
            filePath,
          ),
          from: audioTagProvider,
          name: r'audioTagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$audioTagHash,
          dependencies: AudioTagFamily._dependencies,
          allTransitiveDependencies: AudioTagFamily._allTransitiveDependencies,
          filePath: filePath,
        );

  AudioTagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filePath,
  }) : super.internal();

  final String filePath;

  @override
  Override overrideWith(
    FutureOr<Tag?> Function(AudioTagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AudioTagProvider._internal(
        (ref) => create(ref as AudioTagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filePath: filePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Tag?> createElement() {
    return _AudioTagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AudioTagProvider && other.filePath == filePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AudioTagRef on AutoDisposeFutureProviderRef<Tag?> {
  /// The parameter `filePath` of this provider.
  String get filePath;
}

class _AudioTagProviderElement extends AutoDisposeFutureProviderElement<Tag?>
    with AudioTagRef {
  _AudioTagProviderElement(super.provider);

  @override
  String get filePath => (origin as AudioTagProvider).filePath;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
