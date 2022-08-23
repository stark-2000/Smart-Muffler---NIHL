% This file read audio files in various formats
% 
% Lecture Series: Speech & Audio Signal Processing
% Created By: JCBRO Labs
% Date: 07/05/2017
% website: www.jcbrolabs.org
% mail: jcbrolabs@gmail.com
close all; clear all;

% read .wav file
[data,fs] = wavread('10a07La_boredom');

% read .mp3 file
[x, fs1] = audioread('preview.mp3');

% play audio files
sound(x,fs1);   %one method

% play audio files by another method
player = audioplayer(x,fs1);
play(player);
pause(5);
pause(player);
pause(5);
stop(player);

% plot signal
plot(x); title('Input Sound File');
