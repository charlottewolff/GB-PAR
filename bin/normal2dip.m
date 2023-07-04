function [dip, dip_dir] = normal2dip(norm_vect)
    %%%Conversion vector normal to dip/dip direction

    dip     = atand(norm_vect(3)/sqrt(norm_vect(1)^2 + norm_vect(2)^2))
    dip_dir = atand(norm_vect(2)/norm_vect(1)) 
    
end