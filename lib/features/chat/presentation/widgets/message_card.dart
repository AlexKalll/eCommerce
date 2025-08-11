import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${message.sender.name}: ${message.content}'),
    ));
  }
}