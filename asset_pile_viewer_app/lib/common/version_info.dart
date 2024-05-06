class VersionInfo {
  final int major;
  final int minor;
  final int patch;

  VersionInfo({required this.major, required this.minor, required this.patch});

  factory VersionInfo.fromString(String versionString) {
    final versionParts = versionString.split('.');

    return VersionInfo(
      major: int.tryParse(versionParts.elementAtOrNull(0) ?? '0') ?? 0,
      minor: int.tryParse(versionParts.elementAtOrNull(1) ?? '0') ?? 0,
      patch: int.tryParse(versionParts.elementAtOrNull(2) ?? '0') ?? 0,
    );
  }

  factory VersionInfo.empty() {
    return VersionInfo(major: 0, minor: 0, patch: 0);
  }

  @override
  String toString() => '$major.$minor.$patch';

  bool isEmpty() => major == 0 && minor == 0 && patch == 0;

  @override
  bool operator ==(Object other) {
    return other is VersionInfo &&
        major == other.major &&
        minor == other.minor &&
        patch == other.patch;
  }

  @override
  int get hashCode => Object.hash(major, minor, patch);

  bool operator >(VersionInfo other) {
    final result = major > other.major
        ? true
        : minor > other.minor
            ? true
            : patch > other.patch
                ? true
                : false;
    return result;
  }

  bool operator >=(VersionInfo other) {
    return !(this < other);
  }

  bool operator <(VersionInfo other) {
    final result = major < other.major
        ? true
        : minor < other.minor
            ? true
            : patch < other.patch
                ? true
                : false;
    return result;
  }

  bool operator <=(VersionInfo other) {
    return !(this > other);
  }
}
