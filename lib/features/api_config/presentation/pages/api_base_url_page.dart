import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import 'package:larid/features/auth/presentation/pages/login_page.dart';

class ApiBaseUrlPage extends StatefulWidget {
  const ApiBaseUrlPage({Key? key}) : super(key: key);

  @override
  State<ApiBaseUrlPage> createState() => _ApiBaseUrlPageState();
}

class _ApiBaseUrlPageState extends State<ApiBaseUrlPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isScheme('http') || uri.isScheme('https');
    } catch (e) {
      return false;
    }
  }

  void _saveBaseUrl() {
    if (!_formKey.currentState!.validate()) return;
    
    context.read<ApiConfigBloc>().add(
      ApiConfigEvent.saveBaseUrl(_urlController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Configuration'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ApiConfigBloc, ApiConfigState>(
        listener: (context, state) {
          state.maybeWhen(
            saved: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter API Base URL',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Base URL',
                    hintText: 'https://api.example.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }
                    if (!_isValidUrl(value)) {
                      return 'Please enter a valid URL starting with http:// or https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<ApiConfigBloc, ApiConfigState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => _saveBaseUrl,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.maybeWhen(
                        loading: () => const CircularProgressIndicator(),
                        orElse: () => const Text('Save and Continue'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
