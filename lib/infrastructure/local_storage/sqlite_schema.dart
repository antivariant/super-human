class SQLiteSchema {
  static const String createSessions = '''
CREATE TABLE IF NOT EXISTS sessions (
  session_id TEXT PRIMARY KEY,
  plugin_id TEXT NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT,
  seed INTEGER NOT NULL,
  status TEXT NOT NULL
);
''';

  static const String createAttempts = '''
CREATE TABLE IF NOT EXISTS absolute_pitch_attempts (
  attempt_id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL,
  note_prompt TEXT NOT NULL,
  answer_opened_at TEXT,
  submitted_at TEXT,
  submission_mode TEXT,
  submitted_note TEXT,
  is_correct INTEGER,
  next_allowed_at TEXT,
  state TEXT NOT NULL
);
''';

  static const String createCooldowns = '''
CREATE TABLE IF NOT EXISTS cooldowns (
  plugin_id TEXT PRIMARY KEY,
  cooldown_minutes INTEGER NOT NULL,
  last_completed_session_at TEXT
);
''';

  static const String createDailyStats = '''
CREATE TABLE IF NOT EXISTS daily_plugin_stats (
  plugin_id TEXT NOT NULL,
  day TEXT NOT NULL,
  attempt_count INTEGER NOT NULL,
  correct_count INTEGER NOT NULL,
  PRIMARY KEY (plugin_id, day)
);
''';
}
