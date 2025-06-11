import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHistory {
  final String email;
  final String provider;
  final DateTime loginTime;
  final String device;

  LoginHistory({
    required this.email,
    required this.provider,
    required this.loginTime,
    required this.device,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'provider': provider,
    'loginTime': loginTime.toIso8601String(),
    'device': device,
  };

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      email: json['email'],
      provider: json['provider'],
      loginTime: DateTime.parse(json['loginTime']),
      device: json['device'] ?? 'Unknown',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LoginHistory &&
          email == other.email &&
          loginTime == other.loginTime;

  @override
  int get hashCode => email.hashCode ^ loginTime.hashCode;
}

class ActivityController extends GetxController {
  final RxList<LoginHistory> historyList = <LoginHistory>[].obs;
  final GetStorage _storage = GetStorage();
  final String storageKey = 'login_history';

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() async {
    final rawData = _storage.read<List>(storageKey) ?? [];
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString('email');

    final data = rawData
        .map((item) => LoginHistory.fromJson(Map<String, dynamic>.from(item)))
        .where((history) => history.email == currentEmail)
        .toList();

    historyList.assignAll(data.reversed.toList());
  }

  void addHistory(LoginHistory history) {
    final currentList = _storage.read<List>(storageKey) ?? [];
    currentList.add(history.toJson());
    _storage.write(storageKey, currentList);
    loadHistory(); // update list sesuai email saat ini
  }

  void removeSelectedHistory(List<LoginHistory> selected) {
    final currentList = _storage.read<List>(storageKey) ?? [];

    final updatedList = currentList.where((item) {
      final jsonItem = Map<String, dynamic>.from(item);
      final itemHistory = LoginHistory.fromJson(jsonItem);
      return !selected.contains(itemHistory);
    }).toList();

    _storage.write(storageKey, updatedList);
    loadHistory();
  }

  void clearHistory() {
    historyList.clear(); // hanya hapus tampilan list, tidak hapus dari GetStorage
  }
}
