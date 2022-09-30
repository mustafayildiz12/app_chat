
import 'package:app_chat/core/service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BeePremiumPage extends StatefulWidget {
  const BeePremiumPage({Key? key}) : super(key: key);

  @override
  State<BeePremiumPage> createState() => _BeePremiumPageState();
}

class _BeePremiumPageState extends State<BeePremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: DatabaseService().ardunioStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent databaseEvent = snapshot.data as DatabaseEvent;

            Map linkedHashMap = (databaseEvent.snapshot.value as Map);
            List ardunio = linkedHashMap.values.toList();

            ardunio.sort((a, b) => a.compareTo(b));

            return ListView.builder(
              itemCount: ardunio.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ardunio[index].toString(),
                ),);
              },
            );

            // return const Center(child: Text("Data Var"));
          }
          return const Center(child: Text("Henüz mesaj yok"));
        },
      ),
    );
  }
}
