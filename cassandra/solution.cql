CREATE KEYSPACE my_ks WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE my_ks;

-- user_id - partition key
-- created_at - clustering key
-- Для заданий 1-3
CREATE TABLE posts_by_user
(
    user_id    INT,
    post_id    INT,
    topic_id   INT,
    username   VARCHAR,
    content    TEXT,
    created_at TIMESTAMP,
    PRIMARY KEY (user_id, created_at)
) WITH CLUSTERING ORDER BY (created_at DESC);

-- topic_id - partition key
-- created_at - clustering_key
-- Для задания 4
CREATE TABLE posts_by_topic
(
    user_id    INT,
    post_id    INT,
    topic_id   INT,
    username   VARCHAR,
    created_at TIMESTAMP,
    PRIMARY KEY (topic_id, created_at)
) WITH CLUSTERING ORDER BY (created_at DESC);

-- Тестовые данные для posts_by_user
INSERT INTO posts_by_user(user_id, post_id, topic_id, username, content, created_at)
VALUES (1, 1, 1, 'User1', 'Content 1', '2023-12-14 23:21:31');
INSERT INTO posts_by_user(user_id, post_id, topic_id, username, content, created_at)
VALUES (2, 2, 1, 'User2', 'Content 1', '2023-12-15 22:21:31');
INSERT INTO posts_by_user(user_id, post_id, topic_id, username, content, created_at)
VALUES (2, 3, 1, 'User2', 'Content 1', '2023-12-15 23:00:00');
INSERT INTO posts_by_user(user_id, post_id, topic_id, username, content, created_at)
VALUES (1, 4, 1, 'User1', 'Content 1', '2023-12-15 23:21:31');

-- Задание 1
-- Запрос, который бы доставал посты заданного пользователя упорядоченные по времени создания поста - сначала новые.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT post_id, content, created_at
FROM posts_by_user
WHERE user_id = 1;

-- Задание 2
-- Запрос, который бы доставал последний пост заданного пользователя.
-- Запрос должен возвращать post_id, content, дату создания поста, username.
SELECT post_id, content, created_at, username
FROM posts_by_user
WHERE user_id = 1
LIMIT 1;

-- Задание 3
-- Запрос, который бы доставал посты заданного пользователя, опубликованные после заданной даты.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT post_id, content, created_at
FROM posts_by_user
WHERE user_id = 2
  AND created_at > '2023-12-15';

-- Тестовые данные для posts_by_topic
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (1, 1, 1, 'User1', '2023-12-15 23:59:59');
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (1, 4, 2, 'User1', '2023-12-15 23:20:31');
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (2, 5, 2, 'User2', '2023-12-15 23:20:32');
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (1, 2, 1, 'User1', '2023-12-14 23:59:59');
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (2, 3, 1, 'User2', '2023-12-15 23:19:31');
INSERT INTO posts_by_topic(user_id, post_id, topic_id, username, created_at)
VALUES (2, 6, 1, 'User2', '2023-12-15 23:21:31');

-- Задание 4.
-- Запрос, который бы доставал пользователей, которые сделали пост в заданный день по заданной теме, упорядоченные по времени - сначала новые.
-- Запрос должен возвращать user_id, username, post_id, время создания поста.
SELECT user_id, username, post_id, created_at
FROM posts_by_topic
WHERE topic_id = 1
  AND created_at >= '2023-12-15'
  AND created_at < '2023-12-16'
