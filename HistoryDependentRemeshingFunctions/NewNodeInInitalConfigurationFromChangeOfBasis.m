function [P_0] = NewNodeInInitalConfigurationFromChangeOfBasis(Nodes_0,DeformedNodes,NewPoint)
                                                             % Inital Nodes --  Old Mesh
                                                             % Deformed nodes --  Old Mesh
                                                             % Point -- New Mesh
% Translate each to origin
% InitalConfiguration
vector_12_0 = Nodes_0(2,:) - Nodes_0(1,:); % Inital Vectors in old mesh 
vector_13_0 = Nodes_0(3,:) - Nodes_0(1,:); % Inital Vectors in old mesh 

% Deformed nodes in old mesh 

vector_12 = DeformedNodes(2,:) - DeformedNodes(1,:);%  DEFORMED Vectors in old mesh 
vector_13 = DeformedNodes(3,:) - DeformedNodes(1,:);%  DEFORMED Vectors in old mesh 


% Need to put P into a corrdinate system with the basis vectors
% vector_12, and vector_13. First need to translate by -Nodes(1,:)
% beacuse all the points in this triangle have ( including the
% basis vectors)

z_basis = cross(vector_12, vector_13);
P_translated = NewPoint - DeformedNodes(1,:);

 x1 = vector_12(1);
y1 = vector_12(2);
z1 = vector_12(3);

x2 = vector_13(1);
y2 = vector_13(2);
z2 = vector_13(3);

x3 = z_basis(1);
y3 = z_basis(2);
z3 = z_basis(3);

p1 = P_translated(1);
p2 = P_translated(2);
p3 = P_translated(3);

C1 = -((p1 *y2 *z3 - p1* y3* z2 - p2* x2 *z3 + p2* x3* z2 + p3* x2 *y3 - p3* x3 *y2)/(-x1 *y2 *z3 + x1* y3 *z2 + x2* y1* z3 - x2 *y3 *z1 - x3* y1 *z2 + x3* y2* z1));
C2 = -((-p1 *y1 *z3 + p1 *y3 *z1 + p2*x1* z3 - p2* x3 *z1 - p3 *x1 *y3 +  p3 *x3 *y1)/(-x1* y2 *z3 + x1 *y3* z2 + x2 *y1* z3 - x2* y3 *z1 - x3 *y1 *z2 +  x3* y2 *z1));
C3 = -((-p1 *y1 *z2 + p1 *y2* z1 + p2 *x1 *z2 - p2* x2 *z1 - p3* x1 *y2 + p3* x2 *y1)/(x1 *y2 *z3 - x1 *y3* z2 - x2 *y1 *z3 + x2* y3 *z1 + x3 *y1 *z2 - x3 *y2 *z1));

PointInNewRef = C1 * vector_12 + C2 * vector_13 + C3 * z_basis;
Difference = PointInNewRef - P_translated;
    if norm(Difference) > 0.001
        keyboard
    end




% (C1, C2) now define where the point (translated) is in the
% corrdinate system defined by the Transalted triangle at time t

% I will then get P (translated) in the rotated triangle by
% switching the basis vectors for the rotated basis vectors i.e I
% will rotate the basic vectors to rotate everything in the
% triangle

z_basis_0 = cross(vector_12_0, vector_13_0);

InitalPoint_Trans = C1 * vector_12_0 + C2 * vector_13_0 + C3 * z_basis_0;
P_0 = InitalPoint_Trans + Nodes_0(1,:);

end



function N = ShapeFuncton(a,b,c, Point)

N = a * Point(1) + b * Point(2) + c;

end


function [H] = PlotMesh(Edges, Nodes, H, colour)

t = length(Edges);
for i = 1:t
    
    plot(Nodes(Edges(i,:),1), Nodes(Edges(i,:),2),'LineWidth',3,'color', colour)
    hold on
end

end

function [H] = PlotMesh3(Edges, Nodes, H, colour)

t = length(Edges);
for i = 1:t
    plot3(Nodes(Edges(i,:),1), Nodes(Edges(i,:),2), Nodes(Edges(i,:),3),'LineWidth',3,'color', colour)
    hold on
end

end




