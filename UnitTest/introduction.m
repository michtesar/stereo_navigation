function introduction
screens = Screen('Screens');
screenNumber = max(screens);
w = Screen('OpenWindow', screenNumber, 0);
 
Screen('TextSize', w, 50);
text = ['AEDist2017 Unit Test Demo\n\n',...
    'This is a demo of scene with all the objects and coordinates\n',...
    '\n\n\nFor continue press ANY KEY'];
DrawFormattedText(w, text, 'center', 'center', [255 255 255]);

Screen('Flip', w);
KbWait;
Screen('Flip', w);
end