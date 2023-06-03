import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'ChatRoom.dart';

Future<List<DocumentSnapshot>> fetchChats() async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  print(currentUserId);
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('item_chats')
      .where('seller_id', isEqualTo: currentUserId)
      .orderBy('last_updated', descending: true)
      .get();

  List<DocumentSnapshot> sellerChats = querySnapshot.docs;

  querySnapshot = await FirebaseFirestore.instance
      .collection('item_chats')
      .where('buyer_id', isEqualTo: currentUserId)
      .orderBy('last_updated', descending: true)
      .get();

  List<DocumentSnapshot> buyerChats = querySnapshot.docs;

  List<DocumentSnapshot> allChats = [...sellerChats, ...buyerChats];
  allChats.sort((a, b) => b['last_updated'].compareTo(a['last_updated']));
  print("all chats:");

  print(allChats);
  return allChats;
}

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchChats(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading chats.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chats available.'),
            );
          } else {
            List<DocumentSnapshot> chats = snapshot.data!;

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot chat = chats[index];
                String chatId = chat.id;

                String otherUserId =
                    chat['seller_id'] == FirebaseAuth.instance.currentUser!.uid
                        ? chat['buyer_id']
                        : chat['seller_id'];
                String itemId = chatId.split('_')[0];

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              chat_id: chatId,
                              item_id: itemId,
                              other_id: otherUserId,
                              current_id:
                                  FirebaseAuth.instance.currentUser!.uid,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://api.dicebear.com/6.x/fun-emoji/png?seed=$otherUserId',
                        ),
                      ),
                      title: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('items')
                            .doc(itemId)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const Text('Could not fetch item name');
                          } else {
                            String itemTitle = snapshot.data!['title'];
                            return Text(itemTitle);
                          }
                        },
                      ),
                      subtitle: Text('${chat['last_message']}'),
                      trailing: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('items')
                            .doc(itemId)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error);
                          } else if (!snapshot.hasData) {
                            return const Icon(Icons.image);
                          } else {
                            String itemImage = snapshot.data!['images'][0];

                            DateTime lastMessageTime =
                                DateTime.fromMillisecondsSinceEpoch(
                              chat['last_updated'] as int,
                            );
                            String formattedTime = DateFormat('dd/MM/yyy HH:mm')
                                .format(lastMessageTime);

                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(itemImage),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
