% Pipeline for the data pre-processing
% Including:
% 1. Loading
% 2. Bandpass filter
% 3. Re-reference to the ref channel X3
% 3. Artifact correction / rejection
% ---- need to decide btw correction and rejection
% 3.1. Eye blinks
% 3.2. Movements 
% 4. Convert to cvs or json for further analysis in Python

% Load eeglab set from the one created earlier
eeglab;
data_folder = 'D:\BCI\large_eeg_19ch_13subj';
set_name = 'SubjectJ_LRHand.set'; % need to make universal later
EEG = pop_loadset('filename', set_name, 'filepath', data_folder);

% Bandpass & notch filtering 
low_cutoff = 0.5; high_cutoff = 70;
EEG = pop_eegfiltnew(EEG, 'locutoff', low_cutoff, 'hicutoff', high_cutoff); 
EEG = pop_eegfiltnew(EEG, 'locutoff', 49, 'hicutoff', 51, 'revfilt', 1);  % Notch 

% Re-reference the data to the channel X3
EEG = pop_reref(EEG, find(strcmp({EEG.chanlocs.labels}, 'X3')));  

% Save for export in csv
csv_filename = 'SubjectJ_LRHand_notch_filtered.csv';
csvwrite([export_filepath csv_filename], EEG.data');