%
%     X1 = [x2;x3];
%    Nodes2 = Nodes - Nodes(1,:)
%    Nodes2 = Nodes2(2:3,1:2)
%  % A * Nodes = X1
%    A = X1/Nodes2
%    A2= X1.*inv(Nodes2)
%    A .* Nodes2
%    A2 .* Nodes2
%    X
%
% %    assert(A * Nodes == X)
%
%     RotatedPoints = [dot(A(1,:),P), dot(A(2,:),P)] ;





% Now I have the rotated and translated triangles and points,
% everything is based at the origin, and I can get the shape
% functions and the Displacment vectors Vi.
% Note the way the displacement function works is I need to be
% getting the shape functions from the time t triangle. I can then
% use the displacement funciton to get the displacement of any point
% in the time t triangle, thus giving me the equivilant point P in
% % the original triangle.
% 
% [a,b,c] = ShapeFunctions(X);
% [V1,V2,V3] = DispalcementVectors( ClosestOldNodes, X, X_0);
% 
% % get the shape functions, then try to use this to check if distorted
% % shapes are mapped back
% 
% % Double check the shape function is right
% %assert(1==round(ShapeFuncton(a(1),b(1),c(1), X(1,:)),5) && 1e-9>abs(ShapeFuncton(a(1),b(1),c(1), X(2,:))))
% %assert(1e-9>ShapeFuncton(a(1),b(1),c(1), X(3,:)))
% %assert(ShapeFuncton(a(2),b(2),c(2), X(1,:))<1e-9 && 1==round(ShapeFuncton(a(2),b(2),c(2), X(2,:)),5) && 1e-9>ShapeFuncton(a(2),b(2),c(2), X(3,:)))
% %assert(1e-9>ShapeFuncton(a(3),b(3),c(3), X(1,:)) && 1e-9>ShapeFuncton(a(3),b(3),c(3), X(2,:)) && round(ShapeFuncton(a(3),b(3),c(3), X(3,:)),5)==1 )
% 
% 
% % Put the rotated Point into the rotated inital triangle
% RotatedP_0 =  RotatedP + ShapeFuncton(a(1),b(1),c(1),  RotatedP) *V1 + ShapeFuncton(a(2),b(2),c(2),RotatedP) *V2 + ShapeFuncton(a(3),b(3),c(3),RotatedP) *V3;
% % scatter(RotatedP_0(1), RotatedP_0(2), 300,'r', 'filled'); % Plot the cells 1 put into other
% 
% % now chance the basic of the new node
% syms a1 a2 a3;
% z_basis = cross(x2_0, x3_0);
% eqns = [RotatedP_0 == a1*x2_0 + a2*x3_0 + a3*z_basis];
% vars = [a1,a2,a3];
% [A,B,C] = solve(eqns,vars);
% 
% A1 = double(A);
% A2 = double(B);
% A3 = double(C);
% % RotatedP_0 in the basic configuation of the rotated inital
% % triangle -- basic vectors are give by x2_0, x3_0
% V2 = A1 *x2_0 + A2 *x3_0 + A3*z_basis;
% assert(round(V2(1),5) == round(RotatedP_0(1),5));
% % scatter(V2(1), V2(2), 300,'k'); % Plot the cells 1 put into other
% 
% 
% % Now un-rotate the basis vectors for the inital triangle so I
% % can have the Point definded in the inital trianlge in its
% % origial configuration -- need to remeber to translate after
% % rotating
% BasicVectors0_1 = Nodes_0(2,:) - Nodes_0(1,:);
% BasicVectors0_2 = Nodes_0(3,:) - Nodes_0(1,:);
% z_basis = cross(BasicVectors0_1, BasicVectors0_2);
% P_0_Translated = A1 *BasicVectors0_1  + A2 *BasicVectors0_2 + A3 * z_basis;
%  P_0 = P_0_Translated + Nodes_0(1,:);
% plot =0;
% if plot ==1
% 
%    
%     close all 
%     J= figure();
%     hold on
%     [J] = PlotMesh(edges, Nodes_0, J, 'k')
%     [J] = PlotMesh(edges, Nodes, J, 'b')
%     scatter(P(1), P(2), 200,'b', 'filled'); % Plot the cells 1
% 
%     scatter(P_0(1), P_0(2), 50,'r','filled'); % Plot the cells 1 put into other
%     scatter(P_0(1), P_0(2), 50,'k'); % Plot the cells 1 put into other
%     drawnow
%     pause(2)
%     title("Original Configuation")
% end

