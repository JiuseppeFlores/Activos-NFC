import 'dart:io';
import 'package:activos_nfc_app/blocs/auth/auth_cubit.dart';
import 'package:activos_nfc_app/blocs/auth/auth_state.dart';
import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:activos_nfc_app/ui/views/dialogs/nfc_entry_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:activos_nfc_app/ui/screens/asset_detail_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  late final WebViewController _controller;
  late final String _baseUrl;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final username = authState.username ?? '';
    final password = authState.password ?? '';
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

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if(url.contains('login')){
              _loginWeb(username, password);
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'AndroidRegisterNFCCode',
        onMessageReceived: (JavaScriptMessage jsMessage) {
          final idActivo = jsMessage.message.toString();
          if(idActivo.isNotEmpty){
            _registerNFCCode(idActivo);
          }
        },
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

  void _registerNFCCode(String idActivo) {
    final id = int.tryParse(idActivo);
    if (id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssetDetailScreen(assetId: id),
        ),
      );
    }
  }

  void _handleLogout() {
    const action = 'CERRAR SESIÓN';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(action),
        content: const Text('¿Está seguro que desea salir de la sesión actual?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              _logoutWeb();
              await context.read<AuthCubit>().logout();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
            },
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if(didPop){
              return;
            }else{
              if(await _controller.canGoBack()){
                _controller.goBack();
              }
            }
          },
          canPop: true,
          child: HomePage(
            controller: _controller,
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final userRole = state.authResponse?.user.roleId;
          final canScan = userRole == 1 || userRole == 2;
          
          if (!canScan) return const SizedBox();

          return FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ScanEntryDialog(),
              );
            },
            label: const Text('Escanear Activo'),
            icon: const Icon(Icons.qr_code_scanner),
          );
        },
      ),
    );
  }
}
