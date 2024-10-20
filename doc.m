%% is_point_on_segment
%
% Function to compute if a point M belongs or not to a given [AB] segment
% of the 2D or 3D space. Also handles multiple points M to test for a same [AB] segment. 
%
% Author : nicolas.douillet (at) free.fr, 2024.
%
%
%% Syntax
%
% ison = is_point_on_segment(A, B, M);
% ison = is_point_on_segment(A, B, M, mode);
% 
%
%% Description
%
% ison = is_point_on_segment(A, B, M) computes if the point M belongs to the [AB] segment.
% By default the segment boundaries A and B are included.
%
% ison = is_point_on_segment(A, B, M, mode) uses [AB] closed segment when
% mode is set to 'closed'* and ]AB[ opened segment when mode is set to
% 'opened'.
%
%% See also
%
% <https://fr.mathworks.com/matlabcentral/fileexchange/73478-point-to-line-distance-fast?s_tid=srchtitle point_to_line_distance> |
% <https://fr.mathworks.com/matlabcentral/fileexchange/73760-line-plane-intersection-fast?s_tid=srchtitle line_plane_intersection>
%
%% Input arguments
%
% - A = [Ax Ay Az], numeric row vector double, [AB] segment begining point. size(A) = [1 nbdims] with 2 <= nbdims <= 3.
%
% - B = [Bx By Bz], numeric row vector double, [AB] segment end point.      size(B) = [1 nbdims] with 2 <= nbdims <= 3.
%
%        [ |  |  |] 
% - M = [Mx My Mz], numeric vector or matrix double, the point(s) to test. size(M) = [nb_pts2test nbdims] with 2 <= nbdims <= 3.
%        [ |  |  |]
%
%
% - mode : character string in the set {'closed','opened','CLOSED','OPENED'},
% variable to set the state of the A and B boundaries behaviour. A and B are included
% -belong to the segment- when mode is set to 'closed'/'CLOSED'* whereas
% they are excluded -don't belong to the segment- when mode is set to 'opened'/'OPENED'.
%
%
%% Output argument
%
% - ison : logical true (1)/false (0). ison = true when M belongs to [AB] segment, and ison = false otherwise. 
%
%
%% Example#1 : basic 2D

A = [1.5, 0];
B = [3.5, 0];
M1 = [sqrt(2), 0];
is_point_on_segment(A, B, M1) % expected result : ison = false
M2 = [pi, 0];
is_point_on_segment(A, B, M2) % expected result : ison = true

%% Example #2 : 1st 3D bissectrice

A = [0 0 0];
B = [1 1 1];
M1 = (2/3)*B;
is_point_on_segment(A, B, M1)          % expected result : ison = true
M2 = 1.0001*B;
is_point_on_segment(A, B, M2)          % expected result : ison = false
M3 = [0.6666 0.6667 0.6666];
is_point_on_segment(A, B, M3)          % expected result : ison = false
M4 = B;
is_point_on_segment(A, B, M4,'opened') % expected result : ison = false

%% Example #3 : multiple points handling

M = cat(1,M1,M2,M3,M4);      % here mode = 'closed' by default, hence M4 belongs to [AB]
is_point_on_segment(A, B, M) % expected result : ison = [true, false, false, true]'