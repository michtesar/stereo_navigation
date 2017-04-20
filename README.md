# Stereo-vision navigation paradigm

Electrophysiology navigation paradigm in stereoscopic rendered scene.

## Prerequisities
* MATLAB (tested MATLAB 2016a for macOS 10.12.4 and Windows 7 64-bit and MATLAB 2017b for Windows 7 SP2 64-bit)
* Psychtoolbox for OpenGL - download [here](http://psychtoolbox.org)
* All the textures and source files from GitHub from release - download [here](https://github.com/neuropacabra/Stereo/releases)

## How does it works?
When Psychtoolbox is installed it contains MEX files on OpenGL C/C++ functions wrapper. It also contain ported version of GLU and GLUT library.

There is no way to use classic window handling function, callback function and/or other parameter like enable sterescopy rendering the scene for nVidia Vision 2 glassses. This is done by internal PSychtoolbox function `Screne()` which is multipurpose thing.

Key thing is here to generate slightly different camera angles for left and right eye buffer. And it has to be enabled stereo mode 1 as active-stereoscopy.

```matlab
AssertOpenGL;
screenid = max(Screen('Screens'));
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', screenid, 0, [], [], [],...
    stereoMode, 0);
```

In any cases OpenGL code has to put inbetween:

```matlab
Screen('BeginOpenGL', win);
...
Screen('EndOpenGL', win);
```

## FAQ
* It crashes from unkonw reason but I see a screen for a moment or it print out the sync problems.
    * Disable sych test at the begining with `Screen('Preference', 'SkipSyncTests', 1);`
* It won't exist right after ESCAPE was pressed
    * Unfortunately it is pretty HW resources hard and it could occur in testing version

# TODO
- [ ] Optimize textures
- [ ] Fix the measurments (get it to real values like cm)
- [ ] Prepare EEG tag system
- [ ] Get the main loop
- [ ] Write logger
- [ ] Compile as MATLAB application and release it on GitHub

# Paradigm overview

## OpenGL scene

Paradigm consists of textured arena made from floor (ground disk with `floor.jpg` texture) and wall made of cylinder (rounded wall made with texture `wall.jpg`).

In the arena is placed a yellow small cylinder named as marker or reference-point. Then two main particles in arena are placed - two non-textured spheres. One is red, second is white.

Demo [here](https://www.youtube.com/watch?v=1V2lfM1x0gE)

Scene is generated as followings:

![Scene design](https://github.com/neuropacabra/Stereo/blob/documentation/scene_design.png?raw=true)
