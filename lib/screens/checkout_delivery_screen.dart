import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout_payment_screen.dart';
import '../data/checkout_locations.dart';
import '../data/models/saved_address.dart';
import '../data/models/user_profile.dart';
import '../state/providers.dart';

class CheckoutDeliveryScreen extends ConsumerStatefulWidget {
  const CheckoutDeliveryScreen({super.key});

  @override
  ConsumerState<CheckoutDeliveryScreen> createState() => _CheckoutDeliveryScreenState();
}

class _CheckoutDeliveryScreenState extends ConsumerState<CheckoutDeliveryScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _apt = TextEditingController();
  final _city = TextEditingController();
  final _postal = TextEditingController();
  final _country = TextEditingController();

  String? _selectedAddressId;
  /// Bumps when saved address or profile prefill updates location fields so [_FormCard] resyncs.
  int _locationFormGeneration = 0;

  void _bumpLocationForm() {
    if (mounted) setState(() => _locationFormGeneration++);
  }

  @override
  void initState() {
    super.initState();
    _country.text = 'Sri Lanka';
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
  }

  void _applyAddress(SavedAddress a) {
    final parts = a.fullName.trim().split(RegExp(r'\s+'));
    _firstName.text = parts.isNotEmpty ? parts.first : '';
    _lastName.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    _phone.text = a.phone;
    _street.text = a.street;
    _apt.text = a.apt;
    _city.text = a.city;
    _postal.text = a.postalCode;
    _country.text = a.country.isNotEmpty ? a.country : 'Sri Lanka';
    _selectedAddressId = a.id;
    _bumpLocationForm();
  }

  Future<void> _prefillFromProfile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final repo = ref.read(userRepositoryProvider);
    if (repo == null) {
      final profile = UserProfile.fromFirebaseUser(user);
      if (!mounted) return;
      if (profile.email.isNotEmpty) _email.text = profile.email;
      final parts = profile.fullName.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty) _firstName.text = parts.first;
      if (parts.length > 1) _lastName.text = parts.sublist(1).join(' ');
      if ((profile.phone ?? '').isNotEmpty) _phone.text = profile.phone!;
      _bumpLocationForm();
      return;
    }
    final profile = await repo.getProfile(user.uid);
    if (!mounted) return;
    if (profile.email.isNotEmpty) _email.text = profile.email;
    final addresses = await repo.watchAddresses(user.uid).first;
    if (!mounted) return;
    if (addresses.isNotEmpty) {
      _applyAddress(addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first));
      return;
    }
    final parts = profile.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isNotEmpty) _firstName.text = parts.first;
    if (parts.length > 1) _lastName.text = parts.sublist(1).join(' ');
    if ((profile.phone ?? '').isNotEmpty) _phone.text = profile.phone!;
    _bumpLocationForm();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _street.dispose();
    _apt.dispose();
    _city.dispose();
    _postal.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(onBack: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 160),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 768),
                        child: Column(
                          children: [
                            const _ProgressIndicatorRow(active: 0),
                            const SizedBox(height: 40),
                            const _Headline(),
                            const SizedBox(height: 24),
                            _SavedAddressPicker(
                              onSelected: _applyAddress,
                              selectedId: _selectedAddressId,
                            ),
                            const SizedBox(height: 24),
                            _FormCard(
                              key: ValueKey(_locationFormGeneration),
                              firstName: _firstName,
                              lastName: _lastName,
                              email: _email,
                              phone: _phone,
                              street: _street,
                              apt: _apt,
                              city: _city,
                              postal: _postal,
                              country: _country,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(19, 19, 19, 0.95),
                      border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: GestureDetector(
                          onTap: () {
                            final user = ref.read(currentUserProvider);
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please sign in to continue checkout.')),
                              );
                              return;
                            }
                            if (_country.text.trim().isEmpty || _city.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a country and city for delivery.')),
                              );
                              return;
                            }
                            ref.read(checkoutDraftProvider.notifier).setDraft({
                              'firstName': _firstName.text.trim(),
                              'lastName': _lastName.text.trim(),
                              'email': _email.text.trim(),
                              'phone': _phone.text.trim(),
                              'street': _street.text.trim(),
                              'apt': _apt.text.trim(),
                              'city': _city.text.trim(),
                              'postalCode': _postal.text.trim(),
                              'country': _country.text.trim(),
                            });
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutPaymentScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFD4AF37), Color(0xFFF1D37E), Color(0xFFB8860B)],
                              ),
                              boxShadow: const [BoxShadow(color: Color.fromRGBO(212, 175, 55, 0.4), blurRadius: 20, offset: Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CONTINUE TO PAYMENT',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    letterSpacing: 0.7,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset('assets/images/icon_cta_arrow.svg', width: 9.9, height: 9.9),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 48, 17),
      decoration: const BoxDecoration(
        color: Color(0xFF131313),
        border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset('assets/images/icon_checkout_back.svg', width: 14, height: 14),
          ),
          const Spacer(),
          Text(
            'CHECKOUT',
            style: GoogleFonts.notoSerif(
              fontSize: 18,
              height: 28 / 18,
              letterSpacing: 1.8,
              color: const Color(0xFFE9C349),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ProgressIndicatorRow extends StatelessWidget {
  const _ProgressIndicatorRow({required this.active});
  final int active;

  @override
  Widget build(BuildContext context) {
    Color labelColor(int index) => index == active ? const Color(0xFFE9C349) : const Color(0xFFE5E2E1);
    double labelOpacity(int index) => index == active ? 1 : 0.5;
    Color dotColor(int index) => index == active ? const Color(0xFFE9C349) : const Color(0xFF494740);
    double dotOpacity(int index) => index == active ? 1 : 0.5;

    Widget dot(int index) {
      final isActive = index == active;
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: dotColor(index).withValues(alpha: dotOpacity(index)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.5), blurRadius: 8)] : null,
        ),
      );
    }

    Widget divider() => Container(width: 48, height: 1, color: const Color(0xFF4E4639).withValues(alpha: 0.5));

    Widget step(String text, int index) {
      return Column(
        children: [
          dot(index),
          const SizedBox(height: 8),
          Opacity(
            opacity: labelOpacity(index),
            child: Text(
              text,
              style: GoogleFonts.manrope(fontSize: 10, height: 15 / 10, letterSpacing: 1.0, color: labelColor(index)),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        step('DELIVERY', 0),
        const SizedBox(width: 16),
        divider(),
        const SizedBox(width: 16),
        step('PAYMENT', 1),
        const SizedBox(width: 16),
        divider(),
        const SizedBox(width: 16),
        step('REVIEW', 2),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Shipping Details',
          style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE5E2E1)),
        ),
        const SizedBox(height: 8),
        Text(
          'Where should we deliver your selection?',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color.fromRGBO(229, 226, 225, 0.7)),
        ),
      ],
    );
  }
}

