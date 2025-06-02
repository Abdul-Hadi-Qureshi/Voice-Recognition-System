
% Initialize variables to store recognition results
recognition_results = zeros(n, n);

for k = 1:n
    % Construct the filename for the k-th test file
    file = fullfile('test', sprintf('s%d.wav', k));
    
    % Check if the file exists
    if exist(file, 'file')
        % Read the audio file
        [s, fs] = audioread(file);
        
        % Compute MFCC features
        v = mfcc(s, fs);
        
        % Initialize variables for matching
        distmin = inf;
        k1 = 0;
        distances = zeros(1, length(code));
        
        % Compare with each trained codebook and compute distortion
        for l = 1:length(code)
            d = distance(v, code{l});
            dist = sum(min(d,[],2)) / size(d,1);
            distances(l) = dist;

            if dist < distmin
                distmin = dist;
                k1 = l;
            end
        end

        % Display matching result
        msg = sprintf('Test file %s matches with speaker %d', file, k1);
        disp(msg);
        
        % Plotting the distance between the test file's MFCC and each speaker's codebook
        figure;
        bar(distances);
        title(sprintf('Distance to Codebooks for Test File %d', k));
        xlabel('Speaker');
        ylabel('Distance');
        xticks(1:length(code));
        xticklabels({'Speaker 1', 'Speaker 2', 'Speaker 3', 'Speaker 4', 'Speaker 5'});
        grid on;

        % Store recognition result
        recognition_results(k, k1) = 1;
    else
        % Display a warning if the file is not found
        warning('File %s not found. Skipping...', file);
    end

    % Plotting the recognition results
    figure;
    stem(recognition_results(k, :), 'LineWidth', 2);
    title(sprintf('Recognition Results for Test File %d', k));
    xlabel('Speaker');
    ylabel('Recognition');
    xticks(1:length(code));
    xticklabels({'Speaker 1', 'Speaker 2', 'Speaker 3', 'Speaker 4', 'Speaker 5'});
    ylim([0 1]);
    grid on;
end
