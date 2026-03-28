import 'attendance_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String _userName = 'Guest';
  String _userPost = 'Visitor';
  String _branch = 'All Branches';
  String _userId = '';

  String get userName => _userName;
  String get userPost => _userPost;
  String get branch => _branch;
  String get userId => _userId;

  void setUser(String name, String post, String branchName, {String userId = ''}) {
    _userName = name;
    _userPost = post;
    _branch = branchName;
    _userId = userId;
  }

  void logout() {
    AttendanceService().checkOut();
    _userName = 'Guest';
    _userPost = 'Visitor';
    _branch = 'All Branches';
    _userId = '';
  }
}

