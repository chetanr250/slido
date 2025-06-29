import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room.dart';
import '../models/quiz_status.dart';
import '../services/room_service.dart';

final roomServiceProvider = Provider<RoomService>((ref) => RoomService());

final roomStreamProvider =
    StreamProvider.family<Room?, String>((ref, roomCode) {
  final service = ref.watch(roomServiceProvider);
  return service.streamRoom(roomCode);
});

final roomStatusProvider =
    FutureProvider.family<QuizStatus?, String>((ref, roomCode) async {
  final service = ref.watch(roomServiceProvider);
  return service.getRoomStatus(roomCode);
});

final roomActionsProvider = Provider<RoomActions>((ref) {
  final service = ref.watch(roomServiceProvider);
  return RoomActions(service);
});

class RoomActions {
  final RoomService _service;
  RoomActions(this._service);

  Future<void> updateStatus(String roomCode, QuizStatus status) =>
      _service.updateRoomStatus(roomCode, status);

  Future<void> addOrUpdateParticipant(String roomCode, String userEmail,
          Map<String, dynamic> participantData) =>
      _service.addOrUpdateParticipant(roomCode, userEmail, participantData);

  Future<void> removeParticipant(String roomCode, String userEmail) =>
      _service.removeParticipant(roomCode, userEmail);

  Future<void> deleteRoom(String roomCode) => _service.deleteRoom(roomCode);
}
