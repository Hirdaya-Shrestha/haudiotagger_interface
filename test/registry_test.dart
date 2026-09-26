import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:haudiotagger_interface/haudiotagger_interface.dart';

class _FakeBackend implements FingerprintBackend {
  @override
  Future<AudioFingerprint> fingerprint(String path) async =>
      AudioFingerprint(values: Uint32List.fromList([1, 2, 3]), durationSecs: 5);

  @override
  Future<AudioFingerprint> fingerprintFromBytes(Uint8List bytes) async =>
      AudioFingerprint(values: Uint32List.fromList([1, 2, 3]), durationSecs: 5);

  @override
  Future<double> similarity(AudioFingerprint a, AudioFingerprint b) async =>
      1.0;
}

void main() {
  test('unregistered registry throws helpful error', () {
    expect(
      FingerprintRegistry.instance.fingerprint('a.mp3'),
      throwsA(isA<StateError>()),
    );
  });

  test('registered backend delegates', () async {
    FingerprintRegistry.instance = _FakeBackend();
    final fp = await FingerprintRegistry.instance.fingerprint('a.mp3');
    expect(fp.values, [1, 2, 3]);
    expect(fp.durationSecs, 5);
    expect(
      await FingerprintRegistry.instance.similarity(fp, fp),
      1.0,
    );
  });
}
