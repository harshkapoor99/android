const host = 'https://api.guftagu.net/api';

enum RemoteEndpoint {
  loginPhone(path: 'userservice/user/userloginwithphonenumber/'),
  otpPhone(path: 'userservice/user/userotpverificationbyphonenumber/'),
  loginEmail(path: 'userservice/user/userloginwithemail/'),
  otpEmail(path: 'userservice/user/userotpverificationbyemail/')
  //
  ;

  const RemoteEndpoint({required this.path});

  final String path;

  String get url => '$host/$path';
}