class _FormCard extends StatefulWidget {
  const _FormCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.street,
    required this.apt,
    required this.city,
    required this.postal,
    required this.country,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController street;
  final TextEditingController apt;
  final TextEditingController city;
  final TextEditingController postal;
  final TextEditingController country;

  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  late int _countryIndex;
  String? _cityDropdownValue;

  @override
  void initState() {
    super.initState();
    _syncFromControllers();
  }

  void _syncFromControllers() {
    final cName = widget.country.text.trim();
    var ci = kCheckoutCountries.indexWhere((c) => c.name.toLowerCase() == cName.toLowerCase());
    if (ci < 0) ci = 0;
    _countryIndex = ci;
    final cities = kCheckoutCountries[ci].cities;
    final cityTxt = widget.city.text.trim();
    if (cityTxt.isEmpty) {
      _cityDropdownValue = null;
      return;
    }
    final known = cities.any((c) => c.name.toLowerCase() == cityTxt.toLowerCase());
    if (known) {
      _cityDropdownValue = cities.firstWhere((c) => c.name.toLowerCase() == cityTxt.toLowerCase()).name;
      final auto = checkoutPostalFor(kCheckoutCountries[ci].name, _cityDropdownValue!);
      if (auto != null && auto.isNotEmpty) {
        widget.postal.text = auto;
      }
    } else {
      _cityDropdownValue = cityTxt;
    }
  }

  CheckoutCountry get _countryData => kCheckoutCountries[_countryIndex];

