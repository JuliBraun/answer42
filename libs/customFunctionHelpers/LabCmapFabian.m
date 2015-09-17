function [cmap] = LabCmap(varargin)
% LABCMAP  Returns perceptual uniform colormap using CIE Lab colorspace.
%   CMAP = LABCMAP(NAME)
%   	Return predefined colormap with 255 points.
%   CMAP = LABCMAP(POINT1, POINT2, STEPS, CHROMASCALE, CHROMAOFFSET)
%   	Returns colormap with given parameters
%
%   Use predefined colormap
%   	'bluegreenyellow'
%   	'blueredyellow'
%
%   or define your own. This functions returns colors along a line using a
%   variant of CIE HCL color space.
%
%   POINT1 and POINT2 define points on a colorspace, where the hue denotes the X
%   axis and a combination of luminosity and chroma. The function returns a
%   number of STEPS equidistant points on the line.
%
%   The parameter chromascale and chromaoffset define, how the Chroma
%   scales linerly with the Luminosity (cromascale==0 would give colors with
%   same Chroma). This can be used to boost contrast without going out of gamut
%   of sRGB.
%
%   Have fun! :)
%   2014, Fabian Kössel

	if nargin == 5 % create new colormap
		cmap = makecmap(varargin{1}, varargin{2}, varargin{3}, varargin{4},...
			varargin{5});
	elseif nargin == 1 % or return predefined
		switch varargin{1}
			case 'bluegreenyellow'
				cmap = makecmap([.8 .2], [.3, .96], 255, .763, -.1);
			case 'blueredyellow'
				cmap = makecmap([.2 .15], [.8, .9], 255, -.7, -.05);
		end
	else
		error('Wrong number of input arguments')
	end
end



function [cmap] = makecmap(p1, p2, steps, chromascale, chromaoffset)
    a = (p2(2) - p1(2)) / (p2(1) - p1(1));
    l = p1(2) - p1(1) * a;

    luh = @(h) a * h + l;

	cmap = zeros(steps, 3);

	h = linspace(p1(1), p2(1), steps);

	for i = 1:steps
		cmap(i, :) = hlso2sRGB(h(i), luh(h(i)), chromascale, chromaoffset)';
	end
end


function [Lab] = hlso2Lab(h, l, s, o)
%scale chroma linearly with luminosity to get a wider color palette
%without going out of gamut of sRGB
%
%    h: hue in [1,1]
%    l: luminosity parameter in [0,1]
%    s: linear scaling factor
%    o: offset

    angle = h * 2 * pi;
    c = l * s + o;
    a = c * cos(angle) * 100;
    b = c * sin(angle) * 100;
    L = l * 100;

	Lab = [L a b];
end


function [Lab] = LCHab2Lab(l, C, H)
% Transforms cylindrical CIELab into linear CIELab.
	L = l;
    a = C * cos(H / 180. * pi);
    b = C * sin(H / 180. * pi);

	Lab = [L a b];
end


function [y] = transform(x)
	EPS = 216. / 24389.;
	KAP = 24389. / 27. / 116.;
	if x.^3 > EPS
		y = x.^3;
	else
		y = (x - 4. / 29.) / KAP;
	end
end

function [XYZ] = Lab2XYZ(Lab)
%Transforms CIELab into CIEXYZ space.
	WP = [0.95047 1.00000 1.08883];

	L = Lab(1);
	a = Lab(2);
	b = Lab(3);

    fy = (L + 16) / 116.;
    fz = fy - b / 200.;
    fx = fy + a / 500.;

	xyz = [transform(fx) transform(fy) transform(fz)];

	XYZ = xyz .* WP;
end


function [rgb] = XYZ2sRGB(XYZ)
%Transforms CIEXYZ into sRGB with D65 whitepoint.
    M = [
		3.2404542, -1.5371385, -0.4985314;
        -0.9692660, 1.8760108, 0.0415560;
        0.0556434, -0.2040259, 1.0572252
		];

    rgb = M * XYZ';

    mask = rgb > .0031308;
    rgb(mask) = 1.055 * rgb(mask) .^(1 / 2.4) - 0.055;
    rgb(~mask) = rgb(~mask) * 12.92;

    if max(rgb) > 1 || min(rgb) < 0
        rgb = zeros(3,1);
	end
end


function [rgb] = hlso2sRGB(h, l, s, o)
    rgb = XYZ2sRGB(Lab2XYZ(hlso2Lab(h, l, s, o)));
end
