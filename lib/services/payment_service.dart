import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/payment_model.dart';

class PaymentService {
  final SupabaseClient _client;

  PaymentService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<List<PaymentModel>> fetchPayments() async {
    final response = await _client
        .from('payments')
        .select()
        .order('payment_date', ascending: false);

    return response
        .map((row) => PaymentModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<PaymentModel>> fetchPaymentsByStudentId(String studentId) async {
    final response = await _client
        .from('payments')
        .select()
        .eq('student_id', studentId)
        .order('payment_date', ascending: false);

    return response
        .map((row) => PaymentModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final response =
        await _client
            .from('payments')
            .insert(payment.toJson())
            .select()
            .single();

    return PaymentModel.fromMap(Map<String, dynamic>.from(response));
  }
}
