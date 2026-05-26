import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_console_links.dart';

/// Shown when Firebase returns *provider disabled* / operation-not-allowed for Google.
Future<void> showGoogleSignInSetupDialog(BuildContext context) async {
  final projectId = Firebase.app().options.projectId ?? '(unknown)';
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      final body = GoogleFonts.plusJakartaSans(
        color: const Color(0xFFE5E2E1),
        fontSize: 14,
        height: 1.4,
      );
      return AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'Enable Google in Firebase',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFF5F0E8),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Project: $projectId', style: body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text(
                '1. In Firebase Console → Authentication → Sign-in method, turn Google on and save.\n\n'
                '2. On web, open Google Cloud → Credentials → your Web client and add Authorized JavaScript origins for your URL (e.g. http://localhost:PORT).',
                style: body,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFB8B4B0))),
          ),
          TextButton(
            onPressed: () async {
              final u = googleCloudConsoleCredentialsUri();
              if (await canLaunchUrl(u)) {
                await launchUrl(u, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              'Google Cloud',
              style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE8C265)),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE8C265),
              foregroundColor: const Color(0xFF3E2E00),
            ),
            onPressed: () async {
              final u = firebaseConsoleAuthProvidersUri();
              if (await canLaunchUrl(u)) {
                await launchUrl(u, mode: LaunchMode.externalApplication);
              }
            },
            child: Text('Open Firebase', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ],
      );
    },
  );
}
