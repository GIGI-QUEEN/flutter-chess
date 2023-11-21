class Invite {
  //final String inviteId;
  final String lobbyName;
  final String lobbyId;
  final String lobbyIOwnerName;

  Invite(
      {
      // required this.inviteId,
      required this.lobbyName,
      required this.lobbyId,
      required this.lobbyIOwnerName});

  factory Invite.fromRTBD(Map<String, dynamic> data) {
    return Invite(
      lobbyName: data['lobby_name'],
      lobbyId: data['lobby_id'],
      lobbyIOwnerName: data['lobby_owner_name'],
    );
  }
}
