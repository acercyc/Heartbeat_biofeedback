function isPass = f_waveCheck_BiThreshold_SD(sd, amp, sdThreshold, rangeRateThreshold)
isPass = f_waveCheck_BiThreshold(amp, rangeRateThreshold) && (sd <= sdThreshold);
