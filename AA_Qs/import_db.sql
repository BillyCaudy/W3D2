-- DROP TABLE [IF EXISTS] question_likes;
-- DROP TABLE [IF EXISTS] replies;
-- DROP TABLE [IF EXISTS] questions_follows;
-- DROP TABLE [IF EXISTS] questions;
-- DROP TABLE [IF EXISTS] users;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jack','Black'),
  ('Jill','Thrill'),
  ('Sexy','Sady'),
  ('Polythene','Pam'),
  ('Babylon','Drifter');

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('wtf', 'Seriously, WTF?', (SELECT id FROM users WHERE fname='Jack' AND lname='Black')),
  ('everything', 'What is the answer to life, the universe, and everything?', (SELECT id FROM users WHERE fname='Jill' AND lname='Thrill')),
  ('dreamer', 'We are like the dreamer who dreams and then lives in the dream. But who is the dreamer?', (SELECT id FROM users WHERE fname='Sexy' AND lname='Sady')),
  ('woodchuck', 'How much wood could a woodchuck chuck if a woodchuck could chuck wood?', (SELECT id FROM users WHERE fname='Polythene' AND lname='Pam'));

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_follows (user_id, question_id)
VALUES 
  ((SELECT id FROM users WHERE fname='Jack' AND lname='Black'), (SELECT id FROM questions WHERE title = 'everything')),
  ((SELECT id FROM users WHERE fname='Jill' AND lname='Thrill'), (SELECT id FROM questions WHERE title = 'everything')),
  ((SELECT id FROM users WHERE fname='Sexy' AND lname='Sady'), (SELECT id FROM questions WHERE title = 'everything')),
  ((SELECT id FROM users WHERE fname='Polythene' AND lname='Pam'), (SELECT id FROM questions WHERE title = 'everything')),
  ((SELECT id FROM users WHERE fname='Babylon' AND lname='Drifter'), (SELECT id FROM questions WHERE title = 'everything')),
  ((SELECT id FROM users WHERE fname='Jack' AND lname='Black'), (SELECT id FROM questions WHERE title = 'dreamer')),
  ((SELECT id FROM users WHERE fname='Jill' AND lname='Thrill'), (SELECT id FROM questions WHERE title = 'woodchuck')),
  ((SELECT id FROM users WHERE fname='Sexy' AND lname='Sady'), (SELECT id FROM questions WHERE title = 'woodchuck'));

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

INSERT INTO
  replies (body, user_id, question_id, parent_id)
VALUES 
  ('42',
    (SELECT id FROM users WHERE fname='Sexy' AND lname='Sady'), 
    (SELECT id FROM questions WHERE title = 'everything'),
    NULL
  ),
  ('SO MUCH',
    (SELECT id FROM users WHERE fname='Jill' AND lname='Thrill'), 
    (SELECT id FROM questions WHERE title = 'woodchuck'),
    NULL
  );

  INSERT INTO
    replies (body, user_id, question_id, parent_id)
  VALUES
  ('What was the question?',
    (SELECT id FROM users WHERE fname='Babylon' AND lname='Drifter'), 
    (SELECT id FROM questions WHERE title = 'everything'),
    (SELECT id FROM replies WHERE body = '42')
  );

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES 
  ((SELECT id FROM users WHERE fname='Sexy' AND lname='Sady'), (SELECT id FROM questions WHERE title = 'everything'));


