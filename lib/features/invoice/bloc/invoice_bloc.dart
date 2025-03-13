import '../../../../core/di/service_locator.dart'; // Import for getIt
import '../../../../features/auth/domain/repositories/auth_repository.dart'; // Import for AuthRepository
import '../../../../core/network/api_service.dart';
import '../../../../database/invoice_table.dart'; // Fixed import path
import '../presentation/bloc/invoice_event.dart';
import '../presentation/bloc/invoice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/sync/domain/entities/customer_entity.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  // Add this field
  final dynamic _taxCalculator; // Update with actual type if available

  // Create a constructor that accepts dependency injection
  InvoiceBloc()
    : _taxCalculator = null,
      // Create a dummy customer for initialization - this will be overridden soon
      super(
        InvoiceState.initial(
          const CustomerEntity(customerCode: '', customerName: ''),
        ),
      ) {
    // Event handlers
    on<SyncInvoice>(_onSyncInvoice);
    on<SubmitInvoice>(_onSubmitInvoice);
    // Other event handlers...
  }

  // User credential methods
  Future<String> getUserId() async {
    // Get user ID from the auth repository
    final user = await getIt<AuthRepository>().getCurrentUser();
    return user?.userid ?? '';
  }

  Future<String> getWorkspace() async {
    // Get workspace from the auth repository
    final user = await getIt<AuthRepository>().getCurrentUser();
    return user?.workspace ?? '';
  }

  Future<String> getPassword() async {
    // Get password from the auth repository
    final user = await getIt<AuthRepository>().getCurrentUser();
    return user?.password ?? '';
  }

  // Return the tax calculator
  dynamic getTaxCalculator() {
    return _taxCalculator;
  }

  // SyncInvoice event handler
  Future<void> _onSyncInvoice(
    SyncInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      // Set syncing flag to true
      emit(state.copyWith(isSyncing: true));

      // Get user credentials
      final authRepository = getIt<AuthRepository>();
      final user = await authRepository.getCurrentUser();

      if (user == null) {
        emit(
          state.copyWith(isSyncing: false, errorMessage: 'User not logged in'),
        );
        return;
      }

      // Get API service
      final apiService = getIt<ApiService>();

      // Check if we have items to upload
      if (state.items.isEmpty) {
        emit(
          state.copyWith(isSyncing: false, errorMessage: 'No items to upload'),
        );
        return;
      }

      // Format items for API
      final List<Map<String, dynamic>> formattedItems =
          state.items.map((item) {
            // Use already calculated tax values from the invoice item
            final taxAmount = item.taxAmount; // Use existing tax amount
            final taxRate = item.taxRate; // Use existing tax rate

            // Ensure all numeric values are properly cast to double
            final quantity = item.quantity.toDouble(); // Convert int to double
            final price =
                item.item.sellUnitPrice.toDouble(); // Ensure it's double

            return {
              'sItem_cd': item.item.itemCode,
              'sDescription': item.item.description,
              'sSellUnit_cd': item.item.sellUnitCode,
              'qty': quantity,
              'mSellUnitPrice_amt': price,
              'sTax_cd': item.item.taxCode,
              'taxAmount': taxAmount,
              'taxPercentage': taxRate,
            };
          }).toList();

      // Upload the invoice
      final invoiceNumber = await apiService.uploadInvoice(
        // Auth parameters
        userid: user.userid,
        workspace: user.workspace,
        password: user.password,

        // Customer details
        customerCode: state.customer.customerCode,
        customerName: state.customer.customerName,
        customerAddress: state.customer.address ?? '',
        invoiceReference: state.invoiceNumber ?? '',
        comments: state.comment,

        // Invoice items
        items: formattedItems,
      );

      // Update state with success
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: null,
          // Add any other state updates needed
        ),
      );

      // Log success
      print('Invoice uploaded successfully with number: $invoiceNumber');
    } catch (e) {
      // Update state with error
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: 'Error syncing invoice: ${e.toString()}',
        ),
      );

      // Log error
      print('Error syncing invoice: ${e.toString()}');
    }
  }

  Future<void> _onSubmitInvoice(
    SubmitInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      // Get user ID for formatting invoice number
      final userId = await getUserId();

      // Get next invoice number and format it with user ID
      final nextInvoiceNumber =
          await getIt<InvoiceTable>().getNextInvoiceNumber();
      final formattedInvoiceNumber =
          userId.isNotEmpty ? '$userId-$nextInvoiceNumber' : nextInvoiceNumber;

      // Save invoice with formatted number
      final invoiceId = await getIt<InvoiceTable>().saveInvoice(
        invoiceNumber: formattedInvoiceNumber, // Use formatted number here
        customer: state.customer,
        invoiceState: state,
        isReturn: event.isReturn,
      );

      // Update state with the new formatted invoice number
      emit(
        state.copyWith(
          isSubmitting: false,
          invoiceNumber: formattedInvoiceNumber,
        ),
      );

      print(
        'Invoice saved successfully with ID: $invoiceId and number: $formattedInvoiceNumber',
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Error submitting invoice: ${e.toString()}',
        ),
      );
      print('Error submitting invoice: $e');
    }
  }
}
