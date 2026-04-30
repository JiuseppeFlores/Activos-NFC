import 'package:activos_empresa_app/common/data/data.dart';

class Product {

  final int _id;
  final String _name;
  final String _barcode;

  Product({
    int id = DefaultData.int,
    String name = DefaultData.string,
    String barcode = DefaultData.string,
  }) : _id = id, _name = name, _barcode = barcode;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['idProducto'] ?? DefaultData.int,
      name: json['producto'] ?? DefaultData.string,
      barcode: json['codigoBarras'] ?? DefaultData.string,
    );
  }

  static List<Product> fromList(List<dynamic> array) => array.map((item) => Product.fromJson(item)).toList();

  int get id => _id;
  String get name => _name;
  String get barcode => _barcode;

  @override
  String toString() 
    => 'Product{ '
          'id=$_id, '
          'name=$_name, '
          'barcode=$_barcode '
        '}';

}