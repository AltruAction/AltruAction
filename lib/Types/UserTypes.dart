import 'package:recloset/Types/CommonTypes.dart';

class UserState {
  String UUID;
  int credits;
  List<int> listedItems;
  List<int> likedItems;
  List<Transaction> transactions;

  UserState(this.UUID, this.credits, this.listedItems, this.likedItems, this.transactions);

  map(int Function(dynamic item) param0) {}
}