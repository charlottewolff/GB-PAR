function [result_point_cloud, target_pointCloud, frameParam, plan_param] = changeToRadarFrame(radar, target, dy, point_cloud)
    %definition variables
    xr = radar.pos(1);
    yr = radar.pos(2);
    zr = radar.pos(3);
    xt = target.pos(1);
    yt = target.pos(2);
    zt = target.pos(3); 

    %unit vector for new frame
    vector_newFrame = [[1 (xt - xr)/(yr - yt) 0 ] ; [1 (yt - yr)/(xt - xr) 0] ; [0 0 1]];
    
    %parameters for frame conversion
    syms a b tx ty tz
    eqns = [a*xt-b*yt+tx==0, b*xt+a*yt+ty==0, zt+tz==0, a*(xt+1)-b*(yt+(xt-xr)/(yr-yt))+tx==1, b*(xt+1)+a*(yt+(xt-xr)/(yr-yt))+ty==0];
    frameParam = solve(eqns,[a b tx ty tz]);
    a   = double(frameParam.a) ; 
    b   = double(frameParam.b)  ;
    tx  = double(frameParam.tx) ;
    ty  = double(frameParam.ty) ;
    tz  = double(frameParam.tz) ;
    rotation_matrice    = [[a -b 0] ; [b a 0] ; [0 0 1]];
    translation_matrice = [tx ; ty ; tz];
    %Conversion point cloud coor in new frame
    result_point_cloud_2 = rotation_matrice * point_cloud(:,1:3)' + translation_matrice;
    result_point_cloud = [point_cloud result_point_cloud_2'];

    %%%%  for checking new point cloud in new frame
    figure_dist = figure();
    handle_dist.a = axes;
    handle_dist.x = result_point_cloud_2(1, :);
    handle_dist.y = result_point_cloud_2(2, :);
    handle_dist.z = result_point_cloud_2(3, :);
    handle_dist.sf = result_point_cloud_2(3,:);
    handle_dist.p = scatter3(handle_dist.x,handle_dist.y,handle_dist.z,70,handle_dist.sf,'filled'); 
    hold on
    scatter3(0,0,0,80,'r','fill')
    title_message = 'frame target'; 
    title(title_message, 'Color','k');
    %%%%  for checking new point cloud in new frame
      
    %Filter point cloud neat target
    radar.Vangle = 5;
    radar.Hangle = 15;
    dx = tand(radar.Hangle) * sqrt((xr-xt)^2 + (yr-yt)^2 + (zr-zt)^2);
    dz = tand(radar.Vangle) * sqrt((xr-xt)^2 + (yr-yt)^2 + (zr-zt)^2);
%     dx= 15;  
     dy = dz;
%     dz = 45;
    target_pointCloud =  result_point_cloud;
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,8)> -dz), :); 
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,8)< dz), :);
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,7)> -dy), :);
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,7)< dy), :);
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,6)> -dx), :);
    target_pointCloud = target_pointCloud(find(target_pointCloud(:,6)< dx), :);

    %il faut garder les coordonnées du premier nuage 
    %add column bool 
    % 0 : NOT SEEN BY RADAR
    % 1 : SEEN BY RADAR 
    bool_matrice = zeros(size(result_point_cloud,1), 1);
    for li = 1:size(result_point_cloud,1)
        if result_point_cloud(li,8)>-dz && result_point_cloud(li,8)<dz && result_point_cloud(li,7)> -dz && result_point_cloud(li,7)<dz && result_point_cloud(li,6)> -dx && result_point_cloud(li,6)<dx
            bool_matrice(li) = 1;
        end
    end 
    result_point_cloud = [result_point_cloud , bool_matrice];
    
   %Plot result graph
    figure_frame = figure();
    handle_frame.a = axes;
    handle_frame.x = target_pointCloud(:, 1);
    handle_frame.y = target_pointCloud(:, 2);
    handle_frame.z = target_pointCloud(:, 3);
    handle_frame.sf = target_pointCloud(:,3);
    handle_frame.p = scatter3(handle_frame.x,handle_frame.y,handle_frame.z,5,handle_frame.sf,'filled'); 
    hold on
   

    %estimate mean plan
    [paramPlan, plan, N_vect] = plan_estimate(target_pointCloud(:,(1:3)));
    
%     paramPlan
%     handle_frame.p2 = scatter3(plan(:,1),plan(:,2),plan(:,3),3,'r','filled'); 
    tri = delaunay(plan(:,1), plan(:,2));
    handle_frame.p3 = trisurf(tri, plan(:,1), plan(:,2), plan(:,3),'Facecolor','red', 'EdgeColor', 'none', 'FaceAlpha',.7);
    handle_frame.p3
    pt = [717700, 148200, 717700*paramPlan(1) + 148200*paramPlan(2) + paramPlan(3)];
    pt2 = [pt; pt + 500*N_vect];
    axis equal
    %handle_frame.p3 = scatter3(pt2(:,1),pt2(:,2),pt2(:,3), 'k', 'filled');
    view(-50,35)
    %synt
    view(-125,18)
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = 'Illuminated area with mean plan'; 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Height';
    
    %conversion dip/dip direction
    [dip, dip_dir] = normal2dip(N_vect);
    plan_param.PC         = plan;
    plan_param.N_vect     = N_vect;
    plan_param.dip        = dip; 
    plan_param.dip_dir    = dip_dir;
    plan_param.paramPlan  = paramPlan; 
   
    
end