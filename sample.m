D=load('silver-US.csv');
data=D(:,2) %second column
data=log(data)
y=data*100;
n_y=length(y)
year=1968.00+1/12:1/12:2015.00+11/12;

subplot(1,2,1)
plot(year,y)
xlim([1968 2020])
grid()
title('log silver in US')

subplot(1,2,2)
dy=12*(y(2:n_y)-y(1:(n_y-1))); %2:n_y means data starts from the second point (to cal delta y)
year2=1968.00+2/12:1/12:2015.00+11/12;
n_dy=length(dy);
mean_dy=sum(dy)/n_dy

plot(year2,dy)
xlim([1968 2020])
grid()
title('Growth Rate of silver in US Per Annum')
hold on
plot([1968 2015],[0 0],'black');
plot([1968 2015],[mean_dy mean_dy],'red')
hold off


dy_l0=dy(2:n_dy);
dy_l1=dy(1:(n_dy-1));
n_dy_l0=length(dy_l0)
n_dy_l1=length(dy_l1)
X=[ones(n_dy_l1,1) dy_l1];
alpha_hat=(inv(X'*X))*X'*dy_l0
model=arima(1,0,0)
fit_AR1=estimate(model,dy)
n_ahead=60; %forecasted no. of months
[pred_dy,pred_dy_var]=forecast(fit_AR1,n_ahead);
year3=2015.00+11/12:1/12:(2015.00+11/12+1/12*(n_ahead-1));

subplot(1,2,1)
h1=plot(year2,dy);
xlim([1968 2020])
hold on
plot([1968 2015],[0,0],'black');
h2=plot(year3,pred_dy,'r');
h3=plot(year3,pred_dy+1.96*sqrt(pred_dy_var),'r:');
plot(year3,pred_dy-1.96*sqrt(pred_dy_var),'r:');
grid()
legend('Observed','0 points','Forecast','95% Confidence Interval')
hold off
subplot(1,2,2)
for i = 1:n_ahead
    pred_y(i)=y(n_y)+sum(pred_dy(1:i)/12);
     pred_y_upper95(i)=y(n_y)+sum(pred_dy(1:i)/12)+sum(1.96*sqrt(pred_dy_var(1:i))/12);
    pred_y_lower95(i)=y(n_y)+sum(pred_dy(1:i)/12)-sum(1.96*sqrt(pred_dy_var(1:i))/12);
end
h1=plot(year,y);
xlim([1968 2020])
grid()
hold on
h2=plot(year3,pred_y,'r');
h3=plot(year3,pred_y_upper95,'r:');
plot(year3,pred_y_lower95,'r:');
legend('Observed','Forecast','95% Confidence Interval')

hold off