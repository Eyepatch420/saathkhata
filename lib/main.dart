import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/router/auth_state_notifier.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_provider.dart';
import 'core/localization/fallback_material_localizations.dart';
import 'core/services/storage_service.dart';
import 'core/utils/app_logger.dart';
import 'core/utils/bloc_observer.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  await dotenv.load(fileName: '.env');

  // Draw behind both the status bar and navigation bar so Flutter
  // controls the full screen. Screens add SafeArea where needed.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  AppLogger.i('App', '═══════════════════════════════════════');
  AppLogger.i('App', '  SaathKhata starting up');
  AppLogger.i('App', '═══════════════════════════════════════');

  // Wire global BLoC observer before any BLoC is created
  Bloc.observer = AppBlocObserver();
  AppLogger.i('App', 'BlocObserver registered');

  AppLogger.i('App', 'Initialising dependencies...');
  await configureDependencies();
  AppLogger.i('App', 'Dependencies ready');

  // Bridge AuthBloc → AuthStateNotifier so GoRouter re-evaluates redirect
  final authBloc = getIt<AuthBloc>();
  final authNotifier = getIt<AuthStateNotifier>();
  authBloc.stream.listen(authNotifier.onAuthStateChanged);
  AppLogger.i('App', 'Auth→Router bridge connected');

  // Populate the bloc from stored session on every cold start
  authBloc.add(const AuthCheckStatusRequested());

  AppLogger.i('App', 'Launching UI');

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(getIt<StorageService>()),
      child: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const SaathKhataApp(),
      ),
    ),
  );
}

class SaathKhataApp extends StatefulWidget {
  const SaathKhataApp({super.key});

  @override
  State<SaathKhataApp> createState() => _SaathKhataAppState();
}

class _SaathKhataAppState extends State<SaathKhataApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppLogger.i('Lifecycle', 'App widget mounted — observer registered');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppLogger.i('Lifecycle', 'App widget disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.i('Lifecycle', '▶ App RESUMED (foreground)');
      case AppLifecycleState.inactive:
        AppLogger.w('Lifecycle', '⏸ App INACTIVE (transitioning)');
      case AppLifecycleState.paused:
        AppLogger.w('Lifecycle', '⏸ App PAUSED (background / sleep)');
      case AppLifecycleState.detached:
        AppLogger.w('Lifecycle', '⏹ App DETACHED (process may be killed)');
      case AppLifecycleState.hidden:
        AppLogger.w('Lifecycle', '🙈 App HIDDEN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final localeProvider = Provider.of<LocaleProvider>(context);
        return MaterialApp.router(
          onGenerateTitle: (context) =>
              AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            // Must precede the Global* delegates so bho/mai borrow Hindi framework
            // strings instead of throwing (Flutter has no bho/mai bundle).
            ...fallbackLocalizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
