function [p] = permtest(x,y,nperm,method)
% Performes a simple permutation test of the difference in means.
% method:
%   - 'conservative': p-value is calculated by
%   (abs(nPerm)>=abs(testVal)+1)/(nPerm+1)
%
%   - 'exact': p-value is calculated by:
%        Phipson & Smyth 2010 Formula (1)
%
%   - 'approximate': p-value is calculated by:
%        Phipson & Smyth 2010 Formula (2)
%
%   - 'auto': depending on number of possible permutationes (<10000) exakt
%   or (>10000) approximate is used. (default)
%
% Generally 'auto' is a good solution. If speed is a concern, 'conservative'
% is the fastest. It gives conservative (i.e. slightly too large) p-values
% depending on the number of trials in the groups. Above 50 trials per
% group there should not be any difference anymore. See the paper for more
% information.
%
%
% Phipson & Smyth 2010:
% Permutation P-values Should Never Be Zero:Calculating Exact P-values When
% Permutations Are Randomly Drawn
%
% http://www.statsci.org/webguide/smyth/pubs/permp.pdf
% some code taken from the statmod R package (
% tested:
% p0=nan(1,10);
% for k = 1:1000;
%     p0(k)=permtest(rand(100,1),rand(50,1));
% end
% histogram(p0,30) %<- histogram is flat

if nargin<3
    nperm = 1000;
end
if nargin <4
    method = 'auto';
end
x = x(:);
y = y(:);
z = [x;y];
n1 = length(x);
n2 = length(y);

testValue = mean(x)-mean(y);

%taken from "Andrei Bobrov' http://de.mathworks.com/matlabcentral/answers/155207-matrix-with-different-randperm-rows
[~, idx] = sort(rand(nperm,n1+n2),2);

x_p = z(idx(:,1:n1));
y_p = z(idx(:,n1+1:end));
permDist = mean(x_p,2) - mean(y_p,2);


%Phibson 2010 Permutation P-values should never be zero: calculating exact P - NCBI
b = sum(abs(permDist)>=abs(testValue));
p_t = (b+1)/(nperm+1);


if strcmp(method, 'conservative')
    p = p_t;
    return
end
% sometimes with large n1/n2 there is a warning that mt is inaccurate. In
% this case, the correction doesnt do much anyways.
warning off
mt = nchoosek(n1+n2,n1); %total number of possible permutations
warning on
if n1 == n2
    mt = mt/2; % not sure why this is but its in the R-Code
end



if strcmp(method,'auto')
    if mt<10000
        method = 'exact';
    else
        method = 'approximate';
    end
end

if strcmp(method,'approximate')
    fun = @(p_t)binocdf(b,nperm,p_t);
    p = p_t - integral(fun,0,0.5/(mt+1));
    
elseif strcmp(method,'exact')
    p = (1:mt)./mt;
    x2 = repmat(b,1,mt);
    p = sum(binocdf(x2,nperm,p))/mt;
else
    warning('could not find chosen method')
end
