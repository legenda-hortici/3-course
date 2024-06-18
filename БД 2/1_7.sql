use discogs;

select * from artist limit 1000;

-- Составляются и выполняются запросы:
-- a) Найти информацию по заданному исполнителю, используя его имя
CREATE INDEX idx_artist_name ON artist (name);
CREATE INDEX idx_namevariation_name ON namevariation (name);
SET profiling=1;
SELECT * FROM artist WHERE NAME = 'Mr. C';
show profiles;
drop index idx_artist_name on artist;
drop index idx_namevariation_name on namevaration;

-- b) Найти всех участников указанного музыкального коллектива (по названию коллектива)
CREATE index idx_artist_name ON artist (NAME);
SET profiling=1;
SELECT artist.REALNAME FROM artist WHERE artist.NAME = '808 State';
SHOW PROFILES;
drop index idx_artist_name on artist;

-- c) Найти всех исполнителей, в описании (профиле) которых встречается указанное выражение, с использованием полнотекстового запроса.
CREATE FULLTEXT INDEX index_profile_description ON artist(PROFILE);
SET profiling=1;
SELECT * FROM artist WHERE MATCH(artist.PROFILE) AGAINST ('German duo, split in 2005.');
SHOW PROFILES;
drop index index_profile_description on artist;

-- Найти все релизы заданного исполнителя и отсортировать их по дате выпуска. Вывести имя исполнителя, название релиза, дату выхода. 
CREATE INDEX index_release_artist ON release_artist(NAME, RELEASE_ID);
SET profiling=1;
SELECT ra.NAME AS 'Исполнитель', 
       r.TITLE AS 'Название релиза', 
       r.RELEASED AS 'Дата выхода'
FROM release_artist ra
INNER JOIN `release` r ON ra.RELEASE_ID = r.RELEASE_ID
WHERE ra.NAME = 'Mr. C'
ORDER BY r.RELEASED;
SHOW PROFILES;
drop index index_release_artist on release_artist;

-- Найти все главные релизы, выпущенные в указанный год, с указанием стиля релиза. 
-- Релиз является главным, если поле release.IS_MAIN_RELEASE = 1
CREATE INDEX idx_release_date ON `release`(RELEASED);
set profiling=1;
SELECT r.TITLE AS 'Название релиза', 
       s.STYLE_NAME AS 'Стиль релиза'
FROM `release` r
INNER JOIN style s ON r.RELEASE_ID = s.RELEASE_ID
WHERE r.RELEASED BETWEEN '1990-01-01' AND '2000-12-31'
  AND r.IS_MAIN_RELEASE = 1;
SHOW PROFILES;
drop index idx_release_date on `release`;













