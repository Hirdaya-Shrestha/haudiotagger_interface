import 'dart:typed_data';

/// A perceptual audio fingerprint.
///
/// Two recordings of the same audio produce equal (or near-equal)
/// fingerprints even if filenames, tags, containers, or encoders differ.
/// Compare with a backend's `similarity`.
class AudioFingerprint {
  /// Raw fingerprint items (one per ~0.12s of audio).
  final Uint32List values;

  /// Audio duration in whole seconds.
  final int durationSecs;

  const AudioFingerprint({required this.values, required this.durationSecs});
}

/// Implemented by fingerprint providers (e.g. `haudiotagger_fingerprint`).
abstract interface class FingerprintBackend {
  Future<AudioFingerprint> fingerprint(String path);
  Future<AudioFingerprint> fingerprintFromBytes(Uint8List bytes);
  Future<double> similarity(AudioFingerprint a, AudioFingerprint b);
}

/// Global slot for the active backend.
///
/// Set automatically when `haudiotagger_fingerprint` is installed (via its
/// `dartPluginClass` registration). Unset by default so `haudiotagger` alone
/// stays lean — calls then throw a helpful error instead.
class FingerprintRegistry {
  static FingerprintBackend _instance = const _UnimplementedBackend();

  static FingerprintBackend get instance => _instance;

  static set instance(FingerprintBackend backend) => _instance = backend;
}

class _UnimplementedBackend implements FingerprintBackend {
  const _UnimplementedBackend();

  Never _throw() => throw StateError(
        'No fingerprint backend registered. '
        'Add haudiotagger_fingerprint to your dependencies to enable '
        'Haudiotagger.fingerprint().',
      );
  @override
  Future<AudioFingerprint> fingerprint(String path) async => _throw();

  @override
  Future<AudioFingerprint> fingerprintFromBytes(Uint8List bytes) async =>
      _throw();

  @override
  Future<double> similarity(AudioFingerprint a, AudioFingerprint b) async =>
      _throw();
}
