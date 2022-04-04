class LoginAuth {
  final String user;
  final String pass;
  final String status;
  final int code;
  final String msg;

  LoginAuth({this.user = '', this.pass = '', this.status = '', this.code = 0, this.msg = '', });

  factory LoginAuth.fromJson(Map<String, dynamic> json) {
    return LoginAuth(
      status: json['status'],
      code: json['code'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'user' : user,
        'pass' : pass,
      };
}

//required this.user, required this.pass,

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;
//
//   Post({required this.userId, required this.id, required this.title, required this.body});
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }