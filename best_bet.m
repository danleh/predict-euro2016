function best_bet_goals = best_bet( teamA, teamB )
    % Typically, for "tip games" or bets you will still get some points
    % (albeit lesser) if you at least have the goal difference or the
    % winning team correct, even if you guessed the goal count wrong.
    % So we don't just want to maximize the probability for a goal result,
    % but rather the expected value of the betting game.
    
    % In my case, you get 4 points for the exact result, 2 points for the 
    % correct winning team (or draw), and 3 points for the correct goal 
    % difference (if the game was not a draw, otherwise you get just 2 points).
    
    % get the data...
    [most_probable_goals, ...
    probability_winA, probability_winB, probability_draw, ...
    goal_range, goal_combinations, probabilities, ...
    goal_differences, goal_difference_probabilities] = predict(teamA, teamB);

    goal_differences_nonunique = goal_combinations(1,:) - goal_combinations(2,:);
    
    % for each possible bet, compute the expected value of the betting game
    expected_value = probabilities;
    for i = 1:length(goal_combinations)
        if goal_combinations(1,i) > goal_combinations(2,i)
            expected_value(i) = expected_value(i) + 2 * probability_winA ...
                + goal_difference_probabilities(goal_differences == goal_differences_nonunique(i));
        elseif goal_combinations(1,i) < goal_combinations(2,i)
            expected_value(i) = expected_value(i) + 2 * probability_winB ...
                + goal_difference_probabilities(goal_differences == goal_differences_nonunique(i));
        else
            expected_value(i) = 2 * expected_value(i) + 2 * probability_draw;
        end
    end
    
    % plot in the same way as the goals distribution
    expected_value_grid = reshape(expected_value,length(goal_range),length(goal_range));
    figure(3);
    handle = bar3(expected_value_grid);
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
    title('Exptected Value of Bet on Goals');
    xlabel(['Goals for ' capital(teamA)]);
    ylabel(['Goals for ' capital(teamB)]); 
    zlabel('Expected Value');
    % nice angle
    view(45,30);

    % the best bet is where the expected value is maximized (so argmax)
    best_bet_goals = goal_combinations(:,expected_value == max(expected_value));

end