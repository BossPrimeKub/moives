import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviePage(),
    );
  }
}

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  Future<List<dynamic>> fetchShows() async {
    final url = Uri.parse(
      'https://api.tvmaze.com/search/shows?q=batman',
    );

    final response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Go to the Movies"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchShows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          final shows = snapshot.data!;

          return ListView.builder(
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index]['show'];

              return ListTile(
                leading: show['image'] != null
                    ? Image.network(
                  show['image']['medium'],
                  width: 50,
                )
                    : const Icon(Icons.movie),
                title: Text(show['name']),
                subtitle: Text(
                  show['summary']
                      ?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                      'ไม่มีเรื่องย่อ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
