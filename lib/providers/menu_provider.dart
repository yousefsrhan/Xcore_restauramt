import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DynamicMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // هنا نخبر التطبيق بـ "مراقبة" مجموعة menu_items لحظياً
      stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('حدث خطأ في جلب البيانات');
        if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

        // تحويل البيانات القادمة من Firebase إلى قائمة (List)
        final menuDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: menuDocs.length,
          itemBuilder: (context, index) {
            var item = menuDocs[index];
            return ListTile(
              title: Text(item['name']), // سيظهر "Margherita Pizza"
              subtitle: Text("${item['price']} EGP"), // سيظهر "150 EGP"
              leading: Icon(Icons.fastfood),
            );
          },
        );
      },
    );
  }
}