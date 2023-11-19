import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(), // Replace with your custom search delegate
              );
            },
          ),
          IconButton(
            icon: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              // Implement your logic to add/remove from favorites here
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Favorites under construction"),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results view
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions view
    return Center(
      child: Text('Search suggestions for: $query'),
    );
  }
}
