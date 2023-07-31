function varargout = Homework(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Homework_OpeningFcn, ...
                   'gui_OutputFcn',  @Homework_OutputFcn, ...
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


% --- Executes just before Homework is made visible.
function Homework_OpeningFcn(hObject, eventdata, handles, varargin)
global isPlotted;
isPlotted = false;
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Homework_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --------------------------------------------------------------------
function SetColor(handles)
global color;
if (get(handles.greenRadioButton, "Value") == 1)
    color = "g";
    return
end
if (get(handles.blueRadioButton, "Value") == 1)
    color = "b";
    return
end
if (get(handles.redRadioButton, "Value") == 1)
    color = "r";
    return
end
if (get(handles.blackRadioButton, "Value") == 1)
    color = "k";
    return
end
if (get(handles.magentaRadioButton, "Value") == 1)
    color = "m";
    return
end


% --------------------------------------------------------------------
function SetMarker(handles)
global marker;
switch (get(handles.markerPopupMenu, "Value"))
    case 1
        marker = '';
    case 2
        marker = 'o';
    case 3
        marker = 's';
    case 4
        marker = 'd';
    case 5
        marker = '^';
end


% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
global marker;
SetMarker(handles);
axes(handles.graph);
if (get(handles.taskMenu1, "Checked") == "on")
    dotCount = str2double(get(handles.dotCountEdit, 'String'));
    if (dotCount < 3)
        msgbox("Задайте хотя бы 3 точки на графике.")
        return;
    end
    %global axisWidth;
    global color;
    SetColor(handles);
    axisWidth = str2double(get(handles.axisWidthEdit, 'String'));
    
    a = str2double(get(handles.aCoefEdit, 'String'));
    b = str2double(get(handles.bCoefEdit, 'String'));
    c = str2double(get(handles.cCoefEdit, 'String'));
    
    if (a == 0 && b == 0 && c == 0)
        msgbox("Необходимо указать коэффициенты.")
        return
    end
    
    if (a == 0 && b == 0 && c ~= 0)
        handles.Line = plot(c)
        return
    end
    result = [a, b ,c];
    r = real(roots(result));
    if (r(1) > 0)
        interval = max(r) + 2 * axisWidth - min(r);
        x = min(r) - axisWidth : interval / (dotCount - 1) : max(r) + axisWidth;
        y = a.* (x).^2 + x.* b + c;
        handles.Line = plot(x, y, "-" + marker + color);
        axis([(min(r) - axisWidth - 1) (max(r) + axisWidth + 1) -inf inf]);
    elseif (a ~= 0)
        x1 = -b / 2 / a;
        interval = 2 * axisWidth;
        x = x1 - axisWidth : interval / (dotCount - 1) : x1 + axisWidth;
        y = a.* (x).^2 + x.* b + c;
        handles.Line = plot(x, y, "-" + marker + color);
        axis([(x1 - axisWidth - 1) (x1 + axisWidth + 1) -inf inf]);
    else
        interval = 2 * axisWidth;
        x = -axisWidth : interval / (dotCount - 1) : axisWidth;
        y = a.* (x).^2 + x.* b + c;
        handles.Line = plot(x, y, "-" + marker + color);
        axis([-axisWidth axisWidth -inf inf]);
    end
else
    global func;
    global xStart;
    global xEnd;
    global isPlotted;
    xStart = 0;
    xEnd = 20;
    x = xStart : 0.6 : xEnd;
    if (get(handles.straightButton, "Value") == 1)
        func = "straight";
        y = x;
    elseif (get(handles.parabolaButton, "Value") == 1)
        func = "parabola";
        y = x.*x;
    else
        func = "root";
        y = sqrt(x);
    end
    graphMarker = marker;
    if (get(handles.markersCheckbox, "Value") == 0)
        graphMarker = '';
    end
    handles.Line = plot(x, y, "-" + graphMarker);
    set(handles.integrationButton, "Enable", "on");
    set(handles.integrationMenu, "Enable", "on");
    set(handles.errorPlotButton, "Enable", "on");
    set(handles.errorPlotMenu, "Enable", "on");
    isPlotted = true;
end
guidata(gcbo, handles);


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
axes(handles.graph);
cla;
if (get(handles.taskMenu2, "Checked") == "on")
    set(handles.integrationButton, "Enable", "off");
    set(handles.integrationMenu, "Enable", "off");
    set(handles.errorPlotButton, "Enable", "off");
    set(handles.errorPlotMenu, "Enable", "off");
    global isPlotted;
    isPlotted = false;
end


% --- Executes on button press in valueSetButton1.
function valueSetButton1_Callback(hObject, eventdata, handles)
set(handles.aCoefEdit, "String", "1");
set(handles.bCoefEdit, "String", "1");
set(handles.cCoefEdit, "String", "1");


% --- Executes on button press in valueSetButton2.
function valueSetButton2_Callback(hObject, eventdata, handles)
set(handles.aCoefEdit, "String", "-2");
set(handles.bCoefEdit, "String", "4");
set(handles.cCoefEdit, "String", "-3");


% --- Executes on button press in notClearCheckbox.
function notClearCheckbox_Callback(hObject, eventdata, handles)
if (get(hObject, "Value") == 1)
    set(handles.notClearMenu, "Checked", "on");
    hold on;
else
    set(handles.notClearMenu, "Checked", "off");
    hold off;
end


% --------------------------------------------------------------------
function aCoefEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function aCoefEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function bCoefEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function bCoefEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function cCoefEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function cCoefEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function dotCountEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function dotCountEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in aCoefCheckbox.
function aCoefCheckbox_Callback(hObject, eventdata, handles)


% --- Executes on button press in bCoefCheckbox.
function bCoefCheckbox_Callback(hObject, eventdata, handles)


% --- Executes on button press in cCoefCheckbox.
function cCoefCheckbox_Callback(hObject, eventdata, handles)


% --- Executes on button press in dotCountCheckbox.
function dotCountCheckbox_Callback(hObject, eventdata, handles)



function axisWidthEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function axisWidthEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axisWidthCheckbox.
function axisWidthCheckbox_Callback(hObject, eventdata, handles)


% --- Executes on selection change in markerPopupMenu.
function markerPopupMenu_Callback(hObject, eventdata, handles)
switch (get(hObject, "Value"))
    case 1
        noMarkerMenu_Callback(handles.noMarkerMenu, eventdata, handles);
    case 2
        circleMarkerMenu_Callback(handles.circleMarkerMenu, eventdata, handles);
    case 3
        squareMarkerMenu_Callback(handles.squareMarkerMenu, eventdata, handles);
    case 4
        rhombusMarkerMenu_Callback(handles.rhombusMarkerMenu, eventdata, handles);
    case 5
        triangleMarkerMenu_Callback(handles.triangleMarkerMenu, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function markerPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function plotMenu_Callback(hObject, eventdata, handles)
plotButton_Callback(handles.plotButton, eventdata, handles);


% --------------------------------------------------------------------
function clearMenu_Callback(hObject, eventdata, handles)
clearButton_Callback(handles.clearButton, eventdata, handles);


% --------------------------------------------------------------------
function valueSetMenu1_Callback(hObject, eventdata, handles)
valueSetButton1_Callback(handles.valueSetButton1, eventdata, handles);


% --------------------------------------------------------------------
function valueSetMenu2_Callback(hObject, eventdata, handles)
valueSetButton2_Callback(handles.valueSetButton2, eventdata, handles);


% --------------------------------------------------------------------
function colorMenu_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function taskMenu1_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.taskMenu2, "Checked", "off");
description = { 'Задание 1'
                'Построение графика квадратичной функции'};
description = strjust(description, 'center');

set(handles.valueSetMenu1, "Visible", "on");
set(handles.valueSetMenu2, "Visible", "on");
set(handles.colorMenu, "Visible", "on");
set(handles.checkMarkersMenu, "Visible", "off");
set(handles.notClearMenu, "Visible", "on");
set(handles.integrationMenu, "Visible", "off");
set(handles.errorPlotMenu, "Visible", "off");
set(handles.errorClearMenu, "Visible", "off");
set(handles.graphMenu, "Visible", "off");


set(handles.aCoefText, "Visible", "on");
set(handles.aCoefEdit, "Visible", "on");
set(handles.bCoefText, "Visible", "on");
set(handles.bCoefEdit, "Visible", "on");
set(handles.cCoefText, "Visible", "on");
set(handles.cCoefEdit, "Visible", "on");
set(handles.dotCountText, "Visible", "on");
set(handles.dotCountEdit, "Visible", "on");
set(handles.axisWidthText, "Visible", "on");
set(handles.axisWidthEdit, "Visible", "on");

set(handles.valueSetButton1, "Visible", "on");
set(handles.valueSetButton2, "Visible", "on");
set(handles.errorControlPanel, "Visible", "off");
set(handles.radioButtonPanel, "Visible", "on");
set(handles.integrationPanel, "Visible", "off");
set(handles.graphButtonGroup, "Visible", "off");
set(handles.errorGraph, "Visible", "off");
set(handles.descriptionText, "String", description);
set(handles.notClearCheckbox, "Visible", "on");
set(handles.markersCheckbox, "Visible", "off");

clearButton_Callback(handles.clearButton, eventdata, handles);
errorClearButton_Callback(handles.errorClearButton, eventdata, handles);


% --------------------------------------------------------------------
function taskMenu2_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.taskMenu1, "Checked", "off");
description = { 'Задание 2'
                'Вычисление площади фигуры'};
