import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';

bool isUserOwner(Lobby lobby, User user) {
  return lobby.owner.userUuid == user.userUuid;
}
