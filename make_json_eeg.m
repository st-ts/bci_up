% Make json files that combine: 
% 1. eeg data table
% 2. trial info:
% -- for each trial start time in frames
% -- separately, just in case, duration of each trial (or event)
% 3. task type - HaLt, CLA, etc
% 4. channel names (wtf if there X3 and X5?!)
% 5. sampling rate
% 6. subject info: gender, age, letter code
% 7. just in case, the marker codes
% 8. inter or not - some kind of special interactive thing they used

% Load the .mat file
egg_mat_file = 'HaLTSubjectA1602236StLRHandLegTongue.mat';
name_start = egg_mat_file(1:end-21); % or, (1:19)
load(egg_mat_file); 
% eeg_proc_file_name = 'HaLTSubjectA1602236_min_proc.csv';  
eeg_proc_file_name = [name_start '_min_proc.csv'];

% 1. EEG Data table
eeg_data = readtable(eeg_proc_file_name); % Extract processed EEG data
channel_names = o.chnames; % Channel names
sampling_rate = o.sampFreq; % Sampling frequency

% Get the trial info 
[event_types, event_starts, event_durations] = get_trial_info(trial_markers);

% Task type from file name
if egg_mat_file(1) == 'H'
    task_type = 'HaLt'; 
elseif egg_mat_file(1) == 'C'
    task_type = 'CLA';
elseif egg_mat_file(1) == 'F'
    task_type = 'FreeForm';
else
    error('hmm weird wtf task type');
end

% Check if there are 22 channels


% Subject code from file name
if eeg_proc_file_name(1) == 'H'
    subject = eeg_proc_file_name(12); % Code letter of the participant
else
    error('take care of other task type beyond HalT');
end


% Now, create a structure to hold everything for the JSON
json_struct.eeg_data = eeg_data;
json_struct.event_starts = event_starts;
json_struct.event_durations = event_durations;
json_struct.task_type = task_type;
json_struct.channel_names = channel_names;
json_struct.sampling_rate = sampling_rate;
json_struct.subject = subject;

% 6. Convert structure to JSON
json_str = jsonencode(json_struct);

% 7. Save JSON to a file
json_file_name = [eeg_proc_file_name(1:end-4) '.json']; % Change file name if needed
fid = fopen(json_file_name, 'w');
if fid == -1
    error('Cannot create JSON file');
end
fwrite(fid, json_str, 'char');
fclose(fid);

disp(['JSON file saved as ' json_file_name]);
