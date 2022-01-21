SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season 
FROM [got-dialogues] 
WHERE Speaker=''
LIMIT 1

DELETE
FROM [got-dialogues]
WHERE SPEAKER = ''

SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season 
FROM [got-dialogues]
WHERE Speaker LIKE '%#%'
LIMIT 1

DELETE
FROM [got-dialogues]
WHERE Speaker LIKE '%#%'

SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season 
FROM [got-dialogues]
WHERE Speaker LIKE '%ALL%' 
LIMIT 1

DELETE
FROM [got-dialogues]
WHERE Speaker LIKE '%ALL%'

SELECT substr(Text,1,20)||'...' as 'Text',
Speaker,
Episode,
Season 
FROM [got-dialogues]
GROUP BY Speaker
HAVING COUNT(*)=1
LIMIT 1

DELETE
FROM [got-dialogues]
where Speaker in (SELECT Speaker
FROM [got-dialogues]
GROUP BY Speaker
HAVING COUNT(*)=1)

UPDATE [got-dialogues]
SET Speaker = UPPER(Speaker)

SELECT substr(Text,1,20)||'...' as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
LIMIT 5

SELECT Season,
COUNT(*)
FROM [got-dialogues]
GROUP BY Season

SELECT Speaker,
COUNT(*)
FROM [got-dialogues]
GROUP BY Speaker
ORDER BY 2 DESC
LIMIT 10

SELECT Speaker,
COUNT(*)
FROM [got-dialogues]
GROUP BY Speaker

SELECT Season,
length(Text)
FROM [got-dialogues]

SELECT Season,
(SELECT Speaker 
FROM [got-dialogues] as inner 
WHERE outer.Season=inner.Season
GROUP BY Speaker 
ORDER BY COUNT(*) 
DESC LIMIT 1 ) as TopSpeaker, 
(SELECT COUNT(*)
FROM [got-dialogues] as inner
WHERE outer.Season=inner.Season
GROUP BY Speaker 
ORDER BY COUNT(*) DESC
LIMIT 1) as Amount 
FROM (SELECT DISTINCT Season FROM [got-dialogues]) as outer

SELECT Season,
COUNT(*)
FROM [got-dialogues]
WHERE Season !='season-01'
GROUP BY Season

SELECT substr(Season,9,10),
COUNT(*)
FROM [got-dialogues]
WHERE Season !='season-01'
GROUP BY Season

