import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/user.dart';

class Asset {
  final int id;
  final String name;
  final String barcode;
  final String? dateIngress;
  final String? valuation;
  final String? status;
  final String? nfcTag;
  final bool isInventoried;
  final User? assignedUser;

  Asset({
    required this.id,
    required this.name,
    required this.barcode,
    this.dateIngress,
    this.valuation,
    this.status,
    this.nfcTag,
    this.isInventoried = false,
    this.assignedUser,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['idProducto'] ?? DefaultData.int,
      name: json['producto'] ?? DefaultData.string,
      barcode: json['codigoBarras'] ?? DefaultData.string,
      dateIngress: json['fechaIngreso'],
      valuation: json['valoracion'],
      status: json['estadoActivo'] ?? json['estado'],
      nfcTag: json['uidTag'],
      isInventoried: json['inventariado'] ?? false,
      assignedUser: json.containsKey('nombre') ? User.fromJson(json) : null,
    );
  }

  Asset copyWith({
    int? id,
    String? name,
    String? barcode,
    String? dateIngress,
    String? valuation,
    String? status,
    String? nfcTag,
    bool? isInventoried,
    User? assignedUser,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      dateIngress: dateIngress ?? this.dateIngress,
      valuation: valuation ?? this.valuation,
      status: status ?? this.status,
      nfcTag: nfcTag ?? this.nfcTag,
      isInventoried: isInventoried ?? this.isInventoried,
      assignedUser: assignedUser ?? this.assignedUser,
    );
  }

  @override
  String toString() => 'Asset{id: $id, name: $name, nfcTag: $nfcTag, inventoried: $isInventoried}';
}
