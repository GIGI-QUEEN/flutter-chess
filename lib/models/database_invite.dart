import 'package:client/models/user.dart';
import 'package:uuid/uuid.dart';

class DatabaseInvite {
  final inviteId = const Uuid().v1();
  final User invitedUser;

  DatabaseInvite({required this.invitedUser});
}
