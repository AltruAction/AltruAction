import 'package:recloset/Types/CommonTypes.dart';

class UserState {
  String UUID;
  int credits;
  List<String> listedItems;
  List<String> flaggedItems;
  List<String> likes;
  List<Transaction> transactions;
  String email;

  UserState(this.UUID, this.credits, this.listedItems, this.flaggedItems, this.likes,
      this.transactions, this.email);

  UserState copyWith({
    String? UUID,
    int? credits,
    List<String>? listedItems,
    List<String>? likes,
    List<Transaction>? transactions,
    String? email,
  }) {
    return UserState(UUID ?? this.UUID, 
                      credits ?? this.credits, 
                      listedItems ?? this.listedItems,
                      likes ?? this.likes,
                      flaggedItems ?? this.flaggedItems,
                      transactions ?? this.transactions,
                      email ?? this.email);
  }
}
