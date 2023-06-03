import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final String chat_id;
  final String item_id;
  final String current_id;
  final String other_id;

  const ChatRoom(
      {super.key,
      required this.chat_id,
      required this.item_id,
      required this.current_id,
      required this.other_id});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final List<types.Message> _messages = [];

  void initChat() {
    final CollectionReference chatsCollection =
        FirebaseFirestore.instance.collection('item_chats');
    final CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');

    // Check if the chat room already exists
    chatsCollection
        .doc(widget.chat_id)
        .get()
        .then((chatDoc) async {
          print("Does it exist?");
          print(widget.chat_id);
          print(chatDoc.exists);

          if (chatDoc.exists) {
            // Chat room exists, proceed with fetching messages and setting up listeners

            // Fetch existing messages for the chat room
            messagesCollection
                .where('chat_id', isEqualTo: widget.chat_id)
                .orderBy('createdAt')
                .snapshots()
                .listen((QuerySnapshot snapshot) {
              List<QueryDocumentSnapshot> documents = snapshot.docs;
              // Process fetched messages and update your UI
              // e.g., update a message list or chat bubble widget
              for (var doc in documents) {
                Map<String, dynamic> author = doc['author'];
                String text = doc['text'];
                int createdAt = doc['createdAt'];
                print("listen: ");
                print(doc);

                final textMessage = types.TextMessage(
                  author: types.User(id: author['id']),
                  createdAt: createdAt,
                  id: doc.id,
                  text: text,
                );
                _addMessage(textMessage);
              }
            });
          } else {
            // Chat room does not exist, create it before initializing the chat

            // Create the chat room document
            await chatsCollection.doc(widget.chat_id).set({
              'chat_id': widget.chat_id,
              'item_id': widget.item_id,
              'buyer_id': widget.chat_id.split('_')[1],
              'seller_id': widget.chat_id.split('_')[1] != widget.current_id
                  ? widget.current_id
                  : widget.other_id,
              // Add any other relevant properties for the chat room
            }).then((_) {
              // Chat room created, proceed with fetching messages and setting up listeners
              // (similar to the code for an existing chat room)
              // ...
            }).catchError((error) {
              // Error occurred while creating the chat room
              print('Error creating chat room: $error');
            });
          }
        })
        .then((value) => {
              // Listen for new messages in the chat room
              messagesCollection
                  .where('chat_id', isEqualTo: widget.chat_id)
                  .orderBy('createdAt')
                  .limitToLast(1)
                  .snapshots()
                  .listen((QuerySnapshot snapshot) {
                List<QueryDocumentSnapshot> documents = snapshot.docs;
                // Process new messages and update your UI
                // e.g., append new messages to a message list or chat bubble widget
                for (var doc in documents) {
                  print("listen: ");
                  print(doc);
                  Map<String, dynamic> author = doc['author'];
                  String text = doc['text'];
                  int createdAt = doc['createdAt'];

                  final textMessage = types.TextMessage(
                    author: types.User(id: author['id']),
                    createdAt: createdAt,
                    id: doc.id,
                    text: text,
                  );
                  _addMessage(textMessage);
                }
              })
            })
        .catchError((error) {
          // Error occurred while checking if the chat room exists
          print('Error checking chat room existence: $error');
        });
  }

  @override
  void initState() {
    initChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        // onAttachmentPressed: _handleImageSelection,
        // onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: types.User(id: widget.current_id),
        theme: const DefaultChatTheme(
          inputBackgroundColor: Colors.grey,
          primaryColor: Colors.green,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  void _addMessage(types.Message message) {
    // avoid adding duplicated messages
    final index = _messages.indexWhere((element) => element.id == message.id);
    if (index == -1) {
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: 144,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleImageSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Photo'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleFileSelection();
  //               },
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('File'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _handleFileSelection() async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );

    // if (result != null && result.files.single.path != null) {
    //   final message = types.FileMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     id: randomString(),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: result.files.single.path!,
    //   );

    //   _addMessage(message);
    // }
  }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);

  //     final message = types.ImageMessage(
  //       author: types.User(id: widget.current_id),
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       height: image.height.toDouble(),
  //       id: randomString(),
  //       name: result.name,
  //       size: bytes.length,
  //       uri: result.path,
  //       width: image.width.toDouble(),
  //     );

  //     _addMessage(message);
  //   }
  // }

  // void _handleMessageTap(BuildContext _, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;

  //     if (message.uri.startsWith('http')) {
  //       try {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: true,
  //         );

  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });

  //         final client = http.Client();
  //         final request = await client.get(Uri.parse(message.uri));
  //         final bytes = request.bodyBytes;
  //         final documentsDir = (await getApplicationDocumentsDirectory()).path;
  //         localPath = '$documentsDir/${message.name}';

  //         if (!File(localPath).existsSync()) {
  //           final file = File(localPath);
  //           await file.writeAsBytes(bytes);
  //         }
  //       } finally {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: null,
  //         );

  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //       }
  //     }

  //     // await OpenFilex.open(localPath);
  //   }
  // }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    const uuid = Uuid();
    final timeNow = DateTime.now().millisecondsSinceEpoch;

    final types.TextMessage textMessage = types.TextMessage(
      author: types.User(id: widget.current_id),
      createdAt: timeNow,
      id: uuid.v4(), // Generate a unique identifier using UUID
      text: message.text,
    );

    // Save the text message to the Firestore collection
    FirebaseFirestore.instance.collection('messages').doc(textMessage.id).set({
      ...textMessage.toJson(),
      'chat_id': widget.chat_id,
    }).then((_) {
      FirebaseFirestore.instance
          .collection('item_chats')
          .doc(widget.chat_id)
          .update({
        'last_updated': timeNow,
        'last_message': message.text,
      });
    }).catchError((error) {
      // Error occurred while sending the message
      print('Error sending message: $error');
    });

    // _addMessage(textMessage);
  }
}
