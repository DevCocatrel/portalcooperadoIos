import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_controller.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/styles/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final authProvider = AuthProvider();
  await Future.wait([
    App.setInternetStatus(),
    authProvider.initializeWithSplash(),
    App.getDeviceInfo(),
  ]);

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => AppController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 3), () {
      InternetConnection().onStatusChange.listen((status) {
        App.hasInternet = InternetStatus.connected == status;
        switch (status) {
          // Verifica se há conexão
          case InternetStatus.connected:
            final currentRoute = App.routeObserver.currentRoute;

            // Verifica se a tela WithoutPage é a atual
            if (currentRoute == AppRoutes.withoutNetwork) {
              final context = App.navigatorKey.currentContext!;
              if (context.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final authProvider = context.read<AuthProvider>();

                  if (authProvider.user == null) {
                    await authProvider.initializeWithSplash();
                  }

                  if (context.mounted) {
                    if (authProvider.user == null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login, (_) => false);
                    } else {
                      final canPop = Navigator.of(context).canPop();
                      if (canPop) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.home, (_) => false);
                      }
                    }
                  }
                });
              }
            }

            break;
          case InternetStatus.disconnected:
            final currentRoute = App.routeObserver.currentRoute;
            if (currentRoute != AppRoutes.withoutNetwork) {
              if (App.navigatorKey.currentContext != null) {
                Navigator.of(App.navigatorKey.currentContext!)
                    .pushNamed(AppRoutes.withoutNetwork);
              }
            }
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {}

    if (state == AppLifecycleState.resumed) {
      Provider.of<AuthProvider>(context, listen: false).checkTokenExpiration();
    }
  }

  @override
  Widget build(BuildContext context) {
    var read = context.read<AuthProvider>();
    return MaterialApp(
      title: 'Cocatrel',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      navigatorObservers: [App.routeObserver],
      supportedLocales: const [Locale('pt', 'BR')],
      navigatorKey: App.navigatorKey,
      routes: appRoutes,
      initialRoute: read.initialRoute,
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primaryColor;
              }
              return Colors.white;
            },
          ),
          checkColor: WidgetStateProperty.resolveWith(
            (states) {
              return Colors.white;
            },
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.borderColor),
          ),
          shadowColor: AppColors.shadowColor.withValues(alpha: .15),
          backgroundColor: AppColors.backgroundColor,
          dividerColor: AppColors.borderColor,
          weekdayStyle: AppFonts.text,
          dayStyle: AppFonts.text,
          yearStyle: AppFonts.text,
          headerHelpStyle: AppFonts.text,
          headerHeadlineStyle: AppFonts.title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          cancelButtonStyle: datePickerButtonStyle(),
          confirmButtonStyle: datePickerButtonStyle(),
          dayShape: WidgetStateProperty.resolveWith((state) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            );
          }),
          yearBackgroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.backgroundColor;
          }),
          todayForegroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return AppColors.backgroundColor;
            }
            return AppColors.primaryColor;
          }),
          todayBackgroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.backgroundColor;
          }),
          todayBorder: const BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
          dayBackgroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.backgroundColor;
          }),
          dayForegroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return Colors.white;
            } else if (state.contains(WidgetState.disabled)) {
              return AppColors.textColor.withValues(alpha: .5);
            }
            return AppColors.textColor;
          }),
        ),
        radioTheme:
            RadioThemeData(fillColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return AppColors.primaryColor;
          }
          return AppColors.borderDarkColor;
        })),
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
            .copyWith(
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: AppColors.borderColor,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          actionsPadding: const EdgeInsets.all(16),
          titleTextStyle: AppFonts.title,
          contentTextStyle: AppFonts.text,
          barrierColor: Colors.transparent,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.success,
          contentTextStyle: AppFonts.text.copyWith(color: Colors.white),
          actionTextColor: Colors.white,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.resolveWith((state) {
              return AppFonts.textButton;
            }),
            backgroundColor: WidgetStateProperty.resolveWith(
              (state) {
                return AppColors.backgroundColor;
              },
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.borderColor,
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.all(10),
            iconColor: AppColors.buttonTextLight,
            textStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonTextLight,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        canvasColor: AppColors.backgroundColor,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: border,
          enabledBorder: border,
          border: border,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  ButtonStyle datePickerButtonStyle() {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((state) {
        return AppColors.buttonTextLight;
      }),
      textStyle: WidgetStateProperty.resolveWith((state) {
        return GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );
      }),
    );
  }
}
