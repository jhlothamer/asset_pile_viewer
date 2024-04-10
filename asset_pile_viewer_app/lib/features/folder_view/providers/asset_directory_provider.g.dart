// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_directory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetDirectoryHash() => r'4772f1fca5bc67593ea1fd037dbe6f221bf0b4a1';

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

abstract class _$AssetDirectory
    extends BuildlessAutoDisposeNotifier<model.AssetDirectory> {
  late final String path;

  model.AssetDirectory build(
    String path,
  );
}

/// See also [AssetDirectory].
@ProviderFor(AssetDirectory)
const assetDirectoryProvider = AssetDirectoryFamily();

/// See also [AssetDirectory].
class AssetDirectoryFamily extends Family<model.AssetDirectory> {
  /// See also [AssetDirectory].
  const AssetDirectoryFamily();

  /// See also [AssetDirectory].
  AssetDirectoryProvider call(
    String path,
  ) {
    return AssetDirectoryProvider(
      path,
    );
  }

  @override
  AssetDirectoryProvider getProviderOverride(
    covariant AssetDirectoryProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'assetDirectoryProvider';
}

/// See also [AssetDirectory].
class AssetDirectoryProvider extends AutoDisposeNotifierProviderImpl<
    AssetDirectory, model.AssetDirectory> {
  /// See also [AssetDirectory].
  AssetDirectoryProvider(
    String path,
  ) : this._internal(
          () => AssetDirectory()..path = path,
          from: assetDirectoryProvider,
          name: r'assetDirectoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetDirectoryHash,
          dependencies: AssetDirectoryFamily._dependencies,
          allTransitiveDependencies:
              AssetDirectoryFamily._allTransitiveDependencies,
          path: path,
        );

  AssetDirectoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  model.AssetDirectory runNotifierBuild(
    covariant AssetDirectory notifier,
  ) {
    return notifier.build(
      path,
    );
  }

  @override
  Override overrideWith(AssetDirectory Function() create) {
    return ProviderOverride(
      origin: this,
      override: AssetDirectoryProvider._internal(
        () => create()..path = path,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AssetDirectory, model.AssetDirectory>
      createElement() {
    return _AssetDirectoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetDirectoryProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetDirectoryRef
    on AutoDisposeNotifierProviderRef<model.AssetDirectory> {
  /// The parameter `path` of this provider.
  String get path;
}

class _AssetDirectoryProviderElement extends AutoDisposeNotifierProviderElement<
    AssetDirectory, model.AssetDirectory> with AssetDirectoryRef {
  _AssetDirectoryProviderElement(super.provider);

  @override
  String get path => (origin as AssetDirectoryProvider).path;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
