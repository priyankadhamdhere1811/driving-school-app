import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reminder_model.dart';

class ReminderService {
  final SupabaseClient _client;

  ReminderService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<List<ReminderModel>> fetchReminders() async {
    final response = await _client
        .from('reminders')
        .select()
        .order('due_date', ascending: true);

    return response
        .map((row) => ReminderModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }
}
