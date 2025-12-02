import 'package:equatable/equatable.dart';

class QuantumKeyPair extends Equatable {
  final String publicKey;
  final String privateKey; // Encrypted
  final String algorithm;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final int keySize;
  final String fingerprint;
  final bool isCompromised;

  const QuantumKeyPair({
    required this.publicKey,
    required this.privateKey,
    required this.algorithm,
    required this.generatedAt,
    required this.expiresAt,
    required this.keySize,
    required this.fingerprint,
    required this.isCompromised,
  });

  factory QuantumKeyPair.fromJson(Map<String, dynamic> json) {
    return QuantumKeyPair(
      publicKey: json['public_key'] ?? '',
      privateKey: json['private_key'] ?? '',
      algorithm: json['algorithm'] ?? 'X25519-LATTICE',
      generatedAt: DateTime.parse(json['generated_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      keySize: json['key_size'] ?? 512,
      fingerprint: json['fingerprint'] ?? '',
      isCompromised: json['is_compromised'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_key': publicKey,
      'private_key': privateKey,
      'algorithm': algorithm,
      'generated_at': generatedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'key_size': keySize,
      'fingerprint': fingerprint,
      'is_compromised': isCompromised,
    };
  }

  bool get isValid => 
      !isCompromised && expiresAt.isAfter(DateTime.now());

  bool get needsRotation => 
      expiresAt.difference(DateTime.now()).inDays < 7;

  @override
  List<Object?> get props => [
    publicKey,
    privateKey,
    algorithm,
    generatedAt,
    expiresAt,
    keySize,
    fingerprint,
    isCompromised,
  ];
}

class TimeLockedSecret extends Equatable {
  final String id;
  final String label;
  final String encryptedData;
  final String encryptionAlgorithm;
  final DateTime createdAt;
  final DateTime unlockTime;
  final bool isUnlocked;
  final String unlockKeyHash;
  final List<String> authorizedUsers;
  final String metadataHash;

  const TimeLockedSecret({
    required this.id,
    required this.label,
    required this.encryptedData,
    required this.encryptionAlgorithm,
    required this.createdAt,
    required this.unlockTime,
    required this.isUnlocked,
    required this.unlockKeyHash,
    required this.authorizedUsers,
    required this.metadataHash,
  });

  factory TimeLockedSecret.fromJson(Map<String, dynamic> json) {
    return TimeLockedSecret(
      id: json['id'] ?? '',
      label: json['label'] ?? 'Untitled Secret',
      encryptedData: json['encrypted_data'] ?? '',
      encryptionAlgorithm: json['encryption_algorithm'] ?? 'AES-256-GCM',
      createdAt: DateTime.parse(json['created_at']),
      unlockTime: DateTime.parse(json['unlock_time']),
      isUnlocked: json['is_unlocked'] ?? false,
      unlockKeyHash: json['unlock_key_hash'] ?? '',
      authorizedUsers: List<String>.from(json['authorized_users'] ?? []),
      metadataHash: json['metadata_hash'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'encrypted_data': encryptedData,
      'encryption_algorithm': encryptionAlgorithm,
      'created_at': createdAt.toIso8601String(),
      'unlock_time': unlockTime.toIso8601String(),
      'is_unlocked': isUnlocked,
      'unlock_key_hash': unlockKeyHash,
      'authorized_users': authorizedUsers,
      'metadata_hash': metadataHash,
    };
  }

  bool get isExpired => unlockTime.isBefore(DateTime.now());
  bool get canUnlock => isExpired && !isUnlocked;
  
  Duration get timeRemaining {
    final now = DateTime.now();
    if (unlockTime.isBefore(now)) {
      return Duration.zero;
    }
    return unlockTime.difference(now);
  }

  String get timeRemainingFormatted {
    final duration = timeRemaining;
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  List<Object?> get props => [
    id,
    label,
    encryptedData,
    encryptionAlgorithm,
    createdAt,
    unlockTime,
    isUnlocked,
    unlockKeyHash,
    authorizedUsers,
    metadataHash,
  ];
}

class IdentityShard extends Equatable {
  final String id;
  final int shardNumber;
  final int totalShards;
  final int requiredShards;
  final String encryptedData;
  final String encryptionKeyHash;
  final DateTime createdAt;
  final String metadata;
  final bool isActive;
  final String storageLocation;

  const IdentityShard({
    required this.id,
    required this.shardNumber,
    required this.totalShards,
    required this.requiredShards,
    required this.encryptedData,
    required this.encryptionKeyHash,
    required this.createdAt,
    required this.metadata,
    required this.isActive,
    required this.storageLocation,
  });

  factory IdentityShard.fromJson(Map<String, dynamic> json) {
    return IdentityShard(
      id: json['id'] ?? '',
      shardNumber: json['shard_number'] ?? 1,
      totalShards: json['total_shards'] ?? 1,
      requiredShards: json['required_shards'] ?? 1,
      encryptedData: json['encrypted_data'] ?? '',
      encryptionKeyHash: json['encryption_key_hash'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'] ?? '',
      isActive: json['is_active'] ?? true,
      storageLocation: json['storage_location'] ?? 'local',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shard_number': shardNumber,
      'total_shards': totalShards,
      'required_shards': requiredShards,
      'encrypted_data': encryptedData,
      'encryption_key_hash': encryptionKeyHash,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
      'is_active': isActive,
      'storage_location': storageLocation,
    };
  }

  bool get canReconstruct => isActive;
  bool get isCritical => shardNumber <= requiredShards;

  @override
  List<Object?> get props => [
    id,
    shardNumber,
    totalShards,
    requiredShards,
    encryptedData,
    encryptionKeyHash,
    createdAt,
    metadata,
    isActive,
    storageLocation,
  ];
}

class QuantumSignature extends Equatable {
  final String id;
  final String dataHash;
  final String signature;
  final String publicKey;
  final String algorithm;
  final DateTime signedAt;
  final bool isValid;
  final String verificationProof;

  const QuantumSignature({
    required this.id,
    required this.dataHash,
    required this.signature,
    required this.publicKey,
    required this.algorithm,
    required this.signedAt,
    required this.isValid,
    required this.verificationProof,
  });

  factory QuantumSignature.fromJson(Map<String, dynamic> json) {
    return QuantumSignature(
      id: json['id'] ?? '',
      dataHash: json['data_hash'] ?? '',
      signature: json['signature'] ?? '',
      publicKey: json['public_key'] ?? '',
      algorithm: json['algorithm'] ?? 'ED25519-LATTICE',
      signedAt: DateTime.parse(json['signed_at']),
      isValid: json['is_valid'] ?? false,
      verificationProof: json['verification_proof'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_hash': dataHash,
      'signature': signature,
      'public_key': publicKey,
      'algorithm': algorithm,
      'signed_at': signedAt.toIso8601String(),
      'is_valid': isValid,
      'verification_proof': verificationProof,
    };
  }

  @override
  List<Object?> get props => [
    id,
    dataHash,
    signature,
    publicKey,
    algorithm,
    signedAt,
    isValid,
    verificationProof,
  ];
}