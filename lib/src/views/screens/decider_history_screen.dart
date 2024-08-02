import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DeciderHistoryScreen extends StatelessWidget {
  const DeciderHistoryScreen({super.key});

  Future<List<Map<String, dynamic>>> _getDeciderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedDecisions = prefs.getStringList('decisions') ?? [];

    return storedDecisions.map((decision) {
      return jsonDecode(decision) as Map<String, dynamic>;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karar Verme'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getDeciderHistory(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz bir karar alınmamış.'));
          } else {
            snapshot.data!.sort((a, b) {
              return DateTime.parse(b['timestamp'])
                  .compareTo(DateTime.parse(a['timestamp']));
            });
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                time = DateTime.parse(snapshot.data![index]['timestamp']);
                List<String> options =
                    snapshot.data![index]['options'].cast<String>();
                final decision = snapshot.data![index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('Çıkan Karar: ${decision['selectedOption']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Tarih: ${(time.day).toString().padLeft(2, '0')}/${(time.month).toString().padLeft(2, '0')}/${time.year} ${(time.hour).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
                      Text('Girilen Seçenekler: ${options.join(', ')}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      List<String> storedDecisions =
                          prefs.getStringList('decisions') ?? [];

                      storedDecisions.removeAt(index);

                      await prefs.setStringList('decisions', storedDecisions);

                      Navigator.pushReplacementNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          '/decider_history_screen');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
