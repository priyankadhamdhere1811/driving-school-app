import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student_model.dart';

class StudentService {
  final SupabaseClient _client;

  StudentService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<List<StudentModel>> fetchStudents() async {
    final response = await _client.from('students').select();

    return response
        .map((row) => StudentModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<StudentModel> createStudent(StudentModel student) async {
    final response =
        await _client
            .from('students')
            .insert(student.toJson())
            .select()
            .single();

    return StudentModel.fromJson(Map<String, dynamic>.from(response));
  }
}
