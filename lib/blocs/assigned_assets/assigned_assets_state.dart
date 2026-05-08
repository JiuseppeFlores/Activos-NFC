import 'package:activos_nfc_app/core/models/models.dart';
import 'package:equatable/equatable.dart';

enum AssignedAssetsStatus { initial, loading, success, error }

class AssignedAssetsState extends Equatable {
  final AssignedAssetsStatus status;
  final List<Asset> assets;
  final String? errorMessage;

  const AssignedAssetsState({
    this.status = AssignedAssetsStatus.initial,
    this.assets = const [],
    this.errorMessage,
  });

  AssignedAssetsState copyWith({
    AssignedAssetsStatus? status,
    List<Asset>? assets,
    String? errorMessage,
  }) {
    return AssignedAssetsState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, assets, errorMessage];
}
