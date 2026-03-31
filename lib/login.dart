import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: unused_import
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: unused_import
import 'home.dart';
// ignore: unused_import
import"plant_selection.dart";





class LoginPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange; // ✅ Callback for language change

  const LoginPage({super.key, required this.onLocaleChange});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(AppLocalizations) {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/plant-selection');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterCredentials),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // 🌐 shorthand

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌐 App Title
              Text(
                loc.appTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F9D69),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              // Username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: loc.usernameHint, // 🌐 localized
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: loc.passwordHint, // 🌐 localized
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login button
              ElevatedButton(
                onPressed: () => _login(AppLocalizations.of(context)!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F9D69),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  loc.loginButton, // 🌐 localized
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // 🌐 Language Switcher
              DropdownButton<Locale>(
                value: Localizations.localeOf(context),
                onChanged: (newLocale) {
                  if (newLocale != null) {
                    widget.onLocaleChange(newLocale); // ✅ update app locale
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text("English"),
                  ),
                  DropdownMenuItem(
                    value: Locale('hi'),
                    child: Text("हिन्दी"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
