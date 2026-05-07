import 'package:activos_nfc_app/common/data/data.dart';

class Asset {
  final int id;
  final String name;
  final String barcode;
  final String? dateIngress;
  final String? valuation;
  final String? status;
  final String? nfcTag;

  Asset({
    required this.id,
    required this.name,
    required this.barcode,
    this.dateIngress,
    this.valuation,
    this.status,
    this.nfcTag,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['idProducto'] ?? DefaultData.int,
      name: json['producto'] ?? DefaultData.string,
      barcode: json['codigoBarras'] ?? DefaultData.string,
      dateIngress: json['fechaIngreso'],
      valuation: json['valoracion'],
      status: json['estado'],
      nfcTag: json['uidTag'],
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
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      dateIngress: dateIngress ?? this.dateIngress,
      valuation: valuation ?? this.valuation,
      status: status ?? this.status,
      nfcTag: nfcTag ?? this.nfcTag,
    );
  }

  @override
  String toString() => 'Asset{id: $id, name: $name, nfcTag: $nfcTag}';
}
