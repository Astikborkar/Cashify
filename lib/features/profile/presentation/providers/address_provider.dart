import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/saved_address_model.dart';

class AddressNotifier extends StateNotifier<List<SavedAddress>> {
  AddressNotifier()
      : super([
          const SavedAddress(
            id: 'ADDR-1',
            fullName: 'Rahul Sharma',
            phoneNumber: '+91 98765 43210',
            flatHouseNumber: '#402, Green View Apartments',
            streetArea: '100ft Road, HAL 2nd Stage, Indiranagar',
            landmark: 'Opposite Toit Brewpub',
            city: 'Bengaluru',
            state: 'Karnataka',
            pincode: '560038',
            tag: AddressTag.home,
            isDefault: true,
          ),
          const SavedAddress(
            id: 'ADDR-2',
            fullName: 'Rahul Sharma',
            phoneNumber: '+91 98765 43210',
            flatHouseNumber: 'Level 5, Bagmane Tech Park',
            streetArea: 'CV Raman Nagar, Byrasandra',
            landmark: 'Near Cognizant Block C',
            city: 'Bengaluru',
            state: 'Karnataka',
            pincode: '560093',
            tag: AddressTag.work,
            isDefault: false,
          ),
        ]);

  void addAddress(SavedAddress newAddress) {
    if (newAddress.isDefault) {
      state = [
        ...state.map((a) => a.copyWith(isDefault: false)),
        newAddress,
      ];
    } else {
      state = [...state, newAddress];
    }
  }

  void updateAddress(SavedAddress updated) {
    state = state.map((a) {
      if (a.id == updated.id) {
        return updated;
      }
      return updated.isDefault ? a.copyWith(isDefault: false) : a;
    }).toList();
  }

  void setDefault(String id) {
    state = state.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
  }

  void deleteAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final addressNotifierProvider = StateNotifierProvider<AddressNotifier, List<SavedAddress>>((ref) {
  return AddressNotifier();
});
