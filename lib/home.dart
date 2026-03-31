import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat.dart';
import 'package:flutter_application_1/shop.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class HomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String _disease = "";
  String _confidence = "";
  bool _loading = false;
  bool _showOverlay = false;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _disease = "";
        _confidence = "";
      });
      await _uploadAndPredict(_image!);
    }
  }

  Future<void> _uploadAndPredict(File imageFile) async {
    setState(() => _loading = true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/predict'), // Replace with your backend URL
      );
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var data = jsonDecode(respStr);

        setState(() {
          _disease = data['label'] ?? "None";
          _confidence = ((data['confidence'] ?? 1.0) * 100).toStringAsFixed(0) + "%";
          _showOverlay = true;
        });
      } else {
        setState(() {
          _disease = "Error: ${response.statusCode}";
          _confidence = "-";
          _showOverlay = true;
        });
      }
    } catch (e) {
      setState(() {
        _disease = "Error: $e";
        _confidence = "-";
        _showOverlay = true;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _showPickerDialog() async {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE8F5E9),
        title: Text(
          loc.selectImage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: Text(loc.camera),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: Text(loc.gallery),
          ),
        ],
      ),
    );
  }

  Future<void> _showGuideDialog() async {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE8F5E9),
        title: Text(
          loc.guide,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Guide content goes here"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overlayCard() {
    return _showOverlay
        ? Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),
              Center(
                child: Card(
                  color: Colors.white.withOpacity(0.95),
                  elevation: 14,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Detection Result",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32)),
                        ),
                        const SizedBox(height: 15),
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_image!, height: 150),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 15),
                        Text("Result: $_disease",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 5),
                        Text("Confidence: $_confidence",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => setState(() => _showOverlay = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return const Scaffold(body: Center(child: Text("Localization not loaded")));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Krishi Suraksha',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Welcome, Farmer!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121)),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    childAspectRatio: 1,
                    children: [
                      _buildHomeButton(loc.scanLeaf, Icons.camera_alt, _showPickerDialog),
                      _buildHomeButton(loc.shop, Icons.storefront, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ShopPage()),
                        );
                      }),
                      _buildHomeButton(loc.guide, Icons.menu_book, _showGuideDialog),
                      _buildHomeButton(loc.kisanMitra, Icons.chat, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatBotPage()),
                        );
                      }),
                    ],
                  ),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      final currentLocale = Localizations.localeOf(context);
                      if (currentLocale.languageCode == 'en') {
                        widget.onLocaleChange(const Locale('hi'));
                      } else {
                        widget.onLocaleChange(const Locale('en'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                    ),
                    child: Text(loc.changeLanguageButton),
                  ),
                ),
              ],
            ),
            _overlayCard(),
          ],
        ),
      ),
    );
  }
}