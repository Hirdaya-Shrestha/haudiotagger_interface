# haudiotagger_interface

Shared contract/interface for `haudiotagger`.

- `AudioFingerprint`: the DTO both sides agree on.
- `FingerprintBackend`: the interface fingerprint providers implement.
- `FingerprintRegistry`: the global slot. `haudiotagger` reads it,
  `haudiotagger_fingerprint` fills it (self-registering via
  `dartPluginClass`, so no extra imports or init calls).
- `CancellationToken`: cooperative cancellation for long scans, threaded
  through the backend methods as an optional parameter.

Pure Dart, no native code, zero weight. Versioned independently; consumers
never depend on it directly.

## License

MIT — see [LICENSE](LICENSE).
