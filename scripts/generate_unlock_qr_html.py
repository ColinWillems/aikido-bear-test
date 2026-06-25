#!/usr/bin/env python3
"""Generate a single self-contained HTML page with QR codes for every card
unlock URL. Useful for demos: open in any browser, no internet needed.

The QR payload is the obfuscated deep link
``https://app.bearfruitsnacks.com/?path=<code>`` where ``<code>`` is a
4-character base32 string produced by ``card_id_obfuscator.encode_card_id``.
The app decodes the code back into the original card ID; the
plaintext ID never appears in the QR.

Output: bear_adventure_app/delivery/_firebase_upload/unlock_qrcodes.html
"""

from __future__ import annotations

import html
import sys
from io import BytesIO
from pathlib import Path

import qrcode
import qrcode.image.svg

sys.path.insert(0, str(Path(__file__).resolve().parent))
from card_catalogue import BASE_URL, CARDS, SET_COLORS  # noqa: E402
from card_id_obfuscator import encode_card_id  # noqa: E402

# Card catalogue, colours and base URL come from card_catalogue.py so the
# Excel generator can share the same source of truth without pulling in the
# qrcode dependency.


def make_qr_svg(payload: str) -> str:
    """Return an inline <svg> string for the QR code.

    Uses error-correction level H (~30%) so the QR is still readable from a
    distance / on a projected screen.
    """
    factory = qrcode.image.svg.SvgPathImage
    img = qrcode.make(
        payload,
        image_factory=factory,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=10,
        border=2,
    )
    buf = BytesIO()
    img.save(buf)
    svg = buf.getvalue().decode("utf-8")

    # qrcode emits a full SVG document (with <?xml ...?>). Strip the prolog
    # so it embeds cleanly as inline HTML.
    if svg.startswith("<?xml"):
        svg = svg.split("?>", 1)[1].lstrip()
    return svg


