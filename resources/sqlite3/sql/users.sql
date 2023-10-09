CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    "username" TEXT,
    "password" BLOB,
    "is_admin" BOOLEAN DEFAULT FALSE
);