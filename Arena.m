classdef Arena < handle
    %ARENA trida na zobrazeni pozic objektu v AEDist testu
    %   jen 2D pozice pri pohledu shora
    %   Kamil Vlcek 26.10.2017
    
    properties
        pozice;
        sloupce;
        radky;
        figureh;
        Stred = 0+0i; %stred areny
        r = 0.5; %rozmer areny
        Tyc = 0.017 + 0.483i;
        rtyc = 0.069/2;
        rkoule = 0.083/2;
        rkamera = 0.05;
        lkamera = 0.3; %delka cary kamery
    end
    
    methods
        function obj = Arena(filename)
            obj.Load(filename);
        end
        function obj = Load(obj,filename)
            load(filename);
            obj.pozice = POZICE;
            obj.sloupce = SLOUPCE;
            obj.radky = RADKY;

        end
        function obj = Plot(obj,r)
            if(isempty(obj.figureh) || ~isvalid(obj.figureh))
                obj.figureh = figure('Name','AEDist pozice');
            else
                figure(obj.figureh);
            end
            clf; %vymaze obrazek
            circle(obj.r,real(obj.Stred),imag(obj.Stred),'k'); %obrys areny
            hold on;
            axis equal;
            axis ij;
            circle(obj.rtyc,real(obj.Tyc),imag(obj.Tyc),'y',1); %zluta tyc
            circle(obj.rkoule,obj.pozice(r,1),obj.pozice(r,2),'r',1); %cervena koule
            circle(obj.rkoule,obj.pozice(r,4),obj.pozice(r,5),'k',0); %bila koule
            circle(obj.rkamera,obj.pozice(r,10),obj.pozice(r,11),'m',1); %kamera
            obj.Line(r); %smer pohledu
            text(-0.5,0.4,[num2str(r) ' ' obj.radky{r}]);
        end
        function Line(obj,r)
           x(1) =  obj.pozice(r,10);
           x(2) =  x(1) + obj.lkamera * cosd( obj.pozice(r,9));
           y(1) =  obj.pozice(r,11);
           y(2) =  y(1) + obj.lkamera * sind( obj.pozice(r,9));
           plot(x,y);
        end
        function CheckAll(obj)
            pause('on');
            for r = 1:numel(obj.radky) %#ok<PROP>
                obj.Plot(r); %#ok<PROP>
                pause;
            end
            pause('off')
        end
    end
    
end

