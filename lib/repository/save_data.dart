import 'dart:convert';

import 'package:awecg/models/medical_professional.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;

class SaveData {
  SaveData();
  final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
  final iv = enc.IV.fromLength(16);
  final encrypter =
      enc.Encrypter(enc.AES(enc.Key.fromUtf8('Alejandro Pulido Saravia')));

  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    // encrypt key and value
    final encryptedKey = encrypter.encrypt(key, iv: iv);
    final encryptedValue = encrypter.encrypt(value, iv: iv);
    // save encrypted key and value
    prefs.setString(encryptedKey.base64, encryptedValue.base64);
    //prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // encrypt key
    final encryptedKey = encrypter.encrypt(key, iv: iv);
    // get encrypted value
    final encryptedValue = prefs.getString(encryptedKey.base64);
    // decrypt value
    final decryptedValue =
        encrypter.decrypt(enc.Encrypted.fromBase64(encryptedValue!), iv: iv);
    return decryptedValue;
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // encrypt key
    final encryptedKey = encrypter.encrypt(key, iv: iv);
    // remove encrypted key and value
    prefs.remove(encryptedKey.base64);
  }

  Future<void> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> saveMedicalProfessional(
      MedicalProfessional medicalProfessional) async {
    final prefs = await SharedPreferences.getInstance();
    // convert medical professional to json
    final medicalProfessionalJson = medicalProfessional.toJson();
    // encrypt medical professional json
    final encryptedMedicalProfessionalJson =
        encrypter.encrypt(medicalProfessionalJson, iv: iv);
    // create key encrypted
    final encryptedKey = encrypter.encrypt('medicalProfessional', iv: iv);
    // save encrypted medical professional json
    prefs.setString(
        encryptedKey.base64, encryptedMedicalProfessionalJson.base64);
  }

  Future<MedicalProfessional> getMedicalProfessional() async {
    final prefs = await SharedPreferences.getInstance();
    // create key encrypted
    final encryptedKey = encrypter.encrypt('medicalProfessional', iv: iv);
    // get encrypted medical professional json
    final encryptedMedicalProfessionalJson =
        prefs.getString(encryptedKey.base64);
    // check if medical professional json is null
    if (encryptedMedicalProfessionalJson == null) {
      return MedicalProfessional(
        id: '',
        fullName: '',
        email: '',
        phone: '',
        address: '',
        specialty: '',
        place: '',
      );
    }
    // decrypt medical professional json
    final medicalProfessionalJson = encrypter.decrypt(
        enc.Encrypted.fromBase64(encryptedMedicalProfessionalJson!),
        iv: iv);
    // convert medical professional json to medical professional
    final medicalProfessional =
        MedicalProfessional.fromJson(medicalProfessionalJson);
    return medicalProfessional;
  }

  Future<void> removeMedicalProfessional() async {
    final prefs = await SharedPreferences.getInstance();
    // create key encrypted
    final encryptedKey = encrypter.encrypt('medicalProfessional', iv: iv);
    // remove encrypted medical professional json
    prefs.remove(encryptedKey.base64);
  }
}
