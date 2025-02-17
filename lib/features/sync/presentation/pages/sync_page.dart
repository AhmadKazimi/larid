import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';

class SyncPage extends StatelessWidget {
  final String userid;
  final String workspace;
  final String password;

  const SyncPage({
    super.key,
    required this.userid,
    required this.workspace,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Data')),
      body: BlocConsumer<SyncBloc, SyncState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            success: (customers) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully synced ${customers.length} customers',
                  ),
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial:
                () => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SyncBloc>().add(
                        SyncEvent.syncCustomers(
                          userid: userid,
                          workspace: workspace,
                          password: password,
                        ),
                      );
                    },
                    child: const Text('Start Sync'),
                  ),
                ),
            loading:
                () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Syncing customers...'),
                    ],
                  ),
                ),
            success:
                (customers) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text('${customers.length} customers synced'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SyncBloc>().add(
                            SyncEvent.syncCustomers(
                              userid: userid,
                              workspace: workspace,
                              password: password,
                            ),
                          );
                        },
                        child: const Text('Sync Again'),
                      ),
                    ],
                  ),
                ),
            error:
                (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SyncBloc>().add(
                            SyncEvent.syncCustomers(
                              userid: userid,
                              workspace: workspace,
                              password: password,
                            ),
                          );
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
}