description = strjust(description, 'center');

set(handles.valueSetMenu1, "Visible", "off");
set(handles.valueSetMenu2, "Visible", "off");
set(handles.colorMenu, "Visible", "off");
set(handles.checkMarkersMenu, "Visible", "on");
set(handles.notClearMenu, "Visible", "off");
set(handles.integrationMenu, "Visible", "on");
set(handles.errorPlotMenu, "Visible", "on");
set(handles.errorClearMenu, "Visible", "on");
set(handles.graphMenu, "Visible", "on");

set(handles.aCoefText, "Visible", "off");
set(handles.aCoefEdit, "Visible", "off");
set(handles.bCoefText, "Visible", "off");
set(handles.bCoefEdit, "Visible", "off");
set(handles.cCoefText, "Visible", "off");
set(handles.cCoefEdit, "Visible", "off");
set(handles.dotCountText, "Visible", "off");
set(handles.dotCountEdit, "Visible", "off");
set(handles.axisWidthText, "Visible", "off");
set(handles.axisWidthEdit, "Visible", "off");

set(handles.valueSetButton1, "Visible", "off");
set(handles.valueSetButton2, "Visible", "off");
set(handles.errorControlPanel, "Visible", "on");
set(handles.radioButtonPanel, "Visible", "off");
set(handles.integrationPanel, "Visible", "on");
set(handles.graphButtonGroup, "Visible", "on");
set(handles.errorGraph, "Visible", "on");
set(handles.descriptionText, "String", description);
set(handles.notClearCheckbox, "Visible", "off");
set(handles.markersCheckbox, "Visible", "on");

