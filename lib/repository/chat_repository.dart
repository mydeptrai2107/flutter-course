import 'package:app/common/collection_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String get uid => _auth.currentUser!.uid;
  Future<String> getOrCreateRoom() async {
    final roomRef = _firestore.collection(CollectionName.message).doc((uid));
    final room = await roomRef.get();
    final admin = await FirebaseFirestore.instance
        .collection(CollectionName.admins)
        .get();
    if (!room.exists) {
      await roomRef.set({
        'userId': uid,
        'adminId': admin,
        'lastMessenge': '',
        'lastMessengerTime': FieldValue.serverTimestamp(),
      });
    }
    return roomRef.id;
  }

  Future<void> sendMessage({
    required roomId,
    required String receiverId,
    required String text,
  }) async {
    final msgRef = _firestore
        .collection(CollectionName.chatRoom)
        .doc(roomId)
        .collection(CollectionName.message)
        .doc();
    await msgRef.set({
      "senderId": uid,
      "receiverId": receiverId,
      "text": text,
      "createAt": FieldValue.serverTimestamp(),
      "isRead": false,
    });

    await _firestore.collection(CollectionName.chatRoom).doc(roomId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
}
