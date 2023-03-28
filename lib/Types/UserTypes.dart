import 'package:recloset/Types/CommonTypes.dart';

class UserState {
  String UUID;
  int credits;
  List<String> listedItems;
  List<String> likes;
  List<Transaction> transactions;

  UserState(this.UUID, this.credits, this.listedItems, this.likes,
      this.transactions);

  UserState copyWith({
    String? UUID,
    int? credits,
    List<String>? listedItems,
    List<String>? likes,
    List<Transaction>? transactions,
  }) {
    return UserState(UUID ?? this.UUID, 
                      credits ?? this.credits, 
                      listedItems ?? this.listedItems,
                      likes ?? this.likes,
                      transactions ?? this.transactions);
  }
}
