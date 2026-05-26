/**
 * Creates the Firebase default Storage bucket via REST API, then deploys storage rules.
 * Requires: firebase login (same account as firebase deploy).
 */
import { spawnSync } from 'node:child_process';
import { createRequire } from 'node:module';

const require = createRequire(
  'file:///' + process.env.APPDATA.replace(/\\/g, '/') + '/npm/node_modules/firebase-tools/package.json',
);
const auth = require('firebase-tools/lib/auth');

const projectId = process.argv[2] || 'fashion-store-app-2ac1f';
// Match Firestore if possible; us-central1 is a safe default for new projects.
const location = process.argv[3] || 'us-central1';

async function getBearerToken() {
  const accounts = auth.getAllAccounts();
  if (!accounts.length) {
    throw new Error('Not logged in. Run: firebase login');
  }
  const account = accounts.find((a) => a.user.email) || accounts[0];
  const token = await auth.getAccessToken(account.tokens.refresh_token, [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/firebase',
  ]);
  return token.access_token;
}

async function createDefaultBucket(accessToken) {
  const url = `https://firebasestorage.googleapis.com/v1alpha/projects/${projectId}/defaultBucket`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ location }),
  });

  const text = await res.text();
  if (res.ok) {
    console.log('Default Storage bucket created or linked.');
    return;
  }

  if (res.status === 409 || text.includes('already exists')) {
    console.log('Storage bucket already exists.');
    return;
  }

  throw new Error(`Storage setup failed (${res.status}): ${text}`);
}

function deployStorageRules() {
  const r = spawnSync(
    'firebase',
    ['deploy', '--only', 'storage:rules', '--project', projectId],
    { stdio: 'inherit', shell: true },
  );
  if (r.status !== 0) process.exit(r.status ?? 1);
}

async function main() {
  console.log(`Setting up Firebase Storage for ${projectId} (${location})...`);
  const accessToken = await getBearerToken();
  await createDefaultBucket(accessToken);
  console.log('Deploying storage.rules...');
  deployStorageRules();
  console.log('Done.');
}

main().catch((err) => {
  console.error(err.message || err);
  console.error('\nIf API setup failed, open Storage in the browser and click Get started:');
  console.error(`https://console.firebase.google.com/project/${projectId}/storage`);
  process.exit(1);
});
