function varargout = nongeometric(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nongeometric_OpeningFcn, ...
                   'gui_OutputFcn',  @nongeometric_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function nongeometric_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = nongeometric_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function put_grid_button_Callback(hObject, eventdata, handles)
global get_image
gettedImage = imread(get_image);
gettedImage = imfilter(gettedImage, fspecial('gaussian',7,1));
BW = imcomplement(im2bw(gettedImage));
BW = imclearborder(BW);
BW(150:200,100:150) = 0;
st = regionprops(BW, 'Centroid');
c = vertcat(st.Centroid);
[H,T,R] = hough(BW);
P  = houghpeaks(H, 25);
L = houghlines(BW, T, R, P);
I = imoverlay(gettedImage, BW, [0.9 0.1 0.1]);
imshow(I, 'InitialMag',200, 'Border','tight'), hold on
line(c(:,1), c(:,2), 'LineStyle','none', 'Marker','+', 'Color','b')
for k = 1:length(L)
    xy = [L(k).point1; L(k).point2];
    plot(xy(:,1), xy(:,2), 'g-', 'LineWidth',2);
end
hold off

function get_image_button_Callback(hObject, eventdata, handles)
global get_image
[baseFileName, folder] = uigetfile({'*.*';});
get_image = strcat(folder, baseFileName);
imshow(get_image, 'Parent', handles.image_axes)

function histogram_button_Callback(hObject, eventdata, handles)
global get_image
gettedImage = imread(get_image);
processedImage = rgb2gray(gettedImage);
figure
imhist(processedImage)

function exit_button_Callback(hObject, eventdata, handles)
closereq()
