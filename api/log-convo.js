/* Ukladanie histórie AI konverzácií do Upstash Redis (REST API).
   Volá ho widget po každej odpovedi AI — upsert podľa sessionId,
   takže jedna konverzácia = jeden záznam s kompletným prepisom.

   Potrebné env premenné na Verceli (Storage → Upstash Redis ich nastaví samo):
   - KV_REST_API_URL  alebo UPSTASH_REDIS_REST_URL
   - KV_REST_API_TOKEN alebo UPSTASH_REDIS_REST_TOKEN */

const REDIS_URL = process.env.KV_REST_API_URL || process.env.UPSTASH_REDIS_REST_URL;
const REDIS_TOKEN = process.env.KV_REST_API_TOKEN || process.env.UPSTASH_REDIS_REST_TOKEN;

async function redis(commands) {
  const r = await fetch(`${REDIS_URL}/pipeline`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${REDIS_TOKEN}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(commands),
  });
  if (!r.ok) throw new Error(`Redis error ${r.status}`);
  return r.json();
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!REDIS_URL || !REDIS_TOKEN) return res.status(503).json({ error: 'Storage not configured' });

  try {
    const { sessionId, lang, page, messages } = req.body || {};

    if (!sessionId || !/^[a-zA-Z0-9_-]{6,64}$/.test(sessionId)) {
      return res.status(400).json({ error: 'Invalid sessionId' });
    }
    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ error: 'No messages' });
    }

    // Sanitizácia: max 200 správ, každá max 4000 znakov, len role+content
    const clean = messages.slice(0, 200).map((m) => ({
      role: m && m.role === 'user' ? 'user' : 'assistant',
      content: String((m && m.content) || '').slice(0, 4000),
    }));

    const now = Date.now();
    const key = `convo:${sessionId}`;

    // Zachovaj createdAt z existujúceho záznamu (upsert)
    const existing = await redis([['GET', key]]);
    let createdAt = now;
    try {
      const prev = existing && existing[0] && existing[0].result ? JSON.parse(existing[0].result) : null;
      if (prev && prev.createdAt) createdAt = prev.createdAt;
    } catch (e) { /* poškodený starý záznam — začni odznova */ }

    const record = {
      id: sessionId,
      createdAt,
      updatedAt: now,
      lang: lang === 'en' ? 'en' : 'sk',
      page: String(page || '').slice(0, 300),
      messages: clean,
    };

    await redis([
      ['SET', key, JSON.stringify(record)],
      ['ZADD', 'convo:index', String(createdAt), sessionId],
    ]);

    return res.status(200).json({ ok: true });
  } catch (err) {
    console.error('log-convo error:', err);
    return res.status(500).json({ error: 'Failed to log' });
  }
}
