## 0.3.0

### Features

- `FingerprintBackend.contains(haystack, clip)` contract for clip lookup: scores how much of an excerpt is inside a longer recording (`0.0` to `1.0`, directional). The uninstalled-backend stub throws the same helpful error for it

## 0.2.0

### Features

- `CancellationToken` contract for cooperative scan cancellation; `FingerprintBackend.fingerprint` and `fingerprintFromBytes` accept it as an optional parameter. Providers accept only their own token and reject foreign ones with `ArgumentError`

## 0.1.0

### Features

- `AudioFingerprint` DTO shared by `haudiotagger` and `haudiotagger_fingerprint`
- `FingerprintBackend` interface for fingerprint providers
- `FingerprintRegistry` global slot with a helpful error when no backend is installed
