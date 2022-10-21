import 'dart:convert';

List<Participant> popularParticipantListFromJson(String val) =>
    List<Participant>.from(json.decode(val)['fetchedParticipants']
        .map((model) => Participant.popularParticipantFromJson(model))
    );
class Participant {
  final String id;
  final String fullName;
  final String email;
  final String job;
  final String createdAt;

  Participant({required this.id, required this.fullName, required this.email, required this.job, required this.createdAt});

  factory Participant.popularParticipantFromJson(Map<String, dynamic> data) =>
      Participant(
          id: data['_id'],
          fullName: data['fullName'],
          email: data['email'],
          job: data['job'],
          createdAt: data['createdAt']);
}