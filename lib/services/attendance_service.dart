import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/attendance_model.dart';
import '../models/otp_verification_model.dart';

class AttendanceService {
  final SupabaseClient _client;
  final Random _random;

  AttendanceService({SupabaseClient? client, Random? random})
    : _client = client ?? Supabase.instance.client,
      _random = random ?? Random();

  Future<List<AttendanceModel>> fetchAttendance() async {
    final response = await _client
        .from('attendance_records')
        .select()
        .order('attendance_date', ascending: false);

    return response
        .map((row) => AttendanceModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<String> generateOtp(String studentId) async {
    final otp = (_random.nextInt(900000) + 100000).toString();
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));
    final verification = OtpVerificationModel(
      id: '',
      studentId: studentId,
      otpCode: otp,
      isVerified: false,
      expiresAt: expiresAt,
      verifiedAt: null,
      createdAt: null,
    );

    await _client.from('otp_verifications').insert(verification.toJson());

    return otp;
  }

  Future<AttendanceModel> verifyOtpAndMarkAttendance(
    String studentId,
    String otp,
  ) async {
    final response =
        await _client
            .from('otp_verifications')
            .select()
            .eq('student_id', studentId)
            .eq('is_verified', false)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

    if (response == null) {
      throw Exception('No active OTP found.');
    }

    final verification = OtpVerificationModel.fromMap(
      Map<String, dynamic>.from(response),
    );
    if (verification.otpCode != otp.trim()) {
      throw Exception('Invalid OTP.');
    }

    final expiresAt = verification.expiresAt;
    if (expiresAt == null || expiresAt.isBefore(DateTime.now())) {
      throw Exception('OTP has expired.');
    }

    await _client
        .from('otp_verifications')
        .update({'is_verified': true})
        .eq('id', verification.id);

    final attendance = AttendanceModel(
      id: '',
      studentId: studentId,
      attendanceDate: DateTime.now(),
      status: 'Present',
      otpVerified: true,
      createdAt: null,
    );
    final attendanceResponse =
        await _client
            .from('attendance_records')
            .insert(attendance.toJson())
            .select()
            .single();

    return AttendanceModel.fromMap(
      Map<String, dynamic>.from(attendanceResponse),
    );
  }

  Future<List<AttendanceModel>> fetchAttendanceByStudentId(
    String studentId,
  ) async {
    final response = await _client
        .from('attendance_records')
        .select()
        .eq('student_id', studentId)
        .order('attendance_date', ascending: false);

    return response
        .map((row) => AttendanceModel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }
}
