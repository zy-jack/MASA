function [Best_pos,Best_score,curve]=MASA(pop,Max_iter,lb,ub,dim,fobj)

time1 = datetime();

ST = 0.6;
PD = 0.7;
SD = 0.3;
PA = 0.1;
GD = 0.4;
PDNumber = pop*PD; 
SDNumber = pop * SD;
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end
% 01
X0=initialization_SMP(pop,dim,ub,lb);
X = X0;
fitness = zeros(1,pop);
for i = 1:pop
   fitness(i) =  fobj(X(i,:));
end
[fitness, index]= sort(fitness);
GBestF = fitness(1);
for i = 1:pop
    X(i,:) = X0(index(i),:);
end
curve=zeros(1,Max_iter);
GBestX = X(1,:);
X_new = X;

for i = 1: Max_iter
    BestF = fitness(1);
    WorstF = fitness(end);
    Pbest = X(1,:);
    R2 = rand(1);
    w=cos((pi*i)/(2*Max_iter));
   for j = 1:PDNumber
      if(R2<ST)
          % 2
          X_new(j,:) = X(j,:) + exp((Pbest - X(j,:)*w).*rand());
      else
          % 3
          X_new(j,:) = X(j,:) + rand^2.*(GBestX - X(j,:));
      end     
   end
   for j = PDNumber+1:pop
        if(j>(pop - PDNumber)/2 + PDNumber)
          X_new(j,:) = X(j,:).*exp(-j/(rand(1)*Max_iter)).*w;
        else
          A = ones(1,dim);
          for a = 1:dim
            if(rand()>0.5)
                A(a) = -1;
            end
          end 
          AA = A'*inv(A*A');     
          X_new(j,:)= X(1,:) + abs(X(j,:) - X(1,:)).*AA';
       end
   end
   Temp = randperm(pop);
   SDchooseIndex = Temp(1:SDNumber); 
   for j = 1:SDNumber
       if(fitness(SDchooseIndex(j))>BestF)
           X_new(SDchooseIndex(j),:) = X(1,:) + randn().*abs(X(SDchooseIndex(j),:) - X(1,:));
       elseif(fitness(SDchooseIndex(j))== BestF)
           K = 2*rand() -1;
           X_new(SDchooseIndex(j),:) = X(SDchooseIndex(j),:) + K.*(abs( X(SDchooseIndex(j),:) - X(end,:))./(fitness(SDchooseIndex(j)) - WorstF + 10^-8));
       end
   end
   for j = 1:pop
       for a = 1: dim
           if(X(j,a)>ub)
               X(j,a) =ub(a);
           end
           if(X(j,a)<lb)
               X(j,a) =lb(a);
           end
       end
   end
   [fitness, index]= sort(fitness);
    X = X(index,:);
    for j=1:dim
       Temp = X(1,:);
       item = i;
       st = (log(1 - (i-1)/Max_iter)^2)*0.1 + fitness(1);
       if(st > rand())
            r = tan((rand() - 0.5)*pi);
            Temp(j) = Temp(j) + r*Temp(j);
       else
            r = randn;
            Temp(j) = Temp(j) + Temp(j)*r;
       end
       if(Temp(j)>ub(j))
           Temp(j)=ub(j);
       end
        if(Temp(j)<lb(j))
           Temp(j)=lb(j);
        end
       fTemp = fobj(Temp);
       if(fTemp<fitness(1))
           fitness(1) = fTemp;
           X(1,:)=Temp;
       end
    end
    if fitness(1)<GBestF
        GBestF = fitness(1);
        GBestX = X(1,:);
    end
    curve(i) = GBestF;
end
Best_pos =GBestX;
Best_score = curve(end);
end




