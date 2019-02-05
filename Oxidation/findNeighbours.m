function [locationMat]= findNeighbours(m,cbnd)
format short g
locationMat = zeros(size(m,2), 5);
for i=1:size(m,2)
  mx = max(m(i), cbnd(1,1));
  mx = min(mx, cbnd(1,end));
  eqflag=0;
  %find the index of the closest grid point to the marker
  [diffval idx1]=min(abs(mx - cbnd(1,:)));
  %value of the grid point with the closest distance to the marker
  val1=cbnd(1,idx1);
  %marker is on the right side of the grid index idx1
  if val1 < mx
    idx2 = idx1 + 1;
  %marker is on the left side of the grid index idx1
  elseif val1 > mx
    idx2 = idx1;
    idx1 = idx1 - 1;
  %marker is on the grid index idx1
  else
    eqflag = 1;
    if m(i) <= cbnd(1,1) 
      eqflag = 2;
    end
    if m(i) >= cbnd(1,end) 
      eqflag = 3;
    end
    idx2 = idx1;
  end
  val1=cbnd(1,idx1);
  val2=cbnd(1,idx2);
  locationMat(i,:) = [idx1 idx2 mx-val1 val2-mx eqflag];
end
end