# Predicting the UEFA Euro 2016 Championship Results
This is a crude attempt at predicting the results of individual games of the group stage of the European soccer championships 2016 with MATLAB.

## Basic Idea

1. Obtain some kind of "rating" or "strength factor" for each participating national team. This could be an Elo number (e.g. the [World Football Elo Ratings](https://en.wikipedia.org/wiki/World_Football_Elo_Ratings) from [this website](http://www.eloratings.net/world.html)) or some otherwise comparable number (e.g. the [FIFA/Coca-Cola World Rating](http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html) for national soccer teams).
2. Learn from past games of two competing teams how their "Elo number" affects the final score of their game. Formally speaking, we want to learn a function of 2 numbers to 2 other numbers, i.e. a mapping ```f: R^2 -> R^2```. This is a prime candidate for simple machine learning methods. I chose [ordinary least squares (OLS)](https://en.wikipedia.org/wiki/Ordinary_least_squares) to estimate a _linear function_ from 2D to 2D. (Since a function from 2D to 1D is essentially an equation describing a plane in 3D, our function is a hyperplane in 4D. Because of OLS it has minimal squared distance from the training data points.)
3. We could already use the result of this function to predict the scored goals. However, there are two problems:
  + It is continuous, e.g. the result could be 2.732 vs. 1.231 goals. Soccer only allows a natural number of goals, though ;)
  + We not only want the most probable exact goal count, but maybe also the winning probability for each team, the probability for a draw, or the probability for a particular goal difference.
4. So instead we assume the outcome of the function is really the expected value of goals scored per team. Other sources suggest (see below) that this number is approximately [Poisson-distributed](https://en.wikipedia.org/wiki/Poisson_distribution) for soccer games. Conveniently, the mean of the Poisson distribution is also its only parameter λ. So we set the result of our function as the two parameters of a two dimensional Poisson distribution. (It can simply be obtained by multiplying two 1D Poisson distrubtions since the area under a 1D [probability mass function (PMF)](https://en.wikipedia.org/wiki/Probability_mass_function) is 1 and their product (the volume under the surface of the 2D Poisson distribution) will thus also be 1, making it a correct PMF.)
5. Then we can sample this 2D PMF at every possible combination of goals. That is, we can answer (only approximately, of course) "How probable is the exact result of 3:1 in a match between Spain and Italy?". By adding up all probabilites where the number goals for team A is larger than the number of goals for team B, we get the winning probability for team A. Similarly, we can obtain the probability of a draw as the sum of all probabilities where the goal counts are equal, etc. pp.

## Results so far

As of 2016-06-13 02:00 CEST:

| Match | Predicted Goals | Actual Goals | Result |
| --- | --- | --- | --- |
| FRA:ROU | 2:1 | 2:1 | correct |
| ALB:CH | 0:1 | 0:1 | correct |
| WAL:SVK | 1:1 | 2:1 | wrong |
| ENG:RUS | 1:1 | 1:1 | correct |
| TUR:KRO | 1:1 | 0:1 | wrong |
| POL:NIR | 1:1 | 1:0 | wrong |
| DEU:UKR | 2:1 | 2:0 | wrong goals, correct winner |

First observation: Similarly strong teams result in a draw prediction. This is undesirable, because even though this might be the most probable exact goal result, one would rather like to correctly predict the overall winner of the game, even if the exact goal prediction was wrong. 

## Example Plots for France vs. Romania

![Probability distribution for the possible goal combinations](https://raw.githubusercontent.com/danleh/predict-euro2016/master/plots/exact-result-pmf.png)

![Probability distribution for the possible goal differences](https://raw.githubusercontent.com/danleh/predict-euro2016/master/plots/goal-difference-pmf.png)

The best bet does not necessarily have to be the most probable outcome, for example, because if you bet on the correct winner you still get some points, even though the result (goal count) is not exact.
![Expected value for possible goal combination bets](https://raw.githubusercontent.com/danleh/predict-euro2016/master/plots/betting-expected-value.png)

## Similar Projects, Articles, Sources

1. Higgins, McDowell, and Milne. _Modeling and Predicting Football Results_. Wolfram Community, 2015. http://community.wolfram.com/groups/-/m/t/517631
  + The first article I read about the topic. Attempts to predict outcomes for the soccer world cup 2014. Basis of my assumption that the number of goals per match is approximately Poisson-distributed. Interesting assessment of home advantage. Also talks about the knock-out tree.
2. Etienne Bernard. _Predicting Who Will Win the World Cup with Wolfram Language_. Wolfram Blog, June 20, 2014. http://blog.wolfram.com/2014/06/20/predicting-who-will-win-the-world-cup-with-wolfram-language/
  + Tries to predict 2013/2014 English Premier League results based on training data from the previous season. Additional evidence for the Poisson-distribution hypothesis. Very interesting idea of "offensive" and "defensive" score per team. Quite high accuracy (to my understanding): 58% correct outcome (who wins), 8% correct exact result (goals scored).
3. Hatzius, Stehn, and Millar. _The Econometrician’s Take on Euro 2016_. Goldman Sachs - Our Thinking - Macroeconomic Insights, originally published June 3, 2016. http://www.goldmansachs.com/our-thinking/macroeconomic-insights/euro-cup-2016/index.html
  + Actually read that after my implementation. Seems to use a very similar model :). Nice links for further reading.

## Ideas for Improvement, Unsubstantiated Assumptions, Questions, TODOs

- TODO (!): Do proper (leave one out) cross-validation on the different types of Elo numbers and the learned function (e.g. linear vs polynomial)
- TODO: Add prediction of knock-out stage results. (E.g. Who will be in the semi finals? Who will be in the final? Who wins the tournament and how probable is this outcome?)
- Is the relation between rating and scored goals linear at all?
- Is the 2D distribution of goal results really a 2D Poisson distribution? In particular, would it be possible that draw situations are less probable in reality because both teams switch to a more "aggressive tactic"?
- Idea: Map input data to some higher-dimensional "feature space" first, then learn linear function in this space. E.g. using the basis functions ```[1, x, x^2]``` we could fit a hyperbole through the data points instead of a (hyper-)plane.
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

By [GitHub's Terms of Service](https://help.github.com/articles/github-terms-of-service/#f-copyright-and-content-ownership) you are allowed to view and fork this repository. However, I deliberately do _not_ provide the code under any kind of open source license that allows modification or use of the source code.

Also, this software is provided "as is", _without warranty of any kind_, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfrindgement. In no event shall the author or copyright holder be liable for any claim, damages or other liability, whether in action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

In particular, I strongly advise against using this software or even the underlying model to make bets, monetary or otherwise, on the outcome of these or other sports events. Bookmakers, betting website owners, and even other participants are likely to have more elaborate models for prediction and have a lot more data to train these models on. _You have been warned_. What you do with your money is purely your buisness.
