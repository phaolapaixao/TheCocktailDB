import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/drink_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider para gerenciar drinks
        ChangeNotifierProvider(create: (_) => DrinkProvider()),

        // Provider para gerenciar tema
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'DrinkFinder',
            debugShowCheckedModeBanner: false,

            // Tema claro
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              cardTheme: const CardThemeData(elevation: 2),
            ),

            // Tema escuro
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              cardTheme: const CardThemeData(elevation: 2),
            ),

            // Modo do tema (system, light ou dark)
            themeMode: themeProvider.themeMode,

            // Tela inicial
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
