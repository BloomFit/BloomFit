import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Breed {
  final String name;

  Breed({required this.name});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(name: json['attributes']['name']);
  }
}

class VisualiasiController extends GetxController {
  var breedList = <Breed>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchBreeds();
    super.onInit();
  }

  void fetchBreeds() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://dogapi.dog/api/v2/breeds'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List breeds = data['data'];
        breedList.value = breeds.map((e) => Breed.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching breeds: $e');
    } finally {
      isLoading(false);
    }
  }
}
