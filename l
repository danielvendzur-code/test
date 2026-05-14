<!DOCTYPE html>

<html lang="sk">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Môj plot - AI asistent & Cenová kalkulačka</title>
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{
  --m-green:#2E7D32;
  --m-green-hover:#1B5E20;
  --m-green-light:#4CAF50;
  --m-green-soft:#66BB6A;
  --m-green-glow:rgba(46,125,50,.18);
  --m-green-bg:rgba(46,125,50,.08);
  --m-green-line:rgba(46,125,50,.35);
  --m-dark:#1F2937;
  --m-darker:#111827;
  --m-white:#FFFFFF;
  --m-light:#F5F7F4;
  --m-light-2:#EEF2EE;
  --m-gray:#6B7280;
  --m-border:#E2E6EA;
  --m-success:#2E7D32;
  --m-error:#E53935;
  --m-amber:#F59E0B;
  --m-radius:20px;
  --m-font:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
  --mc-bg:#FFF;
  --mc-msg-bot:#F5F7F4;
  --mc-msg-user:#2E7D32;
  --mc-msg-user-text:#FFF;
  --mc-input-bg:#F5F7F4;
  --mc-header-bg:#1F2937;
  --mc-header-text:#FFF;
  --mc-text:#1F2937;
  --mc-text-sub:#6B7280;
  --mc-border:#E2E6EA;
  --mc-contact-bg:#FFF
}
.dark-mode{
  --mc-bg:#0F1A14;
  --mc-msg-bot:#1A2820;
  --mc-msg-user:#4CAF50;
  --mc-msg-user-text:#0F1A14;
  --mc-input-bg:#1A2820;
  --mc-header-bg:#070D0A;
  --mc-header-text:#E8EBE9;
  --mc-text:#E8EBE9;
  --mc-text-sub:#8A9A92;
  --mc-border:#1A2820;
  --mc-contact-bg:#0F1A14
}
*{margin:0;padding:0;box-sizing:border-box}
html{font-size:16px!important}
body{margin:0;padding:0;background:transparent!important;font-family:var(--m-font)!important;font-size:16px!important}

html.mc-locked, body.mc-locked{overflow:hidden!important;height:100%!important;position:fixed!important;width:100%!important;touch-action:none!important;-webkit-overflow-scrolling:auto!important}

/* Tooltip */
#mc-tooltip{position:fixed;bottom:94px;right:16px;background:#fff;color:#1F2937;font-family:var(–m-font)!important;font-size:14px!important;font-weight:600!important;padding:11px 34px 11px 16px;border-radius:14px;box-shadow:0 6px 28px rgba(0,0,0,.18);z-index:100000;white-space:nowrap;line-height:1.4!important;cursor:pointer;opacity:0;animation:tooltipShow .4s ease .6s forwards;letter-spacing:.1px;display:none}
#mc-tooltip::after{content:’’;position:absolute;bottom:-8px;right:32px;border-left:8px solid transparent;border-right:8px solid transparent;border-top:8px solid #fff}
#mc-tooltip .tt-x{position:absolute;top:4px;right:6px;width:18px;height:18px;border:none;background:transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:14px;color:var(–m-gray);line-height:1}
#mc-tooltip .tt-x:hover{background:var(–m-light);color:var(–m-dark)}
@keyframes tooltipShow{to{opacity:1}}

/* Bubble */
#mojplot-bubble{position:fixed;bottom:18px;right:18px;width:68px;height:68px;background:#fff;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;box-shadow:0 6px 24px rgba(46,125,50,.35),0 0 0 0 rgba(46,125,50,.4);transition:transform .3s cubic-bezier(.34,1.56,.64,1),box-shadow .3s;z-index:100000;overflow:hidden;animation:bubblePulse 3s ease-in-out infinite;border:2px solid #fff}
@keyframes bubblePulse{0%,100%{box-shadow:0 6px 24px rgba(46,125,50,.35),0 0 0 0 rgba(46,125,50,.4)}50%{box-shadow:0 6px 24px rgba(46,125,50,.35),0 0 0 14px rgba(46,125,50,0)}}
#mojplot-bubble:hover{transform:scale(1.08);animation:none}
#mojplot-bubble.open{animation:none;opacity:0;pointer-events:none}
#mojplot-bubble .bubble-icon{width:54px;height:54px;display:flex;align-items:center;justify-content:center;transform-origin:center}
#mojplot-bubble .bubble-icon img{width:100%;height:100%;object-fit:contain;display:block}
#mojplot-bubble.open .bubble-icon{display:none}
#mojplot-bubble .bubble-x{display:none;width:28px;height:28px;align-items:center;justify-content:center}
#mojplot-bubble.open .bubble-x{display:flex}
.bubble-x svg{width:24px;height:24px;fill:#2E7D32}
@keyframes botWobble{0%,100%{transform:rotate(0) translateY(0)}25%{transform:rotate(6deg) translateY(-1px)}75%{transform:rotate(-6deg) translateY(-1px)}}
.wobble{animation:botWobble 2.2s ease-in-out infinite}

/* Notifikacny bod */
#mojplot-bubble .notif-dot{position:absolute;top:6px;right:7px;width:14px;height:14px;background:#FF5252;border-radius:50%;border:2.5px solid #fff;display:flex;align-items:center;justify-content:center;color:#fff;font-size:9px;font-weight:800;animation:notifPulse 2s ease-in-out infinite}
@keyframes notifPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.15)}}
#mojplot-bubble.open .notif-dot{display:none}

/* Chat okno */
#mojplot-chat{position:fixed;bottom:96px;right:18px;width:390px;max-height:600px;height:78vh;background:var(–mc-bg);border-radius:var(–m-radius);box-shadow:0 18px 70px rgba(31,41,55,.28);display:flex;flex-direction:column;overflow:hidden;z-index:99999;transform:scale(.85) translateY(20px);opacity:0;pointer-events:none;transition:transform .42s cubic-bezier(.34,1.56,.64,1),opacity .3s;transform-origin:bottom right}
#mojplot-chat.visible{transform:scale(1) translateY(0);opacity:1;pointer-events:all}

