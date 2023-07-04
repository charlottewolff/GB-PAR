function [paramPlan, plan, N_vect] = plan_estimate(point_cloud)
    %estimation of the mean plan using Least Mean Square
    % paramPlan = X = (At.A)-1 . (At.B)
    
    B = point_cloud(:,3);
    A = [point_cloud(:,[1,2]) , ones(size(point_cloud, 1),1)];
    
    paramPlan = inv(A' * A) * A' * B;

    %Create the plan
    a = paramPlan(1);
    b = paramPlan(2);
    c = paramPlan(3);
    
    Z = a*point_cloud(:,1) + b*point_cloud(:,2) + c;
    plan = [point_cloud(:,[1,2]) , Z];
    
    %Normal vector
    %plan equation is Ax + By + Cz + D = 0, n = (A,B,C)
    % D = 1
    C = -1;
    A = a;
    B = b;
    N_vect = [A, B, C];
    
    
    
end
