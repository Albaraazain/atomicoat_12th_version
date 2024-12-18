import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alarm.dart';
import '../../../repositories/base_repository.dart';

class AlarmRepository extends BaseRepository<Alarm> {
  AlarmRepository() : super('alarms');

  Future<void> remove(String alarmId, {String? userId}) async {
    await delete(alarmId, userId: userId);
  }

  Future<void> clearAcknowledged(String userId) async {
    QuerySnapshot acknowledgedAlarms = await getUserCollection(userId)
        .where('acknowledged', isEqualTo: true)
        .get();

    for (var doc in acknowledgedAlarms.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<Alarm>> getActiveAlarms(String userId) async {
    QuerySnapshot activeAlarms = await getUserCollection(userId)
        .where('acknowledged', isEqualTo: false)
        .get();

    return activeAlarms.docs
        .map((doc) => fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Alarm fromJson(Map<String, dynamic> json) => Alarm.fromJson(json);
}