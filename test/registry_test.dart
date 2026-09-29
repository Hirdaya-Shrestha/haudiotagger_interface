import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:haudiotagger_interface/haudiotagger_interface.dart';

class _FakeBackend implements FingerprintBackend {
  CancellationToken? lastToken;

  @override
  Future<AudioFingerprint> fingerprint(String path,
      {CancellationToken? cancellationToken}) async {
    lastToken = cancellationToken;
    return AudioFingerprint(
        values: Uint32List.fromList([1, 2, 3]), durationSecs: 5);
  }

  @override
  Future<AudioFingerprint> fingerprintFromBytes(Uint8List bytes,
      {CancellationToken? cancellationToken}) async {
    lastToken = cancellationToken;
    return AudioFingerprint(
        values: Uint32List.fromList([1, 2, 3]), durationSecs: 5);
  }

  @override
  Future<double> similarity(AudioFingerprint a, AudioFingerprint b) async =>
      1.0;
}

class _FakeToken implements CancellationToken {
  bool cancelled = false;

  @override
  Future<void> cancel() async {
    cancelled = true;
  }
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

  test('cancellation token flows through the registry', () async {
    final backend = _FakeBackend();
    FingerprintRegistry.instance = backend;
    final token = _FakeToken();
    await FingerprintRegistry.instance
        .fingerprintFromBytes(Uint8List(0), cancellationToken: token);
    expect(backend.lastToken, same(token));
    await token.cancel();
    expect(token.cancelled, isTrue);
  });
}
