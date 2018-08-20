# sql-challenge

## Introduction
In this challenge, I have created a Python script to perform sentiment analysis of the social media activities of 5 major news sources (BBC, CBS, CNN, Fox, and New York times), and visualized the insights.

Using the Tweepy API on Python, I have pulled 100 most recent tweets from each of the five media's official Twitter account. 

## Python Modules: Pre-Requisites
tweepy<br />
numpy<br />
pandas<br />
matplotlib<br />
Twitter API: onsumer_key, consumer_secret, access_token, access_token_secret

## Findings 
According to Figure 2 Barplot: Overall Media Sentiment based on Twitter, New York Times distinguishes itself with highest average of compound sentiments from the other 4 medias. This in fact is a very unexpected result as the sample figure shown in the instruction displays that New York Times to have the most positive average compound sentiments and BBC as the most negative average sentiments. <br />

This inconsistency makes me question the effectiveness of relying on VADER analysis for accurate representation of Twitter's sentiment analysis. Another insights would be that since 100 tweets happen over the course of a day or two, a much broader sample size of tweets and date range should be considered to drive a conclusion on media's general sentiment.

## Author
Eric Jung
