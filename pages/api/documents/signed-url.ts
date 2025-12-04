// pages/api/documents/signed-url.ts
import type { NextApiRequest, NextApiResponse } from 'next';
import { supabaseAdmin } from '../../../lib/supabaseAdmin'; // server-only client

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const path = (req.query.path as string | undefined) || '';
  if (!path) return res.status(400).json({ error: 'Missing path query param' });

  try {
    // bucket name MUST match exactly (case-sensitive)
    const { data, error } = await supabaseAdmin
      .storage
      .from('Documents')
      .createSignedUrl(path, 60); // 60 second expiry (change if needed)

    if (error) {
      // this returns message from Supabase storage if file missing/permission issue
      return res.status(500).json({ error: error.message || error });
    }

    return res.status(200).json(data); // { signedUrl, expiresAt }
  } catch (err: any) {
    console.error('signed-url error', err);
    return res.status(500).json({ error: err.message || 'Server error' });
  }
}
