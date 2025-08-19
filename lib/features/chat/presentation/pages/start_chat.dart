import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/chat/chat_bloc.dart';

class StartChatPage extends StatefulWidget {
  const StartChatPage({super.key});

  @override
  State<StartChatPage> createState() => _StartChatPageState();
}

class _StartChatPageState extends State<StartChatPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start New Chat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Start a Conversation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the email address of the person you want to chat with. '
                      'They must be registered users of this app.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email Input
              Text(
                'User Email',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter user email (e.g., user@gmail.com)',
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _startChat(),
              ),
              const SizedBox(height: 24),

              // Start Chat Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _emailController.text.trim().isEmpty || _isLoading
                      ? null
                      : _startChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Starting Chat...'),
                          ],
                        )
                      : const Text(
                          'Start Chat',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Example
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user@gmail.com',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startChat() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showError(context, 'Please enter an email address');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showError(context, 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Here you would typically call the initiateChat use case
      // For now, we'll simulate the process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        showInfo(context, 'Chat initiated successfully!');
        context.pop(); // Go back to chats page
      }
    } catch (e) {
      if (mounted) {
        showError(context, 'Failed to start chat. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
