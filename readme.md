This is a simple documentation of our startup codes, including importing data, compressing audioes(optional), and using mfcc to extract features. 
---

Directionary Structure
---
-- Start Codes
	-- English
		-- english1.wav
		-- english2.wav
		-- ...
	-- Mandarin
		-- mandarin1.wav
		-- mandarin2.wav
		-- ...
	-- main.m
	-- readData.m
	-- compressData.m
	-- featureExtract.m
	-- readme.md

Component
---
1. readData.m
First, you should put all your data in a separate foler and name them in a structural and meaning way. You can import all data and store them in a cell array by specifying the name of that folder, the type of your audio('mandarin','english',etc), and the suffix of audioes('.mp3' or '.wav'). 

2. compressData.m
This part converts auidoes into sound tracks of approximately the same length. We do this for the sake of later feature extraction part, however, this part is totally optional. We are not sure whether this step will alter some important features of original data, and thus if you are afraid of its possible side effects and want to skip this part, be my guest.

3. featureExtract.m
This part use 'melfcc.m' in 'rastamat' toolbox, so You MUST add 'rastamat' directionary into the working path. The input of 'melfcc.m' is waveform 'x', its sampling rate 'fs', and a lot of optional parameters. For more detailed information of 'rastamat' toolbox, see resource-1. Besides, we provide a basic tutorial of mfcc, see resource-2.

P.S. For the baseline system, we use Matlab neural-network toolbox, and for its tutorial please see resource-3.


resources:
---
1. rastamat toolbox documentation
http://labrosa.ee.columbia.edu/matlab/rastamat/

2. MFCC tutorial
http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/

3. Matlab neural-network toolbox tutorial
http://cn.mathworks.com/help/nnet/gs/fit-data-with-a-neural-network.html

