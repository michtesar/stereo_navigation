camera = [0.302, 0.1, -0.350];
target = [-0.0747, 0.0026, 0.0];

%target = [0.0, 0.0, 0.5];

red = [0.372, -0.052, -0.014];
white = [0.094, 0.056, 0.014];

r = [red(1), -red(2), red(3)];
w = [white(1), -white(2), white(3)];

global GL;

try
    g = Graphic;
catch
    psychrethrow(psychlasterror);
    warning('Cannot initialize scene!');
end

while true
    try
        g.setView(camera, target);
        g.drawArena; 
        g.sphere(r, [1, 0, 0]);
        g.sphere(w, [1, 1, 1]);
        g.sphere(camera, [1, 1, 0]);
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
    elseif find(key, 1) == KbName('RightArrow')
        camera(1) = camera(1) + 0.1;
    elseif find(key, 1) == KbName('UpArrow')
        camera(2) = camera(2) + 0.1;
    elseif find(key, 1)  == KbName('DownArrow')
        camera(2) = camera(2) - 0.1;
    elseif find(key, 1) == KbName('w')
        camera(3) = camera(3) - 0.1;
    elseif find(key, 1) == KbName('s')
        camera(3) = camera(3) + 0.1;
    elseif find(key, 1) == KbName('r')
        camera = [0.0, 0.0, 10.0]; 
        target = [0.0, 0.0, 0.0];
    elseif find(key, 1) == KbName('a')
        target(1) = target(1) - 0.1; 
    elseif find(key, 1) == KbName('d')
        target(1) = target(1) + 0.1;
    elseif find(key, 1) == KbName('q')
        target(2) = target(2) - 0.1; 
    elseif find(key, 1) == KbName('e')
        target(2) = target(2) + 0.1;
    elseif find(key, 1) == KbName('x')
        target(3) = target(3) - 0.1; 
    elseif find(key, 1) == KbName('c')
        target(3) = target(3) + 0.1;
    elseif find(key, 1) == KbName('ESCAPE')
        g.close;
        break;
    end 
end