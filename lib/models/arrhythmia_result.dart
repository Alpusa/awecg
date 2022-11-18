import 'package:awecg/generated/i18n.dart';

class ArrhythmiaResult {
  List<int> results = [];
  int? result;
  int iter = 10;
  int? packs;
  int? frequency;

  ArrhythmiaResult();

  void addResult(int resultAdd) {
    resultAdd >= 0 && resultAdd <= 2 ? results.add(resultAdd) : null;
    calculateResult();
  }

  void calculateResult() {
    int count_0 = 0;
    int count_1 = 0;
    int count_2 = 0;
    results.forEach((element) {
      if (element == 0) {
        count_0++;
      } else if (element == 1) {
        count_1++;
      } else if (element == 2) {
        count_2++;
      }
    });
    result = count_0 > count_1 && count_0 > count_2
        ? 0
        : count_1 > count_0 && count_1 > count_2
            ? 1
            : count_2 > count_0 && count_2 > count_1
                ? 2
                : 0;
  }

  void clear() {
    results.clear();
    result = null;
  }

  get getResultValidation {
    if (result != null) {
      int count = 0;
      for (var element in results) {
        if (element == result) {
          count++;
        }
      }
      return count;
    }
    return null;
  }

  get getFrequencyClassify {
    if (frequency != null) {
      if (frequency! >= 0 && frequency! <= 60) {
        return I18n().bradycardia;
      } else if (frequency! >= 61 && frequency! <= 99) {
        return I18n().normal;
      } else if (frequency! >= 100) {
        return I18n().tachycardia;
      }
    }
    return null;
  }

  set setIter(int iter) {
    this.iter = iter;
  }

  set setPacks(int? packs) {
    this.packs = packs;
  }

  set setFrequency(int? frequency) {
    this.frequency = frequency;
  }

  get getResult => result;
  get getIter => iter;
  get getPacks => packs;
  get getFrequency => frequency;

  ArrhythmiaResult.fromJson(Map<String, dynamic> json) {
    results = json['results'].cast<int>();
    result = json['result'];
    iter = json['iter'];
    packs = json['packs'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = this.results;
    data['result'] = this.result;
    data['iter'] = this.iter;
    data['packs'] = this.packs;
    data['frequency'] = this.frequency;

    return data;
  }

  @override
  String toString() {
    return 'ArrhythmiaResult{results: $results, result: $result , iter: $iter, packs: $packs, frequency: $frequency}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrhythmiaResult &&
          runtimeType == other.runtimeType &&
          results == other.results &&
          result == other.result &&
          iter == other.iter &&
          packs == other.packs &&
          frequency == other.frequency;

  @override
  int get hashCode => results.hashCode ^ result.hashCode;

  ArrhythmiaResult copyWith({
    List<int>? results,
    int? result,
    int? iter,
    int? packs,
    int? frequency,
  }) {
    return ArrhythmiaResult()
      ..results = results ?? this.results
      ..result = result ?? this.result
      ..iter = iter ?? this.iter
      ..packs = packs ?? this.packs
      ..frequency = frequency ?? this.frequency;
  }

  ArrhythmiaResult.fromJsonMap(Map<String, dynamic> map)
      : results = List<int>.from(map["results"]),
        result = map["result"],
        iter = map["iter"],
        packs = map["packs"],
        frequency = map["frequency"];

  Map<String, dynamic> toJsonMap() {
    var map = <String, dynamic>{};
    map["results"] = results;
    map["result"] = result;
    map["iter"] = iter;
    map["packs"] = packs;
    map["frequency"] = frequency;
    return map;
  }

  ArrhythmiaResult clone() {
    return ArrhythmiaResult.fromJsonMap(toJsonMap());
  }
}
