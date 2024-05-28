import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.all_inclusive, 'label': 'All'},
    {'icon': Icons.coffee, 'label': 'Cups'},
    {'icon': Icons.hourglass_empty, 'label': 'Vases'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},
    {'icon': Icons.dinner_dining, 'label': 'Plates'},
    // Add other categories as needed
  ];

  final List<Map<String, dynamic>> featuredProducts = [
    {'image': 'assets/logo.png', 'name': 'Product 1', 'price': '100'},
    {'image': 'assets/logo.png', 'name': 'Product 2', 'price': '150'},
    {'image': 'assets/logo.png', 'name': 'Product 3', 'price': '200'},
    // Add other featured products
  ];

  final List<Map<String, dynamic>> recentProducts = [
    {'image': 'assets/logo.png', 'name': 'Product 4', 'price': '50'},
    {'image': 'assets/logo.png', 'name': 'Product 5', 'price': '75'},
    {'image': 'assets/logo.png', 'name': 'Product 6', 'price': '120'},
    // Add other recent products
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Text(
              'Featured Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          featuredProducts[index]['image'],
                          height: 100,
                        ),
                        Text(featuredProducts[index]['name']),
                        Text('\$${featuredProducts[index]['price']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            Text(
              'Recent Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(
                      recentProducts[index]['image'],
                      height: 50,
                    ),
                    title: Text(recentProducts[index]['name']),
                    subtitle: Text('\$${recentProducts[index]['price']}'),
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
