-- ============================================================
-- Ghost Engine — Setup: derstarkdenker
-- Erstellt: Juni 2026
-- Status: Platzhalter für IDs müssen nach API-Einrichtung
--         ersetzt werden (markiert mit <<PLATZHALTER>>)
-- ============================================================

-- ── SCHRITT 1: Setup registrieren ────────────────────────────
-- Notiere die zurückgegebene UUID — wird in allen folgenden
-- Schritten als {setup_id} verwendet.

INSERT INTO setups (id, slug, niche, sub_niche, status)
VALUES (
  gen_random_uuid(),
  'derstarkdenker',
  'Motivation & Mentale Stärke',
  'Täglicher Antrieb & Alltagsdisziplin',
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
  '<<SETUP_ID>>',
  TRUE,
  'Direkt, Per Du, Emotional, Motivierend, Keine Floskeln, Keine Klichés',
  'Deine tägliche Dosis Motivation um den Tag als Sieger zu bewältigen.',
  'Morgenritual — 5-Minuten-Starter',
  'Dein Morgen. Dein Sieg.',
  'Starte jeden Tag mit Klarheit. Hol dir dein kostenloses Morgenritual. Link in Bio.',
  '#derstarkdenker #mentalestärke #mindset #motivation #selbstdisziplin #persönlichkeitsentwicklung #erfolgsmentalität #starkdenken #wachstum #mindsetcoach #disziplin #fokus #zielerreichung #täglichbesser',
  ARRAY[
    'Mentale Haltung — Mindset-Shifts, Gedankenmuster, innere Überzeugungen',
    'Tägliche Disziplin — Morgenroutinen, Gewohnheiten, kleine tägliche Siege',
    'Bekannte Stimmen — Zitate von Philosophen, Sportlern, Unternehmern mit echtem Kontext',
    'Rückschläge & Resilienz — Scheitern als Teil des Prozesses, ehrliche Einblicke',
    'Energie & Momentum — Aktivierung, Körper-Geist-Verbindung, Antrieb aufbauen'
  ],
  ARRAY[
    'Keine plumpen Klichés (Du schaffst das!, Glaub an dich!)',
    'Toxische Positivität',
    'Generische Selbsthilfe-Phrasen',
    'Falsch zugeschriebene Zitate',
    'Leere Imperativ-Posts ohne Substanz',
    'Übertriebene Hustle-Culture-Glorifizierung'
  ],
  ARRAY['threads', 'instagram'],
  '{"threads": ["07:00"], "instagram": ["07:00"]}'::jsonb,
  '{"threads": "TEXT", "instagram": "CAROUSEL"}'::jsonb,
  '{"instagram": ["IMAGE", "CAROUSEL"]}'::jsonb,
  '[
    "lone mountain climber silhouette reaching summit at golden sunrise, dramatic sky, epic scale, cinematic, no faces, no text, 4k, high quality",
    "powerful ocean wave crashing against rocky shore at dawn, motion blur, raw energy, wide angle, no people, no text, 4k, high quality",
    "single flame burning in complete darkness, macro shot, high contrast, warm amber glow, no people, no text, 4k, high quality",
    "empty road stretching toward dramatic storm clouds breaking into sunlight, golden hour, cinematic, no people, no text, 4k, high quality",
    "weathered hands gripping a frayed rope against dark background, strength and determination, close-up, dramatic lighting, no faces, no text, 4k, high quality"
  ]'::jsonb,
  jsonb_build_object(
    'background_image_url', 'https://raw.githubusercontent.com/Finoro/finoro-assets/main/derstarkdenker/assets/background.png',
    'logo_url',             'https://raw.githubusercontent.com/Finoro/finoro-assets/main/derstarkdenker/assets/derstarkdenker-logo.png',
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
WHERE setup_id = '<<SETUP_ID>>'
  AND is_active = TRUE;


-- ── SCHRITT 4: Tokens in Vault ───────────────────────────────
-- Nach API-Einrichtung ausführen — Tokens ersetzen

-- Instagram Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  '<<SETUP_ID>>',
  'instagram',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<INSTAGRAM_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Facebook Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  '<<SETUP_ID>>',
  'facebook',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<FACEBOOK_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Threads Access Token
INSERT INTO vault (setup_id, platform, token_type, token_value, expires_at)
VALUES (
  '<<SETUP_ID>>',
  'threads',
  'ACCESS_TOKEN',
  pgp_sym_encrypt('<<THREADS_ACCESS_TOKEN>>', current_setting('app.vault_key')),
  NOW() + INTERVAL '60 days'
);

-- Meta App ID
INSERT INTO vault (setup_id, platform, token_type, token_value)
VALUES (
  '<<SETUP_ID>>',
  'facebook',
  'APP_ID',
  pgp_sym_encrypt('<<META_APP_ID>>', current_setting('app.vault_key'))
);

-- Meta App Secret
INSERT INTO vault (setup_id, platform, token_type, token_value)
VALUES (
  '<<SETUP_ID>>',
  'facebook',
  'APP_SECRET',
  pgp_sym_encrypt('<<META_APP_SECRET>>', current_setting('app.vault_key'))
);


-- ── SCHRITT 5: Verifikation ───────────────────────────────────

-- Setup prüfen
SELECT id, slug, niche, status FROM setups WHERE slug = 'derstarkdenker';

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
WHERE setup_id = '<<SETUP_ID>>';

-- Vault prüfen (nach Token-Eintrag)
SELECT
  platform,
  token_type,
  expires_at,
  LEFT(pgp_sym_decrypt(token_value, current_setting('app.vault_key'))::TEXT, 15) AS token_preview
FROM vault
WHERE setup_id = '<<SETUP_ID>>'
ORDER BY platform, token_type;
