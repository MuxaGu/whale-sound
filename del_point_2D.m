function new_points=del_point_2D (points, a1, a2)
%This function find the points which located in square area and defined
%by two points 'a1' and 'a2'. It removes them from the input vector.

new_points=[];
 X_from = min(a1(1),a2(1));
 X_to = max(a1(1),a2(1));
 Y_from = min(a1(2),a2(2));
 Y_to = max(a1(2),a2(2));
for i=1:size(points,1)
   if points(i,1)<X_from || points(i,1)>X_to ||...
           points(i,2)<Y_from || points(i,2)>Y_to
       new_points=[new_points; points(i,:)];
   end
end

