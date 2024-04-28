// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_file_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetFileHash() => r'41533adaaf913a4c4d16cb731deaee0080b30537';

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

/// See also [assetFile].
@ProviderFor(assetFile)
const assetFileProvider = AssetFileFamily();

/// See also [assetFile].
class AssetFileFamily extends Family<AssetFile> {
  /// See also [assetFile].
  const AssetFileFamily();

  /// See also [assetFile].
  AssetFileProvider call(
    String path,
  ) {
    return AssetFileProvider(
      path,
    );
  }

  @override
  AssetFileProvider getProviderOverride(
    covariant AssetFileProvider provider,
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
  String? get name => r'assetFileProvider';
}

/// See also [assetFile].
class AssetFileProvider extends AutoDisposeProvider<AssetFile> {
  /// See also [assetFile].
  AssetFileProvider(
    String path,
  ) : this._internal(
          (ref) => assetFile(
            ref as AssetFileRef,
            path,
          ),
          from: assetFileProvider,
          name: r'assetFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetFileHash,
          dependencies: AssetFileFamily._dependencies,
          allTransitiveDependencies: AssetFileFamily._allTransitiveDependencies,
          path: path,
        );

  AssetFileProvider._internal(
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
  Override overrideWith(
    AssetFile Function(AssetFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetFileProvider._internal(
        (ref) => create(ref as AssetFileRef),
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
  AutoDisposeProviderElement<AssetFile> createElement() {
    return _AssetFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetFileProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetFileRef on AutoDisposeProviderRef<AssetFile> {
  /// The parameter `path` of this provider.
  String get path;
}

class _AssetFileProviderElement extends AutoDisposeProviderElement<AssetFile>
    with AssetFileRef {
  _AssetFileProviderElement(super.provider);

  @override
  String get path => (origin as AssetFileProvider).path;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
