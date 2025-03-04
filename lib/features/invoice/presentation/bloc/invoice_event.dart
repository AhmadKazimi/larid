import 'package:flutter/foundation.dart';

@immutable
abstract class InvoiceEvent {
  const InvoiceEvent();
}

class InitializeInvoice extends InvoiceEvent {
  final String customerCode;
  
  const InitializeInvoice({required this.customerCode});
}

class AddItem extends InvoiceEvent {
  const AddItem();
}

class ReturnItem extends InvoiceEvent {
  const ReturnItem();
}

class UpdateComment extends InvoiceEvent {
  final String comment;
  
  const UpdateComment({required this.comment});
}

class SyncInvoice extends InvoiceEvent {
  const SyncInvoice();
}

class SubmitInvoice extends InvoiceEvent {
  const SubmitInvoice();
}

class PrintInvoice extends InvoiceEvent {
  const PrintInvoice();
}
