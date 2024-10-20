function ison = is_point_on_segment(A, B, M, mode)
%% is_point_on_segment : function to compute if a point M belongs
% or not to a given [AB] segment of the 2D or 3D space. Also handles
% multiple points M to test for a same [AB] segment. 
%
% Author : nicolas.douillet (at) free.fr, 2024.
%
%
% Syntax
%
% ison = is_point_on_segment(A, B, M);
% ison = is_point_on_segment(A, B, M, mode);
% 
%
% Description
%
% ison = is_point_on_segment(A, B, M) computes if the point M belongs to the [AB] segment.
% By default the segment boundaries A and B are included.
%
% ison = is_point_on_segment(A, B, M, mode) uses [AB] closed segment when
% mode is set to 'closed'* and ]AB[ opened segment when mode is set to
% 'opened'.
%
%
% Input arguments
%
% - A = [Ax Ay Az], numeric row vector double, [AB] segment begining point. size(A) = [1 nbdims] with 2 <= nbdims <= 3.
%
% - B = [Bx By Bz], numeric row vector double, [AB] segment end point.      size(B) = [1 nbdims] with 2 <= nbdims <= 3.
%
%       [ |  |  |] 
% - M = [Mx My Mz], numeric vector or matrix double, the point(s) to test. size(M) = [nb_pts2test nbdims] with 2 <= nbdims <= 3.
%       [ |  |  |]
%
%
% - mode : character string in the set {'closed','opened','CLOSED','OPENED'},
% variable to set the state of the A and B boundaries behaviour. A and B are included
% -belong to the segment- when mode is set to 'closed'/'CLOSED'* whereas
% they are excluded -don't belong to the segment- when mode is set to 'opened'/'OPENED'.
%
%
% Output argument
%
% - ison : logical true (1)/false (0). ison = true when M belongs to [AB] segment, and ison = false otherwise. 
%
%
% Example#1 : 2D
% A = [1.5, 0];
% B = [3.5, 0];
% M1 = [sqrt(2), 0];
% is_point_on_segment(A, B, M1) % expected result : ison = false
% M2 = [pi, 0];
% is_point_on_segment(A, B, M2) % expected result : ison = true
%
%
% Example #2 : 1st 3D bissectrice
%
% A = [0 0 0];
% B = [1 1 1];
% M1 = (2/3)*B;
% is_point_on_segment(A, B, M1)          % expected result : ison = true
% M2 = 1.0001*B;
% is_point_on_segment(A, B, M2)          % expected result : ison = false
% M3 = [0.6666 0.6667 0.6666];
% is_point_on_segment(A, B, M3)          % expected result : ison = false
% M4 = B;
% is_point_on_segment(A, B, M4,'opened') % expected result : ison = false
% 
%
% Example #3 : multiple points handling
%
% M = cat(1,M1,M2,M3,M4)
% is_point_on_segment(A, B, M) % expected result : ison = [true, false, false, true]'


%% Input parsing
if nargin < 4
    
    mode = 'closed';

end


%% Body
ison = false(size(M,1),1);
precision = eps;
u = B - A;
d2H = point_to_line_distance(M,u,A);
f = find(d2H <= precision);


if strcmpi(mode,'closed')
        
    ison(f) = dot(M(f,:)-repmat(A,[numel(f),1]),M(f,:)-repmat(B,[numel(f),1]),2) <= 0;
    
elseif strcmpi(mode,'opened')
   
    ison(f) = dot(M(f,:)-repmat(A,[numel(f),1]),M(f,:)-repmat(B,[numel(f),1]),2) < 0;
    
end


end % is_point_on_segment


%% point_to_line_distance subfunction
function [d2H, H] = point_to_line_distance(P, u, I0)
%
% Author : nicolas.douillet (at) free.fr, 2019-2024.


[nb_pts, nbdim] = size(P);

% Body
if nbdim == 2
    
    t_H = (u(1)*(P(:,1)-repmat(I0(1),[nb_pts,1])) + ...
           u(2)*(P(:,2)-repmat(I0(2),[nb_pts,1]))) / ...
           sum(u.^2);
    
elseif nbdim == 3
    
    t_H = (u(1)*(P(:,1)-repmat(I0(1),[nb_pts,1])) + ...
           u(2)*(P(:,2)-repmat(I0(2),[nb_pts,1])) + ...
           u(3)*(P(:,3)-repmat(I0(3),[nb_pts,1])) ) / ...
           sum(u.^2);

end

% Distance
H = I0 + t_H*u;
d2H = sqrt(sum((P-H).^2,2));


end % point_to_line_distance