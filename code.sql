-- Interesują nas dialogi wypowiedziane tylko przez postacie w serialu (wpis Speaker nie może być pusty).
DELETE
FROM [got-dataset]
WHERE SPEAKER = ''
-- [17:46:46] Query finished in 0.028 second(s). Rows affected: 206

-- Usuwamy dialogi postaci w tle, przedstawianych jako np. Woman #4
DELETE
FROM [got-dataset]
WHERE Speaker LIKE '%#%'
--[17:46:46] Query finished in 0.028 second(s). Rows affected: 206

-- Usuwamy wspólne dialogi, dotyczy pozycji typu 'ALL TOGETHER', 'ALL THREE', 'ALL AT THE BACK'
DELETE
FROM [got-dataset]
WHERE Speaker LIKE '%ALL%'
--[17:46:55] Query finished in 0.033 second(s). Rows affected: 177

-- Usuwamy pojedyncze, mało znaczące wypowiedzi 
DELETE
FROM [got-dataset]
where Speaker in (SELECT Speaker
FROM [got-dataset]
GROUP BY Speaker
HAVING COUNT(*)=1)
--[17:56:40] Query finished in 0.045 second(s). Rows affected: 338

-- W bazie danych pojawiają się wpisy typu Speaker='Roose' oraz Speaker='ROOSE', dlatego trzymamy się jednej wersji:
UPDATE [got-dataset]
SET 
    Speaker = UPPER(Speaker);
-- [17:47:42] Query finished in 0.042 second(s). Rows affected: 24459

SELECT Season, COUNT(*)
FROM [got-dataset]
GROUP BY Season

-- [17:20:12] Query finished in 0.008 second(s).
-- season-01	3374
-- season-02	4199
-- season-03	4027
-- season-04	3605
-- season-05	3078
-- season-06	2854
-- season-07	2209
-- season-08	1496

SELECT Season, Episode, COUNT(*)
FROM [got-dataset]
GROUP BY Season, Episode

-- [17:22:48] Query finished in 0.011 second(s).
-- season-01	e1-Winter is Coming	324
-- season-01	e10-Fire and Blood	268
-- season-01	e2-The Kings Road	286
-- season-01	e3-Lord Snow	356
-- season-01	e4-Cripples Bastards and Broken Things	403
-- season-01	e5-The Wolf and The Lion	421
-- season-01	e6-A Golden Crown	296
-- season-01	e7-You Win or You Die	284
-- season-01	e8-The Pointy End	374
-- season-01	e9-Baelor	362
-- season-02	e1-The North Remembers	376
-- season-02	e10-Valar Morghulis	383
-- season-02	e2-The Night Lands	441
-- season-02	e3-What is Dead May Never Die	375
-- season-02	e4-Garden of Bones	388
-- season-02	e5-The Ghost Of Harrenhal	447
-- season-02	e6-The Old Gods and the New	472
-- season-02	e7-A Man Without Honor	454
-- season-02	e8-The Prince of Winterfell	445
-- season-02	e9-Blackwater	418
-- season-03	e1-Valar Dohaeris	379
-- season-03	e10-Mhysa	442
-- season-03	e2-Dark Wings Dark Words	497
-- season-03	e3-Walk of Punishment	411
-- season-03	e4-And Now His Watch is Ended	389
-- season-03	e5-Kissed by Fire	454
-- season-03	e6-The Climb	352
-- season-03	e7-The Bear and the Maiden Fair	457
-- season-03	e8-Second Sons	340
-- season-03	e9-The Rains of Castamere	306
-- season-04	e1-Two Swords	496
-- season-04	e10-The Children	323
-- season-04	e2-The Lion and the Rose	412
-- season-04	e3-Breaker of Chains	429
-- season-04	e4-Oathkeeper	302
-- season-04	e5-First of His Name	419
-- season-04	e6-The Laws of God and Men	333
-- season-04	e7-Mockingbird	350
-- season-04	e8-The Mountain and the Viper	318
-- season-04	e9-The Watchers on the Wall	223
-- season-05	e1	312
-- season-05	e10	243
-- season-05	e2	376
-- season-05	e3	368
-- season-05	e4	308
-- season-05	e5	288
-- season-05	e6	327
-- season-05	e7	321
-- season-05	e8	287
-- season-05	e9	248
-- season-06	e1	225
-- season-06	e10	280
-- season-06	e2	281
-- season-06	e3	280
-- season-06	e4	378
-- season-06	e5	320
-- season-06	e6	279
-- season-06	e7	277
-- season-06	e8	342
-- season-06	e9	192
-- season-07	e1	286
-- season-07	e2	314
-- season-07	e3	373
-- season-07	e4	300
-- season-07	e5	371
-- season-07	e6	148
-- season-07	e7	417
-- season-08	e1	314
-- season-08	e2	418
-- season-08	e4	483
-- season-08	e6	281


SELECT Speaker, COUNT(*)
FROM [got-dataset]
GROUP BY Speaker
ORDER BY 2 DESC
LIMIT 10

-- TYRION	1543
-- CERSEI	901
-- JON	877
-- JAIME	864
-- DAENERYS	855
-- SANSA	710
-- ARYA	669
-- DAVOS	501
-- THEON	411
-- BRONN	400