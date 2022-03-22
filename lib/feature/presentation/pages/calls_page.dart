import 'package:flutter/material.dart';
import 'package:justmeet/feature/presentation/pages/sub_pages/single_item_call_page.dart';

import '../widgets/theme/style.dart';
class CallsPage extends StatelessWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return const SingleItemCallPage();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: primaryColor,
        child: const Icon(Icons.add_call,color: Colors.white,),
      ),
    );
  }
}