if (get(handles.notClearCheckbox, "Value") == 1)
    set(handles.notClearCheckbox, "Value", 0);
    notClearCheckbox_Callback(handles.notClearCheckbox, eventdata, handles);
end

clearButton_Callback(handles.clearButton, eventdata, handles);


% --------------------------------------------------------------------
function blueMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.redMenu, "Checked", "off");
set(handles.greenMenu, "Checked", "off");
set(handles.blackMenu, "Checked", "off");
set(handles.magentaMenu, "Checked", "off");
set(handles.blueRadioButton, "Value", 1);

% --------------------------------------------------------------------
function redMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.blueMenu, "Checked", "off");
set(handles.greenMenu, "Checked", "off");
set(handles.blackMenu, "Checked", "off");
set(handles.magentaMenu, "Checked", "off");
set(handles.redRadioButton, "Value", 1);


% --------------------------------------------------------------------
function greenMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.blueMenu, "Checked", "off");
set(handles.redMenu, "Checked", "off");
set(handles.blackMenu, "Checked", "off");
set(handles.magentaMenu, "Checked", "off");
set(handles.greenRadioButton, "Value", 1);


% --------------------------------------------------------------------
function blackMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.blueMenu, "Checked", "off");
set(handles.greenMenu, "Checked", "off");
set(handles.redMenu, "Checked", "off");
set(handles.magentaMenu, "Checked", "off");
set(handles.blackRadioButton, "Value", 1);


% --------------------------------------------------------------------
function magentaMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.blueMenu, "Checked", "off");
set(handles.greenMenu, "Checked", "off");
set(handles.blackMenu, "Checked", "off");
set(handles.redMenu, "Checked", "off");
set(handles.magentaRadioButton, "Value", 1);


% --------------------------------------------------------------------
function noMarkerMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.circleMarkerMenu, "Checked", "off");
set(handles.squareMarkerMenu, "Checked", "off");
set(handles.rhombusMarkerMenu, "Checked", "off");
set(handles.triangleMarkerMenu, "Checked", "off");
set(handles.markerPopupMenu, "Value", 1);


