import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/saved_address.dart';
import '../state/providers.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final addressesAsync = ref.watch(savedAddressesProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _luxGold, size: 20),
                  ),
                  Expanded(
                    child: Text('Saved Addresses', textAlign: TextAlign.center, style: GoogleFonts.bodoniModa(fontSize: 24, color: _text)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: user == null
                  ? Center(child: Text('Sign in to manage addresses.', style: GoogleFonts.manrope(color: _muted)))
                  : addressesAsync.when(
                      data: (list) => list.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text('No saved addresses yet. Add one for faster checkout.', textAlign: TextAlign.center, style: GoogleFonts.manrope(color: _muted)),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(24),
                              itemCount: list.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) => _AddressTile(
                                address: list[i],
                                onDelete: () {
                                  final r = ref.read(userRepositoryProvider);
                                  if (r == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Addresses are unavailable on Windows desktop. Use Android or Chrome.'),
                                      ),
                                    );
                                    return;
                                  }
                                  r.deleteAddress(user.uid, list[i].id);
                                },
                              ),
                            ),
                      loading: () => const Center(child: CircularProgressIndicator(color: _luxGold)),
                      error: (e, _) => Center(child: Text('Could not load addresses.', style: GoogleFonts.manrope(color: _muted))),
                    ),
            ),
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _showAddSheet(context, ref, user.uid),
                    style: FilledButton.styleFrom(backgroundColor: _luxGold, foregroundColor: const Color(0xFF2A2420), padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('ADD NEW ADDRESS'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref, String uid) async {
    final tag = TextEditingController(text: 'HOME');
    final name = TextEditingController();
    final phone = TextEditingController();
    final street = TextEditingController();
    final city = TextEditingController(text: 'Colombo');
    final postal = TextEditingController();
    var isDefault = true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1B1B),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.viewInsetsOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Label (HOME / OFFICE)', tag),
            _field('Full name', name),
            _field('Phone', phone, keyboard: TextInputType.phone),
            _field('Street', street),
            _field('City', city),
            _field('Postal code', postal),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (context, setSt) => CheckboxListTile(
                value: isDefault,
                onChanged: (v) => setSt(() => isDefault = v ?? true),
                title: Text('Default address', style: GoogleFonts.manrope(color: _text, fontSize: 14)),
                activeColor: _luxGold,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final repo = ref.read(userRepositoryProvider);
                if (repo == null) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Addresses are unavailable on Windows desktop. Use Android or Chrome.'),
                      ),
                    );
                  }
                  return;
                }
                final addr = SavedAddress(
                  id: '',
                  tag: tag.text.trim().toUpperCase(),
                  fullName: name.text.trim(),
                  phone: phone.text.trim(),
                  street: street.text.trim(),
                  apt: '',
                  city: city.text.trim(),
                  postalCode: postal.text.trim(),
                  country: 'Sri Lanka',
                  isDefault: isDefault,
                );
                await repo.saveAddress(uid, addr);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              style: FilledButton.styleFrom(backgroundColor: _luxGold, foregroundColor: const Color(0xFF2A2420), minimumSize: const Size.fromHeight(48)),
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );

    tag.dispose();
    name.dispose();
    phone.dispose();
    street.dispose();
    city.dispose();
    postal.dispose();
  }

  Widget _field(String label, TextEditingController c, {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        style: GoogleFonts.manrope(color: _text),
        decoration: InputDecoration(labelText: label, labelStyle: GoogleFonts.manrope(color: _muted)),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address, required this.onDelete});
  final SavedAddress address;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        border: Border.all(color: address.isDefault ? const Color(0xFFB8963E) : const Color.fromRGBO(78, 70, 57, 0.35)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${address.tag}${address.isDefault ? ' · DEFAULT' : ''}', style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 1.2, color: const Color(0xFFB8963E))),
                const SizedBox(height: 6),
                Text(address.fullName, style: GoogleFonts.manrope(fontSize: 15, color: const Color(0xFFF5F0E8))),
                Text('${address.street}, ${address.city} ${address.postalCode}', style: GoogleFonts.manrope(fontSize: 13, color: const Color(0xFFD0C5B2))),
                Text(address.phone, style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF8A8278))),
              ],
            ),
          ),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFC78B94))),
        ],
      ),
    );
  }
}
