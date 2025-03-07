import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:larid/features/api_config/presentation/bloc/api_config_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/gradient_page_layout.dart';
import '../../../../core/theme/app_theme.dart';

class ApiBaseUrlPage extends StatefulWidget {
  const ApiBaseUrlPage({super.key});

  @override
  State<ApiBaseUrlPage> createState() => _ApiBaseUrlPageState();
}

class _ApiBaseUrlPageState extends State<ApiBaseUrlPage> {
  final _formKey = GlobalKey<FormState>();
  static const String _urlPrefix = 'https://';
  static const String _urlSuffix = '/api/sr';
  final _urlController = TextEditingController(text: "cloud.larid.net");

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  bool _isValidDomain(String domain) {
    // Basic domain validation: at least one dot and no spaces
    return domain.contains('.') && !domain.contains(' ');
  }

  String _getFullUrl() {
    final domain = _urlController.text.trim();
    // Remove any accidentally entered prefixes or suffixes
    final cleanDomain = domain
        .replaceAll(_urlPrefix, '')
        .replaceAll(_urlSuffix, '')
        .replaceAll('https://', '')
        .replaceAll('http://', '');
    return '$_urlPrefix$cleanDomain$_urlSuffix';
  }

  void _saveBaseUrl() {
    if (!_formKey.currentState!.validate()) return;

    final fullUrl = _getFullUrl();
    context.read<ApiConfigBloc>().add(ApiConfigEvent.saveBaseUrl(fullUrl));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocListener<ApiConfigBloc, ApiConfigState>(
        listener: (context, state) {
          state.maybeWhen(
            saved: () {
              context.go(RouteConstants.login);
            },
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            orElse: () {},
          );
        },
        child: GradientPageLayout(
          useScroll: false,
          child: SafeArea(
            child: Column(
              children: [
                GradientFormCard(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset('assets/images/img_larid2.png'),
                ),
                const SizedBox(height: 16),
                GradientFormCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.apiConfiguration,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.enterApiBaseUrl,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              labelText: l10n.baseUrl,
                              hintText: 'cloud.larid.net',
                              prefixIcon: const Icon(Icons.link, size: 20),
                              helperText: 'Enter only the domain name',
                              helperStyle: TextStyle(fontSize: 12),
                              labelStyle: TextStyle(fontSize: 14),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              isDense: true,
                            ),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseEnterUrl;
                              }
                              if (!_isValidDomain(value.trim())) {
                                return 'Please enter a valid domain (e.g., cloud.larid.net)';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: state.maybeWhen(
                                  loading:
                                      () => const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                  orElse:
                                      () => Text(
                                        l10n.saveAndContinue,
                                        style: const TextStyle(
                                          fontSize: 14,
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
      ),
    );
  }
}