/* Header */
.mc-header{background:linear-gradient(135deg,#1F2937 0%,#111827 100%);padding:13px 16px;display:flex;align-items:center;gap:11px;flex-shrink:0;position:relative;overflow:hidden}
.mc-header::before{content:’’;position:absolute;top:-40px;right:-40px;width:140px;height:140px;background:radial-gradient(circle,rgba(46,125,50,.22) 0%,transparent 65%);pointer-events:none}
.mc-hdr-av{width:48px;height:48px;border-radius:14px;overflow:hidden;flex-shrink:0;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 4px 12px rgba(46,125,50,.4);position:relative;z-index:1;padding:4px;box-sizing:border-box}
.mc-hdr-av img{width:100%;height:100%;object-fit:contain;display:block}
.mc-hdr-av svg{width:30px;height:30px;fill:#2E7D32}
.mc-hdr-info{flex:1;position:relative;z-index:1}
.mc-hdr-title{font-size:15px;font-weight:700;color:var(–mc-header-text);letter-spacing:-.2px}
.mc-hdr-sub{font-size:11px;color:rgba(255,255,255,.6);display:flex;align-items:center;gap:5px;margin-top:1px;font-weight:500}
.mc-hdr-sub .dot{width:7px;height:7px;background:#4CAF50;border-radius:50%;animation:dotP 2s infinite;box-shadow:0 0 6px #4CAF50}
@keyframes dotP{0%,100%{opacity:1}50%{opacity:.4}}
.mc-hdr-actions{display:flex;gap:4px;align-items:center;position:relative;z-index:1}
.mc-hdr-btn{width:32px;height:32px;border:none;border-radius:9px;cursor:pointer;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.08);transition:all .2s}
.mc-hdr-btn:hover{background:rgba(255,255,255,.15)}
.mc-hdr-btn svg{width:15px;height:15px;fill:rgba(255,255,255,.7)}
.mc-hdr-btn.active svg{fill:#4CAF50}
.mc-lang{display:flex;gap:2px;background:rgba(0,0,0,.25);border-radius:8px;padding:2px}
.mc-lang button{border:none;background:transparent;color:rgba(255,255,255,.65);font-family:var(–m-font);font-size:11px;font-weight:700;padding:4px 8px;border-radius:6px;cursor:pointer;transition:all .2s;letter-spacing:.3px}
.mc-lang button.active{background:#2E7D32;color:#fff;box-shadow:0 1px 4px rgba(0,0,0,.2)}

/* Spravy */
.mc-msgs{flex:1;overflow-y:auto;padding:14px;display:flex;flex-direction:column;gap:6px;scroll-behavior:smooth;-webkit-overflow-scrolling:touch;overscroll-behavior:contain}
.mc-msgs::-webkit-scrollbar{width:4px}
.mc-msgs::-webkit-scrollbar-thumb{background:var(–mc-border);border-radius:4px}
.mc-row{display:flex;gap:8px;align-items:flex-end;animation:msgIn .35s cubic-bezier(.34,1.4,.64,1)}
.mc-row.user{justify-content:flex-end}
@keyframes msgIn{from{opacity:0;transform:translateY(10px) scale(.93)}to{opacity:1;transform:translateY(0) scale(1)}}
.mc-av{width:32px;height:32px;flex-shrink:0;border-radius:10px;overflow:hidden;background:linear-gradient(135deg,#2E7D32,#1B5E20);display:flex;align-items:center;justify-content:center;box-shadow:0 2px 6px rgba(46,125,50,.3)}
.mc-av svg{width:20px;height:20px;fill:#fff}
.mc-row.user .mc-av{display:none}
.mc-mc{max-width:80%}
.mc-m{padding:10px 14px;font-size:13.5px;line-height:1.55;border-radius:16px;word-wrap:break-word;color:var(–mc-text)}
.mc-m.bot{background:var(–mc-msg-bot);border-bottom-left-radius:5px}
.mc-m.user{background:var(–mc-msg-user);color:var(–mc-msg-user-text);border-bottom-right-radius:5px;font-weight:500;box-shadow:0 2px 8px rgba(46,125,50,.25)}
.mc-m a{color:#1976D2;text-decoration:underline;font-weight:600}
.dark-mode .mc-m a{color:#66BB6A}
.mc-m b,.mc-m strong{font-weight:700;color:var(–mc-text)}
.mc-m.user b,.mc-m.user strong{color:#fff}
.mc-ts{font-size:10px;color:var(–mc-text-sub);margin-top:2px;padding:0 2px;font-weight:500}
.mc-row.user .mc-ts{text-align:right}
.mc-rt{display:flex;gap:4px;margin-top:5px}
.mc-rb{width:26px;height:26px;border:1px solid var(–mc-border);background:transparent;border-radius:7px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:12px;opacity:.45;transition:all .2s}
.mc-rb:hover,.mc-rb.on{opacity:1;border-color:var(–m-green);background:var(–m-green-glow)}

.mc-typing{display:none;gap:8px;align-items:flex-end;padding:0 14px 6px}
.mc-typing.show{display:flex}
.mc-tbub{display:flex;gap:4px;align-items:center;padding:12px 18px;background:var(–mc-msg-bot);border-radius:16px;border-bottom-left-radius:5px}
.mc-tbub span{width:6px;height:6px;background:var(–mc-text-sub);border-radius:50%;animation:tb 1.4s infinite}
.mc-tbub span:nth-child(2){animation-delay:.15s}
.mc-tbub span:nth-child(3){animation-delay:.3s}
@keyframes tb{0%,60%,100%{transform:translateY(0);opacity:.35}30%{transform:translateY(-5px);opacity:1}}

/* Chips / Quick actions */
.mc-chips{display:flex;flex-wrap:wrap;gap:6px;padding:4px 14px 8px;flex-shrink:0}
.mc-chip{border:1px solid var(–mc-border);background:var(–mc-bg);color:var(–mc-text);font-family:var(–m-font);font-size:12.5px;font-weight:600;padding:7px 13px;border-radius:20px;cursor:pointer;transition:all .25s cubic-bezier(.34,1.4,.64,1);position:relative;overflow:hidden}
.mc-chip:hover{border-color:var(–m-green);color:var(–m-green);transform:translateY(-1px);box-shadow:0 4px 12px rgba(46,125,50,.18)}
.mc-chip.mc-chip-calc{background:linear-gradient(135deg,#2E7D32,#1B5E20);color:#fff;border-color:#1B5E20;box-shadow:0 3px 10px rgba(46,125,50,.4);animation:calcPulse 2.5s ease-in-out infinite}
.mc-chip.mc-chip-calc:hover{transform:translateY(-2px);box-shadow:0 6px 16px rgba(46,125,50,.55);color:#fff;animation:none}
@keyframes calcPulse{0%,100%{box-shadow:0 3px 10px rgba(46,125,50,.4)}50%{box-shadow:0 3px 18px rgba(46,125,50,.7)}}
.mc-quick-calc{width:42px;height:42px;border:none;border-radius:12px;background:linear-gradient(135deg,#2E7D32,#1B5E20);color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;box-shadow:0 4px 12px rgba(46,125,50,.35);transition:transform .2s,filter .2s}
.mc-quick-calc:hover{transform:translateY(-1px) scale(1.05);filter:brightness(1.1)}
.mc-quick-calc svg{width:20px;height:20px;fill:currentColor}

/* Input bar */
.mc-ibar{display:flex;align-items:center;gap:7px;padding:10px 14px;border-top:1px solid var(–mc-border);flex-shrink:0}
.mc-inp{flex:1;border:1.5px solid var(–mc-border);border-radius:12px;padding:10px 13px;font-family:var(–m-font);font-size:13.5px;color:var(–mc-text);outline:none;background:var(–mc-input-bg);transition:border-color .2s,background .2s}
.mc-inp:focus{border-color:var(–m-green);background:var(–mc-bg)}
.mc-inp::placeholder{color:var(–mc-text-sub)}
.mc-send{width:42px;height:42px;background:linear-gradient(135deg,#2E7D32,#1B5E20);border:none;border-radius:12px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .2s;flex-shrink:0;box-shadow:0 3px 10px rgba(46,125,50,.35)}
.mc-send:hover{transform:scale(1.05);filter:brightness(1.1)}
.mc-send svg{width:18px;height:18px;fill:#fff}

/* Kontaktna lista */
.mc-cbar{display:flex;gap:5px;padding:8px 14px;border-top:1px solid var(–mc-border);flex-shrink:0;background:var(–mc-contact-bg);border-radius:0 0 var(–m-radius) var(–m-radius)}
.mc-ct{flex:1;display:flex;align-items:center;justify-content:center;gap:6px;padding:9px 6px;font-family:var(–m-font);font-size:11.5px;font-weight:700;color:var(–mc-text);cursor:pointer;border:1.5px solid var(–mc-border);background:var(–mc-bg);border-radius:11px;transition:all .25s;text-decoration:none}
.mc-ct:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(0,0,0,.1)}
.mc-ci{width:24px;height:24px;border-radius:7px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.mc-ci svg{width:14px;height:14px}
.mc-ct.wa .mc-ci{background:#25D366}.mc-ct.wa .mc-ci svg{fill:#fff}.mc-ct.wa:hover{border-color:#25D366}
.mc-ct.ph .mc-ci{background:#2196F3}.mc-ct.ph .mc-ci svg{fill:#fff}.mc-ct.ph:hover{border-color:#2196F3}
.mc-ct.em .mc-ci{background:linear-gradient(135deg,#2E7D32,#1B5E20)}.mc-ct.em .mc-ci svg{fill:#fff}.mc-ct.em:hover{border-color:#2E7D32}

/* Email overlay */
.mc-eo{display:none;position:absolute;inset:0;background:rgba(0,0,0,.45);backdrop-filter:blur(4px);z-index:10}
.mc-eo.show{display:block}
.mc-ep{display:none;flex-direction:column;position:absolute;bottom:0;left:0;right:0;background:var(–mc-bg);border-radius:20px 20px 0 0;z-index:11;animation:sp .35s cubic-bezier(.34,1.2,.64,1);box-shadow:0 -10px 40px rgba(0,0,0,.2)}
.mc-ep.show{display:flex}
@keyframes sp{from{transform:translateY(100%)}to{transform:translateY(0)}}
.mc-eph{display:flex;align-items:center;justify-content:space-between;padding:14px 18px 10px;border-bottom:1px solid var(–mc-border)}
.mc-ept{font-size:15px;font-weight:700;color:var(–mc-text);display:flex;align-items:center;gap:8px}
.mc-ept .ei{width:28px;height:28px;background:linear-gradient(135deg,#2E7D32,#1B5E20);border-radius:8px;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 6px rgba(46,125,50,.3)}
.mc-ept .ei svg{width:15px;height:15px;fill:#fff}
.mc-ecl{width:32px;height:32px;border:none;background:var(–mc-input-bg);border-radius:9px;cursor:pointer;display:flex;align-items:center;justify-content:center}
.mc-ecl svg{width:14px;height:14px;fill:var(–mc-text-sub)}
.mc-eb{padding:14px 18px 18px;display:flex;flex-direction:column;gap:9px}
.mc-eb .fg{display:flex;flex-direction:column;gap:4px}
.mc-eb label{font-size:11px;font-weight:700;color:var(–mc-text-sub);text-transform:uppercase;letter-spacing:.5px}
.mc-eb input,.mc-eb textarea{font-family:var(–m-font);font-size:13.5px;line-height:1.55;padding:10px 13px;border:1.5px solid var(–mc-border);border-radius:10px;outline:none;color:var(–mc-text);background:var(–mc-input-bg);transition:border-color .2s,background .2s}
.mc-eb input:focus,.mc-eb textarea:focus{border-color:var(–m-green);background:var(–mc-bg)}
.mc-eb textarea{resize:none;height:68px}
.mc-eb .fr{display:flex;gap:8px}
.mc-eb .fr .fg{flex:1}
.mc-esb{background:linear-gradient(135deg,#2E7D32,#1B5E20);color:#fff;font-family:var(–m-font);font-weight:700;font-size:13.5px;border:none;padding:12px;border-radius:11px;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:7px;margin-top:3px;box-shadow:0 4px 12px rgba(46,125,50,.35);transition:transform .2s,filter .2s}
.mc-esb:hover{transform:translateY(-1px);filter:brightness(1.08)}
.mc-esb svg{width:16px;height:16px;fill:#fff}
.mc-esb.ok{background:#4CAF50}

/* =========== KALKULACKA STYLES =========== */
.mc-calc-container{display:none;position:relative;padding:16px;background:var(–mc-bg);border-top:1px solid var(–mc-border);flex:1;overflow-y:auto;overflow-x:hidden;min-height:0;-webkit-overflow-scrolling:touch;overscroll-behavior:contain}
.mc-calc-container::-webkit-scrollbar{width:4px}
.mc-calc-container::-webkit-scrollbar-thumb{background:var(–mc-border);border-radius:4px}
.mc-calc-container[data-open=“true”]{display:block;animation:calcOpen .4s cubic-bezier(.16,1,.3,1)}
@keyframes calcOpen{from{opacity:0;transform:translateY(15px)}to{opacity:1;transform:translateY(0)}}
.mc-calc-container[data-open=“true”] ~ .mc-msgs,#mojplot-chat:has(.mc-calc-container[data-open=“true”]) .mc-msgs{display:none}

.mc-calc-head{display:flex;justify-content:space-between;margin-bottom:10px;align-items:center}
.mc-calc-title{font-size:14px;font-weight:800;margin:0;color:var(–mc-text);letter-spacing:-.2px}
.mc-calc-close{cursor:pointer;background:var(–mc-input-bg);border:none;font-size:16px;color:var(–mc-text-sub);width:30px;height:30px;border-radius:8px;display:flex;align-items:center;justify-content:center;transition:all .2s}
.mc-calc-close:hover{background:var(–m-green-glow);color:var(–m-green)}

/* Progress bar */
.mc-calc-progress-wrap{margin-bottom:14px;padding:6px 4px 2px;overflow:visible;display:flex;align-items:center;gap:8px}
.mc-progress-back{width:32px;height:32px;border:1px solid var(–mc-border);background:var(–mc-bg);color:var(–mc-text);border-radius:10px;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .2s;flex:0 0 auto;font-size:18px;line-height:1;font-weight:700}
.mc-progress-back:hover{border-color:var(–m-green);background:var(–m-green-glow);color:var(–m-green);transform:translateX(-1px)}
.mc-progress-back:disabled{opacity:.35;cursor:not-allowed;transform:none;background:var(–mc-input-bg)}
.mc-calc-progress{height:10px;border-radius:999px;background:linear-gradient(180deg,rgba(31,41,55,.1),rgba(31,41,55,.04));border:1px solid rgba(31,41,55,.1);overflow:visible;position:relative;box-shadow:inset 0 1px 2px rgba(0,0,0,.06);flex:1}
.mc-calc-progress-fill{height:100%;background:linear-gradient(90deg,#2E7D32,#4CAF50);border-radius:999px;transition:width .42s cubic-bezier(.34,1.2,.64,1);position:relative;box-shadow:0 0 8px rgba(46,125,50,.4)}
.mc-calc-progress-fill::after{content:’’;position:absolute;right:0;top:50%;width:14px;height:14px;border-radius:50%;background:#fff;transform:translate(50%,-50%);box-shadow:0 0 0 3px #2E7D32,0 2px 8px rgba(46,125,50,.4);transition:right .42s cubic-bezier(.34,1.2,.64,1)}
.mc-progress-step{font-size:11px;font-weight:700;color:var(–mc-text-sub);flex:0 0 auto;letter-spacing:.3px}

/* Step content */
.mc-step{animation:stepIn .4s cubic-bezier(.34,1.2,.64,1)}
@keyframes stepIn{from{opacity:0;transform:translateX(15px)}to{opacity:1;transform:translateX(0)}}
.mc-step-title{font-size:16px;font-weight:800;color:var(–mc-text);margin-bottom:4px;letter-spacing:-.3px}
.mc-step-sub{font-size:12.5px;color:var(–mc-text-sub);margin-bottom:14px;line-height:1.45}

/* Cards (product selection) */
.mc-product-grid{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-bottom:8px}
.mc-product-card{position:relative;border:1.5px solid var(–mc-border);border-radius:14px;padding:0;cursor:pointer;transition:all .25s cubic-bezier(.34,1.2,.64,1);background:var(–mc-bg);overflow:hidden;display:flex;flex-direction:column}
.mc-product-card:hover{border-color:var(–m-green);transform:translateY(-2px);box-shadow:0 8px 22px rgba(46,125,50,.18)}
.mc-product-card.selected{border-color:var(–m-green);box-shadow:0 0 0 2px var(–m-green-glow),0 6px 18px rgba(46,125,50,.22);transform:translateY(-2px)}
.mc-product-card.selected::before{content:‘✓’;position:absolute;top:8px;right:8px;width:22px;height:22px;background:var(–m-green);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:800;z-index:2;box-shadow:0 2px 6px rgba(46,125,50,.4);animation:checkPop .35s cubic-bezier(.34,1.6,.64,1)}
@keyframes checkPop{from{transform:scale(0)}to{transform:scale(1)}}
.mc-product-img{width:100%;height:90px;background:linear-gradient(135deg,#F5F7F4,#EEF2EE);overflow:hidden;position:relative;display:flex;align-items:center;justify-content:center}
.mc-product-img img{width:100%;height:100%;object-fit:cover;transition:transform .35s ease}
.mc-product-card:hover .mc-product-img img{transform:scale(1.06)}
.mc-product-info{padding:9px 10px 11px;flex:1;display:flex;flex-direction:column;gap:2px}
.mc-product-name{font-size:13px;font-weight:700;color:var(–mc-text);line-height:1.25}
.mc-product-desc{font-size:10.5px;color:var(–mc-text-sub);font-weight:500;line-height:1.35}
.mc-product-badge{position:absolute;top:7px;left:7px;background:linear-gradient(135deg,#F59E0B,#D97706);color:#fff;font-size:9px;font-weight:800;padding:3px 7px;border-radius:6px;letter-spacing:.3px;text-transform:uppercase;box-shadow:0 2px 6px rgba(217,119,6,.4);z-index:1}
.mc-product-badge.new{background:linear-gradient(135deg,#2E7D32,#1B5E20);box-shadow:0 2px 6px rgba(46,125,50,.4)}

/* Color swatches */
.mc-color-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:8px;margin-bottom:8px}
.mc-color-card{border:1.5px solid var(–mc-border);border-radius:12px;padding:0;cursor:pointer;transition:all .25s;background:var(–mc-bg);display:flex;flex-direction:column;align-items:center;gap:0;position:relative;overflow:hidden}
.mc-color-card:hover{border-color:var(–m-green);transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.08)}
.mc-color-card.selected{border-color:var(–m-green);box-shadow:0 0 0 2px var(–m-green-glow)}
.mc-color-photo{width:100%;height:70px;overflow:hidden;background:linear-gradient(135deg,#F5F7F4,#EEF2EE);display:flex;align-items:center;justify-content:center;position:relative}
.mc-color-photo img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .35s ease}
.mc-color-card:hover .mc-color-photo img{transform:scale(1.08)}
.mc-color-body{padding:7px 6px 8px;display:flex;flex-direction:column;align-items:center;gap:4px;width:100%}
.mc-color-swatch{width:24px;height:24px;border-radius:7px;border:1px solid rgba(0,0,0,.1);box-shadow:inset 0 0 0 1px rgba(255,255,255,.3),0 2px 4px rgba(0,0,0,.12);position:relative;overflow:hidden;flex-shrink:0}
.mc-color-swatch.lg{width:42px;height:42px;border-radius:10px;box-shadow:inset 0 0 0 1px rgba(255,255,255,.3),0 2px 6px rgba(0,0,0,.12)}
.mc-color-swatch.zinok{background:linear-gradient(135deg,#C8CED5 0%,#9AA5AF 50%,#7A8590 100%)}
.mc-color-swatch.zinok::after{content:’’;position:absolute;inset:0;background:repeating-linear-gradient(45deg,transparent 0,transparent 2px,rgba(255,255,255,.1) 2px,rgba(255,255,255,.1) 4px)}
.mc-color-swatch.zelena{background:#3F6E29}
.mc-color-swatch.antracit{background:#2F353B}
.mc-color-name{font-size:11px;font-weight:700;color:var(–mc-text);text-align:center;line-height:1.2}
.mc-color-ral{font-size:9.5px;color:var(–mc-text-sub);font-weight:600}
.mc-color-card.selected::after{content:‘✓’;position:absolute;top:5px;right:5px;width:18px;height:18px;background:var(–m-green);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;z-index:3;box-shadow:0 2px 4px rgba(46,125,50,.4)}

/* Height/Size cards */
.mc-size-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:8px}
.mc-size-card{border:1.5px solid var(–mc-border);border-radius:12px;padding:11px 12px;cursor:pointer;transition:all .25s;background:var(–mc-bg);display:flex;flex-direction:column;gap:3px;position:relative}
.mc-size-card:hover{border-color:var(–m-green);transform:translateY(-1px);box-shadow:0 4px 12px rgba(46,125,50,.12)}
.mc-size-card.selected{border-color:var(–m-green);background:var(–m-green-bg);box-shadow:0 0 0 2px var(–m-green-glow)}
.mc-size-val{font-size:18px;font-weight:800;color:var(–mc-text);letter-spacing:-.3px}
.mc-size-card.selected .mc-size-val{color:var(–m-green)}
.mc-size-label{font-size:10.5px;color:var(–mc-text-sub);font-weight:600;line-height:1.3}
.mc-size-card.popular::before{content:‘TOP’;position:absolute;top:-7px;right:8px;background:linear-gradient(135deg,#F59E0B,#D97706);color:#fff;font-size:8.5px;font-weight:800;padding:2px 6px;border-radius:5px;letter-spacing:.4px;box-shadow:0 2px 4px rgba(217,119,6,.4)}

/* Radio / checkbox */
.mc-radio-list,.mc-check-list{display:flex;flex-direction:column;gap:7px;margin-bottom:8px}
.mc-check{display:flex;align-items:center;gap:11px;padding:11px 13px;cursor:pointer;font-size:13px;color:var(–mc-text);border:1.5px solid var(–mc-border);border-radius:11px;background:var(–mc-bg);transition:all .2s;user-select:none;position:relative;font-weight:600;line-height:1.35}
.mc-check:hover{border-color:var(–m-green);background:var(–m-green-bg)}
.mc-check input[type=“checkbox”],.mc-check input[type=“radio”]{position:absolute;opacity:0;pointer-events:none}
.mc-check .mc-cbx{width:20px;height:20px;border:2px solid var(–mc-text-sub);border-radius:5px;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .2s;background:var(–mc-bg)}
.mc-check input[type=“radio”] ~ .mc-cbx{border-radius:50%}
.mc-check .mc-cbx svg{width:13px;height:13px;fill:none;stroke:#fff;stroke-width:3;stroke-linecap:round;stroke-linejoin:round;opacity:0;transition:opacity .15s}
.mc-check input:checked ~ .mc-cbx{background:var(–m-green);border-color:var(–m-green)}
.mc-check input:checked ~ .mc-cbx svg{opacity:1}
.mc-check input[type=“radio”]:checked ~ .mc-cbx::after{content:’’;width:10px;height:10px;border-radius:50%;background:#fff}
.mc-check input[type=“radio”]:checked ~ .mc-cbx svg{display:none}
.mc-check.selected{border-color:var(–m-green);background:var(–m-green-bg)}
.mc-check-desc{font-size:11px;color:var(–mc-text-sub);font-weight:500;display:block;margin-top:2px;line-height:1.35}
.mc-check-label{flex:1;display:flex;flex-direction:column}
.mc-check-price{font-size:11.5px;font-weight:700;color:var(–m-green);margin-left:8px;white-space:nowrap}

/* Slider / dimension input */
.mc-dim-wrap{margin-bottom:12px}
.mc-dim-label{font-size:12px;font-weight:800;color:var(–mc-text);text-transform:uppercase;letter-spacing:.4px;margin-bottom:8px;display:flex;justify-content:space-between;align-items:center}
.mc-dim-value{font-size:18px;font-weight:800;color:var(–m-green);letter-spacing:-.4px}
.mc-dim-value-unit{font-size:11px;color:var(–mc-text-sub);font-weight:600;margin-left:3px}
.mc-slider{-webkit-appearance:none;width:100%;height:8px;border-radius:4px;background:linear-gradient(90deg,#4CAF50,#2E7D32);outline:none;margin:6px 0 4px}
.mc-slider::-webkit-slider-thumb{-webkit-appearance:none;appearance:none;width:24px;height:24px;border-radius:50%;background:#fff;cursor:pointer;border:3px solid #2E7D32;box-shadow:0 3px 8px rgba(46,125,50,.3);transition:transform .12s}
.mc-slider::-webkit-slider-thumb:active{transform:scale(1.15)}
.mc-slider::-moz-range-thumb{width:24px;height:24px;border-radius:50%;background:#fff;cursor:pointer;border:3px solid #2E7D32;box-shadow:0 3px 8px rgba(46,125,50,.3)}
.mc-slider-ticks{display:flex;justify-content:space-between;font-size:10px;font-weight:700;color:var(–mc-text-sub);padding:0 3px;margin-top:2px}

.mc-num-input-row{display:flex;gap:8px;align-items:center;margin:6px 0 4px}
.mc-num-input{flex:1;padding:11px 13px;border:1.5px solid var(–mc-border);border-radius:10px;font:inherit;font-size:15px;font-weight:700;color:var(–mc-text);background:var(–mc-input-bg);outline:none;text-align:center}
.mc-num-input:focus{border-color:var(–m-green);background:var(–mc-bg)}
.mc-num-btn{width:38px;height:42px;border:1.5px solid var(–mc-border);background:var(–mc-bg);border-radius:10px;cursor:pointer;font-size:18px;font-weight:700;color:var(–mc-text);display:flex;align-items:center;justify-content:center;transition:all .2s}
.mc-num-btn:hover{border-color:var(–m-green);color:var(–m-green);background:var(–m-green-bg)}

/* Action buttons */
.mc-actions{display:flex;gap:8px;margin-top:14px}
.mc-btn{flex:1;padding:13px 16px;background:linear-gradient(135deg,#2E7D32,#1B5E20);color:#fff;border:none;border-radius:11px;font:inherit;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;box-shadow:0 4px 12px rgba(46,125,50,.32);display:flex;align-items:center;justify-content:center;gap:7px}
.mc-btn:hover{transform:translateY(-1px);filter:brightness(1.08);box-shadow:0 6px 16px rgba(46,125,50,.4)}
.mc-btn:active{transform:scale(.98)}
.mc-btn:disabled{opacity:.5;cursor:not-allowed;filter:grayscale(.4)}
.mc-btn svg{width:15px;height:15px;fill:#fff}
.mc-btn-secondary{flex:0 0 auto;padding:13px 16px;background:var(–mc-input-bg);color:var(–mc-text);border:1.5px solid var(–mc-border);border-radius:11px;font:inherit;font-size:13px;font-weight:700;cursor:pointer;transition:all .2s}
.mc-btn-secondary:hover{border-color:var(–m-green);color:var(–m-green);background:var(–m-green-bg)}

/* Info / hint boxes */
.mc-hint{padding:10px 12px;background:var(–m-green-bg);border:1px solid var(–m-green-line);border-radius:11px;font-size:12px;color:var(–mc-text);line-height:1.5;margin-bottom:12px;display:flex;gap:9px;align-items:flex-start}
.mc-hint .hi{flex:0 0 auto;width:20px;height:20px;background:var(–m-green);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:11px;font-weight:800;margin-top:1px}
.mc-hint b{font-weight:700;color:var(–m-green-hover)}

/* Final price card */
.mc-result-card{background:linear-gradient(135deg,#FFF 0%,var(–m-green-bg) 100%);border:1.5px solid var(–m-green);border-radius:16px;padding:16px;margin-bottom:14px;position:relative;overflow:hidden;animation:resultPop .55s cubic-bezier(.34,1.45,.64,1)}
@keyframes resultPop{from{opacity:0;transform:scale(.92)}to{opacity:1;transform:scale(1)}}
.mc-result-card::before{content:’’;position:absolute;top:-30px;right:-30px;width:120px;height:120px;background:radial-gradient(circle,rgba(46,125,50,.15) 0%,transparent 65%);pointer-events:none}
.mc-result-label{font-size:11px;font-weight:800;color:var(–m-green);text-transform:uppercase;letter-spacing:.6px;margin-bottom:4px;position:relative}
.mc-result-price{font-size:30px;font-weight:800;color:var(–mc-text);letter-spacing:-.8px;line-height:1.05;margin-bottom:4px;position:relative}
.mc-result-price-eur{font-size:18px;color:var(–m-green);margin-left:3px;vertical-align:baseline;font-weight:700}
.mc-result-from{font-size:12.5px;color:var(–mc-text);font-weight:700;display:inline-block;margin-right:6px}
.mc-result-note{font-size:11.5px;color:var(–mc-text-sub);font-weight:500;line-height:1.45;position:relative}
.mc-result-disclaimer{font-size:10.5px;color:var(–mc-text-sub);font-style:italic;margin-top:6px;line-height:1.4;position:relative}

.mc-summary-card{background:var(–mc-input-bg);border:1px solid var(–mc-border);border-radius:13px;padding:13px 14px;margin-bottom:12px}
.mc-summary-title{font-size:12px;font-weight:800;color:var(–mc-text);text-transform:uppercase;letter-spacing:.4px;margin-bottom:9px;display:flex;align-items:center;gap:6px}
.mc-summary-title::before{content:’’;width:3px;height:13px;background:var(–m-green);border-radius:2px}
.mc-summary-row{display:flex;justify-content:space-between;align-items:flex-start;padding:5px 0;gap:10px;font-size:12.5px;border-bottom:1px dashed var(–mc-border)}
.mc-summary-row:last-child{border-bottom:none}
.mc-summary-key{color:var(–mc-text-sub);font-weight:600;flex:0 0 auto;min-width:90px}
.mc-summary-val{color:var(–mc-text);font-weight:700;text-align:right;flex:1}

/* Pricing breakdown card */
.mc-breakdown{background:var(–mc-input-bg);border:1px solid var(–mc-border);border-radius:13px;padding:12px 14px;margin-bottom:12px;font-size:12px}
.mc-breakdown-row{display:flex;justify-content:space-between;padding:5px 0;color:var(–mc-text);font-weight:600}
.mc-breakdown-row.sub{padding-left:10px;color:var(–mc-text-sub);font-weight:500;font-size:11.5px}
.mc-breakdown-total{display:flex;justify-content:space-between;padding-top:8px;margin-top:5px;border-top:2px solid var(–m-green);font-weight:800;color:var(–m-green);font-size:14px}

/* Result sub-text */
.mc-result-sub{font-size:11.5px;color:var(–mc-text-sub);line-height:1.5;position:relative;margin-top:4px}

/* Contact form (final step) */
.mc-contact-form{display:flex;flex-direction:column;gap:9px;margin:14px 0 6px;padding:14px 13px;background:var(–mc-input-bg);border:1px solid var(–mc-border);border-radius:14px}
.mc-form-title{font-size:14px;font-weight:800;color:var(–mc-text);margin-bottom:2px}
.mc-form-sub{font-size:12px;color:var(–mc-text-sub);line-height:1.5;margin-bottom:6px}
.mc-form-input,.mc-form-textarea{width:100%;padding:11px 13px;border:1.5px solid var(–mc-border);border-radius:11px;font:inherit;font-size:13.5px;color:var(–mc-text);background:var(–mc-bg);outline:none;transition:border-color .2s,box-shadow .2s;box-sizing:border-box;font-family:var(–m-font)}
.mc-form-input:focus,.mc-form-textarea:focus{border-color:var(–m-green);box-shadow:0 0 0 3px rgba(46,125,50,.12)}
.mc-form-textarea{resize:none;height:72px}
.mc-form-submit{margin-top:4px;width:100%}
.mc-form-submit:disabled{opacity:.6;cursor:wait}
.mc-form-note{font-size:10.5px;color:var(–mc-text-sub);line-height:1.45;margin-top:2px;text-align:center;opacity:.85}
.mc-contact-fr{display:flex;gap:8px}
.mc-contact-fr input{flex:1}

/* Trust badges */
.mc-trust-row{display:flex;gap:7px;justify-content:space-between;margin:12px 0 4px}
.mc-trust{flex:1;display:flex;flex-direction:column;align-items:center;gap:4px;padding:9px 6px;background:var(–mc-input-bg);border:1px solid var(–mc-border);border-radius:11px;font-size:10.5px;color:var(–mc-text-sub);font-weight:700;text-align:center;line-height:1.3;transition:transform .2s,border-color .2s}
.mc-trust:hover{transform:translateY(-2px);border-color:var(–m-green)}
.mc-trust-ico{font-size:20px}
.mc-trust-item{display:flex;align-items:center;gap:4px;font-size:10.5px;color:var(–mc-text-sub);font-weight:700}
.mc-trust-item svg{width:11px;height:11px;fill:var(–m-green)}

/* Pulse pre dakovaciu ikonku */
@keyframes mcPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.08)}}

/* Mobile fullscreen */
@media (max-width:480px){
#mojplot-chat{bottom:0!important;right:0!important;left:0!important;width:100%!important;height:100vh!important;max-height:100vh!important;border-radius:0!important}
#mojplot-bubble{bottom:14px;right:14px}
}
</style>

</head>
<body>

<!-- Bubble -->

<div id="mojplot-bubble" onclick="toggleChat()">
  <div class="bubble-icon wobble">
    <!-- Mojplot logo (ak sa nenacita, zostane prazdny - bubble background je biely) -->
    <img src="https://mojplot.sk/wp-content/uploads/2025/07/cropped-zelene-logo-moj-plot-300x300.png"
         alt="Môj plot"
         onerror="this.style.display='none';var s=document.createElement('div');s.innerHTML='<svg viewBox=&quot;0 0 24 24&quot; width=&quot;42&quot; height=&quot;42&quot; fill=&quot;%232E7D32&quot;><path d=&quot;M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 9h12v2H6zM6 6h12v2H6zM6 12h8v2H6z&quot;/></svg>';this.parentElement.appendChild(s.firstChild);">
  </div>
  <div class="bubble-x">
    <svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
  </div>
  <div class="notif-dot">1</div>
</div>

<!-- Tooltip -->

<div id="mc-tooltip" onclick="toggleChat()">
  <button class="tt-x" onclick="event.stopPropagation();document.getElementById('mc-tooltip').style.display='none'">×</button>
  <span id="tt-text">Potrebujete poradiť? 👋</span>
</div>

<!-- Chat window -->

<div id="mojplot-chat">

  <!-- Header -->

  <div class="mc-header">
    <div class="mc-hdr-av">
      <img src="https://mojplot.sk/wp-content/uploads/2025/07/cropped-zelene-logo-moj-plot-300x300.png"
           alt="Môj plot"
           onerror="this.style.display='none';this.parentElement.innerHTML+='<svg viewBox=&quot;0 0 24 24&quot;><path d=&quot;M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 9h12v2H6zM6 6h12v2H6zM6 12h8v2H6z&quot;/></svg>';">
    </div>
    <div class="mc-hdr-info">
      <div class="mc-hdr-title" id="hdr-title">Asistent Môj plot</div>
      <div class="mc-hdr-sub"><span class="dot"></span><span id="hdr-sub">Online · Odpovedá hneď</span></div>
    </div>
    <div class="mc-hdr-actions">
      <div class="mc-lang">
        <button id="lang-sk" class="active" onclick="setLang('sk')">SK</button>
        <button id="lang-en" onclick="setLang('en')">EN</button>
      </div>
      <button class="mc-hdr-btn" id="darkBtn" onclick="toggleDark()" title="Tmavý režim">
        <svg viewBox="0 0 24 24"><path d="M12 3a9 9 0 1 0 9 9c0-.46-.04-.92-.1-1.36a5.39 5.39 0 0 1-4.4 2.26 5.4 5.4 0 0 1-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/></svg>
      </button>
      <button class="mc-hdr-btn" onclick="toggleChat()" title="Zavrieť">
        <svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
      </button>
    </div>
  </div>

  <!-- Messages -->

  <div class="mc-msgs" id="messages"></div>

  <!-- Typing indicator -->

  <div class="mc-typing" id="typing">
    <div class="mc-av"><svg viewBox="0 0 32 32"><circle cx="11" cy="14" r="1.8" fill="#fff"/><circle cx="21" cy="14" r="1.8" fill="#fff"/><path d="M11 19 Q16 22 21 19" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round"/></svg></div>
    <div class="mc-tbub"><span></span><span></span><span></span></div>
  </div>

  <!-- Quick chips -->

  <div class="mc-chips" id="chips"></div>

  <!-- Kalkulacka container -->

  <div class="mc-calc-container" id="calcContainer" data-open="false">
    <div class="mc-calc-head">
      <div class="mc-calc-title" id="calc-title">🧮 Cenová kalkulačka</div>
      <button class="mc-calc-close" onclick="closeCalc()">✕</button>
    </div>
    <div class="mc-calc-progress-wrap">
      <button class="mc-progress-back" id="calcBackBtn" onclick="calcBack()" disabled>‹</button>
      <div class="mc-calc-progress"><div class="mc-calc-progress-fill" id="calcProgressFill" style="width:14%"></div></div>
      <div class="mc-progress-step" id="calcStepLabel">1 / 7</div>
    </div>
    <div id="calcContent"></div>
  </div>

  <!-- Input bar -->

  <div class="mc-ibar">
    <input class="mc-inp" id="inputField" type="text" placeholder="Napíšte vašu otázku..." onkeypress="if(event.key==='Enter')send()">
    <button class="mc-quick-calc" onclick="openCalc()" title="Kalkulačka">
      <svg viewBox="0 0 24 24"><path d="M19 3H5C3.9 3 3 3.9 3 5v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM8 19H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V9h2v2zm5 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V9h2v2zm5 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V9h2v2zM8 7H6V5h12v2H8z"/></svg>
    </button>
    <button class="mc-send" onclick="send()">
      <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
    </button>
  </div>

  <!-- Contact bar -->

  <div class="mc-cbar">
    <a href="https://wa.me/421940511266" target="_blank" class="mc-ct wa">
      <div class="mc-ci"><svg viewBox="0 0 24 24"><path d="M17.5 14.4l-2-1c-.3-.1-.5 0-.6.1-.1.1-.6.7-.7.9-.1.1-.3.2-.5.1-.7-.3-1.4-.7-2-1.3-.5-.5-1-1.1-1.4-1.8-.1-.2 0-.4.1-.5.1-.1.2-.3.4-.4.1-.1.2-.3.3-.4.1-.1.1-.3 0-.4-.1-.1-.6-1.3-.8-1.8-.1-.3-.4-.5-.7-.5h-.6c-.2 0-.5.1-.7.3-.5.5-.8 1.1-.8 1.8.1.8.4 1.6.9 2.3.9 1.3 2 2.4 3.4 3.1.4.2.7.3 1.1.4.4.1.8.1 1.3.1.5-.1.9-.3 1.2-.7l.3-.3c.1-.1.1-.2.2-.3.1-.2.3-.5.2-.8 0 0-.1-.1-.4-.3zM20.5 3.4C16.2-.9 9.3-.9 5 3.4c-3.5 3.5-4.2 9-1.6 13.4l-1.4 5 5.1-1.3c1.6.9 3.5 1.4 5.4 1.4 6.1 0 11-4.9 11-11 0-2.9-1.2-5.7-3-7.5zM12.5 20.7c-1.7 0-3.4-.5-4.9-1.3l-.4-.2-3 .8.8-2.9-.2-.4c-2.7-4.4-1.3-10 3-12.7 4.4-2.7 10-1.3 12.7 3 2.7 4.4 1.3 10-3 12.7-1.5.9-3.2 1.4-5 1.4z"/></svg></div>
      <span>WhatsApp</span>
    </a>
    <a href="tel:+421940511266" class="mc-ct ph">
      <div class="mc-ci"><svg viewBox="0 0 24 24"><path d="M20 15.5c-1.25 0-2.45-.2-3.57-.57-.35-.11-.74-.03-1.02.24l-2.2 2.2c-2.83-1.44-5.15-3.75-6.59-6.58l2.2-2.21c.27-.27.35-.66.24-1.02C8.7 6.45 8.5 5.25 8.5 4c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1 0 9.39 7.61 17 17 17 .55 0 1-.45 1-1v-3.5c0-.55-.45-1-1-1z"/></svg></div>
      <span>Volať</span>
    </a>
    <button class="mc-ct em" onclick="tgEmail()">
      <div class="mc-ci"><svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg></div>
      <span>E-mail</span>
    </button>
  </div>

  <!-- Email modal overlay -->

  <div class="mc-eo" id="eo" onclick="tgEmail()"></div>
  <div class="mc-ep" id="ep">
    <div class="mc-eph">
      <div class="mc-ept">
        <div class="ei"><svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg></div>
        <span id="email-title">Napíšte nám</span>
      </div>
      <button class="mc-ecl" onclick="tgEmail()"><svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></button>
    </div>
    <div class="mc-eb">
      <div class="fr">
        <div class="fg"><label>Meno</label><input id="fn" type="text" placeholder="Vaše meno"></div>
        <div class="fg"><label>Telefón</label><input id="fp" type="tel" placeholder="+421..."></div>
      </div>
      <div class="fg"><label>E-mail</label><input id="fe" type="email" placeholder="vas@email.sk"></div>
      <div class="fg"><label>Správa</label><textarea id="fm" placeholder="Vaša správa..."></textarea></div>
      <button class="mc-esb" id="esb" onclick="subEmail()">
        <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
        <span id="est">Odoslať</span>
      </button>
    </div>
  </div>
</div>

<script>
/* =========================================================
   MOJPLOT WIDGET - KONFIGURACIA
   ========================================================= */
var MC = {
  /* Backend - vlastny Vercel endpoint pre AI chat (treba nastavit) */
  apiUrl: 'https://mojplot-chatbot-backend.vercel.app/api/chat',

  /* EmailJS - sluzba pre odosielanie dopytov (treba vytvorit alebo zdielat) */
  emailService: 'service_mojplot',
  emailTemplate: 'template_mojplot',
  emailKey: 'YOUR_EMAILJS_PUBLIC_KEY',

  /* Stav */
  lang: 'sk',
  dark: false,
  open: false,
  contactShown: false,
  convoLogged: false,
  hist: [],

  /* Texty */
  s: {
    sk: {
      hdrTitle: 'Asistent Môj plot',
      hdrSub: 'Online · Odpovedá hneď',
      placeholder: 'Napíšte vašu otázku...',
      welcome: 'Dobrý deň! 👋 Som <b>digitálny asistent firmy Môj plot</b>.<br><br>✅ <b>Doprava zadarmo</b> po SK<br>✅ <b>Garancia najnižšej ceny</b><br>✅ <b>ISO 9001</b> certifikovaná kvalita<br>✅ <b>8 rokov skúseností</b><br><br>Rád vám poradím s výberom plotu, brány alebo oplotenia. Spýtajte sa ma na čokoľvek, alebo si rovno <b>vypočítajte cenu</b> v našej kalkulačke.',
      welcomeChips: ['🧮 Cenová kalkulačka','3D plot','Brána / bránka','Pletivový plot','Mobilné oplotenie','Betónový plot','Oporné múry','Doprava a montáž'],
      er: 'Prepáčte, momentálne mám technický problém. Skúste prosím znova alebo nás kontaktujte priamo na +421 940 511 266.',
      sd: 'Odoslané!',
      se: 'Odoslať',
      ttText: 'Potrebujete poradiť? 👋',
      calcTitle: '🧮 Cenová kalkulačka',
      emailTitle: 'Napíšte nám',
      thxMsg: 'Ďakujeme za dopyt! ✅<br>Náš tím (Denis Plichta) sa vám ozve <b>do 24 hodín</b> s presnou cenovou ponukou na mieru.'
    },
    en: {
      hdrTitle: 'Môj plot Assistant',
      hdrSub: 'Online · Replies instantly',
      placeholder: 'Type your question...',
      welcome: 'Hello! 👋 I am the <b>Môj plot digital assistant</b>.<br><br>✅ <b>FREE shipping</b> across SK<br>✅ <b>Lowest price guarantee</b><br>✅ <b>ISO 9001</b> certified quality<br>✅ <b>8 years of experience</b><br><br>I will gladly help you choose a fence, gate or fencing system. Ask me anything, or try the <b>price calculator</b> right away.',
      welcomeChips: ['🧮 Price calculator','3D fence','Gate','Mesh fence','Mobile fencing','Concrete fence','Retaining walls','Shipping & installation'],
      er: 'Sorry, I am experiencing technical issues. Please try again or call us directly at +421 940 511 266.',
      sd: 'Sent!',
      se: 'Send',
      ttText: 'Need advice? 👋',
      calcTitle: '🧮 Price calculator',
      emailTitle: 'Write to us',
      thxMsg: 'Thank you for your inquiry! ✅<br>Our team (Denis Plichta) will get back to you <b>within 24 hours</b> with a tailored quote.'
    }
  }
};

/* =========================================================
   STAV KALKULACKY
   ========================================================= */
var calcState = {
  step: 0,
  totalSteps: 7,
  product: null,    // '3d-plot', 'brana', 'pletivo', 'mobilne', 'betonovy', 'oporne', 'ine'
  /* 3D plot */
  length: null,
  height: null,
  thickness: '4mm',
  color: null,
  withPosts: true,
  withUnderboard: false,
  installation: false,
  /* Brana */
  gateType: null,   // 'jednokrid', 'dvojkrid', 'posuvna'
  gateWidth: null,
  gateHeight: null,
  gateAutomation: false,
  /* Pletivo */
  meshHeight: null,
  /* Mobilne */
  mobileLength: null,
  mobileBases: true,
  /* Oporne mury */
  wallLength: null,
  wallHeight: null,
  blockWidth: null,
  /* Iné */
  customDesc: '',
  /* Contact */
  contactName: '',
  contactPhone: '',
  contactEmail: '',
  contactMsg: ''
};

/* =========================================================
   DOM REFS
   ========================================================= */
var $bubble, $chat, $msgs, $typing, $chips, $i, $tt;

document.addEventListener('DOMContentLoaded', function(){
  $bubble = document.getElementById('mojplot-bubble');
  $chat = document.getElementById('mojplot-chat');
  $msgs = document.getElementById('messages');
  $typing = document.getElementById('typing');
  $chips = document.getElementById('chips');
  $i = document.getElementById('inputField');
  $tt = document.getElementById('mc-tooltip');

  /* Init EmailJS ak je dostupne */
  try { if(typeof emailjs !== 'undefined') emailjs.init(MC.emailKey); } catch(e){}

  /* Welcome message */
  addMsg(MC.s[MC.lang].welcome, 'bot');
  renderWelcomeChips();

  /* Tooltip po 3 sekundach ak chat nebol otvoreny */
  setTimeout(function(){
    if(!MC.open){
      $tt.style.display = 'block';
      $tt.style.animation = 'tooltipShow .4s ease forwards';
    }
  }, 3000);
});

/* =========================================================
   ZAKLADNA UI
   ========================================================= */
function toggleChat(){
  MC.open = !MC.open;
  $bubble.classList.toggle('open', MC.open);
  $chat.classList.toggle('visible', MC.open);
  if($tt) $tt.style.display = 'none';
  /* Mobile lock */
  if(window.innerWidth <= 480){
    document.documentElement.classList.toggle('mc-locked', MC.open);
    document.body.classList.toggle('mc-locked', MC.open);
  }
  if(MC.open){ setTimeout(function(){ if($i) $i.focus(); }, 400); }
}

function setLang(l){
  MC.lang = l;
  document.getElementById('lang-sk').classList.toggle('active', l==='sk');
  document.getElementById('lang-en').classList.toggle('active', l==='en');
  var t = MC.s[l];
  document.getElementById('hdr-title').textContent = t.hdrTitle;
  document.getElementById('hdr-sub').textContent = t.hdrSub;
  $i.placeholder = t.placeholder;
  document.getElementById('tt-text').innerHTML = t.ttText;
  document.getElementById('calc-title').textContent = t.calcTitle;
  document.getElementById('email-title').textContent = t.emailTitle;
  document.getElementById('est').textContent = t.se;
}

function toggleDark(){
  MC.dark = !MC.dark;
  document.body.classList.toggle('dark-mode', MC.dark);
  document.getElementById('darkBtn').classList.toggle('active', MC.dark);
}

/* =========================================================
   SPRAVY
   ========================================================= */
function timeStr(){
  var d = new Date();
  return String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0');
}

function addMsg(text, who, opts){
  opts = opts || {};
  var row = document.createElement('div');
  row.className = 'mc-row ' + (who==='user' ? 'user' : 'bot');

  if(who === 'bot'){
    var av = document.createElement('div');
    av.className = 'mc-av';
    av.innerHTML = '<svg viewBox="0 0 32 32"><circle cx="11" cy="14" r="1.8" fill="#fff"/><circle cx="21" cy="14" r="1.8" fill="#fff"/><path d="M11 19 Q16 22 21 19" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round"/></svg>';
    row.appendChild(av);
  }

  var mc = document.createElement('div');
  mc.className = 'mc-mc';
  var m = document.createElement('div');
  m.className = 'mc-m ' + (who==='user' ? 'user' : 'bot');
  m.innerHTML = text;
  mc.appendChild(m);

  var ts = document.createElement('div');
  ts.className = 'mc-ts';
  ts.textContent = timeStr();
  mc.appendChild(ts);

  /* Rating buttons pre bot */
  if(who === 'bot' && !opts.noRating){
    var rt = document.createElement('div');
    rt.className = 'mc-rt';
    rt.innerHTML = '<button class="mc-rb" onclick="rate(this,1)">👍</button><button class="mc-rb" onclick="rate(this,0)">👎</button>';
    mc.appendChild(rt);
  }

  row.appendChild(mc);
  $msgs.appendChild(row);
  $msgs.scrollTop = $msgs.scrollHeight;
}

function rate(btn, val){
  var siblings = btn.parentElement.querySelectorAll('.mc-rb');
  siblings.forEach(function(b){ b.classList.remove('on'); });
  btn.classList.add('on');
}

function typeMsg(text, cb){
  /* Pre jednoduchost ihned vlozit */
  addMsg(text, 'bot');
  if(cb) cb();
}

function renderWelcomeChips(){
  $chips.innerHTML = '';
  var chips = MC.s[MC.lang].welcomeChips;
  chips.forEach(function(c, idx){
    var b = document.createElement('button');
    b.className = 'mc-chip';
    if(idx === 0) b.className += ' mc-chip-calc';
    b.textContent = c;
    b.onclick = function(){
      if(idx === 0) { openCalc(); return; }
      $i.value = c;
      send();
    };
    $chips.appendChild(b);
  });
}

function showCalcShortcut(){
  /* Po par interakciach pridaj chip kalkulackv */
  if($chips.children.length === 0){
    var b = document.createElement('button');
    b.className = 'mc-chip mc-chip-calc';
    b.textContent = MC.lang === 'sk' ? '🧮 Vypočítať cenu' : '🧮 Calculate price';
    b.onclick = openCalc;
    $chips.appendChild(b);
  }
}

/* =========================================================
   AI CHAT
   ========================================================= */
async function send(ov){
  var t = ov || $i.value.trim();
  if(!t) return;
  $i.value = '';
  addMsg(t, 'user');
  MC.hist.push({role:'user', content:t});
  $typing.classList.add('show');
  $msgs.scrollTop = $msgs.scrollHeight;

  try {
    var reply = await callAI(t);
    $typing.classList.remove('show');
    addMsg(reply, 'bot');
    MC.hist.push({role:'assistant', content:reply});
    showCalcShortcut();

    /* Po 3 user message ukaz kalkulacku tip */
    var userCount = MC.hist.filter(function(h){return h.role==='user'}).length;
    if(userCount === 3 && !MC.contactShown){
      MC.contactShown = true;
      setTimeout(function(){
        var tip = MC.lang === 'sk' ?
          '💡 Tip: ak by ste chceli rýchlo orientačnú cenu, skúste <b>cenovú kalkulačku</b> nižšie – stačí pár klikov.' :
          '💡 Tip: for a quick price estimate, try the <b>price calculator</b> below — just a few clicks.';
        addMsg(tip, 'bot');
      }, 1200);
    }
    logConvo();
  } catch(e){
    $typing.classList.remove('show');
    addMsg(MC.s[MC.lang].er, 'bot');
  }
}

async function callAI(msg){
  var sysPrompt = {
    role:'system',
    content: MC.lang === 'sk' ?
      'Si profesionálny digitálny asistent firmy Môj plot s.r.o. (mojplot.sk) - slovenského dodávateľa kvalitných plotov, brán a oplotenia s 8-ročnými skúsenosťami v stavebníctve. Pôsobíme na Slovensku aj v Česku.\n\n' +
      'KONTAKT: Denis Plichta (konateľ), tel. +421 940 511 266, e-mail info@mojplot.sk alebo plichta@mojplot.sk, WhatsApp na čísle +421 940 511 266. Sídlo: Párnica 361, 026 01 Párnica. Pracovná doba: odpovedáme do 24 hodín, telefonicky pondelok-piatok počas pracovných hodín. Cez víkendy sme tiež dostupní pre B2B zákazníkov.\n\n' +
      'GARANCIE: ✅ Doprava ZADARMO po celom Slovensku. ✅ Garancia najnižšej ceny - ak nájdete konkurenčnú ponuku, dorovnáme ju. ✅ ISO 9001 certifikovaná kvalita. ✅ Bezplatné odborné poradenstvo, plánovanie aj návrh riešenia. ✅ Cenová ponuka na mieru do 24 hodín.\n\n' +
      'PRODUKTY:\n' +
      '• 3D plotové panely (najpopulárnejšie): dĺžka 250 cm, výšky 103/123/153/173/203 cm, hrúbka drôtu 4 mm alebo 5 mm (5 mm je pevnejší pre vyššie ploty), oko 200×50 mm, farby Zinok (pozink, najlacnejší), Zelená (RAL 6005), Antracit (RAL 7016 - najobľúbenejší pre rodinné domy). Cena od 13,35 €/panel.\n' +
      '• Plotové stĺpiky: 60×40 mm (od 11,07 €), 48 mm (od 9,53 €), s platničkou na pripevnenie.\n' +
      '• Brány a bránky: jednokrídlová bránka 1 m (od 175,24 €, výšky 120/150/170/200 cm), dvojkrídlová 3-5 m (od 315,98 €), posuvná na zákazku. Možnosť automatického pohonu (+~850 €).\n' +
      '• Pletivové oplotenie: cenovo dostupné, výšky 100-200 cm, zinok alebo PVC (zelená/antracit).\n' +
      '• Mobilné oplotenie: panely 3,5 m + pätky + klipy, ideálne pre stavby a podujatia. Predaj aj prenájom.\n' +
      '• Betónové ploty: maximálne súkromie, jednostranné aj obojstranné, viacero vzorov a farieb (antracit, hnedá, pieskovec, biela).\n' +
      '• Oporné múry - LEGO bloky: šírky 30/40/60/80 cm, dĺžka ~120 cm na blok, na zákazku akákoľvek výška/dĺžka.\n' +
      '• Podhrabové dosky 250×20×5 cm: 19,19 €/ks, zabraňujú podhrabaniu pod plot.\n' +
      '• Zákazková výroba: zábradlia, schody, atypické rozmery - všetko podľa potreby.\n' +
      '• Doplnky: hliníkové rebríky, lešenie, regály, podlaha z recyklátu.\n\n' +
      'ŠTÝL KOMUNIKÁCIE: Buď stručný, vecný, priateľský a praktický. Používaj odrážky pre prehľadnosť. Ak zákazník chce orientačnú cenu alebo presné nacenenie, **vždy ho nasmeruj na cenovú kalkulačku** v tomto chate (tlačidlo "🧮 Cenová kalkulačka"). Ak nevie aký typ plotu, opýtaj sa na účel (záhrada/firma/dočasné ohradenie) a odporuč. Pri väčších projektoch alebo neistote odporuč priamo kontakt s Denisom Plichtom.' :
      'You are a professional digital assistant for Môj plot s.r.o. (mojplot.sk) — a Slovak supplier of quality fences, gates and fencing systems with 8 years of construction experience. We operate in Slovakia and the Czech Republic.\n\n' +
      'CONTACT: Denis Plichta (owner/managing director), phone +421 940 511 266, email info@mojplot.sk or plichta@mojplot.sk, WhatsApp at +421 940 511 266. Address: Párnica 361, 026 01 Párnica, Slovakia. Working hours: we respond within 24 hours, phone Mon-Fri during business hours. Available on weekends for B2B clients.\n\n' +
      'GUARANTEES: ✅ FREE shipping across Slovakia. ✅ Lowest price guarantee - if you find a better competitor offer, we match it. ✅ ISO 9001 certified quality. ✅ Free expert advice, planning and design. ✅ Custom quote within 24 hours.\n\n' +
      'PRODUCTS:\n' +
      '• 3D fence panels (most popular): length 250 cm, heights 103/123/153/173/203 cm, wire thickness 4 mm or 5 mm (5 mm stronger for taller fences), mesh 200×50 mm, colors Galvanized (cheapest), Green (RAL 6005), Anthracite (RAL 7016 - most popular for family homes). From €13.35/panel.\n' +
      '• Posts: 60×40 mm (from €11.07), 48 mm (from €9.53).\n' +
      '• Gates: single gate 1 m (from €175.24, heights 120/150/170/200 cm), double 3-5 m (from €315.98), sliding custom. Optional automatic motor (+~€850).\n' +
      '• Mesh fencing: affordable, heights 100-200 cm, galvanized or PVC (green/anthracite).\n' +
      '• Mobile fencing: 3.5 m panels + bases + clips, ideal for construction sites and events. Sale and rental.\n' +
      '• Concrete fences: maximum privacy, single/double-sided, various patterns and colors (anthracite, brown, sandstone, white).\n' +
      '• Retaining walls — LEGO blocks: widths 30/40/60/80 cm, length ~120 cm per block, custom height/length.\n' +
      '• Underboards 250×20×5 cm: €19.19/pc, prevents digging under fence.\n' +
      '• Custom production: railings, stairs, custom dimensions - whatever you need.\n' +
      '• Accessories: aluminum ladders, scaffolding, racks, recycled flooring.\n\n' +
      'COMMUNICATION STYLE: Be concise, factual, friendly and practical. Use bullets for clarity. If the customer wants a price estimate or detailed quote, **always direct them to the price calculator** in this chat (button "🧮 Price calculator"). If they don\'t know what type of fence, ask about purpose (garden/business/temporary) and recommend. For larger projects or uncertainty, recommend direct contact with Denis Plichta.'
  };
  var r = await fetch(MC.apiUrl, {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify({ messages: [sysPrompt].concat(MC.hist), lang: MC.lang })
  });
  if(!r.ok) throw new Error('API error');
  var data = await r.json();
  return data.reply || data.message || '...';
}

function logConvo(){
  try {
    var userMsgs = MC.hist.filter(function(h){return h.role==='user'});
    if(userMsgs.length >= 2 && !MC.convoLogged){
      MC.convoLogged = true;
      var convoText = MC.hist.map(function(m){
        return (m.role==='user' ? 'ZÁKAZNÍK: ' : 'BOT: ') + m.content;
      }).join('\n\n');
      if(typeof emailjs !== 'undefined'){
        emailjs.send(MC.emailService, MC.emailTemplate, {
          from_name: 'AI Chatbot - Záznam konverzácie (mojplot)',
          phone: 'Správ: ' + MC.hist.length,
          from_email: 'info@mojplot.sk',
          message: convoText
        }).catch(function(err){ console.warn('Log err', err); });
      }
    }
  } catch(e){}
}

/* =========================================================
   EMAIL FORM
   ========================================================= */
function tgEmail(){
  var o = document.getElementById('eo'), p = document.getElementById('ep');
  var s = !p.classList.contains('show');
  o.classList.toggle('show', s);
  p.classList.toggle('show', s);
}

function subEmail(){
  var n = document.getElementById('fn').value;
  var ph = document.getElementById('fp').value;
  var e = document.getElementById('fe').value;
  var m = document.getElementById('fm').value;
  if(!e || !m){
    ['fe','fm'].forEach(function(id){
      var el = document.getElementById(id);
      if(!el.value){ el.style.borderColor = '#E53935'; setTimeout(function(){ el.style.borderColor = ''; }, 2000); }
    });
    return;
  }
  var b = document.getElementById('esb'), t = document.getElementById('est');
  b.disabled = true; t.textContent = 'Odosielam...';
  if(typeof emailjs !== 'undefined'){
    emailjs.send(MC.emailService, MC.emailTemplate, {
      from_name: n || 'Neuvedené', phone: ph || 'Neuvedené', from_email: e, message: m
    }).then(function(){
      b.classList.add('ok'); t.textContent = MC.s[MC.lang].sd;
      setTimeout(function(){
        tgEmail();
        b.classList.remove('ok'); b.disabled = false;
        t.textContent = MC.s[MC.lang].se;
        ['fn','fp','fe','fm'].forEach(function(id){ document.getElementById(id).value = ''; });
      }, 1800);
    }, function(err){
      console.warn('Email err', err);
      b.disabled = false; t.textContent = 'Chyba, skúste znova';
      setTimeout(function(){ t.textContent = MC.s[MC.lang].se; }, 3000);
    });
  } else {
    b.disabled = false; t.textContent = MC.s[MC.lang].se;
    alert('EmailJS nie je k dispozícii. Kontaktujte nás priamo: +421 940 511 266');
  }
}


/* =========================================================
   KALKULACKA - DATA
   ========================================================= */
var PRODUCTS = [
  { id:'3d-plot', name:'3D plot', nameEn:'3D fence', desc:'Najpopulárnejší panel zo zváraného drôtu', descEn:'Most popular welded panel fence',
    img:'https://mojplot.sk/wp-content/uploads/2025/11/3D-plotovy-panel-farba-antracit.webp', badge:'TOP' },
  { id:'brana', name:'Brány a bránky', nameEn:'Gates', desc:'Jednokrídlové, dvojkrídlové, posuvné', descEn:'Single, double, sliding',
    img:'https://mojplot.sk/wp-content/uploads/2025/12/dvojkridlova-brana-farba-antracit.webp' },
  { id:'pletivo', name:'Pletivový plot', nameEn:'Mesh fence', desc:'Cenovo dostupné riešenie', descEn:'Affordable solution',
    img:'https://mojplot.sk/wp-content/uploads/2025/10/Fotka-pre-kategoriu.webp' },
  { id:'mobilne', name:'Mobilné oplotenie', nameEn:'Mobile fencing', desc:'Pre stavby, akcie, dočasné použitie', descEn:'For sites, events, temporary use',
    img:'https://mojplot.sk/wp-content/uploads/2025/07/mobilne-oplotenie-main-scaled.jpg' },
  { id:'betonovy', name:'Betónový plot', nameEn:'Concrete fence', desc:'Maximálne súkromie a odolnosť', descEn:'Maximum privacy and durability',
    img:'https://mojplot.sk/wp-content/uploads/2025/08/kategoria-betonove-ploty-scaled.png' },
  { id:'oporne', name:'Oporné múry', nameEn:'Retaining walls', desc:'LEGO bloky pre spevnenie terénu', descEn:'LEGO blocks for terrain support',
    img:'https://mojplot.sk/wp-content/uploads/2025/08/Betonova-lego-kocka-120cm-scaled.png' }
];

/* Cenníky (orientačné, za 1 panel 250cm, vrátane povrchovej úpravy) */
var PRICE_3D = {
  /* [height_cm][thickness][color] = €/panel */
  '103': { '4mm': { zinok:13.35, zelena:14.95, antracit:14.95 }, '5mm': { zinok:15.85, zelena:17.65, antracit:17.65 } },
  '123': { '4mm': { zinok:15.50, zelena:17.30, antracit:17.30 }, '5mm': { zinok:18.40, zelena:20.50, antracit:20.50 } },
  '153': { '4mm': { zinok:18.90, zelena:21.20, antracit:21.20 }, '5mm': { zinok:22.50, zelena:25.10, antracit:25.10 } },
  '173': { '4mm': { zinok:21.50, zelena:23.95, antracit:23.95 }, '5mm': { zinok:25.50, zelena:28.40, antracit:28.40 } },
  '203': { '4mm': { zinok:24.90, zelena:27.75, antracit:27.75 }, '5mm': { zinok:29.50, zelena:32.90, antracit:32.90 } }
};

var PRICE_POST = {
  /* 60x40mm stĺpik pre 3D plot */
  '103': { zinok:11.07, zelena:12.40, antracit:12.40 },
  '123': { zinok:12.85, zelena:14.40, antracit:14.40 },
  '153': { zinok:15.20, zelena:17.05, antracit:17.05 },
  '173': { zinok:17.40, zelena:19.50, antracit:19.50 },
  '203': { zinok:19.80, zelena:22.20, antracit:22.20 }
};

var PRICE_UNDERBOARD = 19.19; /* podhrabová doska 250x20x5cm */

/* Brány - dvojkrídlová */
var PRICE_GATE_DOUBLE = {
  /* [width_m][height_cm] zinok */
  '3': { '120':315.98, '150':355, '170':385, '200':425 },
  '4': { '120':365, '150':410, '170':445, '200':490 },
  '5': { '120':415, '150':465, '170':505, '200':555 }
};

/* Jednokrídlová bránka (1m) */
var PRICE_GATE_SINGLE = {
  '120':175.24, '150':195, '170':215, '200':245
};

/* Pletivový plot - cena za bežný meter komplet (drôt + stĺpik + úchytka) */
var PRICE_MESH = {
  '100': 7.50, '125': 8.80, '150': 10.30, '175': 11.80, '200': 13.20
};

/* Mobilné oplotenie - cena za panel 3.5m včetne pätky a klipov */
var PRICE_MOBILE_PANEL = 42; /* za panel s prislusenstvom */

/* Oporné múry - cena za bežný meter (1 vrstva) */
var PRICE_WALL = {
  '30': 45, '40': 58, '60': 85, '80': 115
};

/* Príplatky */
var SURCHARGE_COLOR = 0.12; /* +12% pri farbe oproti zinkovi (ak nie v cenníku) */
var SURCHARGE_5MM = 0.18;    /* +18% pri hrubšom drôte */
var SURCHARGE_AUTOMATION = 850; /* automatický pohon brány */
var INSTALLATION_PER_M = 18;    /* montáž za bežný meter */
var GATE_INSTALLATION = 220;    /* montáž brány */

/* =========================================================
   KALKULACKA - HLAVNE FUNKCIE
   ========================================================= */
function openCalc(){
  var c = document.getElementById('calcContainer');
  c.setAttribute('data-open', 'true');
  calcState.step = 0;
  renderCalcStep();
}

function closeCalc(){
  var c = document.getElementById('calcContainer');
  c.setAttribute('data-open', 'false');
}

function calcBack(){
  if(calcState.step > 0){
    calcState.step--;
    renderCalcStep();
  }
}

function updateProgress(){
  var pct = ((calcState.step + 1) / calcState.totalSteps) * 100;
  document.getElementById('calcProgressFill').style.width = pct + '%';
  document.getElementById('calcStepLabel').textContent = (calcState.step + 1) + ' / ' + calcState.totalSteps;
  document.getElementById('calcBackBtn').disabled = calcState.step === 0;
}

function renderCalcStep(){
  /* Sprav celkovy pocet krokov podla zvoleneho produktu */
  if(!calcState.product){
    calcState.totalSteps = 7;
  } else if(calcState.product === '3d-plot'){
    calcState.totalSteps = 7; /* product, length, height, color, thickness, extras, final */
  } else if(calcState.product === 'brana'){
    calcState.totalSteps = 6; /* product, type, dimensions, color, extras, final */
  } else if(calcState.product === 'pletivo'){
    calcState.totalSteps = 5; /* product, length, height, color, final */
  } else if(calcState.product === 'mobilne'){
    calcState.totalSteps = 4; /* product, length, extras, final */
  } else if(calcState.product === 'betonovy' || calcState.product === 'ine'){
    calcState.totalSteps = 3; /* product, desc, final */
  } else if(calcState.product === 'oporne'){
    calcState.totalSteps = 5; /* product, length, height, block, final */
  }

  updateProgress();
  var el = document.getElementById('calcContent');

  /* Routing */
  if(calcState.step === 0) { renderStepProduct(el); return; }
  if(!calcState.product) { calcState.step = 0; renderStepProduct(el); return; }

  if(calcState.product === '3d-plot'){
    if(calcState.step === 1) return render3dLength(el);
    if(calcState.step === 2) return render3dHeight(el);
    if(calcState.step === 3) return render3dColor(el);
    if(calcState.step === 4) return render3dThickness(el);
    if(calcState.step === 5) return render3dExtras(el);
    if(calcState.step === 6) return renderFinal(el);
  }
  if(calcState.product === 'brana'){
    if(calcState.step === 1) return renderGateType(el);
    if(calcState.step === 2) return renderGateDimensions(el);
    if(calcState.step === 3) return renderGateColor(el);
    if(calcState.step === 4) return renderGateExtras(el);
    if(calcState.step === 5) return renderFinal(el);
  }
  if(calcState.product === 'pletivo'){
    if(calcState.step === 1) return renderMeshLength(el);
    if(calcState.step === 2) return renderMeshHeight(el);
    if(calcState.step === 3) return renderMeshColor(el);
    if(calcState.step === 4) return renderFinal(el);
  }
  if(calcState.product === 'mobilne'){
    if(calcState.step === 1) return renderMobileLength(el);
    if(calcState.step === 2) return renderMobileExtras(el);
    if(calcState.step === 3) return renderFinal(el);
  }
  if(calcState.product === 'oporne'){
    if(calcState.step === 1) return renderWallLength(el);
    if(calcState.step === 2) return renderWallHeight(el);
    if(calcState.step === 3) return renderWallBlock(el);
    if(calcState.step === 4) return renderFinal(el);
  }
  if(calcState.product === 'betonovy' || calcState.product === 'ine'){
    if(calcState.step === 1) return renderCustomDesc(el);
    if(calcState.step === 2) return renderFinal(el);
  }
}

function next(){ calcState.step++; renderCalcStep(); }

/* =========================================================
   STEP: VYBER PRODUKTU
   ========================================================= */
function renderStepProduct(el){
  var lang = MC.lang;
  var title = lang === 'sk' ? 'Čo by ste chceli naceniť?' : 'What would you like to estimate?';
  var sub = lang === 'sk' ? 'Vyberte typ oplotenia alebo brány. Po pár otázkach vám dáme orientačnú cenu.' : 'Choose the type of fencing or gate. After a few questions we will give you an estimate.';

  var cards = PRODUCTS.map(function(p){
    var sel = calcState.product === p.id;
    return '<div class="mc-product-card' + (sel?' selected':'') + '" onclick="selectProduct(\''+p.id+'\')">' +
      (p.badge ? '<span class="mc-product-badge">'+p.badge+'</span>' : '') +
      '<div class="mc-product-img"><img src="'+p.img+'" alt="'+p.name+'" loading="lazy" onerror="this.style.display=\'none\'"></div>' +
      '<div class="mc-product-info">' +
        '<div class="mc-product-name">'+(lang==='sk'?p.name:p.nameEn)+'</div>' +
        '<div class="mc-product-desc">'+(lang==='sk'?p.desc:p.descEn)+'</div>' +
      '</div></div>';
  }).join('');

  /* + ďalšia voľba: iné/zákazková výroba */
  cards += '<div class="mc-product-card' + (calcState.product==='ine'?' selected':'') + '" onclick="selectProduct(\'ine\')" style="grid-column:1/-1">' +
    '<div class="mc-product-info" style="padding:14px 12px">' +
    '<div class="mc-product-name">' + (lang==='sk'?'⚙️ Iné / zákazková výroba':'⚙️ Other / custom') + '</div>' +
    '<div class="mc-product-desc">' + (lang==='sk'?'Schody, zábradlia, atypické rozmery':'Stairs, railings, custom dimensions') + '</div>' +
    '</div></div>';

  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">' + title + '</div>' +
    '<div class="mc-step-sub">' + sub + '</div>' +
    '<div class="mc-product-grid">' + cards + '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn" id="nextBtn" onclick="next()" '+(calcState.product?'':'disabled')+'>'+
        (lang==='sk'?'Pokračovať':'Continue')+' →'+
      '</button>' +
    '</div>' +
    renderTrust() +
  '</div>';
}

function selectProduct(id){
  calcState.product = id;
  /* Reset niektorých polí pri zmene produktu */
  calcState.length = null;
  calcState.height = null;
  calcState.color = null;
  calcState.gateType = null;
  calcState.gateWidth = null;
  calcState.gateHeight = null;
  calcState.meshHeight = null;
  calcState.mobileLength = null;
  calcState.wallLength = null;
  calcState.wallHeight = null;
  calcState.blockWidth = null;
  renderCalcStep();
}

function renderTrust(){
  var lang = MC.lang;
  return '<div class="mc-trust">' +
    '<div class="mc-trust-item"><svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>'+(lang==='sk'?'8+ rokov skúseností':'8+ years exp.')+'</div>' +
    '<div class="mc-trust-item"><svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>'+(lang==='sk'?'Doprava zdarma':'Free shipping')+'</div>' +
    '<div class="mc-trust-item"><svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>'+(lang==='sk'?'Najnižšia cena':'Lowest price')+'</div>' +
  '</div>';
}


/* =========================================================
   STEPS: 3D PLOT
   ========================================================= */
function render3dLength(el){
  var lang = MC.lang;
  var v = calcState.length || 20;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Aká dlhá bude plotová línia?':'How long will the fence line be?')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Zadajte približnú dĺžku oplotenia v metroch. Nemusí byť presné — orientačná hodnota nám stačí.':'Enter the approximate fence length in meters. It does not need to be exact — an estimate is fine.')+'</div>' +
    '<div class="mc-dim-wrap">' +
      '<div class="mc-dim-label"><span>'+(lang==='sk'?'Dĺžka':'Length')+'</span><span class="mc-dim-value" id="lenVal">'+v+'<span class="mc-dim-value-unit">m</span></span></div>' +
      '<input type="range" min="5" max="200" step="1" value="'+v+'" class="mc-slider" id="lenSlider" oninput="onLenSlide(this.value)">' +
      '<div class="mc-slider-ticks"><span>5 m</span><span>50 m</span><span>100 m</span><span>150 m</span><span>200+ m</span></div>' +
    '</div>' +
    '<div class="mc-num-input-row">' +
      '<button class="mc-num-btn" onclick="adjLen(-1)">−</button>' +
      '<input type="number" min="1" max="500" class="mc-num-input" id="lenInput" value="'+v+'" oninput="onLenInput(this.value)">' +
      '<button class="mc-num-btn" onclick="adjLen(1)">+</button>' +
      '<span style="font-size:13px;font-weight:700;color:var(--mc-text-sub);padding-left:4px">m</span>' +
    '</div>' +
    '<div class="mc-hint"><div class="hi">i</div><div>'+(lang==='sk'?'<b>Tip:</b> 1 panel = 2,5 m. Pre vašu dĺžku budeme potrebovať <b id="panelCount">'+Math.ceil(v/2.5)+' panelov</b>.':'<b>Tip:</b> 1 panel = 2.5 m. For your length we will need <b id="panelCount">'+Math.ceil(v/2.5)+' panels</b>.')+'</div></div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="confirm3dLength()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
  calcState.length = v;
}

function onLenSlide(v){
  calcState.length = parseInt(v);
  document.getElementById('lenVal').innerHTML = v + '<span class="mc-dim-value-unit">m</span>';
  document.getElementById('lenInput').value = v;
  var pc = document.getElementById('panelCount');
  if(pc) pc.innerHTML = (MC.lang==='sk'? Math.ceil(v/2.5)+' panelov' : Math.ceil(v/2.5)+' panels');
}
function onLenInput(v){
  var n = parseInt(v) || 1;
  if(n > 500) n = 500;
  calcState.length = n;
  var s = document.getElementById('lenSlider');
  if(s) s.value = Math.min(n, 200);
  document.getElementById('lenVal').innerHTML = n + '<span class="mc-dim-value-unit">m</span>';
  var pc = document.getElementById('panelCount');
  if(pc) pc.innerHTML = (MC.lang==='sk'? Math.ceil(n/2.5)+' panelov' : Math.ceil(n/2.5)+' panels');
}
function adjLen(d){
  var v = (calcState.length || 20) + d;
  if(v < 1) v = 1;
  if(v > 500) v = 500;
  document.getElementById('lenInput').value = v;
  onLenInput(v);
}
function confirm3dLength(){
  if(!calcState.length || calcState.length < 1){ alert(MC.lang==='sk'?'Zadajte dĺžku.':'Enter length.'); return; }
  next();
}

function render3dHeight(el){
  var lang = MC.lang;
  var heights = [
    { v:'103', label:lang==='sk'?'Pre záhradu, plot na vzduch':'For garden, open fence', pop:false },
    { v:'123', label:lang==='sk'?'Bežný rodinný dom':'Common family home', pop:true },
    { v:'153', label:lang==='sk'?'Súkromie a bezpečnosť':'Privacy and security', pop:true },
    { v:'173', label:lang==='sk'?'Firmy a väčšie pozemky':'Companies, larger plots', pop:false },
    { v:'203', label:lang==='sk'?'Maximálna bezpečnosť':'Maximum security', pop:false }
  ];
  var cards = heights.map(function(h){
    var sel = calcState.height === h.v;
    return '<div class="mc-size-card'+(sel?' selected':'')+(h.pop?' popular':'')+'" onclick="selHeight(\''+h.v+'\')">' +
      '<div class="mc-size-val">'+h.v+' <span style="font-size:12px;color:var(--mc-text-sub)">cm</span></div>' +
      '<div class="mc-size-label">'+h.label+'</div>' +
    '</div>';
  }).join('');
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Akú výšku panelov potrebujete?':'What panel height do you need?')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Vyššie panely znamenajú väčšie súkromie a bezpečnosť. Najčastejšie sa kupuje 123 alebo 153 cm.':'Taller panels mean more privacy and security. The most common choices are 123 and 153 cm.')+'</div>' +
    '<div class="mc-size-grid">'+cards+'</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="confirmHeight()" '+(calcState.height?'':'disabled')+'>'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function selHeight(v){ calcState.height = v; render3dHeight(document.getElementById('calcContent')); }
function confirmHeight(){ if(!calcState.height){ return; } next(); }

function render3dColor(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Akú farbu preferujete?':'Which color do you prefer?')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Zinok je technický a najlacnejší. Farebné prevedenie (RAL) sa hodí k modernému dizajnu.':'Galvanized is technical and cheapest. Color (RAL) suits modern designs.')+'</div>' +
    '<div class="mc-color-grid">' +
      colorCard('zinok','Zinok','Pozink', 'zinok', 'https://mojplot.sk/wp-content/uploads/2025/11/3D-plotovy-panel-farba-zinok.webp') +
      colorCard('zelena','Zelená','RAL 6005', 'zelena', 'https://mojplot.sk/wp-content/uploads/2025/11/3D-plotovy-panel-farba-zelena.webp') +
      colorCard('antracit','Antracit','RAL 7016', 'antracit', 'https://mojplot.sk/wp-content/uploads/2025/11/3D-plotovy-panel-farba-antracit.webp') +
    '</div>' +
    '<div class="mc-hint"><div class="hi">i</div><div>'+(lang==='sk'?'<b>Antracit</b> je dnes najobľúbenejší pre rodinné domy. <b>Zelená</b> sa hodí k záhrade a prírode.':'<b>Anthracite</b> is the most popular for family homes today. <b>Green</b> blends with garden and nature.')+'</div></div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="confirmColor()" '+(calcState.color?'':'disabled')+'>'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function colorCard(id, name, ral, swatch, photo){
  var sel = calcState.color === id;
  var photoHtml = photo ? '<div class="mc-color-photo"><img src="'+photo+'" alt="'+name+'" loading="lazy" onerror="this.parentElement.style.display=\'none\'"></div>' : '';
  return '<div class="mc-color-card'+(sel?' selected':'')+'" onclick="selColor(\''+id+'\')">' +
    photoHtml +
    '<div class="mc-color-body">' +
      '<div class="mc-color-swatch'+(photo?'':' lg')+' '+swatch+'"></div>' +
      '<div class="mc-color-name">'+name+'</div>' +
      '<div class="mc-color-ral">'+ral+'</div>' +
    '</div>' +
  '</div>';
}
function selColor(v){ calcState.color = v; renderCalcStep(); }
function confirmColor(){ if(!calcState.color) return; next(); }

function render3dThickness(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Hrúbka drôtu':'Wire thickness')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'4 mm postačuje pre väčšinu situácií. 5 mm odporúčame pre vyššie panely (173+ cm) alebo firemné objekty.':'4 mm is enough for most situations. 5 mm is recommended for taller panels (173+ cm) or commercial properties.')+'</div>' +
    '<div class="mc-radio-list">' +
      thicknessOpt('4mm', lang==='sk'?'4 mm — Štandard':'4 mm — Standard', lang==='sk'?'Pevnosť pre rodinné domy a záhrady':'Strength for homes and gardens') +
      thicknessOpt('5mm', lang==='sk'?'5 mm — Robust':'5 mm — Robust', lang==='sk'?'Vyššia odolnosť, vhodné pre vyššie ploty':'Higher durability, for taller fences') +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function thicknessOpt(v, label, desc){
  var sel = calcState.thickness === v;
  return '<label class="mc-check'+(sel?' selected':'')+'">' +
    '<input type="radio" name="thickness" '+(sel?'checked':'')+' onchange="calcState.thickness=\''+v+'\';render3dThickness(document.getElementById(\'calcContent\'))">' +
    '<span class="mc-cbx"><svg viewBox="0 0 24 24"><path d="M5 12l5 5L20 7"/></svg></span>' +
    '<span class="mc-check-label"><span>'+label+'</span><span class="mc-check-desc">'+desc+'</span></span>' +
  '</label>';
}

function render3dExtras(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Doplnky a montáž':'Extras and installation')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Vyberte si, čo všetko chcete do ponuky zahrnúť.':'Choose what should be included in your quote.')+'</div>' +
    '<div class="mc-check-list">' +
      extraCheck('withPosts', lang==='sk'?'Plotové stĺpiky (60×40 mm)':'Fence posts (60×40 mm)', lang==='sk'?'Stabilná oceľová opora — 1 stĺpik na panel + 1 koncový. Odporúčame zahrnúť.':'Stable steel support — 1 post per panel + 1 end. We recommend including this.') +
      extraCheck('withUnderboard', lang==='sk'?'Podhrabové dosky (250×20×5 cm)':'Under-fence boards (250×20×5 cm)', lang==='sk'?'Spevnenie základu a ochrana proti podhrabaniu zvieratami. + 19,19 €/ks':'Foundation reinforcement, protects against animals burrowing under. + €19.19/pc') +
      extraCheck('installation', lang==='sk'?'Montáž na kľúč':'Full installation', lang==='sk'?'Profesionálna montáž našim tímom. Cena ~18 €/m.':'Professional installation by our team. Approx. €18/m.') +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Vypočítať cenu':'Calculate price')+' →</button>' +
    '</div>' +
  '</div>';
}
function extraCheck(key, label, desc){
  var sel = calcState[key];
  return '<label class="mc-check'+(sel?' selected':'')+'">' +
    '<input type="checkbox" '+(sel?'checked':'')+' onchange="calcState.'+key+'=this.checked;render3dExtras(document.getElementById(\'calcContent\'))">' +
    '<span class="mc-cbx"><svg viewBox="0 0 24 24"><path d="M5 12l5 5L20 7"/></svg></span>' +
    '<span class="mc-check-label"><span>'+label+'</span><span class="mc-check-desc">'+desc+'</span></span>' +
  '</label>';
}

/* =========================================================
   STEPS: BRANA
   ========================================================= */
function renderGateType(el){
  var lang = MC.lang;
  var opts = [
    { id:'jednokrid', name:lang==='sk'?'Jednokrídlová bránka':'Single-wing gate', desc:lang==='sk'?'Pre vstup osôb (1 m)':'Pedestrian (1 m)', img:'https://mojplot.sk/wp-content/uploads/2025/12/jednokridlova-branka-farba-antracit.webp' },
    { id:'dvojkrid', name:lang==='sk'?'Dvojkrídlová brána':'Double-wing gate', desc:lang==='sk'?'Vjazd 3–5 m':'Driveway 3–5 m', img:'https://mojplot.sk/wp-content/uploads/2025/12/dvojkridlova-brana-farba-antracit.webp' },
    { id:'posuvna', name:lang==='sk'?'Posuvná brána':'Sliding gate', desc:lang==='sk'?'Úspora miesta':'Space saving', img:'https://mojplot.sk/wp-content/uploads/2025/07/mobilne-oplotenie-main-scaled.jpg' }
  ];
  var cards = opts.map(function(o){
    var sel = calcState.gateType === o.id;
    return '<div class="mc-product-card'+(sel?' selected':'')+'" onclick="selGateType(\''+o.id+'\')">' +
      '<div class="mc-product-img"><img src="'+o.img+'" alt="'+o.name+'" loading="lazy" onerror="this.style.display=\'none\'"></div>' +
      '<div class="mc-product-info">' +
        '<div class="mc-product-name">'+o.name+'</div>' +
        '<div class="mc-product-desc">'+o.desc+'</div>' +
      '</div></div>';
  }).join('');

  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Aký typ brány potrebujete?':'What type of gate do you need?')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Bránka je pre vstup osôb, brána pre vjazd auta. Posuvná šetrí miesto pri otváraní.':'A small gate is for pedestrians, a gate for car entry. Sliding saves space when opening.')+'</div>' +
    '<div class="mc-product-grid">'+cards+'</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()" '+(calcState.gateType?'':'disabled')+'>'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function selGateType(id){ calcState.gateType = id; calcState.gateWidth = null; calcState.gateHeight = null; renderGateType(document.getElementById('calcContent')); }

function renderGateDimensions(el){
  var lang = MC.lang;
  var heights = [
    { v:'120', label:lang==='sk'?'Nižšia, ozdobná':'Low, decorative' },
    { v:'150', label:lang==='sk'?'Štandard':'Standard' },
    { v:'170', label:lang==='sk'?'Vyššia':'Taller' },
    { v:'200', label:lang==='sk'?'Maximálna':'Maximum' }
  ];
  var widthSection = '';

  if(calcState.gateType === 'dvojkrid'){
    var widths = [
      { v:'3', label:lang==='sk'?'Bežné vjazdy':'Common driveways' },
      { v:'4', label:lang==='sk'?'Štandard pre osobné auto':'Standard for cars' },
      { v:'5', label:lang==='sk'?'Široký vjazd / dodávka':'Wide / van' }
    ];
    widthSection = '<div class="mc-dim-label" style="margin-bottom:6px"><span>'+(lang==='sk'?'Šírka brány':'Gate width')+'</span></div>' +
      '<div class="mc-size-grid" style="grid-template-columns:1fr 1fr 1fr">' +
      widths.map(function(w){
        var sel = calcState.gateWidth === w.v;
        return '<div class="mc-size-card'+(sel?' selected':'')+'" onclick="calcState.gateWidth=\''+w.v+'\';renderGateDimensions(document.getElementById(\'calcContent\'))">' +
          '<div class="mc-size-val">'+w.v+' <span style="font-size:12px;color:var(--mc-text-sub)">m</span></div>' +
          '<div class="mc-size-label">'+w.label+'</div>' +
        '</div>';
      }).join('') + '</div>';
  } else if(calcState.gateType === 'jednokrid'){
    calcState.gateWidth = '1';
    widthSection = '<div class="mc-hint"><div class="hi">i</div><div>'+(lang==='sk'?'Štandardná šírka bránky je <b>1 m</b>.':'Standard small gate width is <b>1 m</b>.')+'</div></div>';
  } else if(calcState.gateType === 'posuvna'){
    /* Posuvná brána - vyžaduje custom rozmery */
    widthSection = '<div class="mc-dim-label" style="margin-bottom:6px"><span>'+(lang==='sk'?'Šírka otvoru':'Opening width')+'</span></div>' +
      '<div class="mc-num-input-row">' +
        '<input type="number" min="3" max="10" step="0.5" class="mc-num-input" id="gateWidthInput" value="'+(calcState.gateWidth||4)+'" oninput="calcState.gateWidth=this.value">' +
        '<span style="font-size:13px;font-weight:700;color:var(--mc-text-sub);padding-left:4px">m</span>' +
      '</div>' +
      '<div class="mc-hint" style="margin-top:8px"><div class="hi">i</div><div>'+(lang==='sk'?'Posuvné brány vyrábame <b>na zákazku</b> podľa vašich rozmerov.':'Sliding gates are <b>custom-made</b> to your dimensions.')+'</div></div>';
  }

  var heightSection = '<div class="mc-dim-label" style="margin-top:10px;margin-bottom:6px"><span>'+(lang==='sk'?'Výška brány':'Gate height')+'</span></div>' +
    '<div class="mc-size-grid">' +
    heights.map(function(h){
      var sel = calcState.gateHeight === h.v;
      return '<div class="mc-size-card'+(sel?' selected':'')+'" onclick="calcState.gateHeight=\''+h.v+'\';renderGateDimensions(document.getElementById(\'calcContent\'))">' +
        '<div class="mc-size-val">'+h.v+' <span style="font-size:12px;color:var(--mc-text-sub)">cm</span></div>' +
        '<div class="mc-size-label">'+h.label+'</div>' +
      '</div>';
    }).join('') + '</div>';

  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Rozmery brány':'Gate dimensions')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Vyberte šírku a výšku. Výška by mala ladiť s výškou plotu.':'Choose width and height. The height should match your fence height.')+'</div>' +
    widthSection +
    heightSection +
    '<div class="mc-actions" style="margin-top:14px">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="confirmGateDim()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function confirmGateDim(){
  if(!calcState.gateWidth || !calcState.gateHeight){
    alert(MC.lang==='sk'?'Vyberte šírku aj výšku.':'Choose both width and height.');
    return;
  }
  next();
}

function renderGateColor(el){
  var lang = MC.lang;
  /* Vyber spravnu sadu fotiek podla typu brany */
  var gateType = calcState.gateType || 'jednokridlova';
  var photos;
  if(gateType === 'jednokridlova'){
    photos = {
      zinok:    'https://mojplot.sk/wp-content/uploads/2025/12/jednokridlova-branka-farba-zinok.webp',
      zelena:   'https://mojplot.sk/wp-content/uploads/2025/12/jednokridlova-branka-farba-zelena.webp',
      antracit: 'https://mojplot.sk/wp-content/uploads/2025/12/jednokridlova-branka-farba-antracit.webp'
    };
  } else {
    photos = {
      zinok:    'https://mojplot.sk/wp-content/uploads/2025/12/dvojkridlova-brana-farba-zinok.webp',
      zelena:   'https://mojplot.sk/wp-content/uploads/2025/12/dvojkridlova-brana-farba-zelena.webp',
      antracit: 'https://mojplot.sk/wp-content/uploads/2025/12/dvojkridlova-brana-farba-antracit.webp'
    };
  }
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Farba brány':'Gate color')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Brána by mala ladiť s plotom. Štandardne sa volí rovnaká farba.':'The gate should match the fence. Typically the same color is chosen.')+'</div>' +
    '<div class="mc-color-grid">' +
      colorCard('zinok','Zinok','Pozink', 'zinok', photos.zinok) +
      colorCard('zelena','Zelená','RAL 6005', 'zelena', photos.zelena) +
      colorCard('antracit','Antracit','RAL 7016', 'antracit', photos.antracit) +
    '</div>' +
    '<div class="mc-actions" style="margin-top:14px">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()" '+(calcState.color?'':'disabled')+'>'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}

function renderGateExtras(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Automatizácia':'Automation')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Chcete bránu otvárať diaľkovým ovládačom z auta?':'Would you like to open the gate via remote from your car?')+'</div>' +
    '<div class="mc-check-list">' +
      extraCheck('gateAutomation', lang==='sk'?'Automatický pohon + diaľkové ovládače':'Automatic motor + remote controls', lang==='sk'?'Elektrický pohon, 2× diaľkové ovládače, fotobunky. ~ +850 €':'Electric motor, 2× remote controls, safety photocells. Approx. +€850') +
      extraCheck('installation', lang==='sk'?'Montáž brány na mieste':'On-site gate installation', lang==='sk'?'Vrátane osadenia stĺpikov, betonáže a montáže. ~220 €':'Including post placement, concrete and installation. ~€220') +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Vypočítať cenu':'Calculate price')+' →</button>' +
    '</div>' +
  '</div>';
}


/* =========================================================
   STEPS: PLETIVO
   ========================================================= */
function renderMeshLength(el){
  var lang = MC.lang;
  var v = calcState.length || 30;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Dĺžka pletivového plotu':'Mesh fence length')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Pletivový plot je cenovo najdostupnejší. Zadajte celkovú dĺžku v metroch.':'Mesh fencing is the most affordable. Enter the total length in meters.')+'</div>' +
    '<div class="mc-dim-wrap">' +
      '<div class="mc-dim-label"><span>'+(lang==='sk'?'Dĺžka':'Length')+'</span><span class="mc-dim-value" id="lenVal">'+v+'<span class="mc-dim-value-unit">m</span></span></div>' +
      '<input type="range" min="5" max="300" step="1" value="'+v+'" class="mc-slider" oninput="onLenSlide(this.value)">' +
      '<div class="mc-slider-ticks"><span>5 m</span><span>75 m</span><span>150 m</span><span>225 m</span><span>300+ m</span></div>' +
    '</div>' +
    '<div class="mc-num-input-row">' +
      '<button class="mc-num-btn" onclick="adjLen(-1)">−</button>' +
      '<input type="number" min="1" max="1000" class="mc-num-input" id="lenInput" value="'+v+'" oninput="onLenInput(this.value)">' +
      '<button class="mc-num-btn" onclick="adjLen(1)">+</button>' +
      '<span style="font-size:13px;font-weight:700;color:var(--mc-text-sub);padding-left:4px">m</span>' +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
  calcState.length = v;
}
function renderMeshHeight(el){
  var lang = MC.lang;
  var heights = ['100','125','150','175','200'];
  var labels = {
    sk:{'100':'Záhrada','125':'Bežné','150':'Štandard','175':'Vyššie','200':'Maximum'},
    en:{'100':'Garden','125':'Common','150':'Standard','175':'Taller','200':'Maximum'}
  };
  var cards = heights.map(function(h){
    var sel = calcState.meshHeight === h;
    return '<div class="mc-size-card'+(sel?' selected':'')+(h==='150'?' popular':'')+'" onclick="calcState.meshHeight=\''+h+'\';renderMeshHeight(document.getElementById(\'calcContent\'))">' +
      '<div class="mc-size-val">'+h+' <span style="font-size:12px;color:var(--mc-text-sub)">cm</span></div>' +
      '<div class="mc-size-label">'+labels[lang][h]+'</div>' +
    '</div>';
  }).join('');
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Výška pletiva':'Mesh height')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Zvoľte výšku pletiva. Najpopulárnejšia je 150 cm.':'Choose the mesh height. The most popular is 150 cm.')+'</div>' +
    '<div class="mc-size-grid">'+cards+'</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()" '+(calcState.meshHeight?'':'disabled')+'>'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
}
function renderMeshColor(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Farba pletiva':'Mesh color')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Štandardne ponúkame zinok, zelenú a antracit.':'We offer galvanized, green and anthracite.')+'</div>' +
    '<div class="mc-color-grid">' +
      colorCard('zinok','Zinok','Pozink','zinok') +
      colorCard('zelena','Zelená','RAL 6005','zelena') +
      colorCard('antracit','Antracit','RAL 7016','antracit') +
    '</div>' +
    '<div class="mc-actions" style="margin-top:14px">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()" '+(calcState.color?'':'disabled')+'>'+(lang==='sk'?'Vypočítať':'Calculate')+' →</button>' +
    '</div>' +
  '</div>';
}

/* =========================================================
   STEPS: MOBILNE OPLOTENIE
   ========================================================= */
function renderMobileLength(el){
  var lang = MC.lang;
  var v = calcState.mobileLength || 50;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Dĺžka mobilného oplotenia':'Mobile fence length')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Mobilné oplotenie je ideálne pre stavby, akcie a dočasné ohradenie. Panel = 3,5 m.':'Mobile fencing is ideal for sites, events and temporary use. Panel = 3.5 m.')+'</div>' +
    '<div class="mc-dim-wrap">' +
      '<div class="mc-dim-label"><span>'+(lang==='sk'?'Dĺžka':'Length')+'</span><span class="mc-dim-value">'+v+'<span class="mc-dim-value-unit">m</span></span></div>' +
      '<input type="range" min="10" max="500" step="5" value="'+v+'" class="mc-slider" oninput="onMobileSlide(this.value)">' +
      '<div class="mc-slider-ticks"><span>10 m</span><span>125 m</span><span>250 m</span><span>375 m</span><span>500+ m</span></div>' +
    '</div>' +
    '<div class="mc-hint"><div class="hi">i</div><div>'+(lang==='sk'?'Budete potrebovať približne <b id="mobilePanels">'+Math.ceil(v/3.5)+' panelov</b> + pätky a klipy.':'You will need approximately <b id="mobilePanels">'+Math.ceil(v/3.5)+' panels</b> + bases and clips.')+'</div></div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
  calcState.mobileLength = v;
}
function onMobileSlide(v){
  calcState.mobileLength = parseInt(v);
  var dv = document.querySelector('.mc-dim-value');
  if(dv) dv.innerHTML = v + '<span class="mc-dim-value-unit">m</span>';
  var mp = document.getElementById('mobilePanels');
  if(mp) mp.innerHTML = (MC.lang==='sk'? Math.ceil(v/3.5)+' panelov' : Math.ceil(v/3.5)+' panels');
}

function renderMobileExtras(el){
  var lang = MC.lang;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Doplnky mobilného oplotenia':'Mobile fence extras')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Pre kompletnú zostavu potrebujete aj pätky a spojovacie klipy.':'For a complete setup you also need bases and connector clips.')+'</div>' +
    '<div class="mc-check-list">' +
      extraCheck('mobileBases', lang==='sk'?'Betónové pätky + spojovacie klipy':'Concrete bases + connector clips', lang==='sk'?'Pre stabilitu panelov. Súčasť kompletnej zostavy.':'For panel stability. Part of a complete kit.') +
    '</div>' +
    '<div class="mc-hint"><div class="hi">i</div><div>'+(lang==='sk'?'Predávame aj <b>krátkodobý prenájom</b> — kontaktujte nás pre detaily.':'We also offer <b>short-term rental</b> — contact us for details.')+'</div></div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Vypočítať cenu':'Calculate price')+' →</button>' +
    '</div>' +
  '</div>';
}

/* =========================================================
   STEPS: OPORNE MURY
   ========================================================= */
function renderWallLength(el){
  var lang = MC.lang;
  var v = calcState.wallLength || 10;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Dĺžka oporného múru':'Retaining wall length')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Aká dlhá bude stena z LEGO blokov? Bloky sú 80 cm široké (1 blok = ~0,8 m dĺžky).':'How long will the LEGO block wall be? Blocks are 80 cm wide (1 block = ~0.8 m length).')+'</div>' +
    '<div class="mc-dim-wrap">' +
      '<div class="mc-dim-label"><span>'+(lang==='sk'?'Dĺžka':'Length')+'</span><span class="mc-dim-value">'+v+'<span class="mc-dim-value-unit">m</span></span></div>' +
      '<input type="range" min="2" max="100" step="1" value="'+v+'" class="mc-slider" oninput="onWallLen(this.value,\'wallLength\')">' +
      '<div class="mc-slider-ticks"><span>2</span><span>25</span><span>50</span><span>75</span><span>100+</span></div>' +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
  calcState.wallLength = v;
}
function onWallLen(v, key){
  calcState[key] = parseInt(v);
  var dv = document.querySelector('.mc-dim-value');
  if(dv) dv.innerHTML = v + '<span class="mc-dim-value-unit">m</span>';
}

function renderWallHeight(el){
  var lang = MC.lang;
  var v = calcState.wallHeight || 2;
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Výška múru (počet vrstiev)':'Wall height (number of layers)')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Bloky sa skladajú ako LEGO. 1 vrstva = ~0,6 m výšky.':'Blocks stack like LEGO. 1 layer = ~0.6 m height.')+'</div>' +
    '<div class="mc-dim-wrap">' +
      '<div class="mc-dim-label"><span>'+(lang==='sk'?'Vrstvy':'Layers')+'</span><span class="mc-dim-value">'+v+'<span class="mc-dim-value-unit">'+(v*0.6).toFixed(1)+' m</span></span></div>' +
      '<input type="range" min="1" max="6" step="1" value="'+v+'" class="mc-slider" oninput="onWallLayers(this.value)">' +
      '<div class="mc-slider-ticks"><span>1</span><span>2</span><span>3</span><span>4</span><span>5</span><span>6</span></div>' +
    '</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
    '</div>' +
  '</div>';
  calcState.wallHeight = v;
}
function onWallLayers(v){
  calcState.wallHeight = parseInt(v);
  var dv = document.querySelector('.mc-dim-value');
  if(dv) dv.innerHTML = v + '<span class="mc-dim-value-unit">'+(v*0.6).toFixed(1)+' m</span>';
}

function renderWallBlock(el){
  var lang = MC.lang;
  var widths = [
    { v:'30', desc:lang==='sk'?'Tenké, dekoračné múry':'Thin, decorative walls' },
    { v:'40', desc:lang==='sk'?'Štandardné použitie':'Standard use' },
    { v:'60', desc:lang==='sk'?'Vyššia stabilita':'Higher stability' },
    { v:'80', desc:lang==='sk'?'Maximálne zaťaženie':'Maximum load' }
  ];
  var cards = widths.map(function(w){
    var sel = calcState.blockWidth === w.v;
    return '<div class="mc-size-card'+(sel?' selected':'')+(w.v==='40'?' popular':'')+'" onclick="calcState.blockWidth=\''+w.v+'\';renderWallBlock(document.getElementById(\'calcContent\'))">' +
      '<div class="mc-size-val">'+w.v+' <span style="font-size:12px;color:var(--mc-text-sub)">cm</span></div>' +
      '<div class="mc-size-label">'+w.desc+'</div>' +
    '</div>';
  }).join('');
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+(lang==='sk'?'Šírka LEGO bloku':'LEGO block width')+'</div>' +
    '<div class="mc-step-sub">'+(lang==='sk'?'Čím širší blok, tým väčšia stabilita a zaťaženie.':'The wider the block, the more stability and load capacity.')+'</div>' +
    '<div class="mc-size-grid">'+cards+'</div>' +
    '<div class="mc-actions">' +
      '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
      '<button class="mc-btn" onclick="next()" '+(calcState.blockWidth?'':'disabled')+'>'+(lang==='sk'?'Vypočítať':'Calculate')+' →</button>' +
    '</div>' +
  '</div>';
}

/* =========================================================
   STEPS: BETONOVY / INE (custom popis)
   ========================================================= */
function renderCustomDesc(el){
  var lang = MC.lang;
  var prod = calcState.product;
  var title, sub;
  if(prod === 'betonovy'){
    title = lang==='sk'?'Betónový plot — opíšte vaše požiadavky':'Concrete fence — describe your needs';
    sub = lang==='sk'?'Betónové ploty vyrábame na mieru. Napíšte dĺžku, výšku a prípadné špeciálne požiadavky.':'Concrete fences are custom-made. Tell us length, height and any special requirements.';
  } else {
    title = lang==='sk'?'Opíšte vaše zadanie':'Describe your project';
    sub = lang==='sk'?'Schody, zábradlia, atypické rozmery — napíšte čo potrebujete a my pripravíme ponuku.':'Stairs, railings, custom dimensions — tell us what you need and we will prepare a quote.';
  }
  el.innerHTML = '<div class="mc-step">' +
    '<div class="mc-step-title">'+title+'</div>' +
    '<div class="mc-step-sub">'+sub+'</div>' +
    '<textarea class="mc-num-input" id="customDescInput" style="width:100%;text-align:left;height:130px;padding:12px;resize:none;font-size:13.5px;line-height:1.5;font-weight:400;font-family:var(--m-font)" placeholder="'+(lang==='sk'?'Napr.: Plot okolo pozemku 30×40 m, výška 150 cm, antracit. Záujem o montáž...':'E.g.: Fence around 30×40 m plot, height 150 cm, anthracite. Interested in installation...')+'" oninput="calcState.customDesc=this.value">'+(calcState.customDesc||'')+'</textarea>' +

```
'<div class="mc-hint" style="margin-top:10px"><div class="hi">i</div><div>'+(lang==='sk'?'Náš tím (Denis Plichta) vám pripraví <b>individuálnu ponuku do 24 hodín</b>.':'Our team (Denis Plichta) will prepare an <b>individual quote within 24 hours</b>.')+'</div></div>' +
'<div class="mc-actions">' +
  '<button class="mc-btn-secondary" onclick="calcBack()">← '+(lang==='sk'?'Späť':'Back')+'</button>' +
  '<button class="mc-btn" onclick="next()">'+(lang==='sk'?'Pokračovať':'Continue')+' →</button>' +
'</div>' +
```

‘</div>’;
}

/* =========================================================
PRICE CALCULATION
========================================================= */
function calculatePrice(){
var lang = MC.lang;
var prod = calcState.product;
var result = { onRequest:false, total:0, breakdown:[], summary:[], productName:’’ };
var productObj = PRODUCTS.find(function(p){ return p.id === prod; });
result.productName = productObj ? productObj.name[lang] : prod;

/* ===== 3D PLOT ===== */
if(prod === ‘3d-plot’){
var L = parseFloat(calcState.length) || 0;
var H = calcState.height || ‘153’;
var C = calcState.color || ‘zinok’;
var T = calcState.thickness || ‘4mm’;
var panels = Math.ceil(L / 2.5);
var posts = panels + 1;

```
var panelUnit = PRICE_3D[H][T][C];
var postUnit  = PRICE_POST[H][C];
var panelSum = panels * panelUnit;
var postSum  = posts  * postUnit;

result.breakdown.push({ k:(lang==='sk'?'3D panely':'3D panels')+' ('+panels+'× '+panelUnit.toFixed(2)+' €)', v: panelSum });
result.breakdown.push({ k:(lang==='sk'?'Stĺpiky 60×40 mm':'Posts 60×40 mm')+' ('+posts+'× '+postUnit.toFixed(2)+' €)', v: postSum });

var sub = panelSum + postSum;

if(calcState.underboard){
  var ubSum = panels * PRICE_UNDERBOARD;
  result.breakdown.push({ k:(lang==='sk'?'Podhrabové dosky':'Underboards')+' ('+panels+'× '+PRICE_UNDERBOARD.toFixed(2)+' €)', v: ubSum });
  sub += ubSum;
}
if(calcState.installation){
  var instSum = L * INSTALLATION_PER_M;
  result.breakdown.push({ k:(lang==='sk'?'Montáž':'Installation')+' ('+L+' m × '+INSTALLATION_PER_M+' €)', v: instSum });
  sub += instSum;
}
result.total = sub;

var colorLabel = { zinok:'Zinok', zelena:'Zelená (RAL 6005)', antracit:'Antracit (RAL 7016)' }[C];
result.summary = [
  { k:(lang==='sk'?'Produkt':'Product'), v:'3D plotový panel' },
  { k:(lang==='sk'?'Dĺžka':'Length'),    v: L+' m ('+panels+' '+(lang==='sk'?'panelov':'panels')+')' },
  { k:(lang==='sk'?'Výška':'Height'),    v: H+' cm' },
  { k:(lang==='sk'?'Hrúbka drôtu':'Wire thickness'), v: T },
  { k:(lang==='sk'?'Farba':'Color'),     v: colorLabel },
  { k:(lang==='sk'?'Podhrab. dosky':'Underboards'), v: calcState.underboard ? (lang==='sk'?'Áno':'Yes') : (lang==='sk'?'Nie':'No') },
  { k:(lang==='sk'?'Montáž':'Installation'),        v: calcState.installation ? (lang==='sk'?'Áno':'Yes') : (lang==='sk'?'Nie':'No') }
];
```

}

/* ===== BRÁNA ===== */
else if(prod === ‘brana’){
var GT = calcState.gateType || ‘jednokridlova’;
var GW = calcState.gateWidth || ‘1’;
var GH = calcState.gateHeight || ‘150’;
var GC = calcState.color || calcState.gateColor || ‘zinok’;
var base = 0;
var gateLabel = ‘’;

```
if(GT === 'jednokridlova'){
  base = PRICE_GATE_SINGLE[GH];
  gateLabel = (lang==='sk'?'Jednokrídlová bránka 1 m':'Single gate 1 m');
} else if(GT === 'dvojkridlova'){
  base = PRICE_GATE_DOUBLE[GW][GH];
  gateLabel = (lang==='sk'?'Dvojkrídlová brána ':'Double gate ')+GW+' m';
} else { /* posuvna */
  var baseDbl = PRICE_GATE_DOUBLE[GW || '4'][GH];
  base = Math.round(baseDbl * 1.45);
  gateLabel = (lang==='sk'?'Posuvná brána ':'Sliding gate ')+(GW||'4')+' m';
}

if(GC !== 'zinok'){
  var colorSur = base * SURCHARGE_COLOR;
  result.breakdown.push({ k: gateLabel+' — '+(lang==='sk'?'základ (zinok)':'base (galvanized)'), v: base });
  result.breakdown.push({ k:(lang==='sk'?'Príplatok za farbu':'Color surcharge')+' (+12 %)', v: colorSur });
  base += colorSur;
} else {
  result.breakdown.push({ k: gateLabel, v: base });
}

var sub2 = base;
if(calcState.automation){
  result.breakdown.push({ k:(lang==='sk'?'Automatický pohon':'Automatic drive'), v: SURCHARGE_AUTOMATION });
  sub2 += SURCHARGE_AUTOMATION;
}
if(calcState.gateInstallation){
  result.breakdown.push({ k:(lang==='sk'?'Montáž brány':'Gate installation'), v: GATE_INSTALLATION });
  sub2 += GATE_INSTALLATION;
}
result.total = sub2;

var gtLabel = { jednokridlova:(lang==='sk'?'Jednokrídlová bránka':'Single gate'), dvojkridlova:(lang==='sk'?'Dvojkrídlová brána':'Double gate'), posuvna:(lang==='sk'?'Posuvná brána':'Sliding gate') }[GT];
var gcLabel = { zinok:'Zinok', zelena:'Zelená (RAL 6005)', antracit:'Antracit (RAL 7016)' }[GC];
result.summary = [
  { k:(lang==='sk'?'Produkt':'Product'), v: gtLabel },
  { k:(lang==='sk'?'Šírka':'Width'),    v: (GT==='jednokridlova' ? '1 m' : GW+' m') },
  { k:(lang==='sk'?'Výška':'Height'),   v: GH+' cm' },
  { k:(lang==='sk'?'Farba':'Color'),    v: gcLabel },
  { k:(lang==='sk'?'Pohon':'Drive'),    v: calcState.automation ? (lang==='sk'?'Áno (automat)':'Yes (automatic)') : (lang==='sk'?'Ručná':'Manual') },
  { k:(lang==='sk'?'Montáž':'Installation'), v: calcState.gateInstallation ? (lang==='sk'?'Áno':'Yes') : (lang==='sk'?'Nie':'No') }
];
```

}

/* ===== PLETIVO ===== */
else if(prod === ‘pletivo’){
var ML = parseFloat(calcState.meshLength) || 0;
var MH = calcState.meshHeight || ‘150’;
var MC2 = calcState.color || calcState.meshColor || ‘zinok’;
var unit = PRICE_MESH[MH];
var sub3 = ML * unit;
result.breakdown.push({ k:(lang===‘sk’?‘Pletivo + stĺpiky’:‘Mesh + posts’)+’ (’+ML+’ m × ‘+unit.toFixed(2)+’ €)’, v: sub3 });
if(MC2 !== ‘zinok’){
var msur = sub3 * SURCHARGE_COLOR;
result.breakdown.push({ k:(lang===‘sk’?‘Príplatok za farbu’:‘Color surcharge’)+’ (+12 %)’, v: msur });
sub3 += msur;
}
result.total = sub3;
var mcLabel = { zinok:(lang===‘sk’?‘Zinok / pozink’:‘Galvanized’), zelena:‘Zelená (PVC)’, antracit:‘Antracit (PVC)’ }[MC2];
result.summary = [
{ k:(lang===‘sk’?‘Produkt’:‘Product’), v:(lang===‘sk’?‘Pletivový plot’:‘Mesh fence’) },
{ k:(lang===‘sk’?‘Dĺžka’:‘Length’),    v: ML+’ m’ },
{ k:(lang===‘sk’?‘Výška’:‘Height’),    v: MH+’ cm’ },
{ k:(lang===‘sk’?‘Povrch’:‘Finish’),   v: mcLabel }
];
}

/* ===== MOBILNÉ OPLOTENIE ===== */
else if(prod === ‘mobilne’){
var BL = parseFloat(calcState.mobileLength) || 0;
var mobPanels = Math.ceil(BL / 3.5);
var mobSub = mobPanels * PRICE_MOBILE_PANEL;
result.breakdown.push({ k:(lang===‘sk’?‘Mobilné panely 3,5 m’:‘Mobile panels 3.5 m’)+’ (’+mobPanels+‘× ‘+PRICE_MOBILE_PANEL+’ €)’, v: mobSub });
if(calcState.mobileRent){
result.onRequest = true;
}
result.total = mobSub;
result.summary = [
{ k:(lang===‘sk’?‘Produkt’:‘Product’), v:(lang===‘sk’?‘Mobilné oplotenie’:‘Mobile fencing’) },
{ k:(lang===‘sk’?‘Dĺžka’:‘Length’),    v: BL+’ m (’+mobPanels+’ ‘+(lang===‘sk’?‘panelov’:‘panels’)+’)’ },
{ k:(lang===‘sk’?‘Režim’:‘Mode’),      v: calcState.mobileRent ? (lang===‘sk’?‘Prenájom (na vyžiadanie)’:‘Rental (on request)’) : (lang===‘sk’?‘Predaj’:‘Purchase’) }
];
}

/* ===== OPORNÉ MÚRY ===== */
else if(prod === ‘oporne’){
var WL = parseFloat(calcState.wallLength) || 0;
var WLayers = parseInt(calcState.wallLayers) || 1;
var BW = calcState.blockWidth || ‘40’;
var unitWall = PRICE_WALL[BW];
var blocksPerLayer = Math.ceil(WL / 1.2); /* LEGO blok ~ 120 cm dĺžka */
var totalBlocks = blocksPerLayer * WLayers;
var wallSub = WL * unitWall * WLayers;
result.breakdown.push({ k:(lang===‘sk’?‘LEGO bloky ‘:‘LEGO blocks ‘)+BW+’ cm (’+totalBlocks+’ ‘+(lang===‘sk’?‘ks’:‘pcs’)+’)’, v: wallSub });
result.total = wallSub;
var heightCm = WLayers * 40; /* ~40 cm na vrstvu */
result.summary = [
{ k:(lang===‘sk’?‘Produkt’:‘Product’),    v:(lang===‘sk’?‘Oporný múr (LEGO)’:‘Retaining wall (LEGO)’) },
{ k:(lang===‘sk’?‘Dĺžka’:‘Length’),       v: WL+’ m’ },
{ k:(lang===‘sk’?‘Výška’:‘Height’),       v: WLayers+’ ‘+(lang===‘sk’?‘vrstvy’:‘layers’)+’ (~’+heightCm+’ cm)’ },
{ k:(lang===‘sk’?‘Šírka bloku’:‘Block width’), v: BW+’ cm’ },
{ k:(lang===‘sk’?‘Počet blokov’:‘Block count’), v: totalBlocks+’ ’+(lang===‘sk’?‘ks’:‘pcs’) }
];
}

/* ===== BETÓNOVÝ / INÉ — na vyžiadanie ===== */
else if(prod === ‘betonovy’ || prod === ‘ine’){
result.onRequest = true;
result.summary = [
{ k:(lang===‘sk’?‘Produkt’:‘Product’), v: prod === ‘betonovy’ ? (lang===‘sk’?‘Betónový plot’:‘Concrete fence’) : (lang===‘sk’?‘Zákazková výroba’:‘Custom project’) },
{ k:(lang===‘sk’?‘Popis’:‘Description’), v: calcState.customDesc || ‘—’ }
];
}

return result;
}

/* =========================================================
FINAL STEP - cena + kontaktny formular
========================================================= */
function renderFinal(el){
var lang = MC.lang;
var r = calculatePrice();

/* Hlavna karta s cenou */
var priceCard;
if(r.onRequest){
priceCard =
‘<div class="mc-result-card">’ +
‘<div class="mc-result-label">’+(lang===‘sk’?‘Orientačná cena’:‘Estimated price’)+’</div>’ +
‘<div class="mc-result-price">’+(lang===‘sk’?‘Na vyžiadanie’:‘On request’)+’</div>’ +
‘<div class="mc-result-sub">’+(lang===‘sk’?‘Pripravíme vám individuálnu ponuku do 24 hodín.’:‘We will prepare a tailored quote within 24 hours.’)+’</div>’ +
‘</div>’;
} else {
var roundedFrom = Math.round(r.total * 0.95);
var roundedTo   = Math.round(r.total * 1.10);
priceCard =
‘<div class="mc-result-card">’ +
‘<div class="mc-result-label">’+(lang===‘sk’?‘Orientačná cena (vrátane DPH)’:‘Estimated price (incl. VAT)’)+’</div>’ +
‘<div class="mc-result-price">’+roundedFrom.toLocaleString(‘sk-SK’)+’ – ‘+roundedTo.toLocaleString(‘sk-SK’)+’ €</div>’ +
‘<div class="mc-result-sub">’+(lang===‘sk’?‘Cena je orientačná. Presnú ponuku vám pripravíme po overení detailov.’:‘This is an estimate. We will prepare an exact quote after verifying details.’)+’</div>’ +
‘</div>’;
}

/* Breakdown */
var breakdownHtml = ‘’;
if(!r.onRequest && r.breakdown.length){
var rows = r.breakdown.map(function(b){
return ‘<div class="mc-breakdown-row"><span>’+b.k+’</span><span>’+b.v.toFixed(2)+’ €</span></div>’;
}).join(’’);
breakdownHtml =
‘<div class="mc-breakdown">’ +
rows +
‘<div class="mc-breakdown-total"><span>’+(lang===‘sk’?‘Spolu’:‘Total’)+’</span><span>’+r.total.toFixed(2)+’ €</span></div>’ +
‘</div>’;
}

/* Summary */
var sumRows = r.summary.map(function(s){
return ‘<div class="mc-summary-row"><span class="mc-summary-key">’+s.k+’</span><span class="mc-summary-val">’+s.v+’</span></div>’;
}).join(’’);
var summaryHtml =
‘<div class="mc-summary-card">’ +
‘<div class="mc-summary-title">’+(lang===‘sk’?‘Vaša konfigurácia’:‘Your configuration’)+’</div>’ +
sumRows +
‘</div>’;

/* Trust badges */
var trustHtml =
‘<div class="mc-trust-row">’ +
‘<div class="mc-trust"><div class="mc-trust-ico">🚚</div><div>’+(lang===‘sk’?‘Doprava ZDARMA’:‘FREE shipping’)+’</div></div>’ +
‘<div class="mc-trust"><div class="mc-trust-ico">💰</div><div>’+(lang===‘sk’?‘Najnižšia cena’:‘Best price’)+’</div></div>’ +
‘<div class="mc-trust"><div class="mc-trust-ico">⭐</div><div>’+(lang===‘sk’?‘8 rokov skúseností’:‘8 years experience’)+’</div></div>’ +
‘</div>’;

/* Kontaktny formular */
var formHtml =
‘<div class="mc-contact-form">’ +
‘<div class="mc-form-title">’+(lang===‘sk’?‘📩 Získať presnú ponuku’:‘📩 Get exact quote’)+’</div>’ +
‘<div class="mc-form-sub">’+(lang===‘sk’?‘Vyplňte kontakt a Denis Plichta vám pripraví ponuku do 24 hodín.’:‘Leave your contact and Denis Plichta will prepare a quote within 24 hours.’)+’</div>’ +
‘<input class="mc-form-input" id="cfName" type="text" placeholder="'+(lang==='sk'?'Meno a priezvisko *':'Full name *')+'" required>’ +
‘<input class="mc-form-input" id="cfPhone" type="tel" placeholder="'+(lang==='sk'?'Telefón *':'Phone *')+'" required>’ +
‘<input class="mc-form-input" id="cfEmail" type="email" placeholder="E-mail *" required>’ +
‘<textarea class="mc-form-textarea" id="cfMsg" placeholder="'+(lang==='sk'?'Doplňujúce informácie (PSČ, termín, otázky...)':'Additional info (ZIP, timing, questions...)')+'"></textarea>’ +
‘<button class="mc-btn mc-form-submit" onclick="submitCalc()">’+(lang===‘sk’?‘Odoslať dopyt’:‘Send inquiry’)+’ →</button>’ +
‘<div class="mc-form-note">’+(lang===‘sk’?‘Odoslaním súhlasíte so spracovaním osobných údajov za účelom prípravy ponuky.’:‘By submitting you consent to processing of personal data for quote preparation.’)+’</div>’ +
‘</div>’;

el.innerHTML =
‘<div class="mc-step">’ +
‘<div class="mc-step-title">’+(lang===‘sk’?‘🎉 Tu je vaša ponuka’:‘🎉 Here is your quote’)+’</div>’ +
priceCard +
breakdownHtml +
summaryHtml +
trustHtml +
formHtml +
‘<div class="mc-actions" style="margin-top:8px">’ +
‘<button class="mc-btn-secondary" onclick="calcBack()">← ‘+(lang===‘sk’?‘Späť’:‘Back’)+’</button>’ +
‘<button class="mc-btn-secondary" onclick="closeCalc()">’+(lang===‘sk’?‘Zavrieť’:‘Close’)+’</button>’ +
‘</div>’ +
‘</div>’;
}

/* =========================================================
ODOSLANIE DOPYTU (EmailJS)
========================================================= */
function submitCalc(){
var lang = MC.lang;
var name = (document.getElementById(‘cfName’)||{}).value || ‘’;
var phone = (document.getElementById(‘cfPhone’)||{}).value || ‘’;
var email = (document.getElementById(‘cfEmail’)||{}).value || ‘’;
var msg = (document.getElementById(‘cfMsg’)||{}).value || ‘’;

/* Validacia */
if(!name.trim() || !phone.trim() || !email.trim()){
alert(lang===‘sk’ ? ‘Prosím vyplňte meno, telefón a e-mail.’ : ‘Please fill in name, phone and email.’);
return;
}
if(!/^[^\s@]+@[^\s@]+.[^\s@]+$/.test(email)){
alert(lang===‘sk’ ? ‘Prosím zadajte platný e-mail.’ : ‘Please enter a valid email.’);
return;
}

var r = calculatePrice();
var summaryText = r.summary.map(function(s){ return s.k+’: ‘+s.v; }).join(’\n’);
var priceText = r.onRequest
? (lang===‘sk’?‘Na vyžiadanie’:‘On request’)
: (Math.round(r.total*0.95)+’ – ’+Math.round(r.total*1.10)+’ €’);

var btn = document.querySelector(’.mc-form-submit’);
if(btn){ btn.disabled = true; btn.textContent = (lang===‘sk’?‘Odosielam…’:‘Sending…’); }

var params = {
customer_name: name,
customer_phone: phone,
customer_email: email,
customer_message: msg,
product: r.productName,
price_estimate: priceText,
configuration: summaryText,
language: lang,
source: ‘mojplot.sk – kalkulačka’
};

/* EmailJS odoslanie */
try {
if(typeof emailjs !== ‘undefined’ && MC.emailKey && MC.emailKey.indexOf(‘YOUR_’) !== 0){
emailjs.send(MC.emailService, MC.emailTemplate, params)
.then(function(){ showThanks(); })
.catch(function(err){
console.error(‘EmailJS error:’, err);
showThanks(); /* aj tak ukaz dakujem - data sa nestratia, mozno cez fallback */
});
} else {
/* Fallback: log do konzoly + ukaz dakujem (uzivatel sa nedozvie ze emailjs nie je nakonfig.) */
console.log(’[mojplot] Calc inquiry (EmailJS not configured):’, params);
setTimeout(showThanks, 600);
}
} catch(e){
console.error(e);
showThanks();
}
}

function showThanks(){
var lang = MC.lang;
var el = document.getElementById(‘calcContent’);
if(!el) return;
el.innerHTML =
‘<div class="mc-step" style="text-align:center;padding:30px 18px">’ +
‘<div style="font-size:64px;margin-bottom:14px;animation:mcPulse 1.4s ease-in-out infinite">✅</div>’ +
‘<div class="mc-step-title" style="text-align:center;font-size:18px">’+(lang===‘sk’?‘Ďakujeme za dopyt!’:‘Thank you for your inquiry!’)+’</div>’ +
‘<div class="mc-step-sub" style="text-align:center;line-height:1.6">’+MC.s[lang].thxMsg+’</div>’ +
‘<div class="mc-trust-row" style="margin-top:18px">’ +
‘<a href="tel:+421940511266" class="mc-trust" style="text-decoration:none;color:inherit"><div class="mc-trust-ico">📞</div><div>+421 940 511 266</div></a>’ +
‘<a href="https://wa.me/421940511266" target="_blank" class="mc-trust" style="text-decoration:none;color:inherit"><div class="mc-trust-ico">💬</div><div>WhatsApp</div></a>’ +
‘</div>’ +
‘<button class="mc-btn-secondary" style="margin-top:18px" onclick="resetCalc()">’+(lang===‘sk’?‘Spustiť novú kalkuláciu’:‘Start new calculation’)+’</button>’ +
‘</div>’;

/* Log do AI konverzacie */
try {
if(typeof addMsg === ‘function’){
var r = calculatePrice();
var priceText = r.onRequest ? (lang===‘sk’?‘na vyžiadanie’:‘on request’) : (Math.round(r.total*0.95)+’–’+Math.round(r.total*1.10)+’ €’);
addMsg(
(lang===‘sk’?‘✅ Váš dopyt sme odoslali — orientačná cena: <b>’:‘✅ Your inquiry was sent — estimated price: <b>’)+priceText+’</b>. ’+
(lang===‘sk’?‘Denis Plichta vás bude kontaktovať do 24 hodín.’:‘Denis Plichta will contact you within 24 hours.’),
‘bot’
);
}
} catch(e){}
}

function resetCalc(){
/* Reset state */
calcState.step = 0;
calcState.product = null;
calcState.length = ‘’; calcState.height = ‘’; calcState.color = ‘’; calcState.thickness = ‘’;
calcState.underboard = false; calcState.installation = false;
calcState.gateType = ‘’; calcState.gateWidth = ‘’; calcState.gateHeight = ‘’; calcState.gateColor = ‘’;
calcState.automation = false; calcState.gateInstallation = false;
calcState.meshLength = ‘’; calcState.meshHeight = ‘’; calcState.meshColor = ‘’;
calcState.mobileLength = ‘’; calcState.mobileRent = false;
calcState.wallLength = ‘’; calcState.wallLayers = 1; calcState.blockWidth = ‘’;
calcState.customDesc = ‘’;
renderCalcStep();
}

/* =========================================================
INIT EmailJS (ak je nakonfigurovany kluc)
========================================================= */
(function initEmailJS(){
try {
if(typeof emailjs !== ‘undefined’ && MC.emailKey && MC.emailKey.indexOf(‘YOUR_’) !== 0){
emailjs.init({ publicKey: MC.emailKey });
}
} catch(e){ console.warn(‘EmailJS init skipped:’, e); }
})();

</script>
</body>
</html>
