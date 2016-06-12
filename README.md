# Predicting the UEFA Euro 2016 Championship Results
This is a crude attempt at predicting the results of individual games of the group stage of the European soccer championships 2016. 

## Basic Idea

1. Obtain some kind of "rating" or "strength factor" for each participating national team. This could be an Elo number (e.g. the [World Football Elo Ratings](https://en.wikipedia.org/wiki/World_Football_Elo_Ratings) from [this website](http://www.eloratings.net/world.html) or some otherwise comparable number, e.g. the [FIFA/Coca-Cola World Rating](http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html) for national soccer teams.
2. Learn from past games of two competing teams how their "Elo number" affects the final score of their game. Formally speaking, we want to learn a function of 2 numbers to 2 other numbers, i.e. a mapping ```f: R^2 -> R^2```. This is a prime candidate for simple machine learning methods.
3. TODO

## Results so far

TODO

## Similar Projects, Articles, Sources

TODO 

## Ideas for Improvement, TODOs

TODO

## Legal Disclaimer
Copyright 2016, danleh. 

By [GitHub's Terms of Service](https://help.github.com/articles/github-terms-of-service/#f-copyright-and-content-ownership) you are allowed to view and fork this repository. However, I deliberately do _not_ provide the code under any kind of open source license that allows modification or use of the code.

Also, this software is provided "as is", _without warranty of any kind_, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfrindgement. In no event shall the author or copyright holder be liable for any claim, damages or other liability, whether in action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

In particular, I strongly advise against using this software or even the underlying model to make bets, monetary or otherwise, on the outcome of these or other sports events. Bookmakers, betting website owners, and even other participants are likely to have more elaborate models for prediction and have a lot more data to train these models on. _You have been warned_. What you do with your money is purely your buisness.
