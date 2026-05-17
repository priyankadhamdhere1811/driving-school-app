import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/enquiry_model.dart';

class EnquiryService {
  final SupabaseClient _client;

  EnquiryService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<List<EnquiryModel>> fetchEnquiries() async {
    final response = await _client
        .from('enquiries')
        .select()
        .order('created_at', ascending: false);

    return response
        .map((row) => EnquiryModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<EnquiryModel> createEnquiry(EnquiryModel enquiry) async {
    final response =
        await _client
            .from('enquiries')
            .insert(enquiry.toJson())
            .select()
            .single();

    return EnquiryModel.fromMap(Map<String, dynamic>.from(response));
  }
}
