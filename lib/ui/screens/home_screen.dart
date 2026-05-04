import 'dart:io';

import 'package:activos_nfc_app/blocs/account/account_bloc.dart';
import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/navigation/route_manager.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  late final WebViewController _controller;
  late final AccountBloc _accountBloc;
  late final Session _session;
  late final String _baseUrl;

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _session = _accountBloc.state.session;
    _baseUrl = dotenv.env['URL_SERVER'] ?? 'https://stisbolivia.com';
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if(url.contains('login')){
              _loginWeb(_session.username, _session.password);
            }
          },
        ),
      )
      ..enableZoom(false)
      ..loadRequest(Uri.parse(_baseUrl));

    controller.clearCache();

    if(kIsWeb || !Platform.isMacOS){
      controller.setBackgroundColor(const Color(0x80000000));
    }

    if(controller.platform is AndroidWebViewController){
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

  }

  void _loginWeb(String username, String password) async {
    await _controller.runJavaScript("""
      document.getElementById('user_name').value = '$username';
      document.getElementById('password').value = '$password';
      document.getElementById('boton-estilo').click();
    """);
  }

  void _logoutWeb() {
    _controller.loadRequest(Uri.parse('$_baseUrl/login/logout.php'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppData.appName,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.surface,
            ),
            onPressed: () {
              final accountBloc = BlocProvider.of<AccountBloc>(context);
              accountBloc.logout(context, _logoutWeb);
            },
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return SafeArea(
            child: PopScope(
              onPopInvokedWithResult: (didPop, result) async {
                if(didPop){
                  Navigator.of(context).pop();
                }else{
                  if(await _controller.canGoBack()){
                    _controller.goBack();
                  }else{
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                }
              },
              canPop: true,
              child: HomePage(
                controller: _controller,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => RouteManager.goToNFCScanning(context),
        label: Text('Escanear Activo'),
        icon: Icon(Icons.nfc),
      ),
    );
  }
}
