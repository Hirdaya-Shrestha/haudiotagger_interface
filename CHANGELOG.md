## 0.2.0

### Features

- `CancellationToken` contract for cooperative scan cancellation; `FingerprintBackend.fingerprint` and `fingerprintFromBytes` accept it as an optional parameter. Providers accept only their own token and reject foreign ones with `ArgumentError`

## 0.1.0

### Features

- `AudioFingerprint` DTO shared by `haudiotagger` and `haudiotagger_fingerprint`
- `FingerprintBackend` interface for fingerprint providers
- `FingerprintRegistry` global slot with a helpful error when no backend is installed
