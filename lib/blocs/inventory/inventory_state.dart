import 'package:equatable/equatable.dart';

enum InventoryStatus { initial, loading, success, error }

class InventoryState extends Equatable {
  final InventoryStatus status;
  final String? errorMessage;

  const InventoryState({
    this.status = InventoryStatus.initial,
    this.errorMessage,
  });

  InventoryState copyWith({
    InventoryStatus? status,
    String? errorMessage,
  }) {
    return InventoryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
