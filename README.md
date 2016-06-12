# Predicting the UEFA Euro 2016 Championship Results
This is a crude attempt at predicting the results of individual games of the group stage of the European soccer championships 2016. The basic idea is:

1. Obtain some kind of "rating" or "strength factor" for each participating national team. This could be an Elo number (e.g. the [World Football Elo Ratings](https://en.wikipedia.org/wiki/World_Football_Elo_Ratings) from [this website](http://www.eloratings.net/world.html) or some otherwise comparable number, e.g. the [FIFA/Coca-Cola World Rating](http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html).
2. Learn from past games of two competing teams how their "Elo number" affects the final score of their game. Formally speaking, we want to learn a function of 2 numbers to 2 other numbers, i.e. a mapping ```f: R^2 -> R^2```. This is a prime candidate for simple machine learning methods.
