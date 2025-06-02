function code = train(traindir, n)
    % Speaker Recognition: Training Stage
    % Input:
    %       traindir : string name/path of directory contains all train sound files
    %       n        : number of train files in traindir
    % Output:
    %       code     : trained VQ codebooks, code{i} for i-th speaker
    % Note:
    %       Sound files in traindir are supposed to be: 
    %                       s1.wav, s2.wav, ..., sn.wav
    % Train Example
    %     traindir = 'train'; % Directory containing training files
    % n = 5; % Number of training files
    % code = train(traindir, n);
    
    k = 16;                         % number of centroids required
    code = cell(1, n);             % Initialize cell array to store codebooks

    % Iterate through each speaker
    for i = 1:n
        % Construct filename for the i-th speaker
        file = fullfile(traindir, sprintf('s%d.wav', i));
        
        % Check if the file exists
        if exist(file, 'file')
            [s, fs] = audioread(file);
            v = mfcc(s, fs);            % Compute MFCC's
            code{i} = vqCodeBook(v, k); % Train VQ codebook
        else
            warning('File %s not found. Skipping...', file);
        end
         figure;
    scatter(code{i}(1,:), code{i}(2,:), 'filled');
    title(sprintf('Codebook for Speaker %d', i));
    xlabel('Feature 1');
    ylabel('Feature 2');
    grid on;

    end


end

