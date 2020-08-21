%% chronometric function of behavioural session

% automate name of plot
file = dir(fullfile(cd, '*.mat'));
file_name = file.name;
load(file_name);
chrono_name = strcat( file_name(1 : end-4), '_chrono.png' );
psycho_name = strcat( file_name(1 : end-4), '_psycho.png' );

% Step 1: plot raw data of chronometric: hit / (hit+miss)

trialoutcome = fsm.trialoutcome;
ind_hit  = find(contains(trialoutcome,'Hit'));
ind_miss = find(contains(trialoutcome,'Miss'));
RT = [fsm.reactiontimes.RT].';
chronometric = RT(ind_hit);
TF = fsm.Stim2TF;
stimulus = TF(ind_hit);

% Step 2: plot medians of chronometric raw data
figure; boxplot(chronometric, stimulus);
h = findobj(gca, 'Tag', 'Median');
[h.YData];
median = unique(ans);
close

% plot chronometric
figure; scatter(stimulus,chronometric,'.');
hold on;
TF_vals = unique(stimulus);
f = fit(TF_vals', median', 'smoothingspline');
plot(f,TF_vals,median);
scatter(TF_vals, median, 'ko', 'filled');
set(findobj(gca,'type','line'),'linew',2, 'color', 'b')
hold off;
b = gca; legend(b,'off');
set(findobj(gcf,'type','axes'),'FontName','Arial','FontSize',10,'FontWeight','Normal', 'LineWidth', 1.5);
xlabel('Temporal Frequency of Change [Hz]');
ylabel('Reaction Time [s]');

% save plot
saveas(gcf, chrono_name);
close;

% psychometric curve
total_trials = length(ind_hit) + length(ind_miss);
prop_hits = ones(1);
for i = 1:length(TF_vals)
    prop_hits(1,i) = length(find(stimulus==TF_vals(1,i))) / total_trials;
end

figure; 
f = fit(TF_vals', prop_hits', 'Weibull');
plot(f,TF_vals,prop_hits);
hold on;
scatter(TF_vals, prop_hits, 'ko', 'filled');
set(findobj(gca,'type','line'),'linew',2, 'color', 'b')
hold off;
b = gca; legend(b,'off');
set(findobj(gcf,'type','axes'),'FontName','Arial','FontSize',10,'FontWeight','Normal', 'LineWidth', 1.5);
xlabel('Temporal Frequency of Change [Hz]');
ylabel('Proportion of Correct Detections');

% save plot
saveas(gcf, psycho_name);
close;









