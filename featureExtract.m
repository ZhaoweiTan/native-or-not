%x: audio waveform, fs:sampling rate
function features = readAudio(x, fs)
    [im, aspc] = melfcc(x*3.3752, fs, 'maxfreq', 8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
    features = im;
end