% --------------------------------------------------------------------
function circleMarkerMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.noMarkerMenu, "Checked", "off");
set(handles.squareMarkerMenu, "Checked", "off");
set(handles.rhombusMarkerMenu, "Checked", "off");
set(handles.triangleMarkerMenu, "Checked", "off");
set(handles.markerPopupMenu, "Value", 2);


% --------------------------------------------------------------------
function squareMarkerMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.circleMarkerMenu, "Checked", "off");
set(handles.noMarkerMenu, "Checked", "off");
set(handles.rhombusMarkerMenu, "Checked", "off");
set(handles.triangleMarkerMenu, "Checked", "off");
set(handles.markerPopupMenu, "Value", 3);


% --------------------------------------------------------------------
function rhombusMarkerMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.circleMarkerMenu, "Checked", "off");
set(handles.squareMarkerMenu, "Checked", "off");
set(handles.noMarkerMenu, "Checked", "off");
set(handles.triangleMarkerMenu, "Checked", "off");
set(handles.markerPopupMenu, "Value", 4);


% --------------------------------------------------------------------
function triangleMarkerMenu_Callback(hObject, eventdata, handles)
set(hObject, "Checked", "on");
set(handles.circleMarkerMenu, "Checked", "off");
set(handles.squareMarkerMenu, "Checked", "off");
set(handles.rhombusMarkerMenu, "Checked", "off");
set(handles.noMarkerMenu, "Checked", "off");
set(handles.markerPopupMenu, "Value", 5);


% --- Executes on button press in markersCheckbox.
function markersCheckbox_Callback(hObject, eventdata, handles)
global marker;
global isPlotted;
if (get(hObject, "Value") == 1)
    set(handles.checkMarkersMenu, "Checked", "on");
    if (not(isPlotted))
        return;
    end
    if (marker == "")
        set(handles.Line, 'Marker', 'none');
    else
        set(handles.Line, 'Marker', convertStringsToChars(marker));
    end
else
    set(handles.checkMarkersMenu, "Checked", "off");
    if (not(isPlotted))
        return;
    end
    set(handles.Line, 'Marker', 'none');
end
    

% --- Executes on button press in blueRadioButton.
function blueRadioButton_Callback(hObject, eventdata, handles)
blueMenu_Callback(handles.blueMenu, eventdata, handles);


% --- Executes on button press in redRadioButton.
function redRadioButton_Callback(hObject, eventdata, handles)
redMenu_Callback(handles.redMenu, eventdata, handles);


% --- Executes on button press in greenRadioButton.
function greenRadioButton_Callback(hObject, eventdata, handles)
greenMenu_Callback(handles.greenMenu, eventdata, handles);


% --- Executes on button press in blackRadioButton.
function blackRadioButton_Callback(hObject, eventdata, handles)
blackMenu_Callback(handles.blackMenu, eventdata, handles);


% --- Executes on button press in magentaRadioButton.
function magentaRadioButton_Callback(hObject, eventdata, handles)
magentaMenu_Callback(handles.magentaMenu, eventdata, handles);



function startIntegrationEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function startIntegrationEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endIntegrationEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function endIntegrationEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in integrationButton.
function integrationButton_Callback(hObject, eventdata, handles)
a = str2double(get(handles.startIntegrationEdit, "String"));
b = str2double(get(handles.endIntegrationEdit, "String"));
if (isnan(a) || isnan(b))
    msgbox("Пределы интегрирования указаны неверно.");
    return
end
if (a > b)
    msgbox("Пределы интегрирования должны быть расставлены в обратном порядке.");
    return
end
global xStart xEnd;
if (a < xStart || b > xEnd)
    msgbox("Пределы интегрирования должны соответствовать текущему графику.");
    return
end
n = 30;
x = linspace(a, b, n);
global func;
if (func == "straight")
    f = inline('x');
elseif (func == "parabola")
    f = inline('x.*x');
else
    f = inline('sqrt(x)');
end
I = 0;
for i = 1 : n - 1
    I = I + f((x(i + 1) + x(i))/2) * (x(i + 1) - x(i));
end
set(handles.squareText, 'String', num2str(I));


function sqaureEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sqaureEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sqaureEdit as text
%        str2double(get(hObject,'String')) returns contents of sqaureEdit as a double


