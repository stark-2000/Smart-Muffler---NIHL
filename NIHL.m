%load and calibrate the data
[wav,fs_Hz]=audioread('MKBHD.mp3');  %load the WAV file

%{
rec = audiorecorder(44100, 16, 1);
disp('start speaking');
recordblocking(rec, 5);
disp('stop speaking');
wav = getaudiodata(rec);
fs_Hz = 44100;
%}

%plot(wav);
my_cal_factor = 1.0;  %the value for your system to convert the WAV into Pascals
wav_Pa = wav * my_cal_factor;

%extract the envelope
%smooth_sec = 0.125;  %"FAST" SPL is 1/8th of second.  "SLOW" is 1 second;
%smooth_Hz = 1/smooth_sec;
%[b,a]=butter(1,smooth_Hz/(fs_Hz/2),'low');  %design a Low-pass filter
%wav_env_Pa = sqrt(filter(b,a,wav_Pa.^2));  %rectify, by squaring, and low-pass filter

%compute SPL
Pa_ref = 20e-6;  %reference pressure for SPL in Air
SPL_dB = 10.0*log10( (wav_Pa ./ Pa_ref).^2 ); % 10*log10 because signal is squared
 
%{
wav_env_pa_1 = Pa_ref*(sqrt(10.^(SPL_dB/10)));
wav_1 = wav_env_pa_1;
t_sec = ([1:size(wav_Pa)]-1)/fs_Hz;
plot(t_sec,wav_1);
xlabel('Time (sec)');
ylabel('Pressure (Pa)');
filename = 'MKBHD1.wav';
audiowrite(filename,wav_1,fs_Hz);
[wav_1,fs_Hz] = audioread(filename);
sound(wav_1,fs_Hz);
%}

%plot results
figure;
subplot(3,1,1);
t_sec = ([1:size(wav_Pa)]-1)/fs_Hz;
plot(t_sec,wav_Pa);
xlabel('Time (sec)');
ylabel('Pressure (Pa)');

subplot(3,1,2);
plot(t_sec,SPL_dB);
xlabel('Time (sec)');
ylabel('SPL (dB)');
yl=ylim;ylim(yl(2)+[-80 0]);

subplot(3,1,3);
SPL_dB(SPL_dB > 80) = NaN;
%wav_env_pa_1 = Pa_ref*(sqrt(10.^(SPL_dB/10)));
%wav_1 = wav_env_pa_1/my_cal_factor;

plot(t_sec,SPL_dB);
xlabel('Time (sec)');
ylabel('SPL (dB)');
yl=ylim;ylim(yl(2)+[-80 0]);


%sound(wav,fs_Hz);
%pause(25);
%{
filename = 'MKBHD1.wav';
audiowrite(filename,wav_1,fs_Hz);
[wav_2,fs_Hz] = audioread(filename);
%}





