camera = [0.0, 0.0, 5.0];
target = [0.0, 0.0, 0.0];

red = [0.234, 0.339, 0.014];
white = [0.111, 0.070, -0.014];

try
    g = Graphic;
catch
    warning('Cannot initialize scene!');
    psychrethrow(psychlasterror);
end

while true
    try
        g.setView(camera, target);
        g.drawArena;

        text = sprintf('Camera:\nX = %0.2f, Y = %0.2f, Z = %0.2f',...
            camera(1), camera(2), camera(3));
        text = strcat(text,...
            sprintf('\nLook at:\nX = %0.2f, Y = %0.2f, Z = %0.2f\n\n',...
            target(1), target(2), target(3)));
        g.debug(text);
        g.sphere(red, [1, 0, 0]);
        g.sphere(white, [1 1 1]);
        g.wait;
    catch
        g.close;
        warning('Cannot draw arena models!');
        psychrethrow(psychlasterror);
        break;
    end
    
    [t, key, ~] = KbWait;
    if find(key, 1) == KbName('LeftArrow')
        camera(1) = camera(1) - 0.1;
    elseif find(key, 1) == KbName('RightArrow');
        camera(1) = camera(1) + 0.1;
    elseif find(key, 1) == KbName('UpArrow');
        camera(2) = camera(2) + 0.1;
    elseif find(key, 1)  == KbName('DownArrow');
        camera(2) = camera(2) - 0.1;
    elseif find(key, 1) == KbName('w');
        camera(3) = camera(3) - 0.1;
    elseif find(key, 1) == KbName('s');
        camera(3) = camera(3) + 0.1;
    elseif find(key, 1) == KbName('r');
        camera = [0.0, 0.0, 10.0]; 
        target = [0.0, 0.0, 0.0];
    elseif find(key, 1) == KbName('a');
        target(1) = target(1) - 0.1; 
    elseif find(key, 1) == KbName('d');
        target(1) = target(1) + 0.1;
    elseif find(key, 1) == KbName('q');
        target(2) = target(2) - 0.1; 
    elseif find(key, 1) == KbName('e');
        target(2) = target(2) + 0.1;
    elseif find(key, 1) == KbName('x');
        target(3) = target(3) - 0.1; 
    elseif find(key, 1) == KbName('c');
        target(3) = target(3) + 0.1;
    elseif find(key, 1) == KbName('ESCAPE');
        g.close;
        break;
    end 
end