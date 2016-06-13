function [most_probable_goals, ...
    probability_winA, probability_winB, probability_draw, ...
    goal_range, goal_combinations, probabilities, ...
    goal_differences, goal_difference_probabilities] = predict(teamA, teamB)
    % read 1000 international match results from 23 european countries 
    % played in the years 2014, 2015, and 2016. I collected them from 
    % http://www.rsssf.com/tablesl/landen-intres.html#euro
    % and used some "regexing"/scripting to bring them into a common
    % format. Each country (team) was mapped to the official FIFA World
    % Ranking found under http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html
    trainingdata_raw = csvread('data/elo1-elo2-goals1-goals2.csv');
    trainingdata_elos = trainingdata_raw(:,1:2);
    trainingdata_goals = trainingdata_raw(:,3:4);
    
    % the function to learn is from 2 Elo numbers to 2 goal outcomes, i.e.
    % f: R^2 -> R^2
    % mvregress uses Least Squares Regression to fit a hyperplane 
    % (expressed by the 2x2 matrix) through the 4D point cloud formed by
    % the training data with minimal squared error.
    % no ridge factor/regularization is used since I hope 1000 example data
    % points for a 2D linear function is enough to prevent overfitting...
    % TODO: Is this even a linear relation? One could try mapping the data
    % to a higher dimensional space first, e.g. polynomial with the basis
    % functions [1, x, x^2] and then regress. This would basically fit a 
    % 4D-hyperbole instead of a 4D-plane through the data. So far it works 
    % good without though...
    linear_mapping_elo_goals = mvregress(trainingdata_elos, trainingdata_goals);
    
    % also read a dictionary that maps countries to their resp. Elo number
    [elos, countries] = xlsread('data/country-elo.csv');

    % given two country names, get their Elo numbers from the dictionary
    % and put them in a vector
    contenders_elos = [elos(strcmp(teamA,countries)), elos(strcmp(teamB,countries))];
    
    % now use the previously computed 2D linear function from elos -> goals
    % to give us the expected number of goals.
    % Problem: we can only have a discrete/integer number of goals, but
    % here we might get (for example) "2.342 goals expected for team A"
    % Solution: assume the goals in soccer for one team are
    % Poisson-distributed (some empirical evidence that it holds:
    % - http://community.wolfram.com/groups/-/m/t/517631
    % - http://blog.wolfram.com/2014/06/20/predicting-who-will-win-the-world-cup-with-wolfram-language/
    % with parameters lambda.
    lambda = contenders_elos * linear_mapping_elo_goals;
    
    % the goal range (for each team) we want to evaluate on (above 10 seems
    % unrealistic, so we leave it at that)
    goal_range = 0:10;
    
    % all possible combinations on the 2D goal grid
    goal_combinations = combvec(goal_range, goal_range);
    
    % evaluate the poisson PMF at all sample points in parallel
    probabilities = prod(poisspdf(goal_combinations, repmat(lambda', 1, length(goal_range)^2)));
   
    % rearrange into 2D grid for plotting and plot PMF
    probabilities_grid = reshape(probabilities,length(goal_range),length(goal_range))';
    figure(1);
    handle = bar3(probabilities_grid);
    % proper axis ticks and no distance from y axis
    set(gca, 'XTickLabel', goal_range);
    set(gca, 'YTickLabel', goal_range);
    ylim(xlim);
    % color bars by height, see https://www.mathworks.com/help/matlab/creating_plots/color-3-d-bars-by-height-1.html
    for k = 1:length(handle)
        zdata = handle(k).ZData;
        handle(k).CData = zdata;
        handle(k).FaceColor = 'interp';
    end
    % proper captions
    title('PMF of Exact Goal Result');
    xlabel(['Goals for ' capital(teamA)]);
    ylabel(['Goals for ' capital(teamB)]); 
    zlabel('Probability of Exact Result');
    % nice angle
    view(45,30);

    % the most probable exact result is the argmax of the 2D PMF
    most_probable_goals = goal_combinations(:,probabilities == max(probabilities));
    
    % compute the probabilites for a win of team A, win of team B and draw
    % as the sum of the probabilities where # goals A > # goals B, 
    % # goals B > # goals A, # goals A == # goals B
    probability_winA = sum(probabilities(goal_combinations(1,:) > goal_combinations(2, :)));
    probability_winB = sum(probabilities(goal_combinations(1,:) < goal_combinations(2, :)));
    probability_draw = sum(probabilities(goal_combinations(1,:) == goal_combinations(2, :)));
    
    % the possible goal differences go from -max (when team B scores max
    % goals and team A 0) to +max
    goal_differences = -max(goal_range):max(goal_range);
    % just a temporary: 1 row for each goal_difference
    goal_difference_probabilities = repmat(probabilities, length(goal_differences), 1);
    % now, in each column there is the probability of the corresponding
    % goal difference from goal_differences
    goal_difference_probabilities = sum(goal_difference_probabilities .* ...
        bsxfun(@eq, goal_differences', goal_combinations(1,:) - goal_combinations(2,:)), 2)';
    % NOTE according to
    % - https://math.stackexchange.com/questions/1061440/sum-and-difference-between-two-independent-poisson-random-variables
    % - https://en.wikipedia.org/wiki/Skellam_distribution
    % the difference of two independent Poisson distributed random
    % variables is Skellam distributed, but we compute it explicitly
    % here for clarity.
    
    % plot the distribution of the goal differences (as seen from team A)
    figure(2);
    title('PMF of Goal Differences');
    bar(goal_differences, goal_difference_probabilities);
    xlabel(['Goal Difference (as seen from ' capital(teamA) ')']); 
    ylabel('Probability'); 
   
end