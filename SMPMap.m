function [x] = SMPMap(Max_iter)
x(1)=rand; 
eta=0.4;
u=0.3;
for i=1:Max_iter
    if x(i)>=0 && x(i)<eta
        x(i+1)=mod(x(i)/eta+u*sin(pi*x(i))+rand,1);
    end
    if x(i)>=eta && x(i)<0.5
        x(i+1)=mod((x(i)/eta)/(0.5-eta)+u*sin(pi*x(i))+rand,1);
    end
    if x(i)>=0.5 && x(i)<1-eta
        x(i+1)=mod(((1-x(i))/eta)/(0.5-eta)+u*sin(pi*(1-x(i)))+rand,1);
    end
    if x(i)>=1-eta && x(i)<1
        x(i+1)=mod((1-x(i))/eta+u*sin(pi*(1-x(i)))+rand,1);
    end  
end