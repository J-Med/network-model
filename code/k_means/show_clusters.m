function show_clusters(x, c, means)
% show_clusters(x, c, means)
% Input:
%   x         .. Feature vectors, of size [dim, number_of_vectors].
%                This function supports only vectors of dim = 2.
%   c         .. Cluster index for each feature vector, of size
%                [1, number_of_vectors].
%   means     .. Cluster centers, of size [dim, k], i.e. means(:,i) is the
%                center of the i-th cluster.

k = size(means, 2);
num_labels = unique(c);
legend_str = cell(1, k);
for i = 1:k
    legend_str{i} = num2str(i);
end

if size(x, 1) == 2
    figure, hold on;
    cla;
    %ppatterns(x, c);
    data.X = x;
    data.y = c;
    ppatterns(data), hold on;
    if num_labels ~= 1
        legend(legend_str);
    end
    plot(means(1,:), means(2,:), '+m', 'markersize', 10, 'linewidth', 2);
    grid on;
end