def render() -> str:
    css = """
    :root {
      --bg: #fffaf2;
      --fg: #2b1810;
      --muted: #8a7560;
      --card-bg: #ffffff;
      --card-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
      --radius: 18px;
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #15110d;
        --fg: #f5ebd8;
        --muted: #a89784;
        --card-bg: #221c15;
        --card-shadow: 0 6px 20px rgba(0, 0, 0, 0.5);
      }
    }
    * { box-sizing: border-box; }
    html, body {
      margin: 0; padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        Helvetica, Arial, sans-serif;
      background: var(--bg);
      color: var(--fg);
      -webkit-font-smoothing: antialiased;
    }
    header {
      padding: 32px 24px 16px;
      max-width: 1400px;
      margin: 0 auto;
    }
    header h1 {
      margin: 0 0 4px;
      font-size: 28px;
      font-weight: 800;
      letter-spacing: -0.02em;
    }
    header p {
      margin: 0;
      color: var(--muted);
      font-size: 14px;
    }
    .toolbar {
      display: flex; gap: 12px; flex-wrap: wrap;
      padding: 8px 24px 16px;
      max-width: 1400px;
      margin: 0 auto;
      position: sticky;
      top: 0;
      background: linear-gradient(to bottom, var(--bg) 75%, transparent);
      z-index: 10;
      backdrop-filter: blur(8px);
    }
    .toolbar input {
      flex: 1;
      min-width: 200px;
      padding: 10px 14px;
      border-radius: 12px;
      border: 1px solid rgba(0,0,0,0.1);
      background: var(--card-bg);
      color: var(--fg);
      font-size: 15px;
    }
    .toolbar button {
      padding: 10px 16px;
      border-radius: 12px;
      border: 1px solid rgba(0,0,0,0.1);
      background: var(--card-bg);
      color: var(--fg);
      font-size: 14px;
      cursor: pointer;
      font-weight: 600;
    }
    .toolbar button:hover { transform: translateY(-1px); }
    main { padding: 0 24px 64px; max-width: 1400px; margin: 0 auto; }

    section.collection {
      margin-top: 32px;
    }
    section.collection > h2 {
      font-size: 22px;
      margin: 0 0 4px;
      letter-spacing: -0.01em;
    }
    section.collection > .meta {
      color: var(--muted);
      font-size: 13px;
      margin-bottom: 20px;
    }

    section.set {
      margin-bottom: 32px;
    }
    section.set h3 {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      font-size: 16px;
      font-weight: 700;
      letter-spacing: 0.02em;
      text-transform: uppercase;
      margin: 0 0 12px;
      padding: 6px 14px;
      border-radius: 999px;
      color: white;
      text-shadow: 0 1px 2px rgba(0,0,0,0.2);
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 16px;
    }
    .card {
      background: var(--card-bg);
      border-radius: var(--radius);
      padding: 16px;
      box-shadow: var(--card-shadow);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 10px;
      border-top: 4px solid var(--accent, var(--muted));
      transition: transform 0.15s ease;
    }
    .card:hover { transform: translateY(-2px); }
    .card .qr {
      width: 100%;
      aspect-ratio: 1 / 1;
      background: white;
      border-radius: 12px;
      padding: 8px;
      display: flex; align-items: center; justify-content: center;
    }
    .card .qr svg { width: 100%; height: 100%; display: block; }
    .card .title {
      font-weight: 700;
      font-size: 15px;
      text-align: center;
      line-height: 1.25;
    }
    .card .index {
      font-size: 11px;
      color: var(--muted);
      letter-spacing: 0.05em;
      text-transform: uppercase;
    }
    .card .url {
      font-family: ui-monospace, "SF Mono", Menlo, monospace;
      font-size: 11px;
      color: var(--muted);
      word-break: break-all;
      text-align: center;
      max-width: 100%;
    }
    .card .url a { color: inherit; text-decoration: none; }
    .card .url a:hover { text-decoration: underline; }

    /* Hidden when filtered out */
    .card.is-hidden { display: none; }
    section.set:has(.grid > :not(.is-hidden)) ~ section.set {} /* noop */
    section.set.is-empty { display: none; }
    section.collection.is-empty { display: none; }

    /* Compact mode (toggled via JS) */
    body.compact .grid {
      grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
      gap: 12px;
    }
    body.compact .card { padding: 10px; gap: 6px; }
    body.compact .card .title { font-size: 13px; }
    body.compact .card .url { display: none; }

    /* Print: 4 per row, no decorations */
    @media print {
      :root { --bg: white; --fg: black; --card-bg: white; }
      header, .toolbar { display: none; }
      main { padding: 0; }
      section.collection { page-break-after: always; }
      section.set { page-break-inside: avoid; }
      section.set:last-child { page-break-after: auto; }
      .card { box-shadow: none; border: 1px solid #ddd; }
      .grid { grid-template-columns: repeat(4, 1fr); gap: 8px; }
    }
    """

    parts: list[str] = []
    parts.append("<!doctype html>")
    parts.append('<html lang="en"><head>')
    parts.append('<meta charset="utf-8">')
    parts.append('<meta name="viewport" content="width=device-width,initial-scale=1">')
    parts.append("<title>BEAR Adventure — Card Unlock QR Codes</title>")
    parts.append(f"<style>{css}</style>")
    parts.append("</head><body>")
    parts.append("<header>")
    parts.append("<h1>BEAR Adventure — Card Unlock QR Codes</h1>")
    parts.append("<p>Scan a QR code with the BEAR Adventure app or any "
                 "phone camera to unlock the corresponding card. Tap the "
                 "URL to open it directly on a device with the app "
                 "installed.</p>")
    parts.append("</header>")
    parts.append('<div class="toolbar">')
    parts.append('<input id="filter" type="search" '
                 'placeholder="Filter by sport, set or card id…" autofocus>')
    parts.append('<button id="compact" type="button">Compact</button>')
    parts.append('<button onclick="window.print()" type="button">Print</button>')
    parts.append("</div>")
    parts.append("<main>")

    for collection_title, sets in CARDS.items():
        total = sum(len(c) for _, c in sets)
        parts.append(f'<section class="collection">')
        parts.append(f"<h2>{html.escape(collection_title)}</h2>")
        parts.append(f'<div class="meta">{total} cards</div>')

        for set_label, items in sets:
            color = SET_COLORS.get(set_label, "#888")
            parts.append('<section class="set">')
            parts.append(
                f'<h3 style="background:{color}">'
                f'{html.escape(set_label)}'
                "</h3>"
            )
            parts.append('<div class="grid">')
            for card_id, sport, idx in items:
                code = encode_card_id(card_id)
                url = f"{BASE_URL}/?path={code}"
                qr = make_qr_svg(url)
                searchable = " ".join([
                    sport, set_label, card_id, code, str(idx), collection_title,
                ]).lower()
                parts.append(
                    f'<div class="card" '
                    f'style="--accent:{color}" '
                    f'data-search="{html.escape(searchable, quote=True)}">'
                )
                parts.append(f'<div class="qr">{qr}</div>')
                parts.append(f'<div class="title">{html.escape(sport)}</div>')
                parts.append(
                    f'<div class="index">'
                    f"{idx:02d} · {html.escape(card_id)} · "
                    f"<strong>{html.escape(code)}</strong>"
                    "</div>"
                )
                parts.append(
                    f'<div class="url"><a href="{html.escape(url, quote=True)}">'
                    f"{html.escape(url)}</a></div>"
                )
                parts.append("</div>")
            parts.append("</div></section>")
        parts.append("</section>")

    parts.append("</main>")

    js = """
    const input = document.getElementById('filter');
    const cards = Array.from(document.querySelectorAll('.card'));
    const sets = Array.from(document.querySelectorAll('section.set'));
    const colls = Array.from(document.querySelectorAll('section.collection'));
    function applyFilter() {
      const q = input.value.trim().toLowerCase();
      cards.forEach(card => {
        const match = !q || card.dataset.search.includes(q);
        card.classList.toggle('is-hidden', !match);
      });
      sets.forEach(set => {
        const hasVisible = set.querySelector('.card:not(.is-hidden)');
        set.classList.toggle('is-empty', !hasVisible);
      });
      colls.forEach(coll => {
        const hasVisible = coll.querySelector('section.set:not(.is-empty)');
        coll.classList.toggle('is-empty', !hasVisible);
      });
    }
    input.addEventListener('input', applyFilter);

    document.getElementById('compact').addEventListener('click', () => {
      document.body.classList.toggle('compact');
    });

    // Tap a card body (not the link) to copy URL.
    cards.forEach(card => {
      card.addEventListener('click', (e) => {
        if (e.target.closest('a')) return;
        const link = card.querySelector('.url a');
        if (!link) return;
        navigator.clipboard?.writeText(link.href);
        const original = card.style.transform;
        card.style.transform = 'scale(0.97)';
        setTimeout(() => { card.style.transform = original; }, 120);
      });
    });
    """
    parts.append(f"<script>{js}</script>")
    parts.append("</body></html>")
    return "\n".join(parts)


def main() -> int:
    out = Path("bear_adventure_app/delivery/_firebase_upload/unlock_qrcodes.html")
    out.parent.mkdir(parents=True, exist_ok=True)
    html_text = render()
    out.write_text(html_text, encoding="utf-8")
    total = sum(
        len(items)
        for sets in CARDS.values()
        for _, items in sets
    )
    print(f"Wrote {out} ({len(html_text):,} bytes, {total} cards)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
