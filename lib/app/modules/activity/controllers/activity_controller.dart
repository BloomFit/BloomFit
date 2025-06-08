import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginHistory {
  final String email;
  final String provider;
  final DateTime loginTime;

  LoginHistory({
    required this.email,
    required this.provider,
    required this.loginTime,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'provider': provider,
    'loginTime': loginTime.toIso8601String(),
  };

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      email: json['email'],
      provider: json['provider'],
      loginTime: DateTime.parse(json['loginTime']),
    );
  }
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

  void loadHistory() {
    final rawData = _storage.read<List>(storageKey) ?? [];
    final data = rawData
        .map((item) => LoginHistory.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    historyList.assignAll(data.reversed.toList());
  }

  void addHistory(LoginHistory history) {
    final currentList = _storage.read<List>(storageKey) ?? [];
    currentList.add(history.toJson());
    _storage.write(storageKey, currentList);
    loadHistory();
  }

  void clearHistory() {
    _storage.remove(storageKey);
    historyList.clear();
  }
}
