import 'package:flutter/material.dart';

class CeramicShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceramic Shop',
      home: CeramicShopHomePage(),
    );
  }
}

class CeramicShopHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.all_inclusive, 'label': 'All'},
    {'icon': Icons.coffee, 'label': 'Cups'},
    {'icon': Icons.hourglass_empty, 'label': 'Vases'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},

    // Add other categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ceramic Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Handle category tap
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(categories[index]['icon']),
                          Text(categories[index]['label']),
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
