class StudentPrefillModel {
  final String fullName;
  final String mobileNumber;
  final String course;
  final String notes;
  final String? sourceEnquiryId;

  const StudentPrefillModel({
    required this.fullName,
    required this.mobileNumber,
    required this.course,
    required this.notes,
    this.sourceEnquiryId,
  });
}
