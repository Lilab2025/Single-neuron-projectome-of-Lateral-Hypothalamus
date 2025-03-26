% Load data
data = xlsread('G:\shy-20250221\zyf\L24\Results20250221zyfL24-42.csv');

% Extract coordinate data
x = data(:, 8);
y = data(:, 6);
z = data(:, 7);

% Define number of bins
numBins = 10;

% Calculate minimum and maximum values
x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y);
z_min = min(z);
z_max = max(z);

% Create bin edges
x_edges = linspace(x_min, x_max, numBins+1);
y_edges = linspace(y_min, y_max, numBins+1);
z_edges = linspace(z_min, z_max, numBins+1);

% Initialize 3D bin counts matrix
counts_3d = zeros(numBins, numBins, numBins);

% Calculate counts in each bin
for i = 1:numBins
    for j = 1:numBins
        for k = 1:numBins
            idx_x = x >= x_edges(i) & x < x_edges(i+1);
            idx_y = y >= y_edges(j) & y < y_edges(j+1);
            idx_z = z >= z_edges(k) & z < z_edges(k+1);
            counts_3d(i, j, k) = sum(idx_x & idx_y & idx_z);
        end
    end
end

% Filter bins with fewer than 2 points
counts_3d(counts_3d < 2) = NaN;

% Prepare data for bubble chart
[x_bin, y_bin, z_bin] = ind2sub(size(counts_3d), find(~isnan(counts_3d)));
S = counts_3d(~isnan(counts_3d));

% Create 3D bubble chart
figure;
scatter3(x_bin, y_bin, z_bin, S.*S, S, 'filled', ...
    'MarkerEdgeAlpha', 0.3, ...
    'MarkerFaceAlpha', 0.3);
colorbar;
title('3D Bubble Chart of Bins');
xlabel('X Bin');
ylabel('Y Bin');
zlabel('Z Bin');
view(3);
view(-45, 20);

% Example for adding legend and color bar
values = [1, 2, 3, 4, 5];
sizes = 100 * values.^2;

figure;
hold on;
for i = 1:length(values)
    scatter(values(i), values(i), sizes(i), 'filled', 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', jet(values(i)));
end
hold off;

axis([0 6 0 6]);
xlabel('Value');
ylabel('Value');
legendLabels = arrayfun(@(x) sprintf('Value %d', x), values, 'UniformOutput', false);
legend(legendLabels, 'Location', 'best');
title('Legend for Bubble Sizes and Colors Corresponding to Values');
colorbar('Ticks', 1:5, 'TickLabels', {'1', '2', '3', '4', '5'}, 'Location', 'eastoutside');
colormap(jet(5));
