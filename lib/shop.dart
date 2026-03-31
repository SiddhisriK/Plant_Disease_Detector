import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Organic Fertilizer',
      'price': '₹250',
      'link': 'https://katyayanikrishidirect.com/collections/organic-fertilizer',
      'icon': Icons.eco,
    },
    {
      'name': 'Insecticide Spray',
      'price': '₹300',
      'link': 'https://krushidukan.bharatagri.com/en/collections/best-insecticides-and-pesticides-online/products/actara-25-wg-insecticide',
      'icon': Icons.bug_report,
    },
    {
      'name': 'Neem Oil',
      'price': '₹150',
      'link': 'https://nativeindianorganics.com/collections/organic-oils/products/neem-oil',
      'icon': Icons.opacity,
    },
    {
      'name': 'Soil Tester',
      'price': '₹500',
      'link': 'https://krushidukan.bharatagri.com/en/collections/best-soil-testers-online',
      'icon': Icons.science,
    },
    {
      'name': 'Vermicompost',
      'price': '₹200',
      'link': 'https://nativeindianorganics.com/collections/organic-fertilizer/products/vermicompost',
      'icon': Icons.grass,
    },
    {
      'name': 'Bio Fertilizer',
      'price': '₹180',
      'link': 'https://katyayanikrishidirect.com/collections/organic-fertilizer',
      'icon': Icons.agriculture,
    },
    {
      'name': 'Actara 25 WG Insecticide',
      'price': '₹450',
      'link': 'https://krushidukan.bharatagri.com/en/collections/best-insecticides-and-pesticides-online/products/actara-25-wg-insecticide',
      'icon': Icons.bug_report,
    },
    {
      'name': 'Bone Meal',
      'price': '₹150',
      'link': 'https://katyayanikrishidirect.com/collections/organic-fertilizer',
      'icon': Icons.eco,
    },
  ];

  List<Map<String, dynamic>> displayedProducts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedProducts = products;
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _filterProducts(String query) {
    final filtered = products.where((product) {
      final name = product['name']!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: const Color(0xFF4F9D69),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterProducts,
            ),
            const SizedBox(height: 12),
            // Grid of products
            Expanded(
              child: displayedProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: displayedProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: InkWell(
                            onTap: () => _launchURL(product['link']),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Placeholder icon (instead of image)
                                Icon(
                                  product['icon'],
                                  size: 50,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  product['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product['price'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
