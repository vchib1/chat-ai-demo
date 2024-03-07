class ChatUser {
  ChatUser({
    required this.id,
    this.profileImage,
    this.firstName,
    this.lastName,
  });

  final String id;
  final String? profileImage;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileImage': profileImage,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'] as String,
      profileImage: map['profileImage']?.toString(),
      firstName: map['firstName']?.toString(),
      lastName: map['lastName']?.toString(),
    );
  }
}
