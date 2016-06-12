# Predicting the UEFA Euro 2016 Championship Results
This is a crude attempt at predicting the results of individual games of the group stage of the European soccer championships 2016. 

## Basic Idea

1. Obtain some kind of "rating" or "strength factor" for each participating national team. This could be an Elo number (e.g. the [World Football Elo Ratings](https://en.wikipedia.org/wiki/World_Football_Elo_Ratings) from [this website](http://www.eloratings.net/world.html) or some otherwise comparable number, e.g. the [FIFA/Coca-Cola World Rating](http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html) for national soccer teams.
2. Learn from past games of two competing teams how their "Elo number" affects the final score of their game. Formally speaking, we want to learn a function of 2 numbers to 2 other numbers, i.e. a mapping ```f: R^2 -> R^2```. This is a prime candidate for simple machine learning methods.
3. TODO

## Results so far

TODO

## Similar Projects, Articles, Sources

1. Higgins, McDowell, and Milne. _Modeling and Predicting Football Results_. Wolfram Community, 2015. http://community.wolfram.com/groups/-/m/t/517631
  + The first article I read about the topic. Attempts to predict outcomes for the soccer world cup 2014. Basis of my assumption that the number of goals per match is approximately Poisson-distributed. Interesting assessment of home advantage. Also talks about the knock-out tree.
2. Etienne Bernard. _Predicting Who Will Win the World Cup with Wolfram Language_. Wolfram Blog, June 20, 2014. http://blog.wolfram.com/2014/06/20/predicting-who-will-win-the-world-cup-with-wolfram-language/
  + Tries to predict 2013/2014 English Premier League results based on training data from the previous season. Additional evidence for the Poisson-distribution hypothesis. Very interesting idea of "offensive" and "defensive" score per team. Quite high accuracy (to my understanding): 58% correct outcome (who wins), 8% correct exact result (goals scored).
3. Hatzius, Stehn, and Millar. _The Econometrician’s Take on Euro 2016_. Goldman Sachs - Our Thinking - Macroeconomic Insights, originally published June 3, 2016. http://www.goldmansachs.com/our-thinking/macroeconomic-insights/euro-cup-2016/index.html
  + Actually read that after my implementation. Seems to use a very similar model :). Nice links for further reading.

## Ideas for Improvement, Unsubstantiated Assumptions, Questions, TODOs

- Is the relation between rating and scored goals linear at all?
- Idea: Use more features to describe a national team. 
  + Higgins et al. (see above) use an "offensive" vs. "defensive" score for each team in their prediction of the 2013/14 English Premier League season outcomes.
  + Identify each team with its "set of players". Good: Could potentially use a lot more data from national/club league matches. Problem: Is a team really only as strong as the sum of its players? How much influence does the trainer and his/her staff have?
  + Problem: Overfitting (see next point)
- Problem: For international matches there are not many datapoints. E.g. the German national team had only about 10 matches in 2015. How do we prevent overfitting if we have only ~20 data points over 2 years?
- Problem: The squad changes considerably over time, so results from 2010 are probably not very relevant for predictions in 2016. 
- Problem: The same applies to individual players. How constant is their "value" over time?
- Improvement: I assumed the _current_ Elo when learning on _past_ matches. This is of course bogus. One would have to take the Elo number at the time of the match. Problem: I do not know a source for old Elo numbers...

## Legal Disclaimer
Copyright 2016, danleh. 

By [GitHub's Terms of Service](https://help.github.com/articles/github-terms-of-service/#f-copyright-and-content-ownership) you are allowed to view and fork this repository. However, I deliberately do _not_ provide the code under any kind of open source license that allows modification or use of the code.

Also, this software is provided "as is", _without warranty of any kind_, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfrindgement. In no event shall the author or copyright holder be liable for any claim, damages or other liability, whether in action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

In particular, I strongly advise against using this software or even the underlying model to make bets, monetary or otherwise, on the outcome of these or other sports events. Bookmakers, betting website owners, and even other participants are likely to have more elaborate models for prediction and have a lot more data to train these models on. _You have been warned_. What you do with your money is purely your buisness.
