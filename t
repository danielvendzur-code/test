<!DOCTYPE html>
<html lang="sk">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Koverta AI Chatbot & Kalkulačka</title>
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--k-yellow:#FFCC00;--k-yellow-hover:#E6B800;--k-yellow-glow:rgba(255,204,0,0.15);--k-dark:#495862;--k-white:#FFF;--k-light:#F4F5F7;--k-gray:#8A9AA4;--k-border:#E2E6EA;--k-green:#4CAF50;--k-red:#E53935;--k-radius:20px;--k-font:'DM Sans',-apple-system,BlinkMacSystemFont,sans-serif;--kc-bg:#FFF;--kc-msg-bot:#F4F5F7;--kc-msg-user:#FFCC00;--kc-msg-user-text:#495862;--kc-input-bg:#F4F5F7;--kc-header-bg:#495862;--kc-header-text:#FFF;--kc-text:#495862;--kc-text-sub:#8A9AA4;--kc-border:#E2E6EA;--kc-contact-bg:#FFF}
.dark-mode{--kc-bg:#1a2228;--kc-msg-bot:#2a363e;--kc-msg-user:#FFCC00;--kc-msg-user-text:#1a2228;--kc-input-bg:#2a363e;--kc-header-bg:#141b20;--kc-header-text:#F4F5F7;--kc-text:#E2E6EA;--kc-text-sub:#6a7a84;--kc-border:#2a363e;--kc-contact-bg:#1e2a31}
*{margin:0;padding:0;box-sizing:border-box}
html{font-size:16px!important}
body{margin:0;padding:0;background:transparent!important;font-family:var(--k-font)!important;font-size:16px!important;}

/* === MOBILNY FULL-FRAME LOCK === */
html.kc-locked, body.kc-locked { overflow: hidden !important; height: 100% !important; position: fixed !important; width: 100% !important; touch-action: none !important; -webkit-overflow-scrolling: auto !important; }

/* Tooltip */
#kc-tooltip{position:fixed;bottom:94px;right:16px;background:#fff;color:#000;font-family:var(--k-font)!important;font-size:16px!important;font-weight:600!important;padding:11px 34px 11px 16px;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,.15);z-index:100000;white-space:nowrap;line-height:1.4!important;cursor:pointer;opacity:0;animation:tooltipShow .4s ease .6s forwards;letter-spacing:.2px}
#kc-tooltip::after{content:'';position:absolute;bottom:-8px;right:32px;border-left:8px solid transparent;border-right:8px solid transparent;border-top:8px solid #fff}
#kc-tooltip .tt-x{position:absolute;top:4px;right:6px;width:18px;height:18px;border:none;background:transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:14px;color:var(--k-gray);line-height:1}
#kc-tooltip .tt-x:hover{background:var(--k-light);color:var(--k-dark)}
@keyframes tooltipShow{to{opacity:1}}
#kc-tooltip.hidden{display:none}

/* Bubble */
#koverta-bubble{position:fixed;bottom:16px;right:16px;width:70px;height:70px;background:#fff;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;box-shadow:0 4px 20px rgba(0,0,0,.15),0 0 0 0 rgba(255,204,0,.3);transition:transform .3s cubic-bezier(.34,1.56,.64,1),box-shadow .3s;z-index:100000;overflow:hidden;animation:bubblePulse 3s ease-in-out infinite}
@keyframes bubblePulse{0%,100%{box-shadow:0 4px 20px rgba(0,0,0,.15),0 0 0 0 rgba(255,204,0,.3)}50%{box-shadow:0 4px 20px rgba(0,0,0,.15),0 0 0 12px rgba(255,204,0,0)}}
#koverta-bubble:hover{transform:scale(1.08);animation:none}
#koverta-bubble.open{animation:none; opacity: 0; pointer-events:none;}
#koverta-bubble img{width:66px;height:66px;object-fit:contain;border-radius:50%}
#koverta-bubble.open img{display:none}
#koverta-bubble .bubble-x{display:none;width:28px;height:28px;align-items:center;justify-content:center}
#koverta-bubble.open .bubble-x{display:flex}
.bubble-x svg{width:28px;height:28px;fill:var(--k-dark)}
@keyframes robotWobble{0%,100%{transform:rotate(0)}25%{transform:rotate(5deg)}75%{transform:rotate(-5deg)}}
.wobble{animation:robotWobble 2s ease-in-out infinite}

/* Chat okno */
#koverta-chat{position:fixed;bottom:90px;right:16px;width:380px;max-height:560px;height:75vh;background:var(--kc-bg);border-radius:var(--k-radius);box-shadow:0 16px 64px rgba(0,0,0,.25);display:flex;flex-direction:column;overflow:hidden;z-index:99999;transform:scale(.8) translateY(20px);opacity:0;pointer-events:none;transition:transform .4s cubic-bezier(.34,1.56,.64,1),opacity .3s;transform-origin:bottom right}
#koverta-chat.visible{transform:scale(1) translateY(0);opacity:1;pointer-events:all}

.kc-header{background:var(--kc-header-bg);padding:14px 16px;display:flex;align-items:center;gap:10px;flex-shrink:0}
.kc-hdr-av{width:48px;height:48px;border-radius:14px;overflow:hidden;flex-shrink:0;background:#fff}
.kc-hdr-av img{width:48px;height:48px;object-fit:cover}
.kc-hdr-info{flex:1}
.kc-hdr-title{font-size:15px;font-weight:700;color:var(--kc-header-text)}
.kc-hdr-sub{font-size:11px;color:var(--kc-text-sub);display:flex;align-items:center;gap:5px;margin-top:1px}
.kc-hdr-sub .dot{width:7px;height:7px;background:var(--k-green);border-radius:50%;animation:dotP 2s infinite}
@keyframes dotP{0%,100%{opacity:1}50%{opacity:.4}}
.kc-hdr-actions{display:flex;gap:4px;align-items:center}
.kc-hdr-btn{width:32px;height:32px;border:none;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.08);transition:all .2s}
.kc-hdr-btn:hover{background:rgba(255,255,255,.15)}
.kc-hdr-btn svg{width:15px;height:15px;fill:var(--kc-text-sub)}
.kc-hdr-btn.active svg{fill:var(--k-yellow)}
.kc-lang{display:flex;gap:2px;background:rgba(0,0,0,.2);border-radius:7px;padding:2px}
.kc-lang button{border:none;background:transparent;color:var(--kc-text-sub);font-family:var(--k-font);font-size:11px;font-weight:600;padding:3px 7px;border-radius:5px;cursor:pointer;transition:all .2s}
.kc-lang button.active{background:var(--k-yellow);color:var(--k-dark)}

.kc-msgs{flex:1;overflow-y:auto;padding:14px;display:flex;flex-direction:column;gap:6px;scroll-behavior:smooth;-webkit-overflow-scrolling:touch;overscroll-behavior:contain}
.kc-msgs::-webkit-scrollbar{width:3px}
.kc-msgs::-webkit-scrollbar-thumb{background:var(--kc-border);border-radius:3px}
.kc-row{display:flex;gap:7px;align-items:flex-end;animation:msgIn .35s cubic-bezier(.34,1.4,.64,1)}
.kc-row.user{justify-content:flex-end}
@keyframes msgIn{from{opacity:0;transform:translateY(10px) scale(.93)}to{opacity:1;transform:translateY(0) scale(1)}}
.kc-av{width:32px;height:32px;flex-shrink:0;border-radius:10px;overflow:hidden;background:#fff}
.kc-av img{width:32px;height:32px;object-fit:cover}
.kc-row.user .kc-av{display:none}
.kc-mc{max-width:80%}
.kc-m{padding:10px 14px;font-size:13.5px;line-height:1.55;border-radius:16px;word-wrap:break-word;color:var(--kc-text)}
.kc-m.bot{background:var(--kc-msg-bot);border-bottom-left-radius:5px}
.kc-m.user{background:var(--kc-msg-user);color:var(--kc-msg-user-text);border-bottom-right-radius:5px;font-weight:500}
.kc-m a{color:#1976D2;text-decoration:underline;font-weight:600}
.dark-mode .kc-m a{color:var(--k-yellow)}
.kc-ts{font-size:10px;color:var(--kc-text-sub);margin-top:2px;padding:0 2px}
.kc-row.user .kc-ts{text-align:right}
.kc-rt{display:flex;gap:4px;margin-top:4px}
.kc-rb{width:26px;height:26px;border:1px solid var(--kc-border);background:transparent;border-radius:7px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:12px;opacity:.45;transition:all .2s}
.kc-rb:hover,.kc-rb.on{opacity:1;border-color:var(--k-yellow);background:var(--k-yellow-glow)}

.kc-typing{display:none;gap:7px;align-items:flex-end;padding:0 14px 6px}
.kc-typing.show{display:flex}
.kc-tbub{display:flex;gap:4px;align-items:center;padding:12px 18px;background:var(--kc-msg-bot);border-radius:16px;border-bottom-left-radius:5px}
.kc-tbub span{width:6px;height:6px;background:var(--kc-text-sub);border-radius:50%;animation:tb 1.4s infinite}
.kc-tbub span:nth-child(2){animation-delay:.15s}
.kc-tbub span:nth-child(3){animation-delay:.3s}
@keyframes tb{0%,60%,100%{transform:translateY(0);opacity:.35}30%{transform:translateY(-5px);opacity:1}}

.kc-chips{display:flex;flex-wrap:wrap;gap:6px;padding:4px 14px 8px;flex-shrink:0}
.kc-chip{border:1px solid var(--kc-border);background:radial-gradient(circle at center,var(--k-yellow) 0%,var(--k-yellow) 70%,transparent 71%) no-repeat center;background-size:0% 0%;background-color:var(--kc-bg);color:var(--kc-text);font-family:var(--k-font);font-size:12.5px;font-weight:500;padding:6px 13px;border-radius:20px;cursor:pointer;transition:background-size 1s cubic-bezier(.4,0,.2,1), border-color .3s, color .3s, transform .3s;position:relative;z-index:1;}
.kc-chip:hover,.kc-chip:active{background-size:300% 300%;border-color:var(--k-yellow);color:#000;transform:translateY(-1px);animation:chipOrbit 4s linear infinite}
@keyframes chipOrbit{0%{box-shadow:4px 0 8px rgba(73,88,98,.35),0 0 3px rgba(255,204,0,.2)}25%{box-shadow:0 4px 8px rgba(73,88,98,.35),0 0 3px rgba(255,204,0,.2)}50%{box-shadow:-4px 0 8px rgba(73,88,98,.35),0 0 3px rgba(255,204,0,.2)}75%{box-shadow:0 -4px 8px rgba(73,88,98,.35),0 0 3px rgba(255,204,0,.2)}100%{box-shadow:4px 0 8px rgba(73,88,98,.35),0 0 3px rgba(255,204,0,.2)}}
.kc-chip.kc-chip-calc { background: var(--k-yellow)!important; background-color:var(--k-yellow)!important; color:var(--k-dark); font-weight:700; border-color:var(--k-yellow); box-shadow:0 2px 8px rgba(255,204,0,.4); animation:calcPulse 2.5s ease-in-out infinite; }
.kc-chip.kc-chip-calc:hover { transform: translateY(-2px); box-shadow:0 4px 14px rgba(255,204,0,.55); animation:none; }
@keyframes calcPulse { 0%, 100% { box-shadow:0 2px 8px rgba(255,204,0,.4); } 50% { box-shadow:0 2px 16px rgba(255,204,0,.7); } }

.kc-ibar{display:flex;align-items:center;gap:7px;padding:10px 14px;border-top:1px solid var(--kc-border);flex-shrink:0}
.kc-inp{flex:1;border:1.5px solid var(--kc-border);border-radius:12px;padding:10px 13px;font-family:var(--k-font);font-size:13.5px;color:var(--kc-text);outline:none;background:var(--kc-input-bg);transition:border-color .2s,background .2s}
.kc-inp:focus{border-color:var(--k-yellow);background:var(--kc-bg)}
.kc-inp::placeholder{color:var(--kc-text-sub)}
.kc-send{width:40px;height:40px;background:var(--k-yellow);border:none;border-radius:12px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .2s;flex-shrink:0}
.kc-send:hover{background:var(--k-yellow-hover);transform:scale(1.05)}
.kc-send svg{width:18px;height:18px;fill:var(--k-dark)}

.kc-cbar{display:flex;gap:5px;padding:8px 14px;border-top:1px solid var(--kc-border);flex-shrink:0;background:var(--kc-contact-bg);border-radius:0 0 var(--k-radius) var(--k-radius)}
.kc-ct{flex:1;display:flex;align-items:center;justify-content:center;gap:6px;padding:9px 6px;font-family:var(--k-font);font-size:11.5px;font-weight:600;color:var(--kc-text);cursor:pointer;border:1.5px solid var(--kc-border);background:var(--kc-bg);border-radius:11px;transition:all .25s;text-decoration:none}
.kc-ct:hover{transform:translateY(-1px);box-shadow:0 3px 12px rgba(0,0,0,.1)}
.kc-ci{width:22px;height:22px;border-radius:6px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.kc-ci svg{width:14px;height:14px}
.kc-ct.wa .kc-ci{background:#25D366}.kc-ct.wa .kc-ci svg{fill:#fff}.kc-ct.wa:hover{border-color:#25D366}
.kc-ct.ph .kc-ci{background:#2196F3}.kc-ct.ph .kc-ci svg{fill:#fff}.kc-ct.ph:hover{border-color:#2196F3}
.kc-ct.em .kc-ci{background:var(--k-dark)}.kc-ct.em .kc-ci svg{fill:var(--k-yellow)}.kc-ct.em:hover{border-color:var(--k-dark)}

.kc-eo{display:none;position:absolute;inset:0;background:rgba(0,0,0,.4);backdrop-filter:blur(4px);z-index:10}
.kc-eo.show{display:block}
.kc-ep{display:none;flex-direction:column;position:absolute;bottom:0;left:0;right:0;background:var(--kc-bg);border-radius:20px 20px 0 0;z-index:11;animation:sp .35s cubic-bezier(.34,1.2,.64,1);box-shadow:0 -8px 40px rgba(0,0,0,.2)}
.kc-ep.show{display:flex}
@keyframes sp{from{transform:translateY(100%)}to{transform:translateY(0)}}
.kc-eph{display:flex;align-items:center;justify-content:space-between;padding:14px 18px 10px;border-bottom:1px solid var(--kc-border)}

.kc-ept{font-size:15px;font-weight:700;color:var(--kc-text);display:flex;align-items:center;gap:7px}
.kc-ept .ei{width:26px;height:26px;background:var(--k-yellow);border-radius:7px;display:flex;align-items:center;justify-content:center}
.kc-ept .ei svg{width:14px;height:14px;fill:var(--k-dark)}
.kc-ecl{width:30px;height:30px;border:none;background:var(--kc-input-bg);border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center}
.kc-ecl svg{width:14px;height:14px;fill:var(--kc-text-sub)}

.kc-eb{padding:14px 18px 18px;display:flex;flex-direction:column;gap:8px}
.kc-eb .fg{display:flex;flex-direction:column;gap:3px}
.kc-eb label{font-size:11px;font-weight:600;color:var(--kc-text-sub);text-transform:uppercase;letter-spacing:.5px}
.kc-eb input,.kc-eb textarea{font-family:var(--k-font);font-size:13.5px;line-height:1.55;padding:10px 13px;border:1.5px solid var(--kc-border);border-radius:10px;outline:none;color:var(--kc-text);background:var(--kc-input-bg)}
.kc-eb input:focus,.kc-eb textarea:focus{border-color:var(--k-yellow);background:var(--kc-bg)}
.kc-eb textarea{resize:none;height:64px}
.kc-eb .fr{display:flex;gap:8px}
.kc-eb .fr .fg{flex:1}
.kc-esb{background:var(--k-yellow);color:var(--k-dark);font-family:var(--k-font);font-weight:700;font-size:13.5px;border:none;padding:11px;border-radius:11px;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:7px;margin-top:2px}
.kc-esb:hover{background:var(--k-yellow-hover)}
.kc-esb svg{width:16px;height:16px;fill:var(--k-dark)}
.kc-esb.ok{background:var(--k-green);color:#fff}
.kc-esb.ok svg{fill:#fff}

/* Kalkulacka */
.kc-calc-container{display:none;padding:14px;background:var(--kc-bg);border-top:1px solid var(--kc-border);flex:1;overflow-y:auto;min-height:0;-webkit-overflow-scrolling:touch;overscroll-behavior:contain}
.kc-calc-container::-webkit-scrollbar{width:4px}
.kc-calc-container::-webkit-scrollbar-thumb{background:var(--kc-border);border-radius:4px}
.kc-calc-container[data-open="true"]{display:block; animation:calcOpen .4s cubic-bezier(0.16,1,0.3,1);}
@keyframes calcOpen { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
.kc-calc-container[data-open="true"] ~ .kc-msgs, #koverta-chat:has(.kc-calc-container[data-open="true"]) .kc-msgs {display:none}
.kc-calc-head{display:flex;justify-content:space-between;margin-bottom:10px}
.kc-calc-title{font-size:14px;font-weight:700;margin:0;color:var(--kc-text)}
.kc-calc-close{cursor:pointer;background:none;border:none;font-size:18px;color:var(--kc-text-sub)}
.kc-calc-progress{height:6px;border-radius:999px;background:var(--kc-border);margin-bottom:12px;overflow:hidden}
.kc-calc-progress-bar{height:100%;background:var(--k-yellow);border-radius:999px;width:25%;transition:width 500ms ease}

.kc-calc-step{display:none; opacity: 0;}
.kc-calc-step[data-active="true"]{display:block; animation: fadeSlideIn 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;}
@keyframes fadeSlideIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

.kc-calc-label{font-size:13px;font-weight:600;margin-bottom:8px;color:var(--kc-text)}
.kc-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:12px}

/* === KARTA PRODUKTU - VYLEPSENA S VELKOU ILUSTRACIOU === */
.kc-card{border:1.5px solid var(--kc-border);border-radius:14px;padding:14px 8px 12px;text-align:center;cursor:pointer;transition:all 220ms cubic-bezier(.34,1.4,.64,1);background:var(--kc-input-bg);color:var(--kc-text);display:flex;flex-direction:column;align-items:center;gap:8px;position:relative;overflow:hidden}
.kc-card::before{content:'';position:absolute;inset:0;background:radial-gradient(circle at 50% 0%, rgba(255,204,0,.12) 0%, transparent 70%);opacity:0;transition:opacity .25s;pointer-events:none}
.kc-card:hover{border-color:var(--k-yellow);background:var(--kc-bg);transform:translateY(-3px);box-shadow:0 8px 18px rgba(73,88,98,.12)}
.kc-card:hover::before{opacity:1}
.kc-card.selected{border-color:var(--k-dark);background:var(--k-yellow-glow);box-shadow:0 0 0 1.5px var(--k-dark), 0 6px 14px rgba(255,204,0,.25); transform:translateY(-2px)}
.kc-card.selected::before{opacity:1}
.kc-card-illu{width:64px;height:64px;display:flex;align-items:center;justify-content:center;position:relative;z-index:1;margin-bottom:2px;transition:transform .3s cubic-bezier(.34,1.56,.64,1)}
.kc-card:hover .kc-card-illu{transform:scale(1.08) rotate(-2deg)}
.kc-card.selected .kc-card-illu{transform:scale(1.05)}
.kc-card-illu svg{width:64px;height:64px;display:block}
.kc-card-title{font-size:12.5px;font-weight:600;line-height:1.25;color:var(--kc-text);position:relative;z-index:1;padding:0 2px}

.kc-card-cars .kc-card-illu{width:78px;height:54px}
.kc-card-cars .kc-card-illu svg{width:78px;height:54px}

.kc-calc-actions{display:flex;gap:8px;margin-top:10px}
.kc-calc-btn{width:100%;padding:11px;border:none;border-radius:10px;color:var(--k-dark);background:var(--k-yellow);font:inherit;font-weight:600;cursor:pointer;transition:filter 150ms ease,transform 150ms ease}
.kc-calc-btn:hover{filter:brightness(1.1)}
.kc-calc-btn:active{transform:scale(0.98)}
.kc-calc-btn:disabled{opacity:0.5;cursor:not-allowed}
.kc-calc-back{flex:0 0 auto;padding:11px 16px;background:var(--kc-input-bg);border:1px solid var(--kc-border);border-radius:10px;font:inherit;font-size:13.5px;font-weight:600;cursor:pointer;color:var(--kc-text);transition:all 200ms ease;}
.kc-calc-back:hover{border-color:var(--k-dark); background:var(--kc-bg);}
.kc-calc-field{width:100%;padding:9px 12px;margin-bottom:8px;background:var(--kc-input-bg);border:1px solid var(--kc-border);border-radius:10px;font:inherit;font-size:13.5px;color:var(--kc-text);box-sizing:border-box; transition:border-color 0.2s;}
.kc-calc-field:focus{border-color:var(--k-yellow);outline:none}

.kc-dim-row{display:flex;gap:12px;margin-bottom:6px}
.kc-dim-col{flex:1}
.kc-dim-col label{font-size:11px;font-weight:700;color:var(--kc-text-sub);text-transform:uppercase;letter-spacing:.5px;display:block;margin-bottom:4px}
.kc-slider { -webkit-appearance: none; width: 100%; height: 6px; border-radius: 3px; background: var(--kc-border); outline: none; margin: 8px 0 4px; }
.kc-slider::-webkit-slider-thumb { -webkit-appearance: none; appearance: none; width: 22px; height: 22px; border-radius: 50%; background: var(--k-yellow); cursor: pointer; border: 2px solid #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.2); transition: transform 0.1s; }
.kc-slider::-webkit-slider-thumb:active { transform: scale(1.15); }
.kc-slider::-moz-range-thumb { width: 22px; height: 22px; border-radius: 50%; background: var(--k-yellow); cursor: pointer; border: 2px solid #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
.kc-slider-ticks { display: flex; justify-content: space-between; font-size: 9px; font-weight:600; color: var(--kc-text-sub); margin-bottom: 8px; user-select: none; padding: 0 4px; }

.kc-flag-img{width:54px;height:36px;border-radius:4px;box-shadow:0 1px 3px rgba(0,0,0,.2);margin-bottom:4px;display:block;overflow:hidden;}
.kc-brand-card{border:1.5px solid var(--kc-border);border-radius:12px;padding:14px 10px 10px;cursor:pointer;transition:all .2s;background:var(--kc-input-bg);display:flex;flex-direction:column;align-items:center;gap:7px;position:relative;overflow:hidden}
.kc-brand-card::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;background:var(--k-yellow);transform:scaleX(0);transition:transform .25s}
.kc-brand-card:hover{border-color:var(--k-yellow);transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,0,0,.1)}
.kc-brand-card:hover::after{transform:scaleX(1)}
.kc-brand-card.selected{border-color:var(--k-dark);background:var(--k-yellow-glow);box-shadow:0 0 0 1px var(--k-dark);transform:translateY(-2px)}
.kc-brand-card.selected::after{transform:scaleX(1);background:var(--k-dark)}
.kc-brand-name{font-size:13px;font-weight:700;color:var(--kc-text)}
.kc-brand-country{font-size:10px;color:var(--kc-text-sub);font-weight:500}
.kc-brand-badge{font-size:9.5px;font-weight:700;padding:3px 7px;border-radius:20px;letter-spacing:.3px;text-transform:uppercase}
.kc-brand-badge.standard{background:rgba(76,175,80,.12);color:#2e7d32}
.kc-brand-badge.premium{background:rgba(33,150,243,.12);color:#1565c0}

.kc-check{display:flex;align-items:center;gap:10px;padding:10px 12px;margin-bottom:8px;cursor:pointer;font-size:13px;color:var(--kc-text);border:1.5px solid var(--kc-border);border-radius:10px;background:var(--kc-input-bg);transition:all .2s;user-select:none}
.kc-check:hover{border-color:var(--k-yellow)}
.kc-check input[type="checkbox"],.kc-check input[type="radio"]{position:absolute;opacity:0;pointer-events:none}
.kc-check .kc-cbx{width:20px;height:20px;border:2px solid var(--kc-text-sub);border-radius:5px;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .2s;background:var(--kc-bg)}
.kc-check input[type="radio"] ~ .kc-cbx{border-radius:50%}
.kc-check .kc-cbx svg{width:14px;height:14px;fill:none;stroke:var(--k-dark);stroke-width:3;stroke-linecap:round;stroke-linejoin:round;opacity:0;transition:opacity .15s}
.kc-check input:checked ~ .kc-cbx{background:var(--k-yellow);border-color:var(--k-dark)}
.kc-check input:checked ~ .kc-cbx svg{opacity:1}
.kc-check input[type="radio"]:checked ~ .kc-cbx::after{content:'';width:10px;height:10px;border-radius:50%;background:var(--k-dark)}
.kc-check input[type="radio"]:checked ~ .kc-cbx svg{display:none}
.kc-check input:checked ~ .kc-check-label{font-weight:600}
.kc-check.selected{border-color:var(--k-dark);background:var(--k-yellow-glow)}

.kc-calc-result{background:linear-gradient(135deg,var(--kc-input-bg) 0%,var(--k-yellow-glow) 100%);border:1.5px solid var(--k-yellow);border-radius:14px;padding:14px 16px;margin:4px 0 14px;text-align:center;position:relative;overflow:hidden; animation: fadeSlideIn .5s ease forwards;}
.kc-calc-result::before{content:'';position:absolute;top:-20px;right:-20px;width:70px;height:70px;background:var(--k-yellow);opacity:.2;border-radius:50%}
.kc-calc-result-value{font-size:22px;font-weight:700;color:var(--k-dark);margin:4px 0}
.kc-calc-result-note{font-size:10px; font-weight:600; color:var(--kc-text-sub); margin-top:6px; line-height:1.4;}
.dark-mode .kc-calc-result-value{color:#fff}

.kc-sep{display:flex;align-items:center;gap:8px;margin:12px 0 10px}
.kc-sep-line{flex:1;height:1px;background:var(--kc-border)}
.kc-sep-text{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--kc-text-sub);white-space:nowrap}

.kc-model-card{border:1.5px solid var(--kc-border);border-radius:12px;padding:12px 13px;cursor:pointer;transition:all .2s;background:var(--kc-input-bg);margin-bottom:8px}
.kc-model-card:hover{border-color:var(--k-yellow);transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.08)}
.kc-model-card.selected{border-color:var(--k-dark);background:var(--k-yellow-glow);box-shadow:0 0 0 1px var(--k-dark); transform:translateY(-2px)}
.kc-model-card-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:6px}
.kc-model-card-title{font-size:13.5px;font-weight:700;color:var(--kc-text)}
.kc-model-card-tag{font-size:9.5px;font-weight:700;padding:2px 8px;border-radius:20px;text-transform:uppercase;letter-spacing:.3px}
.kc-model-card-desc{font-size:11px;color:var(--kc-text-sub);line-height:1.55}

.kc-summary-card { background: var(--kc-bg); border: 1.5px solid var(--kc-border); border-radius: 12px; padding: 14px; margin-bottom: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
.kc-summary-title { font-size: 12px; font-weight: 700; text-transform: uppercase; color: var(--k-dark); margin-bottom: 8px; border-bottom: 1px dashed var(--kc-border); padding-bottom: 6px; }
.dark-mode .kc-summary-title { color: #fff; }
.kc-summary-item { font-size: 13px; color: var(--kc-text); display: flex; justify-content: space-between; margin-bottom: 4px; }
.kc-summary-item span:first-child { color: var(--kc-text-sub); font-weight: 500; }
.kc-summary-item span:last-child { font-weight: 600; text-align: right; max-width: 65%; word-wrap: break-word;}

.kc-opt-msg-toggle { display: flex; align-items:center; gap:8px; padding: 9px 12px; border:1.5px solid var(--kc-border); border-radius:10px; cursor:pointer; font-size:12.5px; color:var(--kc-text); background: var(--kc-input-bg); transition:all .2s; user-select:none; margin-bottom:0; }
.kc-opt-msg-toggle:hover { border-color:var(--k-yellow); background: var(--kc-bg); }
.kc-opt-msg-toggle.active { border-color:var(--k-dark); background: var(--k-yellow-glow); }
.kc-opt-chk { width:18px; height:18px; border:2px solid var(--kc-text-sub); border-radius: 4px; display: flex; align-items:center; justify-content:center; flex-shrink:0; transition:all .2s; background: var(--kc-bg); }
.kc-opt-chk.on { background: var(--k-yellow); border-color: var(--k-dark); }
.kc-opt-chk.on svg { opacity:1!important; }
.kc-opt-chk svg { width: 11px; height: 11px; opacity:0; transition:opacity .15s; fill:none; stroke: var(--k-dark); stroke-width:3; stroke-linecap: round; stroke-linejoin:round; }
.kc-opt-msg-area { overflow:hidden; max-height:0; transition: max-height .3s ease, margin .3s ease; margin-top:0; }
.kc-opt-msg-area.open { max-height:200px; margin-top:7px; }
.kc-opt-msg-area textarea { width:100%; padding: 9px 12px; background: var(--kc-input-bg); border: 1.5px solid var(--kc-border); border-radius:10px; font: inherit; font-size:13px; color:var(--kc-text); resize: none; height:64px; box-sizing: border-box; outline:none; transition: border-color .2s; }
.kc-opt-msg-area textarea:focus { border-color: var(--k-yellow); background: var(--kc-bg); }

.kc-alert { background: rgba(33, 150, 243, 0.1); border-left: 3px solid #2196F3; padding: 10px 12px; font-size: 11.5px; color: var(--k-dark); border-radius: 4px; margin-bottom: 12px; line-height: 1.5; }
.dark-mode .kc-alert { color: #E2E6EA; }

@media(max-width:500px){
#koverta-chat{width:100vw;height:100dvh;max-height:100dvh;bottom:0;right:0;left:0;top:0;border-radius:0}
#koverta-chat.visible ~ #koverta-bubble, #koverta-bubble.open{display:none!important}
#koverta-bubble{bottom:10px;right:10px;width:58px;height:58px}
#koverta-bubble img{width:54px;height:54px;object-fit:contain;border-radius:50%}
#kc-tooltip{display:none!important}
}
@media (max-width: 768px) {
    #kc-tooltip { display: none !important; }
}
</style>
</head>
<body>

<!-- ========== SVG ILUSTRACIE - definicie pre opatovne pouzitie ========== -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <defs>
    <!-- Pristresok pre auto: 3D pohlad s autom pod zltou strechou -->
    <symbol id="ill-carport" viewBox="0 0 80 80">
      <ellipse cx="40" cy="68" rx="22" ry="2.5" fill="#000" opacity=".08"/>
      <rect x="14" y="22" width="3.5" height="42" rx="1" fill="#495862"/>
      <rect x="62.5" y="22" width="3.5" height="42" rx="1" fill="#495862"/>
      <rect x="11" y="62" width="9.5" height="3" rx="0.5" fill="#3a4750"/>
      <rect x="59.5" y="62" width="9.5" height="3" rx="0.5" fill="#3a4750"/>
      <rect x="8" y="18" width="64" height="6" rx="1.5" fill="#FFCC00"/>
      <rect x="8" y="18" width="64" height="2" rx="1" fill="#FFD633"/>
      <path d="M 8 24 L 12 28 L 76 28 L 72 24 Z" fill="#E6B800"/>
      <rect x="22" y="50" width="36" height="11" rx="2" fill="#495862"/>
      <path d="M 28 50 L 32 41 L 48 41 L 52 50 Z" fill="#5d6d78"/>
      <path d="M 30 49 L 33 43 L 40 43 L 40 49 Z" fill="#a8d8f0" opacity=".7"/>
      <path d="M 41 49 L 41 43 L 47 43 L 50 49 Z" fill="#a8d8f0" opacity=".7"/>
      <circle cx="30" cy="62" r="4" fill="#222"/>
      <circle cx="30" cy="62" r="1.8" fill="#888"/>
      <circle cx="50" cy="62" r="4" fill="#222"/>
      <circle cx="50" cy="62" r="1.8" fill="#888"/>
      <circle cx="57" cy="55" r="1.2" fill="#FFCC00"/>
    </symbol>

    <!-- Bioklimaticka pergola: lamely so slnkom -->
    <symbol id="ill-pergola" viewBox="0 0 80 80">
      <circle cx="62" cy="18" r="6" fill="#FFCC00"/>
      <g stroke="#FFCC00" stroke-width="1.5" stroke-linecap="round">
        <line x1="62" y1="6" x2="62" y2="9"/>
        <line x1="62" y1="27" x2="62" y2="30"/>
        <line x1="50" y1="18" x2="53" y2="18"/>
        <line x1="71" y1="18" x2="74" y2="18"/>
        <line x1="54" y1="10" x2="56" y2="12"/>
        <line x1="68" y1="24" x2="70" y2="26"/>
        <line x1="70" y1="10" x2="68" y2="12"/>
        <line x1="56" y1="24" x2="54" y2="26"/>
      </g>
      <rect x="10" y="32" width="4" height="36" rx="1" fill="#495862"/>
      <rect x="66" y="32" width="4" height="36" rx="1" fill="#495862"/>
      <rect x="7" y="65" width="10" height="3" rx="0.5" fill="#3a4750"/>
      <rect x="63" y="65" width="10" height="3" rx="0.5" fill="#3a4750"/>
      <rect x="8" y="28" width="64" height="5" rx="1" fill="#3a4750"/>
      <g fill="#5d6d78">
        <rect x="14" y="36" width="52" height="3" rx="1.5"/>
        <rect x="14" y="42" width="52" height="3" rx="1.5"/>
        <rect x="14" y="48" width="52" height="3" rx="1.5"/>
        <rect x="14" y="54" width="52" height="3" rx="1.5"/>
      </g>
      <g fill="#7a8892">
        <rect x="14" y="36" width="52" height="0.8" rx="0.4"/>
        <rect x="14" y="42" width="52" height="0.8" rx="0.4"/>
        <rect x="14" y="48" width="52" height="0.8" rx="0.4"/>
        <rect x="14" y="54" width="52" height="0.8" rx="0.4"/>
      </g>
      <rect x="6" y="68" width="68" height="2" rx="0.5" fill="#c9b88a"/>
    </symbol>

    <!-- Zahradny pristresok: dom so siklou strechou + bicykel + kvetinac -->
    <symbol id="ill-zahradny" viewBox="0 0 80 80">
      <ellipse cx="40" cy="70" rx="32" ry="2" fill="#7cb342" opacity=".5"/>
      <rect x="14" y="40" width="3.5" height="28" rx="0.5" fill="#495862"/>
      <rect x="62.5" y="40" width="3.5" height="28" rx="0.5" fill="#495862"/>
      <rect x="11" y="66" width="9.5" height="3" rx="0.5" fill="#3a4750"/>
      <rect x="59.5" y="66" width="9.5" height="3" rx="0.5" fill="#3a4750"/>
      <path d="M 8 42 L 40 18 L 72 42 L 68 42 L 40 22 L 12 42 Z" fill="#FFCC00"/>
      <path d="M 12 42 L 40 22 L 68 42 Z" fill="#FFD633"/>
      <rect x="38" y="18" width="4" height="3" rx="0.5" fill="#E6B800"/>
      <circle cx="28" cy="60" r="4.5" fill="none" stroke="#495862" stroke-width="1.5"/>
      <circle cx="42" cy="60" r="4.5" fill="none" stroke="#495862" stroke-width="1.5"/>
      <path d="M 28 60 L 35 50 L 42 60 M 35 50 L 36 56 L 42 60" stroke="#495862" stroke-width="1.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
      <line x1="34" y1="50" x2="37" y2="50" stroke="#495862" stroke-width="1.5" stroke-linecap="round"/>
      <path d="M 52 56 L 54 64 L 60 64 L 62 56 Z" fill="#c9785a"/>
      <circle cx="57" cy="54" r="3" fill="#7cb342"/>
      <circle cx="55" cy="52" r="2" fill="#9ccc65"/>
      <circle cx="59" cy="53" r="2" fill="#9ccc65"/>
    </symbol>

    <!-- Ine: velka hviezda s iskrami -->
    <symbol id="ill-ine" viewBox="0 0 80 80">
      <path d="M 40 14 L 45.5 32 L 64 32 L 49 43 L 54.5 61 L 40 50 L 25.5 61 L 31 43 L 16 32 L 34.5 32 Z" fill="#FFCC00" stroke="#E6B800" stroke-width="1.2" stroke-linejoin="round"/>
      <path d="M 18 18 L 19.5 21.5 L 23 23 L 19.5 24.5 L 18 28 L 16.5 24.5 L 13 23 L 16.5 21.5 Z" fill="#495862"/>
      <path d="M 64 60 L 65.5 63.5 L 69 65 L 65.5 66.5 L 64 70 L 62.5 66.5 L 59 65 L 62.5 63.5 Z" fill="#495862"/>
      <path d="M 60 12 L 61 14 L 63 15 L 61 16 L 60 18 L 59 16 L 57 15 L 59 14 Z" fill="#FFCC00"/>
      <path d="M 40 22 L 43 32 L 53 32 L 45 38 L 48 47 L 40 41 L 32 47 L 35 38 L 27 32 L 37 32 Z" fill="#FFD633" opacity=".5"/>
    </symbol>

    <!-- 1 AUTO -->
    <symbol id="ill-car-1" viewBox="0 0 90 60">
      <ellipse cx="45" cy="52" rx="32" ry="2.5" fill="#000" opacity=".1"/>
      <path d="M 12 38 L 18 30 L 30 24 L 60 24 L 72 30 L 78 38 L 78 46 L 12 46 Z" fill="#495862"/>
      <path d="M 24 30 L 32 18 L 58 18 L 66 30 Z" fill="#5d6d78"/>
      <path d="M 27 29 L 33 20 L 44 20 L 44 29 Z" fill="#a8d8f0" opacity=".75"/>
      <path d="M 46 29 L 46 20 L 57 20 L 63 29 Z" fill="#a8d8f0" opacity=".75"/>
      <line x1="45" y1="20" x2="45" y2="29" stroke="#5d6d78" stroke-width="0.8"/>
      <line x1="45" y1="32" x2="45" y2="44" stroke="#3a4750" stroke-width="0.8"/>
      <ellipse cx="73" cy="36" rx="2.5" ry="2" fill="#FFCC00"/>
      <ellipse cx="17" cy="36" rx="2" ry="1.8" fill="#E53935"/>
      <circle cx="25" cy="46" r="6" fill="#222"/>
      <circle cx="25" cy="46" r="2.5" fill="#888"/>
      <circle cx="65" cy="46" r="6" fill="#222"/>
      <circle cx="65" cy="46" r="2.5" fill="#888"/>
    </symbol>

    <!-- 2 AUTA vedla seba: zlte + tmave -->
    <symbol id="ill-car-2" viewBox="0 0 100 60">
      <ellipse cx="50" cy="52" rx="42" ry="2.5" fill="#000" opacity=".1"/>
      <g>
        <path d="M 4 38 L 9 32 L 17 27 L 36 27 L 44 32 L 48 38 L 48 46 L 4 46 Z" fill="#FFCC00"/>
        <path d="M 14 32 L 19 23 L 36 23 L 41 32 Z" fill="#E6B800"/>
        <path d="M 16 31 L 20 25 L 25 25 L 25 31 Z" fill="#a8d8f0" opacity=".75"/>
        <path d="M 27 31 L 27 25 L 34 25 L 38 31 Z" fill="#a8d8f0" opacity=".75"/>
        <ellipse cx="45" cy="36" rx="1.8" ry="1.5" fill="#fff"/>
        <ellipse cx="8" cy="36" rx="1.4" ry="1.4" fill="#E53935"/>
        <circle cx="14" cy="46" r="4.5" fill="#222"/>
        <circle cx="14" cy="46" r="1.8" fill="#888"/>
        <circle cx="38" cy="46" r="4.5" fill="#222"/>
        <circle cx="38" cy="46" r="1.8" fill="#888"/>
      </g>
      <g>
        <path d="M 52 38 L 57 32 L 65 27 L 84 27 L 92 32 L 96 38 L 96 46 L 52 46 Z" fill="#495862"/>
        <path d="M 62 32 L 67 23 L 84 23 L 89 32 Z" fill="#5d6d78"/>
        <path d="M 64 31 L 68 25 L 73 25 L 73 31 Z" fill="#a8d8f0" opacity=".75"/>
        <path d="M 75 31 L 75 25 L 82 25 L 86 31 Z" fill="#a8d8f0" opacity=".75"/>
        <ellipse cx="93" cy="36" rx="1.8" ry="1.5" fill="#FFCC00"/>
        <ellipse cx="56" cy="36" rx="1.4" ry="1.4" fill="#E53935"/>
        <circle cx="62" cy="46" r="4.5" fill="#222"/>
        <circle cx="62" cy="46" r="1.8" fill="#888"/>
        <circle cx="86" cy="46" r="4.5" fill="#222"/>
        <circle cx="86" cy="46" r="1.8" fill="#888"/>
      </g>
    </symbol>

    <!-- VIAC AUT (3+ s bodkami) -->
    <symbol id="ill-car-multi" viewBox="0 0 130 60">
      <ellipse cx="65" cy="52" rx="58" ry="2.5" fill="#000" opacity=".1"/>
      <g>
        <path d="M 2 40 L 6 35 L 13 31 L 28 31 L 34 35 L 37 40 L 37 46 L 2 46 Z" fill="#FFCC00"/>
        <path d="M 11 35 L 15 28 L 28 28 L 32 35 Z" fill="#E6B800"/>
        <path d="M 13 34 L 15 30 L 19 30 L 19 34 Z" fill="#a8d8f0" opacity=".75"/>
        <path d="M 21 34 L 21 30 L 27 30 L 30 34 Z" fill="#a8d8f0" opacity=".75"/>
        <circle cx="11" cy="46" r="3.6" fill="#222"/><circle cx="11" cy="46" r="1.4" fill="#888"/>
        <circle cx="29" cy="46" r="3.6" fill="#222"/><circle cx="29" cy="46" r="1.4" fill="#888"/>
      </g>
      <g>
        <path d="M 41 40 L 45 35 L 52 31 L 67 31 L 73 35 L 76 40 L 76 46 L 41 46 Z" fill="#495862"/>
        <path d="M 50 35 L 54 28 L 67 28 L 71 35 Z" fill="#5d6d78"/>
        <path d="M 52 34 L 54 30 L 58 30 L 58 34 Z" fill="#a8d8f0" opacity=".75"/>
        <path d="M 60 34 L 60 30 L 66 30 L 69 34 Z" fill="#a8d8f0" opacity=".75"/>
        <circle cx="50" cy="46" r="3.6" fill="#222"/><circle cx="50" cy="46" r="1.4" fill="#888"/>
        <circle cx="68" cy="46" r="3.6" fill="#222"/><circle cx="68" cy="46" r="1.4" fill="#888"/>
      </g>
      <g>
        <path d="M 80 40 L 84 35 L 91 31 L 106 31 L 112 35 L 115 40 L 115 46 L 80 46 Z" fill="#7cb342"/>
        <path d="M 89 35 L 93 28 L 106 28 L 110 35 Z" fill="#689f38"/>
        <path d="M 91 34 L 93 30 L 97 30 L 97 34 Z" fill="#a8d8f0" opacity=".75"/>
        <path d="M 99 34 L 99 30 L 105 30 L 108 34 Z" fill="#a8d8f0" opacity=".75"/>
        <circle cx="89" cy="46" r="3.6" fill="#222"/><circle cx="89" cy="46" r="1.4" fill="#888"/>
        <circle cx="107" cy="46" r="3.6" fill="#222"/><circle cx="107" cy="46" r="1.4" fill="#888"/>
      </g>
      <circle cx="121" cy="42" r="1.6" fill="#495862"/>
      <circle cx="125" cy="42" r="1.6" fill="#495862"/>
      <circle cx="129" cy="42" r="1.6" fill="#495862"/>
    </symbol>
  </defs>
</svg>

<div id="kc-tooltip" onclick="toggleChat()">Potrebujete poradiť? 🤖<button class="tt-x" onclick="event.stopPropagation();document.getElementById('kc-tooltip').classList.add('hidden');">✕</button></div>

<div id="koverta-bubble" onclick="toggleChat()">
  <img class="wobble" id="bubbleImg" alt="Koverta Robot">
  <div class="bubble-x"><svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></div>
</div>

<div id="koverta-chat">
  <div class="kc-header">
    <div class="kc-hdr-av"><img class="wobble" id="headerImg" alt="Koverta"></div>
    <div class="kc-hdr-info"><div class="kc-hdr-title">Koverta Asistent</div><div class="kc-hdr-sub"><span class="dot"></span><span id="st">Online</span></div></div>
    <div class="kc-hdr-actions">
      <button class="kc-hdr-btn" id="dkBtn" onclick="toggleDark()"><svg viewBox="0 0 24 24"><path d="M12 3a9 9 0 109 9c0-.46-.04-.92-.1-1.36a5.389 5.389 0 01-4.4 2.26 5.403 5.403 0 01-3.14-9.8c-.44-.06-.9-.1-1.36-.1z"/></svg></button>
      <button class="kc-hdr-btn" id="rstBtn" onclick="resetChat()" title="Nová konverzácia"><svg viewBox="0 0 24 24"><path d="M17.65 6.35A7.958 7.958 0 0012 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08A5.99 5.99 0 0112 18c-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg></button>
      <button class="kc-hdr-btn" onclick="toggleChat()" title="Zavrieť"><svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></button>
      <div class="kc-lang"><button class="active" onclick="setLang('sk')">SK</button><button onclick="setLang('en')">EN</button></div>
    </div>
  </div>
  
  <div class="kc-msgs" id="msgs"></div>
  <!-- KALKULACKA -->
  <div class="kc-calc-container" id="kcCalc" data-open="false">
      <div class="kc-calc-head">
          <h4 class="kc-calc-title">Cenová kalkulačka</h4>
          <button type="button" class="kc-calc-close" onclick="closeCalc()">×</button>
      </div>
      <div class="kc-calc-progress"><div class="kc-calc-progress-bar" id="calcProg"></div></div>
      
      <!-- KROK 1 -->
      <div class="kc-calc-step" data-active="true" data-step="1">
          <div class="kc-calc-label">O aký produkt máte záujem?</div>
          <div class="kc-grid">
              <div class="kc-card" data-val="carport" onclick="selCard(this, 'product')">
                  <div class="kc-card-illu"><svg><use href="#ill-carport"/></svg></div>
                  <div class="kc-card-title">Prístrešok pre auto</div>
              </div>
              <div class="kc-card" data-val="pergola" onclick="selCard(this, 'product')">
                  <div class="kc-card-illu"><svg><use href="#ill-pergola"/></svg></div>
                  <div class="kc-card-title">Bioklimatická pergola</div>
              </div>
              <div class="kc-card" data-val="zahradny" onclick="selCard(this, 'product')">
                  <div class="kc-card-illu"><svg><use href="#ill-zahradny"/></svg></div>
                  <div class="kc-card-title">Záhradný prístrešok</div>
              </div>
              <div class="kc-card" data-val="ine" onclick="selCard(this, 'product')">
                  <div class="kc-card-illu"><svg><use href="#ill-ine"/></svg></div>
                  <div class="kc-card-title">Iné</div>
              </div>
          </div>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-btn" id="btn-n1" disabled onclick="goStep(2)">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2-carport: Znacka -->
      <div class="kc-calc-step" data-step="2-carport">
          <div class="kc-calc-label">Vyberte výrobcu prístrešku:</div>
          <div class="kc-grid">
              <div class="kc-brand-card" data-val="koverta" onclick="selBrand(this, 'koverta')">
                  <svg class="kc-flag-img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 600">
                      <rect width="900" height="200" fill="#ffffff"/><rect y="200" width="900" height="200" fill="#0b4ea2"/><rect y="400" width="900" height="200" fill="#ee1c25"/>
                      <g transform="translate(300, 300)">
                          <defs><path id="sk-shield" d="M-85,-110 L85,-110 L85,20 C85,100 30,140 0,155 C-30,140 -85,100 -85,20 Z" /></defs>
                          <use href="#sk-shield" fill="#ee1c25" />
                          <clipPath id="sk-clip"><use href="#sk-shield" /></clipPath>
                          <g clip-path="url(#sk-clip)">
                              <path d="M-95,65 C-60,35 -35,35 -23,60 C-15,10 15,10 23,60 C35,35 60,35 95,65 L95,200 L-95,200 Z" fill="#0b4ea2" />
                              <path d="M-12,-85 H12 V-50 H34 V-30 H12 V-5 H44 V15 H12 V45 C12,48 -12,48 -12,45 V15 H-44 V-5 H-12 V-30 H-34 V-50 H-12 Z" fill="#ffffff" />
                          </g>
                          <use href="#sk-shield" fill="none" stroke="#ffffff" stroke-width="12" />
                      </g>
                  </svg>
                  <div class="kc-brand-name">Koverta</div>
                  <div class="kc-brand-country">Slovensko (Cenník)</div>
                  <div class="kc-brand-badge standard">Pre každého</div>
              </div>
              <div class="kc-brand-card" data-val="soltec" onclick="selBrand(this, 'soltec')">
                  <svg class="kc-flag-img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 600">
                      <rect width="1200" height="200" fill="#ffffff"/><rect y="200" width="1200" height="200" fill="#0033a0"/><rect y="400" width="1200" height="200" fill="#e31837"/>
                      <g transform="translate(300, 200) scale(0.85)">
                          <defs>
                              <path id="si-shield" d="M-70,-100 L70,-100 L70,30 C70,90 30,125 0,140 C-30,125 -70,90 -70,30 Z" />
                              <polygon id="si-star" points="0,-14 4,-4 13,-4 6,2 8,11 0,6 -8,11 -6,2 -13,-4 -4,-4" fill="#ffcd00"/>
                              <clipPath id="si-clip"><use href="#si-shield" /></clipPath>
                          </defs>
                          <use href="#si-shield" fill="#0033a0" />
                          <g clip-path="url(#si-clip)">
                              <path d="M-80,60 L-35,0 L-15,20 L0,-40 L15,20 L35,0 L80,60 Z" fill="#ffffff" />
                              <path d="M-80,65 Q-40,40 0,65 T80,65" fill="none" stroke="#0033a0" stroke-width="12" />
                              <path d="M-80,95 Q-40,70 0,95 T80,95" fill="none" stroke="#0033a0" stroke-width="12" />
                          </g>
                          <use href="#si-shield" fill="none" stroke="#e31837" stroke-width="8" />
                          <use href="#si-star" x="0" y="-65" /><use href="#si-star" x="-32" y="-25" /><use href="#si-star" x="32" y="-25" />
                      </g>
                  </svg>
                  <div class="kc-brand-name">Soltec</div>
                  <div class="kc-brand-country">Slovinsko (Na mieru)</div>
                  <div class="kc-brand-badge premium">Pre náročných</div>
              </div>
          </div>
          <div class="kc-alert">
              <strong>Info k cenám:</strong> Koverta prístrešky majú dostupné fixné cenníkové ceny. Soltec sú prémiové riešenia, ktoré nemajú tabuľkový cenník a naceňujeme ich prísne na mieru.
          </div>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep(1)">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-n2-brand" disabled onclick="goStep('2a-cars')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2a-cars -->
      <div class="kc-calc-step" data-step="2a-cars">
          <div class="kc-calc-label">Pre koľko áut?</div>
          <div class="kc-grid">
              <div class="kc-card kc-card-cars" data-val="1auto" onclick="selCard(this, 'cars')">
                  <div class="kc-card-illu"><svg><use href="#ill-car-1"/></svg></div>
                  <div class="kc-card-title">1 auto</div>
              </div>
              <div class="kc-card kc-card-cars" data-val="2auta" onclick="selCard(this, 'cars')">
                  <div class="kc-card-illu"><svg><use href="#ill-car-2"/></svg></div>
                  <div class="kc-card-title">2 autá</div>
              </div>
              <div class="kc-card kc-card-cars" data-val="viac" onclick="selCard(this, 'cars')" style="grid-column:span 2">
                  <div class="kc-card-illu"><svg><use href="#ill-car-multi"/></svg></div>
                  <div class="kc-card-title">Viac áut</div>
              </div>
          </div>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep('2-carport')">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-n2-cars" disabled onclick="goStep('2a-next')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2a-soltec-model -->
      <div class="kc-calc-step" data-step="2a-soltec-model">
          <div class="kc-calc-label">Vyberte model Soltec carportu:</div>
          <div class="kc-model-card" data-val="soltec-f" onclick="selModelCard(this, 'soltec-f')">
              <div class="kc-model-card-head">
                  <div class="kc-model-card-title">Model F Horizontálny profil</div>
                  <span class="kc-model-card-tag" style="background:rgba(76,175,80,.12); color: #2e7d32">Populárny</span>
              </div>
              <div class="kc-model-card-desc">Strecha: ISO panel s integrovaným sklonom 2%<br>Nosnosť: až 140 kg/m²<br>Rovnaká výška stĺpov | Všetky doplnky dostupné</div>
          </div>
          <div class="kc-model-card" data-val="soltec-sl" onclick="selModelCard(this, 'soltec-sl')">
              <div class="kc-model-card-head">
                  <div class="kc-model-card-title">Model SL Viditeľný sklon</div>
                  <span class="kc-model-card-tag" style="background:rgba(33,150,243,.12);color:#1565c0">Pre náročné podmienky</span>
              </div>
              <div class="kc-model-card-desc">Strecha: ISO panel s viditeľným sklonom 1,5%<br>Nosnosť: až 240 kg/m²<br>Odlišná výška stĺpov | Obmedzený výber doplnkov</div>
          </div>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep('2a-cars')">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-soltec-model" disabled onclick="goStep('2a-dims')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2a-dims -->
      <div class="kc-calc-step" data-step="2a-dims">
          <div class="kc-calc-label">Rozmer prístrešku:</div>
          <div style="font-size:11.5px;background: var(--k-yellow-glow); border:1px solid var(--k-yellow); padding: 8px 10px; border-radius:8px;color:var(--k-dark); margin-bottom:12px">Použite posuvník pre tabuľkové rozmery, alebo vpíšte vlastné číslo pre rozmer na mieru.</div>
          
          <div class="kc-dim-col">
              <label>Šírka (m)</label>
              <input type="range" class="kc-slider" id="cpRangeW" oninput="syncSlider('cp', 'w', 'range')">
              <div class="kc-slider-ticks" id="cpTicksW"></div>
              <input type="text" class="kc-calc-field" id="cpTextW" placeholder="Zadajte šírku" oninput="syncSlider('cp', 'w', 'text')">
          </div>
          <div class="kc-dim-col" style="margin-top:8px">
              <label>Dĺžka (m)</label>
              <input type="range" class="kc-slider" id="cpRangeD" oninput="syncSlider('cp', 'd', 'range')">
              <div class="kc-slider-ticks" id="cpTicksD"></div>
              <input type="text" class="kc-calc-field" id="cpTextD" placeholder="Zadajte dĺžku" oninput="syncSlider('cp', 'd', 'text')">
          </div>
          
          <div class="kc-calc-actions" style="margin-top: 14px">
              <button type="button" class="kc-calc-back" onclick="goStep(calcState.brand==='soltec' ? '2a-soltec-model' : '2a-cars')">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-cpNext" disabled onclick="goStep('2a-acc')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2a-acc -->
      <div class="kc-calc-step" data-step="2a-acc">
          <div class="kc-calc-label">Príslušenstvo a doplnky:</div>
          <div style="font-size:11px; color:var(--kc-text-sub); margin-bottom:10px;">Zistite dostupnosť k vášmu prístrešku (nemá vplyv na cenníkovú cenu konštrukcie).</div>
          
          <label class="kc-check" id="accBoxWrapper" style="display:none; border-color: var(--k-yellow); background: var(--k-yellow-glow);"><input type="checkbox" id="accBox"><span class="kc-cbx"><svg viewBox="0 0 24 24"><polyline points="4,12 10,18 20,6"/></svg></span><span class="kc-check-label" style="font-weight:700">Integrovaný odkladací box</span></label>
          
          <label class="kc-check"><input type="checkbox" id="accLamely"><span class="kc-cbx"><svg viewBox="0 0 24 24"><polyline points="4,12 10,18 20,6"/></svg></span><span class="kc-check-label">Bočné lamely / Rolety</span></label>
          <label class="kc-check"><input type="checkbox" id="accZelena"><span class="kc-cbx"><svg viewBox="0 0 24 24"><polyline points="4,12 10,18 20,6"/></svg></span><span class="kc-check-label">Príprava pre zelenú strechu</span></label>
          <label class="kc-check"><input type="checkbox" id="accLed"><span class="kc-cbx"><svg viewBox="0 0 24 24"><polyline points="4,12 10,18 20,6"/></svg></span><span class="kc-check-label">Integrované LED osvetlenie</span></label>
          
          <div class="kc-calc-label" style="font-size:12px;margin:10px 0 6px">Iné požiadavky:</div>
          <textarea class="kc-calc-field" id="calcAccOther" rows="2" placeholder="Napr. nabíjačka pre auto, preferovaná farba..."></textarea>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep('2a-dims')">Späť</button>
              <button type="button" class="kc-calc-btn" onclick="goStep(3)">Zistiť cenu</button>
          </div>
      </div>

      <!-- KROK 2-pergola -->
      <div class="kc-calc-step" data-step="2-pergola">
          <div class="kc-calc-label">Vyberte model pergoly:</div>
          <div class="kc-alert">Soltec Bioklimatické pergoly nemajú tabuľkový cenník, všetky projekty naceňujeme presne na mieru.</div>
          <div class="kc-model-card" data-val="canopy-f" onclick="selModelCardP(this, 'canopy-f')">
              <div class="kc-model-card-head"><div class="kc-model-card-title">Canopy F</div><span class="kc-model-card-tag" style="background:rgba(255,204,0,.2);color:#7a5800">Kompaktná</span></div>
              <div class="kc-model-card-desc">ISO panel | sklon integrovaný v streche | integrovaný odtok | nižšia nosnosť | rovnaká výška stĺpov</div>
          </div>
          <div class="kc-model-card" data-val="canopy-g" onclick="selModelCardP(this, 'canopy-g')">
              <div class="kc-model-card-head"><div class="kc-model-card-title">Canopy G</div><span class="kc-model-card-tag" style="background:rgba(33,150,243,.12); color:#1565c0">Prémiová</span></div>
              <div class="kc-model-card-desc">ISO/sklo/zelená | sklon pri montáži | vyššia nosnosť | náročnejšie podmienky | rovnaká výška stĺpov</div>
          </div>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep(1)">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-pergModel" disabled onclick="goStep('2p-roof')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2p-roof -->
      <div class="kc-calc-step" data-step="2p-roof">
          <div class="kc-calc-label">Typ strechy pre pergolu:</div>
          <label class="kc-check"><input type="radio" name="pergRoof" onchange="selRadio(this, 'pergRoof', 'hlinikova');document.getElementById('btn-pergRoof').disabled=false"><span class="kc-cbx"></span><span class="kc-check-label">Hliníková (otváracia)</span></label>
          <label class="kc-check"><input type="radio" name="pergRoof" onchange="selRadio(this, 'pergRoof', 'fotovoltaika');document.getElementById('btn-pergRoof').disabled=false"><span class="kc-cbx"></span><span class="kc-check-label">Fotovoltaika</span></label>
          <label class="kc-check"><input type="radio" name="pergRoof" onchange="selRadio(this, 'pergRoof', 'zelena');document.getElementById('btn-pergRoof').disabled=false"><span class="kc-cbx"></span><span class="kc-check-label">Zelená strecha</span></label>
          <label class="kc-check"><input type="radio" name="pergRoof" onchange="selRadio(this, 'pergRoof', 'sklenena');document.getElementById('btn-pergRoof').disabled=false"><span class="kc-cbx"></span><span class="kc-check-label">Sklenená</span></label>
          <div class="kc-calc-actions">
              <button type="button" class="kc-calc-back" onclick="goStep('2-pergola')">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-pergRoof" disabled onclick="goStep('2p-size')">Pokračovať</button>
          </div>
      </div>

      <!-- KROK 2p-size -->
      <div class="kc-calc-step" data-step="2p-size">
          <div class="kc-calc-label">Rozmer pergoly:</div>
          <div style="font-size:11px;background: var(--k-yellow-glow); border:1px solid var(--k-yellow); padding: 8px; border-radius:8px;color:var(--k-dark); margin-bottom:12px">Vyberte predbežnú veľkosť na slideri, alebo wpíšte rozmer na mieru.</div>
          
          <div class="kc-dim-col">
              <label>Šírka (m)</label>
              <input type="range" class="kc-slider" id="pgRangeW" oninput="syncSlider('pg', 'w', 'range')">
              <div class="kc-slider-ticks" id="pgTicksW"></div>
              <input type="text" class="kc-calc-field" id="pgTextW" placeholder="Šírka" oninput="syncSlider('pg', 'w', 'text')">
          </div>
          <div class="kc-dim-col" style="margin-top:8px">
              <label>Dĺžka (m)</label>
              <input type="range" class="kc-slider" id="pgRangeD" oninput="syncSlider('pg', 'd', 'range')">
              <div class="kc-slider-ticks" id="pgTicksD"></div>
              <input type="text" class="kc-calc-field" id="pgTextD" placeholder="Dĺžka" oninput="syncSlider('pg', 'd', 'text')">
          </div>
          
          <div class="kc-calc-actions" style="margin-top: 14px">
              <button type="button" class="kc-calc-back" onclick="goStep('2p-roof')">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-pgNext" disabled onclick="goStep(3)">Zistiť cenu</button>
          </div>
      </div>

      <!-- KROK 2-zahradny -->
      <div class="kc-calc-step" data-step="2-zahradny">
          <div class="kc-calc-label">Rozmer záhradného prístrešku:</div>
          <div style="font-size:11px;background: var(--k-yellow-glow); border:1px solid var(--k-yellow); padding: 8px 10px;border-radius:8px;color: var(--k-dark); margin-bottom: 12px">Sériové rozmery sú na posuvníku. Iné zadajte textovo.</div>
          
          <div class="kc-dim-col">
              <label>Šírka (m)</label>
              <input type="range" class="kc-slider" id="zhRangeW" oninput="syncSlider('zh', 'w', 'range')">
              <div class="kc-slider-ticks" id="zhTicksW"></div>
              <input type="text" class="kc-calc-field" id="zhTextW" placeholder="Šírka" oninput="syncSlider('zh', 'w', 'text')">
          </div>
          <div class="kc-dim-col" style="margin-top:8px">
              <label>Dĺžka (m)</label>
              <input type="range" class="kc-slider" id="zhRangeD" oninput="syncSlider('zh', 'd', 'range')">
              <div class="kc-slider-ticks" id="zhTicksD"></div>
              <input type="text" class="kc-calc-field" id="zhTextD" placeholder="Dĺžka" oninput="syncSlider('zh', 'd', 'text')">
          </div>

          <div class="kc-calc-actions" style="margin-top: 14px">
              <button type="button" class="kc-calc-back" onclick="goStep(1)">Späť</button>
              <button type="button" class="kc-calc-btn" id="btn-zhNext" disabled onclick="goStep(3)">Zistiť cenu</button>
          </div>
      </div>

      <!-- KROK 2-ine -->
      <div class="kc-calc-step" data-step="2-ine">
          <div class="kc-calc-label">O čo iné máte záujem?</div>
          <div style="font-size:11.5px;color: var(--kc-text-sub); margin-bottom:10px">Odošlite nám požiadavku, ozveme sa vám.</div>
          <div style="display: flex; flex-direction: column; gap:7px">
              <div class="kc-model-card" onclick="pickIne('Vonkajšia kuchyňa Soltec')"><div class="kc-model-card-head"><div class="kc-model-card-title">👨‍🍳 Vonkajšie kuchyne Soltec</div></div><div class="kc-model-card-desc">Chef Grand / Classic / Station</div></div>
              <div class="kc-model-card" onclick="pickIne('Box na smetné koše')"><div class="kc-model-card-head"><div class="kc-model-card-title">🗑️ Boxy na smetné koše</div></div><div class="kc-model-card-desc">Classic / so zelenou strechou</div></div>
              <div class="kc-model-card" onclick="pickIne('Tienenie a doplnky')"><div class="kc-model-card-head"><div class="kc-model-card-title">🕶️ Tienenie a doplnky</div></div><div class="kc-model-card-desc">ZIP rolety / sklenené panely / lamely / LED</div></div>
              <div class="kc-model-card" onclick="pickIne('Niečo iné')"><div class="kc-model-card-head"><div class="kc-model-card-title">✨ Niečo iné</div></div><div class="kc-model-card-desc">Špecifikujte v poznámke</div></div>
          </div>
          <div class="kc-calc-actions" style="margin-top:12px">
              <button type="button" class="kc-calc-back" onclick="goStep(1)">Späť</button>
          </div>
      </div>

      <!-- KROK 3 -->
      <div class="kc-calc-step" data-step="3">
          <div id="summaryBox"></div>
          
          <div class="kc-calc-result" id="resBox">
              <div style="font-size:10px;font-weight:700;text-transform:uppercase; letter-spacing:.5px;color:var(--kc-text-sub)" id="resLabel">Orientačná cena konštrukcie</div>
              <div class="kc-calc-result-value" id="resPrice">-</div>
              <div class="kc-calc-result-note" id="resNote">Presnú ponuku vám obratom zašleme.</div>
          </div>
          
          <div id="ineOptionsBox" style="display:none">
              <div class="kc-ine-box">
                  <div class="kc-ine-box-label">Záujem o:</div>
                  <input type="text" class="kc-calc-field" id="calcIneSelect" readonly style="margin-bottom:8px; font-weight:600; background:var(--kc-bg);">
                  <textarea class="kc-calc-field" id="calcIneText" rows="2" placeholder="Napíšte nám detaily vašej požiadavky..." style="margin-bottom:0"></textarea>
              </div>
          </div>

          <div class="kc-sep">
              <div class="kc-sep-line"></div>
              <span class="kc-sep-text">Kontaktné údaje</span>
              <div class="kc-sep-line"></div>
          </div>
          <div style="display: flex; gap:7px;margin-bottom:7px">
              <div style="flex:1;"><input class="kc-calc-field" id="calcName" type="text" placeholder="Meno a priezvisko" style="margin-bottom:0"/></div>
              <div style="flex:1;"><input class="kc-calc-field" id="calcPhone" type="tel" placeholder="Telefón" style="margin-bottom:0"/></div>
          </div>
          <div style="margin-bottom:10px">
              <input class="kc-calc-field" id="calcEmail" type="email" placeholder="E-mail adresa" style="margin-bottom:0"/>
          </div>

          <div id="optMsgSection">
              <div class="kc-opt-msg-toggle" id="optMsgToggleBtn" onclick="toggleOptMsg()">
                  <div class="kc-opt-chk" id="optMsgChk"><svg viewBox="0 0 24 24"><polyline points="4,12 10,18 20,6"/></svg></div>
                  <span>Pridať poznámku/správu k ponuke</span>
              </div>
              <div class="kc-opt-msg-area" id="optMsgArea">
                  <textarea id="calcOptMsg" placeholder="Napr. preferovaná farba, termín realizácie, otázky k montáži..."></textarea>
              </div>
          </div>
          
          <div class="kc-calc-actions" style="margin-top:10px">
              <button type="button" class="kc-calc-back" onclick="goStep(1)">Odznova</button>
              <button type="button" class="kc-calc-btn" id="calcSubmit" onclick="submitCalc()">Odoslať dopyt</button>
          </div>
      </div>
  </div>
  <!-- KONIEC KALKULACKY -->

  <div class="kc-typing" id="typ"><div class="kc-av"><img id="typingImg" alt="Koverta"></div><div class="kc-tbub"><span></span><span></span><span></span></div></div>
  <div class="kc-chips" id="chips"></div>
  <div class="kc-ibar">
    <input class="kc-inp" id="inp" placeholder="Napíšte správu..." autocomplete="off" onkeydown="if(event.key==='Enter')send()">
    <button class="kc-send" onclick="send()"><svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg></button>
  </div>
  <div class="kc-cbar">
    <a class="kc-ct wa" href="https://wa.me/421948482266" target="_blank"><span class="kc-ci"><svg viewBox="0 0 24 24"><path d="M17.5 14.4l-2-1c-.3-.1-.5-.1-.7.1l-.9 1.1c-.2.2-.3.2-.6.1-1.5-.7-2.7-1.9-3.4-3.4-.1-.3-.1-.4.1-.6l.6-.7c.2-.2.2-.4.1-.7l-1-2.3c-.2-.6-.5-.5-.7-.5h-.6c-.2 0-.6.1-.9.4-.3.4-1.2 1.2-1.2 2.8s1.2 3.3 1.4 3.5c.2.2 2.4 3.6 5.8 5.1 3.4 1.4 3.4.9 4 .9s2-.8 2.3-1.6c.3-.8.3-1.5.2-1.6-.1-.2-.3-.3-.6-.4zM12 2C6.5 2 2 6.5 2 12c0 1.8.5 3.5 1.4 5L2 22l5.2-1.4C8.6 21.5 10.3 22 12 22c5.5 0 10-4.5 10-10S17.5 2 12 2z"/></svg></span>WhatsApp</a>
    <a class="kc-ct ph" href="tel:+421948482266"><span class="kc-ci"><svg viewBox="0 0 24 24"><path d="M20.01 15.38c-1.23 0-2.42-.2-3.53-.56a.977.977 0 00-1.01.24l-1.57 1.97c-2.83-1.35-5.48-3.9-6.89-6.83l1.95-1.66c.27-.28.35-.67.24-1.02-.37-1.11-.56-2.3-.56-3.53 0-.54-.45-.99-.99-.99H4.19C3.65 3 3 3.24 3 3.99 3 13.28 10.73 21 20.01 21c.71 0 .99-.63.99-1.18v-3.45c0-.54-.45-.99-.99-.99z"/></svg></span><span id="cl">Zavolať</span></a>
    <button class="kc-ct em" onclick="tgEmail()"><span class="kc-ci"><svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-.4 4.25l-7.07 4.42c-.32.2-.74.2-1.06 0L4.4 8.25a.85.85 0 11.9-1.44L12 11l5.7-4.19a.85.85 0 11.9 1.44z"/></svg></span><span id="el">Email</span></button>
  </div>
  <div class="kc-eo" id="eo" onclick="tgEmail()"></div>
  <div class="kc-ep" id="ep">
    <div class="kc-eph"><div class="kc-ept"><span class="ei"><svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-.4 4.25l-7.07 4.42c-.32.2-.74.2-1.06 0L4.4 8.25a.85.85 0 11.9-1.44L12 11l5.7-4.19a.85.85 0 11.9 1.44z"/></svg></span><span id="ept">Napíšte nám</span></div><button class="kc-ecl" onclick="tgEmail()"><svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg></button></div>
    <div class="kc-eb">
      <div class="fr"><div class="fg"><label id="ln">Meno</label><input type="text" id="fn" placeholder="Ján Novák"></div><div class="fg"><label id="lp">Telefón</label><input type="tel" id="fp" placeholder="+421 9XX XXX XXX"></div></div>
      <div class="fg"><label id="le">Email *</label><input type="email" id="fe" placeholder="jan@example.sk"></div>
      <div class="fg"><label id="lm">Správa *</label><textarea id="fm" placeholder="Zaujíma ma cenová ponuka na..."></textarea></div>
      <button class="kc-esb" id="esb" onclick="subEmail()"><svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg><span id="est">Odoslať správu</span></button>
    </div>
  </div>
</div>
<script>
// === BASE64 OBRÁZKA ROBOTA ===
var ROBOT_B64="__ROBOT_B64_PLACEHOLDER__";

document.addEventListener('DOMContentLoaded', function () {
    var bubbleImg = document.getElementById('bubbleImg');
    var headerImg = document.getElementById('headerImg');
    var typingImg = document.getElementById('typingImg');
    if(bubbleImg) bubbleImg.src = ROBOT_B64;
    if(headerImg) headerImg.src = ROBOT_B64;
    if(typingImg) typingImg.src = ROBOT_B64;
});
var MSG_IMG = ROBOT_B64;
// === KONIEC BASE64 ===

var C={apiUrl:"https://koverta-chatbot-backend.vercel.app/api/chat",lang:'sk',dm:false,snd:true,contactShown:false,convoLogged:false,
s:{sk:{ch:['Carporty','Pergoly','Prístrešky','Kalkulácia ceny','Kontakt'],ph:'Napíšte správu...',st:'Online',ca:'Zavolať',em:'Email',se:'Odoslať správu',sd:'Odoslané! ✓',et:'Napíšte nám',ln:'Meno',lp:'Telefón',le:'Email *',lm:'Správa *',np:'Ján Novák',pp:'+421 9XX XXX XXX',ep:'jan@example.sk',mp:'Zaujíma ma cenová ponuku na...',er:'Prepáčte, momentálne nie som dostupný. Skúste nás kontaktovať telefonicky alebo emailom.',fw:['Ďakujem za váš záujem! Prajeme pekný zvyšok dňa. 😊','Bolo mi potešením pomôcť! Do skorého videnia. 👋','Ďakujeme, že ste nás kontaktovali! Pekný deň! ☀️']},
en:{ch:['Carports','Pergolas','Canopies','Price calculator','Contact'],ph:'Type a message...',st:'Online',ca:'Call us',em:'Email',se:'Send message',sd:'Sent! ✓',et:'Write to us',ln:'Name',lp:'Phone',le:'Email *',lm:'Message *',np:'John Smith',pp:'+421 9XX XXX XXX',ep:'john@example.com',mp:"I'm interested in...",er:"Sorry, I'm not available. Please contact us by phone or email.",fw:['Thank you! Have a great day. 😊','It was my pleasure! See you soon. 👋','Thanks for reaching out! 😊']}}
};
var hist=[];
var $c=document.getElementById('koverta-chat'),$b=document.getElementById('koverta-bubble'),$m=document.getElementById('msgs'),$t=document.getElementById('typ'),$ch=document.getElementById('chips'),$i=document.getElementById('inp'),$tt=document.getElementById('kc-tooltip');

(function(){var isMobile=(window.matchMedia&&window.matchMedia('(max-width:500px),(hover:none) and (pointer:coarse)').matches)||/Mobi|Android|iPhone|iPad|iPod|IEMobile|BlackBerry/i.test(navigator.userAgent);if(isMobile&&$tt){$tt.parentNode&&$tt.parentNode.removeChild($tt);$tt=null;}})();

// === MOBILNY FULL-FRAME LOCK ===
function isMob(){return(window.matchMedia&&window.matchMedia('(max-width:500px),(hover:none) and (pointer:coarse)').matches)||/Mobi|Android|iPhone|iPad|iPod|IEMobile|BlackBerry/i.test(navigator.userAgent);}

var __scrollY = 0;
function lockBodyScroll() {
  if (!isMob()) return;
  __scrollY = window.scrollY || window.pageYOffset || 0;
  document.documentElement.classList.add('kc-locked');
  document.body.classList.add('kc-locked');
  document.body.style.top = '-' + __scrollY + 'px';
  try { window.parent.postMessage({type:'koverta-lock', locked:true, y:__scrollY}, '*'); } catch(e) {}
}
function unlockBodyScroll() {
  if (!isMob()) return;
  document.documentElement.classList.remove('kc-locked');
  document.body.classList.remove('kc-locked');
  document.body.style.top = '';
  window.scrollTo(0, __scrollY);
  try { window.parent.postMessage({type:'koverta-lock', locked:false}, '*'); } catch(e) {}
}

(function(){
  function fit(){
    if(!$c||!$c.classList.contains('visible')||!isMob())return;
    var vh=window.visualViewport?window.visualViewport.height:window.innerHeight;
    $c.style.height=vh+'px';
    $c.style.maxHeight=vh+'px';
    $c.style.top='0px';
    $c.style.bottom='auto';
    if($m)$m.scrollTop=$m.scrollHeight;
  }
  function reset(){
    if(!$c)return;
    $c.style.height='';
    $c.style.maxHeight='';
    $c.style.top='';
    $c.style.bottom='';
  }
  if(window.visualViewport){
    window.visualViewport.addEventListener('resize',fit);
    window.visualViewport.addEventListener('scroll',fit);
  }
  if($i){
    $i.addEventListener('focus',function(){setTimeout(function(){fit();if($m)$m.scrollTop=$m.scrollHeight;},300);});
    $i.addEventListener('blur',function(){setTimeout(function(){if(!$c||!$c.classList.contains('visible'))reset();else if(isMob())fit();},100);});
  }
  window.__kcFit=fit;
  window.__kcReset=reset;
})();

function getTime(){var d=new Date();return d.getHours().toString().padStart(2,'0')+':'+d.getMinutes().toString().padStart(2,'0');}
var AC=window.AudioContext||window.webkitAudioContext,ac;
function snd(t){if(!C.snd)return;if(!ac)ac=new AC();if(t==='send'){var o=ac.createOscillator(),g=ac.createGain();o.connect(g);g.connect(ac.destination);o.type='sine';o.frequency.setValueAtTime(1200,ac.currentTime);o.frequency.linearRampToValueAtTime(1800,ac.currentTime+.08);g.gain.setValueAtTime(.06,ac.currentTime);g.gain.exponentialRampToValueAtTime(.001,ac.currentTime+.12);o.start();o.stop(ac.currentTime+.12);}else if(t==='receive'){var o1=ac.createOscillator(),g1=ac.createGain(),o2=ac.createOscillator(),g2=ac.createGain();o1.connect(g1);g1.connect(ac.destination);o2.connect(g2);g2.connect(ac.destination);o1.type='sine';o1.frequency.value=1400;g1.gain.setValueAtTime(.05,ac.currentTime);g1.gain.exponentialRampToValueAtTime(.001,ac.currentTime+.15);o1.start();o1.stop(ac.currentTime+.15);o2.type='sine';o2.frequency.value=1046;g2.gain.setValueAtTime(.05,ac.currentTime+.08);g2.gain.exponentialRampToValueAtTime(.001,ac.currentTime+.25);o2.start(ac.currentTime+.08);o2.stop(ac.currentTime+.25);}}
function resetChat(){hist=[];C.contactShown=false;C.convoLogged=false;$m.innerHTML='';$ch.innerHTML='';addMsg(wel(),'bot');chips(C.s[C.lang].ch);var svg=document.getElementById('rstBtn').querySelector('svg');svg.style.transition='transform .8s ease';svg.style.transform='rotate(360deg)';setTimeout(function(){svg.style.transition='none';svg.style.transform='';},850);}
function toggleDark(){C.dm=!C.dm;$c.classList.toggle('dark-mode',C.dm);document.getElementById('dkBtn').classList.toggle('active',C.dm);}
function gr(){var h=new Date().getHours(),sk=C.lang==='sk';if(h<12)return sk?'Dobré ráno! ☀️':'Good morning! ☀️';if(h<18)return sk?'Dobrý deň! 👋':'Good afternoon! 👋';return sk?'Dobrý večer! 🌙':'Good evening! 🌙';}
function wel(){var sk=C.lang==='sk';return gr()+(sk?' Som Koverta asistent. Pomôžem vám s výberom prístreškov, pergol a carportov. Čo vás zaujíma?':" I'm Koverta assistant. I can help you choose carports, pergolas and canopies. What are you looking for?");}

function toggleChat(){
  var o=$c.classList.toggle('visible');
  $b.classList.toggle('open',o);
  if(o&&$m.children.length===0)init();
  if(o){
    $i.focus();
    snd('open');
    if($tt)$tt.style.visibility='hidden';
    lockBodyScroll();
    if(window.__kcFit)window.__kcFit();
  }else{
    if($tt)$tt.style.visibility='visible';
    unlockBodyScroll();
    if(window.__kcReset)window.__kcReset();
  }
  try{window.parent.postMessage(o?'koverta-chat-open':'koverta-chat-close','*');}catch(e){}
}

function init(){addMsg(wel(),'bot');chips(C.s[C.lang].ch);}
function setLang(l){C.lang=l;document.querySelectorAll('.kc-lang button').forEach(function(b){b.classList.toggle('active',b.textContent.trim()===l.toUpperCase())});var s=C.s[l];$i.placeholder=s.ph;document.getElementById('st').textContent=s.st;document.getElementById('cl').textContent=s.ca;document.getElementById('el').textContent=s.em;document.getElementById('est').textContent=s.se;document.getElementById('ept').textContent=s.et;document.getElementById('ln').textContent=s.ln;document.getElementById('lp').textContent=s.lp;document.getElementById('le').textContent=s.le;document.getElementById('lm').textContent=s.lm;$m.innerHTML='';hist=[];$ch.innerHTML='';addMsg(wel(),'bot');chips(s.ch);}
function addMsg(t,tp){var r=document.createElement('div');r.className='kc-row '+tp;if(tp==='bot'){var a=document.createElement('div');a.className='kc-av';var im=document.createElement('img');im.src=MSG_IMG;im.className='wobble';a.appendChild(im);r.appendChild(a);}var c=document.createElement('div');c.className='kc-mc';var b=document.createElement('div');b.className='kc-m '+tp;b.innerHTML=fmtL(t);c.appendChild(b);var ts=document.createElement('div');ts.className='kc-ts';ts.textContent=getTime();c.appendChild(ts);r.appendChild(c);$m.appendChild(r);$m.scrollTop=$m.scrollHeight;}
function fmtL(t){return t.replace(/([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/g,'<a href="mailto:$1" style="color:#1976D2;text-decoration:underline;font-weight:600">$1</a>').replace(/(https?:\/\/[^\s]+)/g,'<a href="$1" target="_blank">$1</a>').replace(/(\+421[\s]?\d{3}[\s]?\d{3}[\s]?\d{3})/g,'<a href="tel:$1" style="color:#1976D2;text-decoration:underline;font-weight:600">$1</a>');}
function typeMsg(t,cb){var r=document.createElement('div');r.className='kc-row bot';var a=document.createElement('div');a.className='kc-av';var im=document.createElement('img');im.src=MSG_IMG;im.className='wobble';a.appendChild(im);r.appendChild(a);var c=document.createElement('div');c.className='kc-mc';var b=document.createElement('div');b.className='kc-m bot';c.appendChild(b);var ts=document.createElement('div');ts.className='kc-ts';ts.textContent=getTime();c.appendChild(ts);r.appendChild(c);$m.appendChild(r);$m.scrollTop=$m.scrollHeight;var fmt=fmtL(t),tmp=document.createElement('div');tmp.innerHTML=fmt;var pl=tmp.textContent,i=0,sp=Math.max(8,Math.min(25,800/pl.length));function tc(){if(i<pl.length){b.textContent+=pl.charAt(i);i++;$m.scrollTop=$m.scrollHeight;setTimeout(tc,sp);}else{b.innerHTML=fmt;var rt=document.createElement('div');rt.className='kc-rt';rt.innerHTML='<button class="kc-rb" onclick="rate(this)">👍</button><button class="kc-rb" onclick="rate(this)">👎</button>';c.appendChild(rt);if(cb)cb();}}tc();}
function rate(b){b.parentElement.querySelectorAll('.kc-rb').forEach(function(x){x.classList.remove('on')});b.classList.add('on');snd('send');}
function chips(list){$ch.innerHTML='';list.forEach(function(t){var b=document.createElement('button');var isCalc=(t==='Kalkulácia ceny'||t==='Price calculator');b.className='kc-chip'+(isCalc?' kc-chip-calc':'');if(isCalc){b.innerHTML='<svg viewBox="0 0 24 24" width="13" height="13" style="vertical-align:-2px;margin-right:5px;fill:currentColor;"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm5 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2zm5 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z"/></svg>'+t;}else{b.textContent=t;}b.onclick=function(){b.style.transform='scale(0.95)';b.style.borderColor='rgba(255,204,0,.5)';setTimeout(function(){if(isCalc){openCalcDirect();}else{$ch.innerHTML='';send(t);}},250);};$ch.appendChild(b);});}

/* --- KALKULACKA JS --- */
var calcState = { product: null, brand: null, cars: null, dim: null, soltecModel: null, pergModel: null, acc: {} };
var activeDimArrays = { w: [], d: [] };

var CENNIK_CARPORT = { '2.5x5.2':4497, '2.5x5.6':4597, '2.5x6':4697, '2.8x5.2':4597, '2.8x5.6':4697, '2.8x6':4797 };
var CENNIK_ZAHRADNY = { '3x3':4297, '3x4':4697, '4x3':4797, '4x4':5197, '5x3':5297, '5x4':5797, '6x3':6097, '6x4':6597 };

var WIDTHS_BY_CARS = { '1auto': ['2.5', '2.8', '3', '3.2', '3.5', '3.8', '4', '4.2', '4.5'], '2auta': ['5', '5.2', '5.4', '5.6', '5.8', '6', '6.2', '6.6', '7'], 'viac': ['9'], 'default': ['2.5', '2.8', '3', '3.2', '3.5', '3.8', '4', '4.2', '4.5', '5', '5.2', '5.4', '5.6', '5.8', '6'] };
var DEPTHS_BY_CARS = { 'viac': ['6'], 'default': ['5.2', '5.6', '6'] };

function openCalcDirect() { document.getElementById('kcCalc').dataset.open = "true"; }
function closeCalc() { document.getElementById('kcCalc').dataset.open = "false"; }

function setupSliders(prefix, wArr, dArr) {
    activeDimArrays[prefix+'w'] = wArr; activeDimArrays[prefix+'d'] = dArr;
    var wR = document.getElementById(prefix+'RangeW'), dR = document.getElementById(prefix+'RangeD');
    wR.min = 0; wR.max = wArr.length - 1; wR.value = Math.floor(wArr.length/2);
    dR.min = 0; dR.max = dArr.length - 1; dR.value = Math.floor(dArr.length/2);
    
    var tlW = document.getElementById(prefix+'TicksW'), tlD = document.getElementById(prefix+'TicksD');
    if(tlW) { tlW.innerHTML = ''; wArr.forEach(function(v){ var sp = document.createElement('span'); sp.textContent = v; tlW.appendChild(sp); }); }
    if(tlD) { tlD.innerHTML = ''; dArr.forEach(function(v){ var sp = document.createElement('span'); sp.textContent = v; tlD.appendChild(sp); }); }
    
    syncSlider(prefix, 'w', 'range'); syncSlider(prefix, 'd', 'range');
}

function syncSlider(prefix, axis, source) {
    var r = document.getElementById(prefix + 'Range' + axis.toUpperCase());
    var t = document.getElementById(prefix + 'Text' + axis.toUpperCase());
    var arr = activeDimArrays[prefix+axis];
    if(source === 'range') {
        t.value = arr[r.value];
    } else {
        var typed = t.value.replace(',', '.').trim();
        var idx = arr.indexOf(typed);
        if(idx !== -1) r.value = idx;
    }
    
    var w = document.getElementById(prefix+'TextW').value.trim();
    var d = document.getElementById(prefix+'TextD').value.trim();
    var btn = document.getElementById('btn-' + prefix + 'Next');
    if(w && d) { calcState.dim = w + 'x' + d; btn.disabled = false; } else { calcState.dim = null; btn.disabled = true; }
}

function getClosestDim(w, d, objCennik) {
    var keys = Object.keys(objCennik);
    var minDiff = Infinity, closest = null;
    var uw = parseFloat(w.replace(',','.')), ud = parseFloat(d.replace(',','.'));
    if(isNaN(uw) || isNaN(ud)) return null;
    keys.forEach(function(k) {
        var p = k.split('x');
        var diff = Math.abs(parseFloat(p[0]) - uw) + Math.abs(parseFloat(p[1]) - ud);
        if(diff < minDiff) { minDiff = diff; closest = k; }
    });
    return closest;
}

function goStep(target) {
    document.querySelectorAll('.kc-calc-step').forEach(function(el) { el.dataset.active = 'false'; });
    if(target === 1) {
        calcState = { product: null, brand: null, cars: null, dim: null, soltecModel: null, pergModel: null, acc: {} };
        document.querySelectorAll('.kc-card, .kc-brand-card, .kc-model-card, .kc-check').forEach(function(c){c.classList.remove('selected')});
        document.querySelectorAll('.kc-check input').forEach(function(inp){inp.checked = false;});
        document.getElementById('btn-n1').disabled = true;
        document.getElementById('calcProg').style.width = '10%';
    } else if(target === 2) {
        target = '2-' + calcState.product;
        document.getElementById('calcProg').style.width = '25%';
    } else if(target === '2a-cars') {
        document.getElementById('calcProg').style.width = '45%';
    } else if(target === '2a-next') {
        if(calcState.brand === 'soltec') { target = '2a-soltec-model'; } else { target = '2a-dims'; }
        document.getElementById('calcProg').style.width = '65%';
    } 

    if(target === '2a-dims') {
        var cars = calcState.cars || 'default';
        setupSliders('cp', WIDTHS_BY_CARS[cars] || WIDTHS_BY_CARS['default'], DEPTHS_BY_CARS[cars] || DEPTHS_BY_CARS['default']);
        document.getElementById('calcProg').style.width = '65%';
    } else if(target === '2p-size') {
        setupSliders('pg', ['2','2.5','3','3.5','4','4.5','5','5.5','6'], ['2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8']);
        document.getElementById('calcProg').style.width = '75%';
    } else if(target === '2-zahradny') {
        setupSliders('zh', ['3','4','5','6','7','8'], ['3','4']);
        document.getElementById('calcProg').style.width = '25%';
    }

    if(target === '2a-acc') {
        document.getElementById('calcProg').style.width = '85%';
        document.getElementById('accBoxWrapper').style.display = (calcState.brand === 'soltec') ? 'flex' : 'none';
    } else if(target === '2p-roof') {
        document.getElementById('calcProg').style.width = '50%';
    } else if(target === 3) {
        document.getElementById('calcProg').style.width = '100%';
        calcState.acc = {
            lamely: document.getElementById('accLamely') && document.getElementById('accLamely').checked,
            zelena: document.getElementById('accZelena') && document.getElementById('accZelena').checked,
            led: document.getElementById('accLed') && document.getElementById('accLed').checked,
            box: document.getElementById('accBox') && document.getElementById('accBox').checked,
            other: document.getElementById('calcAccOther') ? document.getElementById('calcAccOther').value : ''
        };
        computePrice();
    }
    
    var stepEl = document.querySelector('.kc-calc-step[data-step="' + target + '"]');
    if (stepEl) { stepEl.dataset.active = 'true'; document.getElementById('kcCalc').scrollTop = 0; }
}

function selCard(el, type) {
    el.parentElement.querySelectorAll('.kc-card').forEach(function(c) { c.classList.remove('selected'); });
    el.classList.add('selected');
    calcState[type] = el.dataset.val;
    if (type === 'product') document.getElementById('btn-n1').disabled = false;
    if (type === 'cars') document.getElementById('btn-n2-cars').disabled = false;
}

function selBrand(el, brand) {
    document.querySelectorAll('.kc-brand-card').forEach(function(c) { c.classList.remove('selected'); });
    el.classList.add('selected');
    calcState.brand = brand;
    document.getElementById('btn-n2-brand').disabled = false;
}

function selModelCard(el, val) {
    el.parentElement.querySelectorAll('.kc-model-card').forEach(function(c) { c.classList.remove('selected'); });
    el.classList.add('selected');
    calcState.soltecModel = val;
    var btn = document.getElementById('btn-soltec-model');
    if(btn) btn.disabled = false;
}

function selModelCardP(el, val) {
    el.parentElement.querySelectorAll('.kc-model-card').forEach(function(c) { c.classList.remove('selected'); });
    el.classList.add('selected');
    calcState.pergModel = val;
    var btn = document.getElementById('btn-pergModel');
    if(btn) btn.disabled = false;
}

function selRadio(input, group, val) {
    var step = input.closest('.kc-calc-step');
    step.querySelectorAll('.kc-check').forEach(function(l) {
        var ri = l.querySelector('input[type="radio"][name="'+group+'"]');
        if(ri) l.classList.toggle('selected', ri.checked);
    });
}

function pickIne(label) {
    calcState.product = 'ine';
    document.getElementById('calcIneSelect').value = label;
    goStep(3);
}

function toggleOptMsg() {
    var btn = document.getElementById('optMsgToggleBtn'), chk = document.getElementById('optMsgChk'), area = document.getElementById('optMsgArea');
    btn.classList.toggle('active');
    chk.classList.toggle('on');
    area.classList.toggle('open');
    if(area.classList.contains('open')) setTimeout(function(){ document.getElementById('calcOptMsg').focus(); }, 300);
}

function computePrice() {
    var rBox = document.getElementById('resBox'), priceEl = document.getElementById('resPrice'), labelEl = document.getElementById('resLabel'), noteEl = document.getElementById('resNote');
    var sBox = document.getElementById('summaryBox');
    
    if(!calcState.product) { rBox.style.display = 'none'; sBox.innerHTML = ''; return; }
    
    var sHtml = '<div class="kc-summary-card"><div class="kc-summary-title">Zhrnutie vášho výberu</div>';
    if(calcState.product === 'ine') {
        sHtml += '<div class="kc-summary-item"><span>Produkt:</span><span>Iné - ' + document.getElementById('calcIneSelect').value + '</span></div>';
    } else {
        var prodMap = {carport: 'Prístrešok pre auto', pergola: 'Bioklimatická pergola', zahradny: 'Záhradný prístrešok'};
        sHtml += '<div class="kc-summary-item"><span>Produkt:</span><span>' + prodMap[calcState.product] + '</span></div>';
        
        if(calcState.brand) sHtml += '<div class="kc-summary-item"><span>Značka:</span><span>' + (calcState.brand==='soltec'?'Soltec':'Koverta') + '</span></div>';
        if(calcState.soltecModel) sHtml += '<div class="kc-summary-item"><span>Model:</span><span>' + (calcState.soltecModel==='soltec-f'?'Model F':'Model SL') + '</span></div>';
        if(calcState.pergModel) sHtml += '<div class="kc-summary-item"><span>Model:</span><span>' + (calcState.pergModel==='canopy-f'?'Canopy F':'Canopy G') + '</span></div>';
        if(calcState.dim) sHtml += '<div class="kc-summary-item"><span>Rozmery:</span><span>' + calcState.dim.replace('.',',') + ' m</span></div>';
        
        var accs = [];
        if(calcState.acc) {
            if(calcState.acc.lamely) accs.push('Lamely/Rolety');
            if(calcState.acc.zelena) accs.push('Príprava - zel. strecha');
            if(calcState.acc.led) accs.push('LED');
            if(calcState.acc.box) accs.push('Odkladací box');
        }
        if(accs.length > 0) sHtml += '<div class="kc-summary-item"><span>Doplnky:</span><span>' + accs.join(', ') + '</span></div>';
    }
    sHtml += '</div>';
    sBox.innerHTML = sHtml;

    rBox.style.display = 'block';
    priceEl.style.fontSize = '';
    noteEl.textContent = 'Presnú ponuku vám obratom zašleme.';
    
    if(calcState.product === 'ine' || calcState.brand === 'soltec' || calcState.product === 'pergola') {
        labelEl.textContent = 'Cena konštrukcie:';
        priceEl.style.fontSize = '15px';
        priceEl.textContent = 'Na vyžiadanie (individuálna ponuka)';
        if(calcState.brand === 'soltec' || calcState.product === 'pergola') {
            noteEl.innerHTML = 'Soltec produkty a pergoly nemajú tabuľkový cenník.<br>Cena príslušenstva bude prebraná s konateľom.';
        }
        return;
    }

    if(calcState.dim) {
        var isCarport = (calcState.product === 'carport');
        var cennik = isCarport ? CENNIK_CARPORT : CENNIK_ZAHRADNY;
        var p = cennik[calcState.dim];
        
        if(p) {
            labelEl.textContent = 'Orientačná cena (konštrukcia):';
            priceEl.textContent = 'od ' + p.toLocaleString('sk-SK') + ' €';
            noteEl.innerHTML = 'Zobrazená cena nezahŕňa doplnky. Cena príslušenstva (lamely, LED...) závisí od podmienok a bude prebraná s konateľom.';
        } else {
            labelEl.textContent = 'Rozmer na mieru:';
            priceEl.style.fontSize = '15px';
            priceEl.textContent = 'Naceníme individuálne';
            
            var parts = calcState.dim.split('x');
            var cls = getClosestDim(parts[0], parts[1], cennik);
            if(cls && cennik[cls]) {
                noteEl.innerHTML = 'Najbližší sériový rozmer v cenníku je <b>' + cls.replace('.',',') + ' m</b> za <b>' + cennik[cls].toLocaleString('sk-SK') + ' €</b>.<br>Cena príslušenstva bude prebraná s konateľom.';
            } else {
                noteEl.innerHTML = 'Cena príslušenstva závisí od viacerých podmienok a bude prebraná s konateľom.';
            }
        }
    }
}

function submitCalc() {
    var nm = document.getElementById('calcName').value, ph = document.getElementById('calcPhone').value, em = document.getElementById('calcEmail').value;
    if(!nm || !ph || !em) { alert("Prosím vyplňte Meno, Telefón a E-mail."); return; }
    
    var btn = document.getElementById('calcSubmit');
    btn.innerHTML = 'Odosielam...'; btn.disabled = true;

    var pText = calcState.product;
    if(calcState.product === 'ine') pText = 'Iné - ' + document.getElementById('calcIneSelect').value;
    
    var dataStr = 'DOPYT Z KALKULACKY:\nProdukt: ' + pText + '\nZnačka/Model: ' + (calcState.brand || calcState.pergModel || calcState.soltecModel || '-') + '\nRozmer: ' + (calcState.dim || '-') + '\n\nPoznámka: ' + document.getElementById('calcOptMsg').value;
    
    emailjs.send('service_r599m2r', 'template_hk69h2l', {from_name: nm, phone: ph, from_email: em, message: dataStr}).then(function() {
        closeCalc();
        addMsg('Ďakujeme za dopyt! Náš tím vás čoskoro bude kontaktovať s presnou cenovou ponukou.', 'bot');
        btn.innerHTML = 'Odoslať dopyt'; btn.disabled = false;
    }).catch(function() {
        alert("Chyba. Skúste to prosím znova.");
        btn.innerHTML = 'Odoslať dopyt'; btn.disabled = false;
    });
}
/* --- KONIEC KALKULACKY JS --- */

async function send(ov){var t=ov||$i.value.trim();if(!t)return;$i.value='';$ch.innerHTML='';addMsg(t,'user');snd('send');hist.push({role:'user',content:t});$t.classList.add('show');$m.scrollTop=$m.scrollHeight;try{var reply=await callAI(t);$t.classList.remove('show');snd('receive');typeMsg(reply,function(){var userMsgCount=hist.filter(function(h){return h.role==='user'}).length;if(userMsgCount===3&&!C.contactShown){C.contactShown=true;setTimeout(function(){var cMsg=C.lang==='sk'?'💡 Tip: Ak by ste chceli individuálnu ponuku alebo konzultáciu, zanechajte nám na seba kontakt cez formulár nižšie (tlačidlo Email). Ozveme sa vám do 24 hodín!':'💡 Tip: If you would like a personalized quote, leave us your contact via the Email button below. We will get back to you within 24 hours!';addMsg(cMsg,'bot');},1500);}});hist.push({role:'assistant',content:reply});logConvo();}catch(e){$t.classList.remove('show');addMsg(C.s[C.lang].er,'bot');}}
function logConvo(){try{var userMsgs=hist.filter(function(h){return h.role==='user'});if(userMsgs.length>=2&&!C.convoLogged){C.convoLogged=true;var convoText=hist.map(function(m){return(m.role==='user'?'ZÁKAZNÍK: ':'BOT: ')+m.content;}).join('\n\n');emailjs.send('service_r599m2r','template_hk69h2l',{from_name:'AI Chatbot - Záznam konverzácie',phone:'Počet správ: '+hist.length,from_email:'obchod@koverta.sk',message:convoText}).then(function(){console.log('Konverzácia odoslaná');},function(err){console.error('Log error:',err);});}}catch(e){console.error(e);}}
async function callAI(m){var r=await fetch(C.apiUrl,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({messages:hist,lang:C.lang})});if(!r.ok)throw new Error();return(await r.json()).reply;}
function tgEmail(){var o=document.getElementById('eo'),p=document.getElementById('ep');var s=!p.classList.contains('show');o.classList.toggle('show',s);p.classList.toggle('show',s);}
function subEmail(){var e=document.getElementById('fe').value,m=document.getElementById('fm').value;if(!e||!m){['fe','fm'].forEach(function(id){var el=document.getElementById(id);if(!el.value){el.style.borderColor='#E53935';setTimeout(function(){el.style.borderColor='';},2000);}});return;}var b=document.getElementById('esb'),t=document.getElementById('est');b.disabled=true;t.textContent='Odosielam...';emailjs.send('service_r599m2r','template_hk69h2l',{from_name:document.getElementById('fn').value||'Neuvedené',phone:document.getElementById('fp').value||'Neuvedené',from_email:e,message:m}).then(function(){b.classList.add('ok');t.textContent=C.s[C.lang].sd;snd('send');setTimeout(function(){tgEmail();b.classList.remove('ok');b.disabled=false;t.textContent=C.s[C.lang].se;['fn','fp','fe','fm'].forEach(function(id){document.getElementById(id).value='';});},1800);},function(err){console.error('EmailJS error:',err);b.disabled=false;t.textContent='Chyba, skúste znova';setTimeout(function(){t.textContent=C.s[C.lang].se;},3000);});}
emailjs.init('tDzbDHRy2D6wjC_LA');
</script>
</body>
</html>
