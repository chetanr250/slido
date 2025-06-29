import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room.dart';
import '../models/quiz_status.dart';

class RoomService {
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('rooms');

  // Create a new room
  Future<void> createRoom(Room room) async {
    await roomsCollection.doc(room.roomCode).set(room.toJson());
  }

  // Get a room by code
  Future<Room?> getRoom(String roomCode) async {
    final doc = await roomsCollection.doc(roomCode).get();
    if (!doc.exists) return null;
    return Room.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Stream a room for real-time updates
  Stream<Room?> streamRoom(String roomCode) {
    return roomsCollection.doc(roomCode).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Room.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // Update room status
  Future<void> updateRoomStatus(String roomCode, QuizStatus status) async {
    await roomsCollection.doc(roomCode).update({
      'status': quizStatusToString(status),
    });
  }

  // Get room status (returns enum)
  Future<QuizStatus?> getRoomStatus(String roomCode) async {
    final doc = await roomsCollection.doc(roomCode).get();
    if (!doc.exists) return null;
    final status = doc['status'] as String;
    return quizStatusFromString(status);
  }

  // Add or update participant
  Future<void> addOrUpdateParticipant(String roomCode, String userEmail,
      Map<String, dynamic> participantData) async {
    await roomsCollection.doc(roomCode).update({
      'participants.$userEmail': participantData,
    });
  }

  // Remove participant
  Future<void> removeParticipant(String roomCode, String userEmail) async {
    await roomsCollection.doc(roomCode).update({
      'participants.$userEmail': FieldValue.delete(),
    });
  }

  // Delete room (after quiz ends)
  Future<void> deleteRoom(String roomCode) async {
    await roomsCollection.doc(roomCode).delete();
  }
}