  List<String> get _cityItemValues {
    final names = _countryData.cities.map((c) => c.name).toList();
    final v = _cityDropdownValue;
    if (v != null && v.isNotEmpty && !names.contains(v)) {
      return [...names, v];
    }
    return names;
  }

  void _onCountryChanged(String? name) {
    if (name == null) return;
    final i = kCheckoutCountries.indexWhere((c) => c.name == name);
    if (i < 0) return;
    setState(() {
      _countryIndex = i;
      widget.country.text = name;
      _cityDropdownValue = null;
      widget.city.text = '';
      widget.postal.text = '';
    });
  }

  void _onCityChanged(String? name) {
    setState(() {
      _cityDropdownValue = name;
      if (name == null || name.isEmpty) {
        widget.city.text = '';
        widget.postal.text = '';
        return;
      }
      widget.city.text = name;
      final p = checkoutPostalFor(_countryData.name, name);
      widget.postal.text = p ?? widget.postal.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 41),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(14, 14, 14, 0.4), blurRadius: 40, offset: Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('CONTACT INFO'),
          const SizedBox(height: 16),
          _InputField(label: 'First Name', controller: widget.firstName),
          const SizedBox(height: 24),
          _InputField(label: 'Last Name', controller: widget.lastName),
          const SizedBox(height: 24),
          _InputField(label: 'Email Address', controller: widget.email, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 24),
          _InputField(label: 'Phone Number', controller: widget.phone, keyboardType: TextInputType.phone),
          const SizedBox(height: 40),
          const _SectionTitle('DELIVERY ADDRESS'),
          const SizedBox(height: 16),
          _InputField(label: 'Street Address', controller: widget.street),
          const SizedBox(height: 24),
          _InputField(label: 'Apt, Suite, Unit (Optional)', controller: widget.apt),
          const SizedBox(height: 24),
          _LabeledDropdown(
            label: 'Country',
            value: _countryData.name,
            items: kCheckoutCountries.map((c) => c.name).toList(),
            onChanged: _onCountryChanged,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabeledDropdown(
                  label: 'City',
                  value: _cityDropdownValue,
                  hint: 'Select city',
                  items: _cityItemValues,
                  onChanged: _onCityChanged,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _ReadOnlyPostalField(controller: widget.postal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveValue = value != null && items.contains(value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF4E4639)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              // Controlled selection; `value` still correct until FormField migration stabilizes.
              // ignore: deprecated_member_use
              value: effectiveValue,
              dropdownColor: const Color(0xFF2A2A2A),
              iconEnabledColor: const Color(0xFFE9C349),
              hint: hint != null
                  ? Text(hint!, style: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(229, 226, 225, 0.45)))
                  : null,
              style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1)),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.fromLTRB(5, 14, 5, 14)),
              items: items
                  .map(
                    (s) => DropdownMenuItem<String>(
                      value: s,
                      child: Text(s, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyPostalField extends StatelessWidget {
  const _ReadOnlyPostalField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Postal Code',
            style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1)),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(17, 15, 17, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF232323),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF4E4639)),
          ),
          child: TextField(
            controller: controller,
            readOnly: true,
            enableInteractiveSelection: true,
            style: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(229, 226, 225, 0.85)),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Choose a city',
              hintStyle: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(229, 226, 225, 0.35)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 9),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
      child: Text(
        text,
        style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFE9C349)),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.label, required this.controller, this.keyboardType});
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(17, 15, 17, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF4E4639)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1)),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavedAddressPicker extends ConsumerWidget {
  const _SavedAddressPicker({required this.onSelected, required this.selectedId});
  final void Function(SavedAddress) onSelected;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(savedAddressesProvider);
    return addressesAsync.when(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SAVED ADDRESS', style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 2, color: const Color(0xFFE9C349))),
            const SizedBox(height: 10),
            for (final a in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => onSelected(a),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: a.id == selectedId ? const Color(0xFF2A2A2A) : const Color(0xFF1C1B1B),
                      border: Border.all(
                        color: a.id == selectedId ? const Color(0xFFE9C349) : const Color.fromRGBO(78, 70, 57, 0.4),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${a.tag} · ${a.fullName}\n${a.street}, ${a.city}',
                      style: GoogleFonts.manrope(fontSize: 12, height: 18 / 12, color: const Color(0xFFE5E2E1)),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
