import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/router/route_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_page_layout.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _workspaceController = TextEditingController(
    // TODO: remove for production
    text: "DEMO",
  );
  final _useridController = TextEditingController(
    // TODO: remove for production
    text: "101",
  );
  final _passwordController = TextEditingController(
    // TODO: remove for production
    text: "12345",
  );

  @override
  void dispose() {
    _workspaceController.dispose();
    _useridController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final userEntity = UserEntity(
        userid: _useridController.text,
        workspace: _workspaceController.text,
        password: _passwordController.text,
      );

      context.read<AuthBloc>().add(LoginEvent(userEntity: userEntity));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            context.go(RouteConstants.map);
          }
        },
        builder: (context, state) {
          return GradientPageLayout(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.background,
                          size: 24,
                        ),
                        onPressed: () => context.go(RouteConstants.apiConfig),
                      ),
                    ),
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
                              l10n.welcomeBack,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.signInToContinue,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _workspaceController,
                              decoration: InputDecoration(
                                labelText: l10n.workspace,
                                prefixIcon: const Icon(
                                  Icons.business,
                                  size: 20,
                                ),
                                labelStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.pleaseEnterWorkspace;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _useridController,
                              decoration: InputDecoration(
                                labelText: l10n.userId,
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  size: 20,
                                ),
                                labelStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.pleaseEnterUserId;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  size: 20,
                                ),
                                labelStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
                              obscureText: true,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return l10n.pleaseEnterPassword;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state is AuthLoading
                                        ? null
                                        : _onLoginPressed,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    state is AuthLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          l10n.login,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
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
        },
      ),
    );
  }
}
