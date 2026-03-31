import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat.dart';
import 'package:flutter_application_1/shop.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String _prediction = "";
  bool _loading = false;
  final picker = ImagePicker();

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _prediction = "";
      });
      await _uploadAndPredict(_image!);
    }
  }

  // Upload image to backend and get prediction
  Future<void> _uploadAndPredict(File imageFile) async {
    setState(() => _loading = true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/predict'), // Change if using real device
      );
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var data = jsonDecode(respStr);
        setState(() {
          _prediction =
              "${data['label']} (Confidence: ${(data['confidence']*100).toStringAsFixed(2)}%)";
        });
      } else {
        setState(() {
          _prediction = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _prediction = "Error: $e";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // Show picker dialog
  Future<void> _showPickerDialog() async {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF1F8F6),
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

  // Show guide dialog
  void _showGuideDialog() {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF1F8F6),
        title: Text(
          loc.guideTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            '${loc.guideScanLeaf}\n\n'
            '${loc.guideShop}\n\n'
            '${loc.guideGuide}\n\n'
            '${loc.guideChatbot}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Build Home Button
  Widget _buildHomeButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF4F9D69)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Scaffold(body: Center(child: Text("Localization not loaded")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      appBar: AppBar(
        title: const Text(
          'Krishi Suraksha',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4F9D69),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Welcome, Farmer!',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                color: Color(0xFF4F9D69),
              ),
            ),
          if (!_loading && _prediction.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _prediction,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                // Toggle between English and Hindi
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
    );
  }
}
