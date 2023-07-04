function varargout = UI_plot(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_plot_OutputFcn, ...
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


% --- Executes just before UI_plot is made visible. 
function UI_plot_OpeningFcn(hObject, ~, handles, varargin)
    handles.output          = hObject;
    handles.test            = 1;
    handles.radar           = struct('Hangle', 5, 'Vangle', 5, 'pos', [0,0,0], 'target', [0,0,0], 'dip', -2, 'dip_direction', 0, 'selected', 0,'selected2', 0, 'distance', 0, 'target2', [0,0,0], 'frequency', 175, 'aperture', 3);
    handles.target           = struct('pos', [0,0,0], 'target', [0,0,0], 'dip', -2, 'dip_direction', 0, 'selected', 0,'selected2', 0, 'distance', 0, 'target2', [0,0,0], 'frequency', 75, 'aperture', 3);
    handles.point_cloud     = [];
    handles.select_point    = 0;
    handles.figure1         = struct();
    handles.dy              = 5;
    guidata(hObject, handles);

function varargout = UI_plot_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output;

function load_button_Callback(hObject, ~, handles) %#ok<*DEFNU>
    [file,path] = uigetfile('*.txt', 'Select joint file');
    if isequal(file,0)
        disp('No file selected');
        return;
    end   
   handles.input_file = file;
   input_file = fullfile(path,file);
   %enable button, plot point cloud
   set(handles.x_edit, 'Enable', 'on')
   set(handles.y_edit, 'Enable', 'on')
   set(handles.z_edit, 'Enable', 'on')
   set(handles.ok_location_button, 'Enable', 'on')
   
   %plot point cloud   
   handles.point_cloud   = readmatrix(input_file);
   
   %check column nb : X Y Z dip dip_dir
   nb_column = size(handles.point_cloud, 2);
   if  nb_column < 5
       error("Not enough columns : X Y Z dip dip_dir")
   elseif nb_column > 5
       error("Too many columns : X Y Z dip dip_dir")
   end
   
   set(handles.x_edit, 'Value', max(handles.point_cloud(:,1)));
   set(handles.y_edit, 'Value', max(handles.point_cloud(:,2)));
   set(handles.z_edit, 'Value', max(handles.point_cloud(:,3)));
   set(handles.x_edit, 'String', max(handles.point_cloud(:,1)));
   set(handles.y_edit, 'String', max(handles.point_cloud(:,2)));
   set(handles.z_edit, 'String', max(handles.point_cloud(:,3)));
   
   figure(1)
   handles.figure1 = plot_pt(handles.point_cloud);
   guidata(hObject, handles)

function x_edit_Callback(~, ~, handles) %#ok<INUSD>

function x_edit_CreateFcn(hObject, ~, handles) %#ok<INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_edit_Callback(~, ~, handles) %#ok<INUSD>

function y_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function z_edit_Callback(~, ~, handles) %#ok<INUSD>

function z_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_button_Callback(~, ~, handles)   
    if handles.radar.selected
        delete(handles.figure1.radarPlot)
        delete(handles.figure1.labels)
    elseif handles.radar.selected == 2 
        delete(handles.figure1.radarPlot)
        delete(handles.figure1.labels)
        delete(handles.figure1.targetPlot)
        delete(handles.figure1.labelss)
        delete(handles.figure1.radarDirection)
    end
    
function ok_location_button_Callback(hObject, ~, handles)
   %enable button, plot point cloud
   set(handles.x_target_edit, 'Enable', 'on')
   set(handles.y_target_edit, 'Enable', 'on')
   set(handles.z_target_edit, 'Enable', 'on')
   set(handles.ok_target_location_button, 'Enable', 'on')
   
   set(handles.x_target_edit, 'Value', min(handles.point_cloud(:,1)));
   set(handles.y_target_edit, 'Value', min(handles.point_cloud(:,2)));
   set(handles.z_target_edit, 'Value', min(handles.point_cloud(:,3)));
   set(handles.x_target_edit, 'String', min(handles.point_cloud(:,1)));
   set(handles.y_target_edit, 'String', min(handles.point_cloud(:,2)));
   set(handles.z_target_edit, 'String', min(handles.point_cloud(:,3)));


    figure(1)
    str = get(handles.frequency_edit, 'String');
    if isnan(str2double(str))|| str2double(str)<=0 || str2double(str)>30 
        set(handles.frequency_edit, 'String','75');
        warning('Input must be numerical');
    end
   
    if handles.radar.selected
        delete(handles.figure1.radarPlot)
        delete(handles.figure1.labels)
    elseif handles.radar.selected == 2
        delete(handles.figure1.radarPlot)
        delete(handles.figure1.labels)
        delete(handles.figure1.radarDirection)
    end
    
    % Get radar info
    handles.radar.selected  = 1;
    handles.radar.pos       = [str2double(get(handles.x_edit, 'String')), str2double(get(handles.y_edit, 'String')), str2double(get(handles.z_edit, 'String'))];
    handles.radar.aperture  = get(handles.aperture_slider, 'Value');
    handles.radar.frequency = 175;
    %handles.radar.frequency = str2double(get(handles.frequency_edit, 'String'));
    handles.figure1.radarPlot = scatter3(handles.radar.pos(1),handles.radar.pos(2),handles.radar.pos(3),50,'r','fill');
    labels = {'Radar position'};
    handles.figure1.labels = text(handles.radar.pos(1),handles.radar.pos(2),handles.radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
    handles.figure1;
    
    %handles.dist_map = plot_distMap(handles.radar, handles.point_cloud);    
    guidata(hObject, handles) 
    
        handles.radar.pos(1)        = str2double(get(handles.x_edit, 'String')); 
        handles.radar.pos(2)        = str2double(get(handles.y_edit, 'String'));
        handles.radar.pos(3)        = str2double(get(handles.z_edit, 'String'));

        %dip & dip direction
        handles.radar.dip_direction = rad2deg(pi/2 - cart2pol(handles.radar.target(1)-handles.radar.pos(1), handles.radar.target(2)-handles.radar.pos(2)));
        if handles.radar.dip_direction<0
            handles.radar.dip_direction = handles.radar.dip_direction + 360;
        end
        handles.radar.distance = sqrt((handles.radar.pos(1)-handles.radar.target(1))^2 + (handles.radar.pos(2)-handles.radar.target(2))^2 + (handles.radar.pos(3)-handles.radar.target(3))^2);
        handles.radar.dip = asind ((handles.radar.target(3) - handles.radar.pos(3)) / handles.radar.distance);

        %Analyse result 
        handles.result_point_cloud = plot_3d_result(handles.radar, handles.point_cloud);
        guidata(hObject, handles)

    
function save_button_Callback(~, ~, handles)
    save_name = strrep(handles.input_file,'.', '_forshortening.');
    [save_file,save_path] = uiputfile(save_name);
    save_file = fullfile(save_path,save_file);

    fid = fopen(save_file, 'w');
    % Print header
    fprintf(fid, 'Radar position\n');
    fprintf(fid,'%f %f %f %f\n\n', handles.radar.pos);
    fprintf(fid, '\nx y z f_fa forshortening\n');
    % Print point cloud 
    fprintf(fid, '%f %f %f %f %f %f\n', (handles.result_point_cloud).');
    fclose(fid);       	


function saveDist_button_Callback(~, ~, handles)
    save_name = strrep(handles.input_file,'.', '_distMap.');
    [save_file,save_path] = uiputfile(save_name);
    save_file = fullfile(save_path,save_file);

    fid = fopen(save_file, 'w');
    %%%%% Print header
    %radar info : frequency - width aperture angle
    fprintf(fid, 'Radar frequency\n');
    fprintf(fid,'%f\n', handles.radar.frequency);
    fprintf(fid, 'Radar rail width\n');
    fprintf(fid,'%f\n', handles.radar.aperture);
    fprintf(fid, 'Radar aperture angle\n');
    fprintf(fid,'%f\n', handles.radar.Vangle);
    %radar pos
    fprintf(fid, 'Radar position\n');
    fprintf(fid,'%f %f %f %f\n', handles.radar.pos);
    %target pos
    fprintf(fid, 'Target position\n');
    fprintf(fid,'%f %f %f %f\n', handles.target.pos);
    %distance to target
    fprintf(fid, 'Distance radar - target\n');
    fprintf(fid,'%f\n', handles.target.pos);    
    %nb pixel in range
    fprintf(fid, 'Nb pixel in range\n');
    fprintf(fid,'%f\n', handles.target.nb_pixel_range);    
    %range and azimuth resolution 
    fprintf(fid, 'Resolution azimuth - range\n');
    fprintf(fid,'%f - %f\n', handles.target.az_resolution, handles.target.range_resolution);      
    %mean plan - dip - dip direction 
    fprintf(fid, 'Plan fitting target : normal_x normal_y normal_z - dip/dip direction\n');
    fprintf(fid,'%f %f %f // %f / %f\n', handles.target.fit_plan.N_vect(1), handles.target.fit_plan.N_vect(2), handles.target.fit_plan.N_vect(3), handles.target.fit_plan.dip, handles.target.fit_plan.dip_dir); 
    
    %%%%% Print point cloud 
    xyz_raw     = handles.result_point_cloud(:, (1:3));
    dist_radar  = handles.result_point_cloud(:, 6);
    azi_reso    = handles.result_point_cloud(:, 7);
    range_reso  = handles.result_point_cloud(:, 8);
    xyz_radar   = handles.result_point_cloud2(:, (6:8));
    target_bool = handles.result_point_cloud2(:, 9);
    print_point_cloud = [xyz_raw , dist_radar, azi_reso, range_reso, xyz_radar, target_bool];
    fprintf(fid, '\nx y z dist2radar azi_reso range_reso x_radar y_radar_z_radar targetted_bool\n');
    fprintf(fid, '%f %f %f %f %f %f %f %f %f %f \n', (print_point_cloud).');
    fclose(fid);       	

function aperture_slider_Callback(hObject, ~, handles)
    handles.radar.aperture = get(handles.aperture_slider, 'Value'); 
    set(handles.aperture_text_edit, 'String', handles.radar.aperture);
    guidata(hObject, handles)

function aperture_slider_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function frequency_edit_Callback(hObject, ~, ~) %#ok<INUSD>

function frequency_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function aperture_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function aperture_text_edit_CreateFcn(hObject, ~, ~) %#ok<INUSD>

function aperture_edit_Callback(hObject, ~, ~) %#ok<INUSD>

function x_target_edit_Callback(~, ~, handles) %#ok<INUSD>

function x_target_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_target_edit_Callback(~, ~, handles) %#ok<INUSD>

function y_target_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function z_target_edit_Callback(~, ~, handles) %#ok<INUSD>

function z_target_edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ok_target_location_button_Callback(hObject, ~, handles)
    %enable to store results 
    set(handles.saveDist_button, 'Enable', 'on') %store result button now
    %Get radar vertical aperture angle
    handles.radar.Vangle = str2double(get(handles.aperture_edit, 'String'));
    fprintf('Radar vertical aperture angle value : %f\n', handles.radar.Vangle)
    
    figure(1)
    handles.target.pos       = [str2double(get(handles.x_target_edit, 'String')), str2double(get(handles.y_target_edit, 'String')), str2double(get(handles.z_target_edit, 'String'))];
    handles.figure1.targetPlot = scatter3(handles.target.pos(1),handles.target.pos(2),handles.target.pos(3),50,'w','fill');
    labels = {'Target position'};
    handles.figure1.labels = text(handles.target.pos(1),handles.target.pos(2),handles.target.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
    handles.figure1;
    
    handles.target.dist_target_radar = sqrt((handles.target.pos(1) - handles.radar.pos(1))^2 + (handles.target.pos(2) - handles.radar.pos(2))^2 + (handles.target.pos(3) - handles.radar.pos(3))^2);
    
    %Resolution
    dist_map_target         = plot_distMap(handles.target, handles.point_cloud); 
    [~,target_point_index]  = min(dist_map_target(:,4));
    target_range_resolution = handles.result_point_cloud(target_point_index, 8);
    target_az_resolution    = handles.result_point_cloud(target_point_index, 7);
    
    %Target area and mean plan
    [handles.result_point_cloud2, ~, frameParam, handles.target.fit_plan] = changeToRadarFrame(handles.radar, handles.target, handles.dy, handles.point_cloud);
    
    %Nb pixels in range
    %nb_pixel_range = compute_nbPixel_range(handles.radar, handles.target, handles.target.fit_plan, target_range_resolution)
%     dh = tand(handles.radar.Vangle/2)*dist_target_radar
%     nb_pixel_range = dh/sind(abs(handles.target.fit_plan.dip))

    %Mean foreshortening 
    foreshortening = compute_foreshortening(handles.point_cloud, handles.target.fit_plan, handles.radar, handles.target);
    
    
    %resume
    %handles.target.nb_pixel_range   = nb_pixel_range;
    handles.target.range_resolution = target_range_resolution; 
    handles.target.az_resolution    = target_az_resolution;
    fprintf('Target azimuth resolution : %f. \n', target_az_resolution)
    fprintf('Target range resolution : %f. \n', target_range_resolution)
    %fprintf('Nombre de pixels en range : %f. \n ', nb_pixel_range)
    disp('out')
    
    %Plot target area on first figure 
    figure(1)
    t = handles.result_point_cloud2(find(handles.result_point_cloud2(:,9)==1), (1:3));
    scatter3(t(:, 1),t(:, 2),t(:, 3),10,'*');
    
    %enable to store results
    set(handles.saveDist_button, 'Enable', 'on') %store result button now
    
    guidata(hObject, handles)



function H_aperture_edit_Callback(hObject, eventdata, handles)
% hObject    handle to H_aperture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H_aperture_edit as text
%        str2double(get(hObject,'String')) returns contents of H_aperture_edit as a double


% --- Executes during object creation, after setting all properties.
function H_aperture_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_aperture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
