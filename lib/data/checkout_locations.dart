/// Cities with representative postal / ZIP codes for checkout dropdowns.
/// Sri Lanka entries use common Sri Lanka Post–style 5-digit area codes (approximate).
class CheckoutCity {
  const CheckoutCity(this.name, this.postalCode);
  final String name;
  final String postalCode;
}

class CheckoutCountry {
  const CheckoutCountry(this.name, this.cities);
  final String name;
  final List<CheckoutCity> cities;
}

/// Ordered list for dropdowns (Sri Lanka first for this app’s primary market).
const List<CheckoutCountry> kCheckoutCountries = <CheckoutCountry>[
  CheckoutCountry(
    'Sri Lanka',
    <CheckoutCity>[
      CheckoutCity('Colombo', '00100'),
      CheckoutCity('Dehiwala', '10350'),
      CheckoutCity('Mount Lavinia', '10370'),
      CheckoutCity('Moratuwa', '10400'),
      CheckoutCity('Nugegoda', '10250'),
      CheckoutCity('Maharagama', '10280'),
      CheckoutCity('Kotte', '10120'),
      CheckoutCity('Negombo', '11500'),
      CheckoutCity('Gampaha', '11000'),
      CheckoutCity('Kalutara', '12000'),
      CheckoutCity('Panadura', '12500'),
      CheckoutCity('Kandy', '20000'),
      CheckoutCity('Peradeniya', '20400'),
      CheckoutCity('Galle', '80000'),
      CheckoutCity('Matara', '81000'),
      CheckoutCity('Hambantota', '82000'),
      CheckoutCity('Jaffna', '40000'),
      CheckoutCity('Vavuniya', '43000'),
      CheckoutCity('Batticaloa', '30000'),
      CheckoutCity('Trincomalee', '31000'),
      CheckoutCity('Ampara', '32000'),
      CheckoutCity('Sammanthurai', '32200'),
      CheckoutCity('Anuradhapura', '50000'),
      CheckoutCity('Polonnaruwa', '51000'),
      CheckoutCity('Kurunegala', '60000'),
      CheckoutCity('Puttalam', '61300'),
      CheckoutCity('Ratnapura', '70000'),
      CheckoutCity('Badulla', '90000'),
      CheckoutCity('Bandarawela', '90100'),
      CheckoutCity('Nuwara Eliya', '22200'),
      CheckoutCity('Ella', '90090'),
    ],
  ),
  CheckoutCountry(
    'India',
    <CheckoutCity>[
      CheckoutCity('Mumbai', '400001'),
      CheckoutCity('Delhi', '110001'),
      CheckoutCity('Bengaluru', '560001'),
      CheckoutCity('Chennai', '600001'),
      CheckoutCity('Kolkata', '700001'),
      CheckoutCity('Hyderabad', '500001'),
      CheckoutCity('Pune', '411001'),
      CheckoutCity('Ahmedabad', '380001'),
      CheckoutCity('Jaipur', '302001'),
      CheckoutCity('Kochi', '682001'),
    ],
  ),
  CheckoutCountry(
    'United Arab Emirates',
    <CheckoutCity>[
      CheckoutCity('Dubai', '00000'),
      CheckoutCity('Abu Dhabi', '00000'),
      CheckoutCity('Sharjah', '00000'),
      CheckoutCity('Ajman', '00000'),
      CheckoutCity('Al Ain', '00000'),
    ],
  ),
  CheckoutCountry(
    'United Kingdom',
    <CheckoutCity>[
      CheckoutCity('London', 'SW1A 1AA'),
      CheckoutCity('Manchester', 'M1 1AE'),
      CheckoutCity('Birmingham', 'B1 1AA'),
      CheckoutCity('Edinburgh', 'EH1 1YZ'),
      CheckoutCity('Glasgow', 'G1 1XX'),
      CheckoutCity('Liverpool', 'L1 8JQ'),
    ],
  ),
  CheckoutCountry(
    'United States',
    <CheckoutCity>[
      CheckoutCity('New York', '10001'),
      CheckoutCity('Los Angeles', '90001'),
      CheckoutCity('Chicago', '60601'),
      CheckoutCity('Houston', '77001'),
      CheckoutCity('Miami', '33101'),
      CheckoutCity('San Francisco', '94102'),
    ],
  ),
  CheckoutCountry(
    'Singapore',
    <CheckoutCity>[
      CheckoutCity('Singapore', '018956'),
    ],
  ),
  CheckoutCountry(
    'Malaysia',
    <CheckoutCity>[
      CheckoutCity('Kuala Lumpur', '50000'),
      CheckoutCity('Penang', '10000'),
      CheckoutCity('Johor Bahru', '80000'),
    ],
  ),
];

CheckoutCountry checkoutCountryByName(String name) {
  final n = name.trim();
  for (final c in kCheckoutCountries) {
    if (c.name.toLowerCase() == n.toLowerCase()) return c;
  }
  return kCheckoutCountries.first;
}

String? checkoutPostalFor(String countryName, String cityName) {
  final co = checkoutCountryByName(countryName);
  for (final city in co.cities) {
    if (city.name.toLowerCase() == cityName.trim().toLowerCase()) {
      return city.postalCode;
    }
  }
  return null;
}
