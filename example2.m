% Example 2 - Shows which key was pressed and timeouts after .5 seconds
% written for Psychtoolbox 3  by Aaron Seitz 1/2012

[window, rect]=Screen('OpenWindow',0);  % open screen
ListenChar(2); %makes it so characters typed don?t show up in the command window
HideCursor(); %hides the cursor

KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming

for trial=1:2 %runs 5 trials
    IM1=rand(100,100,3)*255; %creates random colored image
    tex(1) = Screen('MakeTexture', window, IM1); %makes texture
    Screen('DrawTexture', window, tex(1), []); %draws to backbuffer
    WaitSecs(rand+.5) %jitters prestim interval between .5 and 1.5 seconds

    rtMs = 0;
    rtFeedback = 'No response';
    
    stimuliOnset=Screen('Flip',window); %swaps backbuffer to frontbuffer
    
    t = 1.5;
    [stimSecs, keyCode, deltaSecs] = KbWait([], [], stimuliOnset+t);
    WaitSecs((t)-(stimSecs-stimuliOnset));
    if find(keyCode == 1)
        rtMs = (stimSecs - stimuliOnset) * 1000;
    end
    
    DrawFormattedText(window, '+', 'center', 'center', [0 0 0]);
    fixationOnset = Screen('Flip', window);
    [fixationSecs, keyCode, deltaSecs] = KbWait([], [], fixationOnset+t);
    WaitSecs((t)-(fixationSecs-fixationOnset));
    if rtMs == 0
        if find(keyCode == 1)
            rtMs = (fixationSecs-stimuliOnset) * 1000;
        end
    end
    
    if rtMs > 0
        rtFeedback = sprintf('RT: %.f ms', rtMs);
    end
    
    DrawFormattedText(window,rtFeedback, 'center'  ,'center',[255 0 255]); %shows RT
    vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    Screen('Flip',window,vbl+1); %erases feedback after 1 second
end

ListenChar(0); %makes it so characters typed do show up in the command window
ShowCursor(); %shows the cursor
Screen('CloseAll'); %Closes Screen