% --- Executes during object creation, after setting all properties.
function sqaureEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sqaureEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in errorPlotButton.
function errorPlotButton_Callback(hObject, eventdata, handles)
a = str2double(get(handles.startIntegrationEdit, 'String'));
b = str2double(get(handles.endIntegrationEdit, 'String'));
if (isnan(a) || isnan(b))
    msgbox("Пределы интегрирования указаны неверно.");
    return
end
if (a > b)
    msgbox("Пределы интегрирования должны быть расставлены в обратном порядке.");
    return
end
global xStart xEnd;
if (a < xStart || b > xEnd)
    msgbox("Пределы интегрирования должны соответствовать текущему графику.");
    return
end
n = 50;
h = (b - a)/n;
x = linspace(a, b, n);
global func;
if (func == "straight")
    f = x;
elseif (func == "parabola")
    f = x.*x;
else
    f = log(x);
end
f1 = diff(f)./diff(x);
f2 = diff(f1)./diff(x(1 : n - 1));
E = f2 * h^3/24;
axes(handles.errorGraph);
handles.ErrorLine = plot(f(1 : n - 2), E);
guidata(gcbo, handles);


% --- Executes on button press in errorClearButton.
function errorClearButton_Callback(hObject, eventdata, handles)
axes(handles.errorGraph);
cla;


% --- Executes on button press in rootButton.
function rootButton_Callback(hObject, eventdata, handles)
set(handles.straightMenu, "Checked", "off");
set(handles.parabolaMenu, "Checked", "off");
set(handles.rootMenu, "Checked", "on");


% --- Executes on button press in straightButton.
function straightButton_Callback(hObject, eventdata, handles)
set(handles.straightMenu, "Checked", "on");
set(handles.parabolaMenu, "Checked", "off");
set(handles.rootMenu, "Checked", "off");


% --------------------------------------------------------------------
function notClearMenu_Callback(hObject, eventdata, handles)
if (get(handles.notClearCheckbox, "Value") == 1)
    set(handles.notClearCheckbox, "Value", 0);
else
    set(handles.notClearCheckbox, "Value", 1);
end
notClearCheckbox_Callback(handles.notClearCheckbox, eventdata, handles);


% --------------------------------------------------------------------
function checkMarkersMenu_Callback(hObject, eventdata, handles)
if (get(handles.markersCheckbox, "Value") == 1)
    set(handles.markersCheckbox, "Value", 0);
else
    set(handles.markersCheckbox, "Value", 1);
end
markersCheckbox_Callback(handles.markersCheckbox, eventdata, handles);


% --------------------------------------------------------------------
function integrationMenu_Callback(hObject, eventdata, handles)
integrationButton_Callback(handles.integrationButton, eventdata, handles);


% --------------------------------------------------------------------
function errorPlotMenu_Callback(hObject, eventdata, handles)
errorPlotButton_Callback(handles.errorPlotButton, eventdata, handles);


% --------------------------------------------------------------------
function errorClearMenu_Callback(hObject, eventdata, handles)
errorClearButton_Callback(handles.errorClearButton, eventdata, handles);


% --------------------------------------------------------------------
function graphMenu_Callback(hObject, eventdata, handles)
% hObject    handle to graphMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function straightMenu_Callback(hObject, eventdata, handles)
set(handles.straightButton, "Value", 1);
set(handles.straightMenu, "Checked", "on");
set(handles.parabolaMenu, "Checked", "off");
set(handles.rootMenu, "Checked", "off");


% --------------------------------------------------------------------
function parabolaMenu_Callback(hObject, eventdata, handles)
set(handles.parabolaButton, "Value", 1);
set(handles.straightMenu, "Checked", "off");
set(handles.parabolaMenu, "Checked", "on");
set(handles.rootMenu, "Checked", "off");


% --------------------------------------------------------------------
function rootMenu_Callback(hObject, eventdata, handles)
set(handles.rootButton, "Value", 1);
set(handles.straightMenu, "Checked", "off");
set(handles.parabolaMenu, "Checked", "off");
set(handles.rootMenu, "Checked", "on");


% --- Executes on button press in parabolaButton.
function parabolaButton_Callback(hObject, eventdata, handles)
set(handles.straightMenu, "Checked", "off");
set(handles.parabolaMenu, "Checked", "on");
set(handles.rootMenu, "Checked", "off");
