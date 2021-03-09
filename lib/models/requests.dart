class Request {
  final String phone;
  final String name;
  final String currentdate;
  final double latitude;
  final double longitude;
  final String address;
  final String imageurl;
  final String animaltype;
  final String problem;
  final String rescuedatetime;
  final String entryid;
  final String teamphone;
  final String teamname;
  Request(
      {this.address,
      this.animaltype,
      this.currentdate,
      this.imageurl,
      this.latitude,
      this.longitude,
      this.name,
      this.phone,
      this.problem,
      this.rescuedatetime,
      this.entryid,
      this.teamphone,
      this.teamname});
}
