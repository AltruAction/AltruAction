import 'package:recloset/Types/CommonTypes.dart';

class UserState {
  String UUID;
  int credits;
  List<String> listedItems;
  List<String> likes;
  List<Transaction> transactions;
  String email;
  String? role;

  UserState(this.UUID, this.credits, this.listedItems, this.likes,
      this.transactions, this.email,
      {this.role});

  UserState copyWith({
    String? UUID,
    int? credits,
    List<String>? listedItems,
    List<String>? likes,
    List<Transaction>? transactions,
    String? email,
    String? role, // Include role in the copyWith method
  }) {
    return UserState(
        UUID ?? this.UUID,
        credits ?? this.credits,
        listedItems ?? this.listedItems,
        likes ?? this.likes,
        transactions ?? this.transactions,
        email ?? this.email,
        role: role ??
            this.role); // Assign the optional role parameter to the new instance
  }
}
