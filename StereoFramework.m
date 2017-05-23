raw_data = readtable('AEDist2017_source.xlsx');
source = raw_data(~isnan(raw_data.RedX), :);

try
    PsychDefaultSetup(2);
    [window, windowRect]=PsychImaging('OpenWindow',0,0,[200 200 800 600]);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);

    DrawFormattedText(window, 'Starting...', 'center', 'center', [1 1 1]);
    HideCursor();
    ListenChar(2);
    Screen('Flip', window);
    
    KbWait;
    
    KbName('UnifyKeyNames');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    escapeKey = KbName('ESCAPE');
        
    redDotColor = [1 0 0];
    whiteDotColor = [1 1 1];
    dotSize = 50;
    
    for event = 1:size(source, 1)
        Screen('DrawDots', window, [source.RedY(event),...
            source.RedY(event)], dotSize, redDotColor, [], 2);
        Screen('DrawDots', window, [source.WhiteY(event),...
            source.WhiteY(event)], dotSize, whiteDotColor, [], 2);
        Screen('Flip', window);
        
        % HACK - Chytré pou¾ití KbCheck na kontrolu stiknuté klávesy
        % asi by s hodilo si to nìkam zapsat na pøí¹tì (blog)
        while 1
            [keyIsDown, timeSecs, keyCode] = KbCheck;
            if find(keyCode, 1) == leftKey
                disp('LEFT');
                KbReleaseWait;
                break;
            elseif find(keyCode, 1) == rightKey
                disp('RIGHT');
                KbReleaseWait;
                break;
            elseif find(keyCode, 1) == escapeKey
                ListenChar(0);
                ShowCursor();
                Screen('CloseAll');
                break;
            end 
        end
    end
    
catch
    ListenChar(0);
    ShowCursor();
    Screen('CloseAll');
    clear screen
    Priority(0);
    KbQueueRelease;
    psychrethrow(psychlasterror);
end

ListenChar(0);
ShowCursor();
sca;