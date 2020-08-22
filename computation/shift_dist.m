function dist = shift_dist(X1,long)
%cross-correlation-based distance function. Custom distance function
%in Matlab format
dist =zeros(size(long,1),1);
for i = 1:size(long,1)
    %Find max similarity then dist
    [vals,shift] = xcorr(X1,long(i,:));
    [~,ind]=max(vals);
    dist(i)=sum((circshift(long(i,:),shift(ind))-X1).^2)^0.5;
end
