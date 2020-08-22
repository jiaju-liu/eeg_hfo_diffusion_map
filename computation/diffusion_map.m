function [V,D,a] = diffusion_map(EEG,dist_func)
%Computes the diffusion map over the EEG data matrix
%Inputs:
%EEG: data matrix
%dist_func: distance function to use in the gaussian kernel. 'mahalanobis',
%'shift', and any metric accepted by pdist2 work.
%Outputs:
%V: diffusion map eigenvectors
%D: diffusion map eigenvalues
%a: similarity matrix

tic
EEG=normalize(EEG')';

%Compute squared distance
switch dist_func
    case 'mahalanobis'
        %Mahalanobis distance can be computed with pdist2 but this is
        %HIGHLY discouraged. fast_mahal_dist utilizes a Cholesky
        %factorization to compute the inverse covariance matrix
        a = fast_mahal_dist(EEG);
    case 'shift'
        %Cross-correlation-based distance function
        a=zeros(size(EEG,1));
        for i = 1:size(EEG,1)
            for j = (i+1):size(EEG,1)
                %Find max similarity then dist
                [vals,shift] = xcorr(EEG(i,:),EEG(j,:));
                [~,ind]=max(vals);
                a(i,j)=sum((circshift(EEG(j,:),shift(ind))-EEG(i,:)).^2);
            end
        end
        %Only the entries above the diagonal are computed to save time.
        %Since the matrix is symmetric:
        a = a+a';
    otherwise
        try
            a=pdist2(EEG,EEG,dist_func).^2;
        catch
            disp('Distance function is not recognized')
        end
end

%Compute e
temp =(a+a')/2;
temp = temp(temp~=0);
e = median(temp);

% Diffusion kernel
A = exp(-a/e);
q = diag(sum(A).^(-0.5));
k = q*A*q;
d = sum(k);
k = k*diag(d.^(-1));
[V,D] = eigs(k);

toc