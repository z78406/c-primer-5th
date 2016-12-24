function [H2to1] = computeH(p1,p2);


p1(:,3) = 1;
p2(:,3) = 1;
for i = 1:5
A(2*i-1,:) = [p2(i,:) 0 0 0 p2(i,:)*(-p1(i,1))];
A(2*i,:) =   [0 0 0 p2(i,:) -p1(i,2)*p2(i,:)];
end;
[U,S,V] = svd(A'*A);
H2to1 = V(:,end);
H2to1 = vec2mat(H2to1, 3);

end




