function plot_radar_POS(handles)
    click_point = handles.figure1.a.CurrentPoint(2,:);
    if handles.select_point == 0 % radar location selection
        handles.radar.pos(1) = click_point(1);
        handles.radar.pos(2) = click_point(2);
    end
    handles.radar.pos

end