import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

const TO = 'info@mojplot.sk';
const FROM = 'Môj plot Kalkulačka <kalkulacka@mojplot.sk>';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  try {
    const {
      from_name, from_email, phone, message, subject,
      customer_name, customer_phone, customer_email, customer_message,
      product, price_estimate, configuration, source
    } = req.body;

    const name   = from_name    || customer_name    || 'Neuvedené';
    const email  = from_email   || customer_email   || '';
    const tel    = phone        || customer_phone   || 'Neuvedené';
    const msg    = message      || customer_message || '';
    const subj   = subject      || (product ? `Dopyt – ${product}` : 'Dopyt z webu Môj plot');

    const html = `
      <h2 style="color:#2E7D32">${subj}</h2>
      <table style="border-collapse:collapse;font-family:sans-serif;font-size:14px">
        <tr><td style="padding:6px 12px 6px 0;color:#666;white-space:nowrap"><b>Meno</b></td><td style="padding:6px 0">${name}</td></tr>
        <tr><td style="padding:6px 12px 6px 0;color:#666;white-space:nowrap"><b>Email</b></td><td style="padding:6px 0"><a href="mailto:${email}">${email}</a></td></tr>
        <tr><td style="padding:6px 12px 6px 0;color:#666;white-space:nowrap"><b>Telefón</b></td><td style="padding:6px 0"><a href="tel:${tel}">${tel}</a></td></tr>
        ${product         ? `<tr><td style="padding:6px 12px 6px 0;color:#666"><b>Produkt</b></td><td style="padding:6px 0">${product}</td></tr>` : ''}
        ${price_estimate  ? `<tr><td style="padding:6px 12px 6px 0;color:#666"><b>Cena</b></td><td style="padding:6px 0;font-weight:bold;color:#2E7D32">${price_estimate}</td></tr>` : ''}
        ${source          ? `<tr><td style="padding:6px 12px 6px 0;color:#666"><b>Zdroj</b></td><td style="padding:6px 0">${source}</td></tr>` : ''}
      </table>
      ${msg          ? `<h3 style="margin-top:20px">Správa</h3><p style="white-space:pre-wrap">${msg}</p>` : ''}
      ${configuration ? `<h3 style="margin-top:20px">Konfigurácia</h3><pre style="background:#f5f5f5;padding:12px;border-radius:6px;font-size:13px">${configuration}</pre>` : ''}
    `;

    await resend.emails.send({ from: FROM, to: TO, reply_to: email || undefined, subject: subj, html });

    return res.status(200).json({ ok: true });
  } catch (err) {
    console.error('Resend error:', err);
    return res.status(500).json({ error: 'Failed to send email' });
  }
}
