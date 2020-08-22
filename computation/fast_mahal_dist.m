function mahal_mat = fast_mahal_dist(Y)
    %Y is data where columns are observations
    %mahal_mat is the squared Mahalanobis matrix i.e.:
    %pdist2(Y',Y','mahalanobis').^2=fastMahalDist(Y)
    %Use this OVER pdist2 for the mahalanobis distance. fast_mahal_dist
    %utilizes a Cholesky factorization to compute the inverse covariance
    %matrix, making it much faster. Some fancy matrix multiplication is
    %used to compute without any for loops
    
    covMat = cov(Y);
    Y = Y';
    hx = chol(covMat);
    Ynew = hx'\Y;
    G = Ynew'*Ynew;
    dim = size(G,1);
    mahal_mat = diag(G)*ones(1,dim)-2*G+ones(dim,1)*diag(G)';
end