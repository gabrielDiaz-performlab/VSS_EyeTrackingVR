function varargout = Classify_GUI(varargin)
% CLASSIFY_GUI MATLAB code for Classify_GUI.fig
%      This GUI function lets a user try various Velocity and Dispersion
%      threshold values to visualize classification.
%      Author: Rakshit Kothari
%      email: rsk3900@rit.edu

%      CLASSIFY_GUI, by itself, creates a new CLASSIFY_GUI or raises the existing
%      singleton*.
%
%      H = CLASSIFY_GUI returns the handle to a new CLASSIFY_GUI or the handle to
%      the existing singleton*.
%
%      CLASSIFY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFY_GUI.M with the given input arguments.
%
%      CLASSIFY_GUI('Property','Value',...) creates a new CLASSIFY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Classify_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Classify_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Classify_GUI

% Last Modified by GUIDE v2.5 16-May-2018 17:14:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Classify_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Classify_GUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Classify_GUI is made visible.
function Classify_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Classify_GUI (see VARARGIN)

% Choose default command line output for Classify_GUI
handles.output = hObject;
ExpData = varargin{1};
% Assign data to handles. Handles is a struct which gets passed between
% functions in the GUI.
handles.T = ExpData.T;
handles.EIH_vel = ExpData.EIH_Vel;
handles.Disper = ExpData.Disper;
handles.LabelStruct = [];

plot(handles.ViewPort, handles.T, handles.EIH_vel)
xlabel(handles.ViewPort, 'Time (S)')
ylabel(handles.ViewPort, 'Velocity (\circ/s)')
title(handles.ViewPort, 'I-V&DT Classification')

% Set slider 1 parameters
handles.slider1.Value = 100;
handles.slider1.Min = 20;
handles.slider1.Max = 400;
handles.slider1.SliderStep = [0.005, 0.05];

handles.slider2.Value = 0.003;
handles.slider2.Max = 0.02;
handles.slider2.Min = 0.0018;
handles.slider2.SliderStep = [0.005, 0.05];
% Ser slider 2 parameters

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Classify_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Classify_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.LabelStruct;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LabelStruct = UpdateLabels(handles, handles.slider1.Value, handles.slider2.Value);
handles.text2.String = sprintf('Vel Thresh: %f', handles.slider1.Value);
drawnow;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LabelStruct = UpdateLabels(handles, handles.slider1.Value, handles.slider2.Value);
handles.text3.String = sprintf('Disp Thresh: %f', handles.slider2.Value);
drawnow
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
