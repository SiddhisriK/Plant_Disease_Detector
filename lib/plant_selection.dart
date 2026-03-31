// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login.dart';


class PlantSelectionPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange; // 👈 add this

  const PlantSelectionPage({super.key, required this.onLocaleChange});

  @override
  State<PlantSelectionPage> createState() => _PlantSelectionPageState();
}

class _PlantSelectionPageState extends State<PlantSelectionPage> {
  final List<Map<String, String>> plants = const [
    {"name": "Cherry", "image": "assets/plants/cherry.png"},
    {"name": "Potato", "image": "assets/plants/potato.png"},
    {"name": "Tomato", "image": "assets/plants/tomato.png"},
    {"name": "Grape", "image": "assets/plants/grape.png"},
    {"name": "Corn", "image": "assets/plants/corn.png"},
    {"name": "Peach", "image": "assets/plants/peach.png"},
    {"name": "Apple", "image": "assets/plants/apple.png"},
    {"name": "Orange", "image": "assets/plants/orange.png"},
    {"name": "Bell Pepper", "image": "assets/plants/bellpepper.png"},
  ];

  final Set<String> selectedPlants = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.whichPlants,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFA9DBCA),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'en') {
                widget.onLocaleChange(const Locale('en'));
              } else if (value == 'hi') {
                widget.onLocaleChange(const Locale('hi'));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text("English")),
              const PopupMenuItem(value: 'hi', child: Text("हिन्दी")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.builder(
                itemCount: plants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  final isSelected = selectedPlants.contains(plant['name']);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedPlants.remove(plant['name']);
                        } else {
                          selectedPlants.add(plant['name']!);
                        }
                      });
                    },
                    child: Card(
                      elevation: isSelected ? 8 : 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isSelected
                            ? const BorderSide(color: Colors.green, width: 2)
                            : BorderSide.none,
                      ),
                      color: const Color(0xFFF1F8F6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                plant['image']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plant['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.green[800]
                                  : Colors.black87,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedPlants.length <= 5
                  ? () {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F9D69),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.continueButton(
                  selectedPlants.length,
                  
                ),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
