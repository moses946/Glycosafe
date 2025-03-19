class Endpoints {
  final String mainEndpoint;
  final String refresh;
  final String token;
  final String register;
  final String confirm;
  final String upload;
  final String verify;
  final String logout;
  final String password_signup;
  final String meal_confirm;
  final String personal_info;
  final String get_meals;
  final String report_bug;
  final String delete_account;
  final String change_password;
  final String update_personal_info;
  final String forgot_password;
  final String confirm_reset;
  final String reset_password;
  final String delete_reset_code;
  final String get_meals_test;
  final String add_medication;
  final String load_profile_login;

  factory Endpoints() {
    const mainEndpoint = "https://condor-endless-finally.ngrok-free.app/";
    return Endpoints._internal(
      mainEndpoint,
      "${mainEndpoint}token/refresh/",
      "${mainEndpoint}token/",
      "${mainEndpoint}register/",
      "${mainEndpoint}confirm/",
      "${mainEndpoint}upload/",
      "${mainEndpoint}verify/",
      "${mainEndpoint}logout/",
      "${mainEndpoint}password-signup/",
      "${mainEndpoint}meal-confirm/",
      "${mainEndpoint}personal-info/",
      "${mainEndpoint}get-meals/",
      "${mainEndpoint}report-bug/",
      "${mainEndpoint}delete-account/",
      "${mainEndpoint}change-password/",
      "${mainEndpoint}update-personal-info/",
      "${mainEndpoint}forgot-password/",
      "${mainEndpoint}confirm-reset/",
      "${mainEndpoint}reset-password/",
      "${mainEndpoint}delete-reset-code/",
      "${mainEndpoint}get-meals-test/",
      "${mainEndpoint}add-medication/",
      "${mainEndpoint}load-profile-login/",
    );
  }

  Endpoints._internal(
    this.mainEndpoint,
    this.refresh,
    this.token,
    this.register,
    this.confirm,
    this.upload,
    this.verify,
    this.logout,
    this.password_signup,
    this.meal_confirm,
    this.personal_info,
    this.get_meals,
    this.report_bug,
    this.delete_account,
    this.change_password,
    this.update_personal_info,
    this.forgot_password,
    this.confirm_reset,
    this.reset_password,
    this.delete_reset_code,
    this.get_meals_test,
    this.add_medication,
    this.load_profile_login,
  );
}
