

import 'package:flutter/material.dart';

class DateTimeProvider with ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _allFieldsComplete = false;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  bool get allFieldsComplete => _allFieldsComplete;

  // Private method to check and update the boolean field
  void _checkAllFieldsComplete() {
    bool previousState = _allFieldsComplete;
    _allFieldsComplete = _startDate != null && 
                        _endDate != null && 
                        _startTime != null && 
                        _endTime != null;
    
    // Only notify listeners if the state actually changed
    if (previousState != _allFieldsComplete) {
      print('All fields complete status changed: $_allFieldsComplete');
    }
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    _endDate = null; // Reset end date when start changes
    _checkAllFieldsComplete();
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    _checkAllFieldsComplete();
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    _startTime = time;
    _endTime = null; 
    _checkAllFieldsComplete();
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    _endTime = time;
    _checkAllFieldsComplete();
    notifyListeners();
  }

  Future<void> resetAll() async {
    try{
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      _startDate = null;
      _endDate = null;
      _startTime = null;
      _endTime = null;
      _checkAllFieldsComplete();
      notifyListeners();
    }catch(e){
      print('Error fetching recent booking: $e');
    }
  }
}