import 'package:activos_nfc_app/core/models/models.dart';
import 'package:equatable/equatable.dart';

enum AssetStatus { initial, loading, success, error, updating, updateSuccess, updateError }

class AssetState extends Equatable {
  final AssetStatus status;
  final Asset? asset;
  final String? errorMessage;

  const AssetState({
    this.status = AssetStatus.initial,
    this.asset,
    this.errorMessage,
  });

  AssetState copyWith({
    AssetStatus? status,
    Asset? asset,
    String? errorMessage,
  }) {
    return AssetState(
      status: status ?? this.status,
      asset: asset ?? this.asset,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, asset, errorMessage];
}
