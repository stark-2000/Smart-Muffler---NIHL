[wav,fs_Hz]=audioread('MKBHD.mp3'); 


rec = audiorecorder(44100, 16, 1);
disp('start speaking');
recordblocking(rec, 5);
disp('stop speaking');
wav = getaudiodata(rec);
fs_Hz = 44100;


%plot(wav);
my_cal_factor = 1.0;  %the value for your system to convert the WAV into Pascals
wav_Pa = wav * my_cal_factor;

%extract the envelope
smooth_sec = 0.125;  %"FAST" SPL is 1/8th of second.  "SLOW" is 1 second;
smooth_Hz = 1/smooth_sec;
[b,a]=butter(1,smooth_Hz/(fs_Hz/2),'low');  %design a Low-pass filter
wav_env_Pa = sqrt(filter(b,a,wav_Pa.^2));  %rectify, by squaring, and low-pass filter

Pa_ref = 20e-6;  %reference pressure for SPL in Air
SPL_dB = 10.0*log10( (wav_env_Pa ./ Pa_ref).^2 ); 
 
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


z = SPL_dB > 80;
d = length (z);
j=0;
for i=1:d
    if(z(i,1) == 1)
        j = 1;
    end
end

if(j == 1)
    wav_1 = wav * 0.1;
    filename = 'MKBHD1.wav';
    audiowrite(filename,wav_1,fs_Hz);
    [wav_2,fs_Hz] = audioread(filename);
    sound(wav,fs_Hz);
    pause(25);
    sound(wav_2,fs_Hz);
    wav_Pa_1 = wav_1 * my_cal_factor;
    wav_env_Pa_1 = sqrt(filter(b,a,wav_Pa_1.^2));
    SPL_dB_1 = 10.0*log10( (wav_env_Pa_1 ./ Pa_ref).^2 );
    subplot(3,1,3);
    SPL_dB_1(SPL_dB_1 > 80) = NaN;
    plot(t_sec,SPL_dB_1);
    xlabel('Time (sec)');
    ylabel('SPL_1 (dB)');
    yl=ylim;ylim(yl(2)+[-80 0]);
else
    sound(wav,fs_Hz);
end








