import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {

  final String code;
  final ScanType type;

  const ProductScreen({
    super.key,
    required this.code,
    required this.type,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  late AccountBloc _accountBloc;
  User _user = User();
  Product _product = Product();
  bool _loading = true;

  void _loadProductByBarcode() async {
    final data = await _accountBloc.getProductByBarcode(context, widget.code);
    if(data != null){
      setState(() {
        _user = data['user'];
        _product = data['product'];
      });
    }
    setState(() => _loading = false);
  }

  void _loadProductByUIDTag() async {
    final data = await _accountBloc.getProductByUIDTag(context, widget.code);
    if(data != null){
      setState(() {
        _user = data['user'];
        _product = data['product'];
      });
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    if(widget.type == ScanType.barcode){
      _loadProductByBarcode();
    }else if(widget.type == ScanType.nfc){
      _loadProductByUIDTag();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.code,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: _loading 
              ? LoadingPage() 
              : ProductPage(
                  user: _user,
                  product: _product,
                ),
          ),
        ),
      ),
    );
  }
}