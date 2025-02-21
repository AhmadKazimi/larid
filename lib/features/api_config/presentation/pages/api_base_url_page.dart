import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/widgets/gradient_page_layout.dart';

class ApiBaseUrlPage extends StatefulWidget {
  const ApiBaseUrlPage({super.key});

  @override
  State<ApiBaseUrlPage> createState() => _ApiBaseUrlPageState();
}

class _ApiBaseUrlPageState extends State<ApiBaseUrlPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController(
    // TODO: remove for production
    text: "https://cloud.larid.net/api/sr"
  );

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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: BlocListener<ApiConfigBloc, ApiConfigState>(
        listener: (context, state) {
          state.maybeWhen(
            saved: () {
              context.go(RouteConstants.login);
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        child: GradientPageLayout(
          child: Column(
            children: [
              const SizedBox(height: 32),
              GradientFormCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.apiConfiguration,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.enterApiBaseUrl,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: l10n.baseUrl,
                          hintText: l10n.baseUrlHint,
                          prefixIcon: const Icon(Icons.link),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterUrl;
                          }
                          if (!_isValidUrl(value)) {
                            return l10n.pleaseEnterValidUrl;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<ApiConfigBloc, ApiConfigState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.maybeWhen(
                                loading: () => null,
                                orElse: () => _saveBaseUrl,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: state.maybeWhen(
                                loading: () => const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                orElse: () => Text(
                                  l10n.saveAndContinue,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
