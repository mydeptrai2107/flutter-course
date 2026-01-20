import 'package:flutter/material.dart';

class MessagerPage extends StatefulWidget {
  const MessagerPage({super.key});

  @override
  State<MessagerPage> createState() => _MessagerPageState();
}

class _MessagerPageState extends State<MessagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tư vấn', style: TextStyle(fontSize: 20))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: Colors.lightBlueAccent,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send_rounded, color: Colors.lightBlueAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
