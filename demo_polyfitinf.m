% Set seed for reproducibility
rng(2024)

%%%%%%%%%

M = 5; % chosen degree of polynomial fit
K = 0; % parity of polynomial; 0=mixed (general); 1=odd; 2=even
niter = 100000;
epsh = 1e-8;

% example data
% Todo: restructure to not have excessive switches.
if K==0
    x = -5:5;
elseif K==1 % odd poly; subroutine expects x-data to be strictly positive.
    x = 1:10;
elseif K==2 % even poly; x-data can include x=0.
    x=0:9;
end

y = randi([-5,5], [1,length(x)]);
%y = 5 + x.^2 - 2*x.^4 + 6*x.^6;

A = polyfitinf(M, length(x), K, x, y, epsh, niter);

errs = polyval(A,x) - y;
err_mag = max(abs(errs));

%%%%%%%%%%%%%%%%%%%%%%%%%
% evaluate
if K==1
    fprintf('\nOdd polynomial expected...\n')
    disp( all(A(end:-2:1) == 0 ) )
elseif K==2
    fprintf('\nEven polynomial expected...\n')
    disp( all(A(end-1:-2:1) == 0 ) )
end

x_fine = linspace(min(x), max(x), 100);


subplot(2,1,1)
scatter(x,y, 100, 'Marker', '.');
hold on;

plot(x_fine, polyval(A, x_fine))
hold off;

xlabel('x')
ylabel('y')

%%%%%%%%%%%%%%
% get an eyeball view on optimality conditions
% expect to see at least two (three?) points for which 
% abs(err) == err_mag.

subplot(2,1,2)
% errors
scatter(x, errs, 100, 'Marker', 's')

hold on
plot(x, -err_mag*ones(size(x)), 'r', 'LineWidth', 2)
plot(x, +err_mag*ones(size(x)), 'r', 'LineWidth', 2)

xlabel('x')
ylabel('p(x) - y')

hold off
ylim([min(-epsh,-1.1*err_mag), max(epsh,1.1*err_mag)])
grid on
