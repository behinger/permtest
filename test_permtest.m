% Warning: 

sBefore = RandStream.getGlobalStream();



nRepeats = 1000;
nperm = 1000;
n1 = 5;
n2 = 5;
result = [];
pOut = nan(3,nRepeats);
x = randn(n1, nRepeats)+1;
y =randn(n2,nRepeats);
for method = {'exact','approximate','conservative';{1},{2},{3}}
    
    if strcmp(method{1},'exact') && (n1+2)>15
        result = [result nan];
        warning('Skipped the method=exact because n1+n2 > 15. Else it will get seriously slow (and high memory)')
        continue
    end
        tic
    for k = 1:nRepeats
        %display(k)
        s = RandStream('mt19937ar','Seed',k);
        RandStream.setGlobalStream(s);
        
        pOut(method{2}{1},k) = permtest(x(:,k),y(:,k),nperm,method{1});
        
    end
    result = [result toc]
end

sBefore = RandStream.setGlobalStream(sBefore);

%%
[~,ix] = sort(pOut(1,:));
plot(log(pOut(1,ix)),(pOut(3,ix))./pOut(1,ix),'o-');
hold all
plot(log(pOut(1,ix)),(pOut(2,ix))./pOut(1,ix),'o-');
set(gca,'XTickLabel',exp(get(gca,'XTick')))
vline(log(0.05))
vline(log(0.001))
legend('conservative / exact','approximate / exact')
title(sprintf('nRepeats=%i,nperms=%i,n1=%i,n2=%i',nRepeats,nperm,n1,n2))