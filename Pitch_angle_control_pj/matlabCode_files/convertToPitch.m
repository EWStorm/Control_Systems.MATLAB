%convert to pitch 

function pitch =convertToPitch (acceleration) 

acceleration_x=acceleration(1);
acceleration_y=acceleration(2);
acceleration_z=acceleration(3);

pitch= atand(acceleration_x/sqrt(acceleration_y^2+acceleration_z^2)); 

end 