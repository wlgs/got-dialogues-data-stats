knitr::opts_chunk$set(warning = FALSE, message = FALSE)
library(DBI)
library(dbplot)
library(dplyr)
library(ggplot2)
con <- dbConnect(drv = RSQLite::SQLite(), dbname = "data/got-dataset.db")
dbListTables(con)

query <- "
SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
WHERE Speaker=''
LIMIT 1"
dbGetQuery(con, query)

query <- "
DELETE
FROM [got-dialogues]
WHERE SPEAKER = ''"
res <- dbSendStatement(con, query)

query <- "
SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
WHERE Speaker LIKE '%#%'
LIMIT 1"
dbGetQuery(con, query)

query <- "
DELETE
FROM [got-dialogues]
WHERE Speaker LIKE '%#%'"
res <- dbSendStatement(con, query)

dbGetRowsAffected(res)
dbClearResult(res)

query <- "
SELECT substr(Text,1,20)||'...'as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
WHERE Speaker LIKE '%ALL%'
LIMIT 1"
dbGetQuery(con, query)

query <- "
DELETE
FROM [got-dialogues]
WHERE Speaker LIKE '%ALL%'"
res <- dbSendStatement(con, query)

dbGetRowsAffected(res)
dbClearResult(res)

query <- "
SELECT substr(Text,1,20)||'...' as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
GROUP BY Speaker
HAVING COUNT(*)=1
LIMIT 1"
dbGetQuery(con, query)

query <- "
DELETE
FROM [got-dialogues]
where Speaker in (SELECT Speaker
FROM [got-dialogues]
GROUP BY Speaker
HAVING COUNT(*)=1)"
res <- dbSendStatement(con, query)

dbGetRowsAffected(res)
dbClearResult(res)

query <- "
UPDATE [got-dialogues]
SET Speaker = UPPER(Speaker)"
res <- dbSendStatement(con, query)
dbGetRowsAffected(res)
dbClearResult(res)

query <- "
SELECT substr(Text,1,20)||'...' as 'Text',
Speaker,
Episode,
Season
FROM [got-dialogues]
LIMIT 5"
dbGetQuery(con, query)

df <- dbGetQuery(con, "
SELECT Season,
COUNT(*)
FROM [got-dialogues]
GROUP BY Season")
ggplot(data = df, aes(x = df[, 1], y = df[, 2])) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_text(aes(label = df[, 2]), vjust = 1) +
  labs(x = "", y = "Ilosc dialogów") +
  theme_minimal()

summary(df[, 2])
var(df[, 2])
sd(df[, 2])

df <- dbGetQuery(con, "
SELECT Speaker,
COUNT(*)
FROM [got-dialogues]
GROUP BY Speaker
ORDER BY 2 DESC
LIMIT 10")
ggplot(data = df, aes(x = df[, 1], y = df[, 2])) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_text(aes(label = df[, 2]), vjust = 1) +
  labs(x = "", y = "Ilosc kwestii") +
  theme_minimal()

df <- dbGetQuery(con, "
SELECT Speaker,
COUNT(*)
FROM [got-dialogues]
GROUP BY Speaker")

summary(df[, 2])
var(df[, 2])
sd(df[, 2])

df <- dbGetQuery(con, "
SELECT Season,
length(Text)
FROM [got-dialogues]")
ggplot(data = df, aes(x = df[, 1], y = df[, 2])) +
  geom_jitter(size = 0.1, position = position_jitter(0.45), color = "blue") +
  labs(
    x = "",
    y = "Dlugosc kwestii [znaki]",
    caption = "(Kropka odpowiada pojedynczej wypowiedzianej kwestii)"
  ) +
  theme_minimal()

summary(df[, 2])
var(df[, 2])
sd(df[, 2])

df <- dbGetQuery(con, "
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
FROM (SELECT DISTINCT Season FROM [got-dialogues]) as outer")

ggplot(data = df, aes(x = df[, 1], y = df[, 3])) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_text(aes(label = paste(df[, 2], df[, 3])), vjust = -0.4) +
  labs(x = "", y = "Ilosc kwestii") +
  theme_minimal()

summary(df[, 3])
var(df[, 3])
sd(df[, 3])

df <- dbGetQuery(con, "
SELECT Season,
COUNT(*)
FROM [got-dialogues]
WHERE Season !='season-01'
GROUP BY Season")
ggplot(data = df, aes(x = df[, 1], y = df[, 2])) +
  geom_point(stat = "identity", fill = "lightblue") +
  geom_text(aes(label = df[, 2]), vjust = -0.4) +
  labs(x = "", y = "") +
  scale_y_continuous(name = "Ilosc kwestii", limits = c(0, 4500)) +
  theme_minimal()

df <- dbGetQuery(con, "
SELECT substr(Season,9,10),
COUNT(*)
FROM [got-dialogues]
WHERE Season !='season-01'
GROUP BY Season")
df2 <- data.frame(x = as.numeric(df[, 1]), y = df[, 2])
model_lm <- lm(y ~ x, data = df2)
df_lm <- data.frame(x = 2:12)

summary(model_lm)

ggplot(df_lm, aes(x)) +
  stat_function(
    fun = function(x) coefficients(model_lm)[1] + x * (coefficients(model_lm)[2]),
    color = "turquoise4"
  ) +
  scale_x_continuous(
    "sezon",
    labels = as.character(df_lm$x),
    breaks = df_lm$x,
    limits = c(2, 12)
  ) +
  scale_y_continuous(name = "Ilosc kwestii", limits = c(0, 4500)) +
  labs(
    title = "Regresja liniowa ilosci kwestii w
       poszczególnych sezonach (wraz z predykcja)",
    caption = paste(
      "równanie regresji liniowej: y=",
      coefficients(model_lm)[2], "x + ",
      coefficients(model_lm)[1]
    )
  )

point <- -1 * (coefficients(model_lm)[1]) / (coefficients(model_lm)[2])
print(point)

dbDisconnect(con)
unlink("data/got-dataset.db")