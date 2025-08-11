import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String userName;

  const UserHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // box
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Greetings
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('July 14, 2024',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text('Hello, ',
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text('$userName!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),

          // Notification
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_active,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}