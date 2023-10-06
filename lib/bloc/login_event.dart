abstract class LoginEvent {}

class IsPasswordVisibleChanged extends LoginEvent {}

class FormSumitted extends LoginEvent {
  String username;
  String password;

  FormSumitted({required this.username, required this.password});
}