-- ============================================================
-- Ghost Engine — Setup: aufstiegmomentum
-- Erstellt: Juni 2026
-- Status: Platzhalter für IDs müssen nach API-Einrichtung
--         ersetzt werden (markiert mit <<PLATZHALTER>>)
-- ============================================================

-- ── SCHRITT 1: Setup registrieren ────────────────────────────
-- Notiere die zurückgegebene UUID — wird in allen folgenden
-- Schritten als <<SETUP_ID>> verwendet.

INSERT INTO setups (id, slug, niche, sub_niche, status)
VALUES (
  gen_random_uuid(),
  'aufstiegmomentum',
  'Energie & Momentum',
  'Morgenenergie & täglicher Aufstieg',
  'ACTIVE'
)
RETURNING id, slug;

-- !! setup_id aus dem RETURNING-Ergebnis kopieren !!
-- !! Alle <<SETUP_ID>> unten ersetzen              !!


-- ── SCHRITT 2: Setup-Konfiguration ───────────────────────────

INSERT INTO setup_configs (
  setup_id,
  is_active,
  tonality,
  core_promise,
  freebie,
  cta_headline,
  cta_body,
  hashtags,
  content_pillars,
  avoid_list,
  active_platforms,
  prime_times,
  prime_formats,
  active_formats,
  hook_image_templates,
  voice_profile,
  few_shots,
  prime_topics,
  config_source
) VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  TRUE,
  'Kraftvoll, ermutigend, erdend, Per Du, keine Klichés',
  'Jeden Morgen neu starten — mit Energie, Klarheit und dem Willen aufzusteigen.',
  'Morgenaufstieg — 7-Tage Energie-Routine',
  'Dein Aufstieg beginnt.',
  '7 Tage. Jeden Morgen ein Ritual. Kostenlos. Link in Bio.',
  '#aufstiegmomentum #morgenroutine #energie #momentum #aufstieg #morgenmotivation #täglicheraufstieg #wachstum #disziplin #morgenenergie #erfolg #mindset #persönlichkeitsentwicklung #naturkraft',
  ARRAY[
    'Morgenenergie — Rituale, Routinen, der erste Moment des Tages',
    'Aufstieg & Wachstum — kleine Schritte, konstante Entwicklung, sichtbarer Fortschritt',
    'Naturweisheit — Was die Natur über Ausdauer, Zyklen und Erneuerung lehrt',
    'Mentale Kraft — Innere Stärke, Überwindung, Fokus auf das Wesentliche',
    'Inspirierende Stimmen — Zitate mit echtem Kontext, Geschichten realer Menschen'
  ],
  ARRAY[
    'Toxische Hustle-Culture (Schlaf ist für Schwache)',
    'Leere Motivationssprüche ohne Substanz',
    'Übertriebene Spiritualität / Esoterik',
    'Generische Sonnenaufgang-Klichés (Jeder Tag ist ein Geschenk)',
    'Falsch zugeschriebene Zitate'
  ],
  ARRAY['threads', 'instagram'],
  '{"threads": ["06:00"], "instagram": ["06:00"]}'::jsonb,
  '{"threads": "TEXT", "instagram": "CAROUSEL"}'::jsonb,
  '{"instagram": ["IMAGE", "CAROUSEL"]}'::jsonb,
  '[
    "dramatic golden sunrise over misty mountain peaks, god rays breaking through clouds, epic wide angle, no people, no text, 4k, high quality",
    "single tree on hilltop silhouetted against vibrant orange and pink sunrise sky, minimalist, powerful, no people, no text, 4k, high quality",
    "morning dew on green leaves with soft golden backlight, macro shot, fresh energy, nature, no people, no text, 4k, high quality",
    "winding mountain path ascending toward bright sunrise, perspective shot, journey and progress, no people, no text, 4k, high quality",
    "calm lake reflecting golden sunrise, perfect mirror, stillness and energy, wide angle, no people, no text, 4k, high quality"
  ]'::jsonb,
  jsonb_build_object(
    'background_image_url', 'https://raw.githubusercontent.com/Finoro/finoro-assets/main/aufstiegmomentum/assets/background.png',
    'logo_url',             'https://raw.githubusercontent.com/Finoro/finoro-assets/main/aufstiegmomentum/assets/aufstiegmomentum-logo.png',
    'logo_enabled',         true,
    'logo_position',        'bottom_right',
    'hook_enabled',         true,
    'gradient_enabled',     true,
    'overlay_preset',       'stoic',
    'layout_mode',          'split',
    'layout_mode_carousel', 'framed',
    'split_ratio',          0.60,
    'panel_color',          '[0,0,0]',
    'aspect_ratio',         '4:5',
    'frame_x1',             108,
    'frame_y1',             108,
    'frame_x2',             972,
    'frame_y2',             1242
  ),
  '[]'::jsonb,
  ARRAY[]::text[],
  'MANUAL'
);


-- ── SCHRITT 3: platform_meta eintragen ───────────────────────
-- Nach API-Einrichtung ausführen — IDs ersetzen

UPDATE setup_configs
SET platform_meta = jsonb_build_object(
  'threads',   jsonb_build_object('user_id', '<<THREADS_USER_ID>>'),
  'instagram', jsonb_build_object('page_id', '<<INSTAGRAM_PAGE_ID>>'),
  'facebook',  jsonb_build_object('page_id', '<<FACEBOOK_PAGE_ID>>')
)
WHERE setup_id = 'b3c1851d-a6c1-405d-bea4-02983d242e7c'
  AND is_active = TRUE;


-- ── SCHRITT 4: Tokens in Vault ───────────────────────────────
-- Nach API-Einrichtung ausführen — Tokens ersetzen

-- Instagram Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  'instagram',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<INSTAGRAM_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Facebook Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  'facebook',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<FACEBOOK_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Threads Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  'threads',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<THREADS_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Meta App ID
INSERT INTO vault (setup_id, platform, token_type, token_value)
VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  'facebook',
  'APP_ID',
  pgp_sym_encrypt('<<META_APP_ID>>', current_setting('app.vault_key'))
);

-- Meta App Secret
INSERT INTO vault (setup_id, platform, token_type, token_value)
VALUES (
  'b3c1851d-a6c1-405d-bea4-02983d242e7c',
  'facebook',
  'APP_SECRET',
  pgp_sym_encrypt('<<META_APP_SECRET>>', current_setting('app.vault_key'))
);


-- ── SCHRITT 5: Verifikation ───────────────────────────────────

-- Setup prüfen
SELECT id, slug, niche, status FROM setups WHERE slug = 'aufstiegmomentum';

-- Config prüfen
SELECT
  setup_id,
  is_active,
  active_platforms,
  prime_times,
  prime_formats,
  core_promise,
  freebie,
  cta_headline,
  platform_meta
FROM setup_configs
WHERE setup_id = 'b3c1851d-a6c1-405d-bea4-02983d242e7c';

-- Vault prüfen (nach Token-Eintrag)
SELECT
  platform,
  token_type,
  expires_at,
  LEFT(pgp_sym_decrypt(token_value, current_setting('app.vault_key'))::TEXT, 15) AS token_preview
FROM vault
WHERE setup_id = 'b3c1851d-a6c1-405d-bea4-02983d242e7c'
ORDER BY platform, token_type;
