function rfv = versec(g,rf)

[m n] = size(rf);
if m<n,
  rf = conj(rf');
  [m n] = size(rf);
end;
k = cumsum(g);
k = (m-1)*k/max(k);
rfv = [];
g = m*g/sum(g);
for j=1:n,
  rft = g.*interp1([0:m-1],rf(:,j),k);
  rfv = [rfv rft];
end;
