/* Čítanie histórie AI konverzácií pre admin dashboard (admin.html).
   Chránené env premennou ADMIN_KEY — bez správneho kľúča vráti 401.

   GET    ?from=YYYY-MM-DD&to=YYYY-MM-DD&limit=50&offset=0   → zoznam konverzácií (najnovšie prvé)
   DELETE ?id=<sessionId>                                     → zmaže jednu konverzáciu (GDPR)

   Kľúč sa posiela v hlavičke:  Authorization: Bearer <ADMIN_KEY>

   Potrebné env premenné na Verceli:
   - ADMIN_KEY (silné heslo pre dashboard)
   - KV_REST_API_URL / KV_REST_API_TOKEN (Upstash Redis) */

const REDIS_URL = process.env.KV_REST_API_URL || process.env.UPSTASH_REDIS_REST_URL;
const REDIS_TOKEN = process.env.KV_REST_API_TOKEN || process.env.UPSTASH_REDIS_REST_TOKEN;
const ADMIN_KEY = process.env.ADMIN_KEY;

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
  res.setHeader('Access-Control-Allow-Methods', 'GET, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (!REDIS_URL || !REDIS_TOKEN) return res.status(503).json({ error: 'Storage not configured' });
  if (!ADMIN_KEY) return res.status(503).json({ error: 'ADMIN_KEY not configured' });

  const auth = req.headers.authorization || '';
  const key = auth.startsWith('Bearer ') ? auth.slice(7) : '';
  if (key !== ADMIN_KEY) return res.status(401).json({ error: 'Unauthorized' });

  try {
    if (req.method === 'DELETE') {
      const id = String(req.query.id || '');
      if (!/^[a-zA-Z0-9_-]{6,64}$/.test(id)) return res.status(400).json({ error: 'Invalid id' });
      await redis([
        ['DEL', `convo:${id}`],
        ['ZREM', 'convo:index', id],
      ]);
      return res.status(200).json({ ok: true });
    }

    if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

    const limit = Math.min(Math.max(parseInt(req.query.limit) || 50, 1), 200);
    const offset = Math.max(parseInt(req.query.offset) || 0, 0);

    // Dátumový filter → rozsah skóre (createdAt v ms). `to` je vrátane celého dňa.
    let min = '-inf';
    let max = '+inf';
    if (req.query.from && /^\d{4}-\d{2}-\d{2}$/.test(req.query.from)) {
      min = String(new Date(`${req.query.from}T00:00:00`).getTime());
    }
    if (req.query.to && /^\d{4}-\d{2}-\d{2}$/.test(req.query.to)) {
      max = String(new Date(`${req.query.to}T23:59:59.999`).getTime());
    }

    const [countRes, idsRes] = await redis([
      ['ZCOUNT', 'convo:index', min, max],
      ['ZREVRANGEBYSCORE', 'convo:index', max, min, 'LIMIT', String(offset), String(limit)],
    ]);

    const total = countRes.result || 0;
    const ids = idsRes.result || [];
    if (ids.length === 0) return res.status(200).json({ ok: true, total, items: [] });

    const dataRes = await redis([['MGET', ...ids.map((id) => `convo:${id}`)]]);
    const items = (dataRes[0].result || [])
      .map((raw) => { try { return JSON.parse(raw); } catch (e) { return null; } })
      .filter(Boolean);

    return res.status(200).json({ ok: true, total, items });
  } catch (err) {
    console.error('history error:', err);
    return res.status(500).json({ error: 'Failed to read history' });
  }
}
