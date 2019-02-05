%% Calculate marker movements 
function [VkMarker mrk VmMarker JvaMarker] = markerV(flx,Vm,t,mrk,cvcc)
for j= 1 : size(flx,3)
  Jtot(j)= sum(flx(1,:,j)); %all components
  Jsub(j)= (flx(1,2,j) + flx(1,4,j)+ flx(1,5,j)); %only substitutionals
  Jva(j)= -1 * Jsub(j);
end

Neighbours = findNeighbours(mrk,cvcc);

for i = 1:size(mrk,2)
  switch Neighbours(i,5)
    case 0 %middel
      idxLeft=Neighbours(i,1);
      idxRight=Neighbours(i,2);
      L= sum(Neighbours(i,3:4));
      LLeft=Neighbours(i,3);
      LRight=Neighbours(i,4);
      JvaLeft=Jva(1,idxLeft);
      JvaRight=Jva(1,idxRight);
      JvaMarker(i)= JvaLeft* (LRight/L) + JvaRight*(LRight/L);
      %VmMarker(i)=  Vm(idxLeft)* (LRight/L) + Vm(idxRight)*(LRight/L);
      VmMarker(i)=  Vm(idxLeft);
      VkMarker(i)= JvaMarker(i) * VmMarker(i);
    case 1 %middle equal
      idxC=Neighbours(i,1);
      VkMarker(i)= Jva(1,idxC) * Vm(idxC);
    case 2 %right at Boundary
      VkMarker(i)= 0;
    case 3 %left at boundary
      VkMarker(i)= 0;
  end
end
  mrk = mrk + VkMarker*t;
end
