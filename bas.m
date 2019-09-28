function [X, y, info] = bas2(obj_fun, x0, varargin)

p = inputParser;

addRequired(p, 'obj_fun', @(x) isfinite(x(x0)));
addRequired(p, 'x0', @(x) ~any(isinf(x)));
addParameter(p, 'max_iter', 100, @(x) isfinite(x));
addParameter(p, 'antennae_length', 1, @(x) isfinite(x));
addParameter(p, 'step_to_antennae', 1, @(x) isfinite(x));
addParameter(p, 'antennae_decay_factor', 0.99, @(x) isfinite(x));
addParameter(p, 'stop_fun', @(x) 0);
addParameter(p, 'retain_best', 0, @(x) x==0 || x==1);
addParameter(p, 'post_antennae', @() 0);
addParameter(p, 'user_data', []);

parse(p, obj_fun, x0, varargin{:});

max_iter = p.Results.max_iter;
antennae_length = p.Results.antennae_length;
step_size = p.Results.step_to_antennae;
antennae_decay_factor = p.Results.antennae_decay_factor;
stop_fun = p.Results.stop_fun;
retain_best = p.Results.retain_best;
post_antennae = p.Results.post_antennae;

num_variables = numel(x0);

% X's
X_hist = zeros(max_iter+1, num_variables);
% f's
f_hist = zeros(max_iter+1, 1);
% f_data's
f_data_hist = cell(max_iter+1, 1);

X = x0;
X_hist(1, :) = X;

try
    [f, f_data] = obj_fun(X);
    f_data_hist{1, 1} = f_data;
    is_dual_output = 1;
catch
    [f] = obj_fun(X);
    is_dual_output = 0;
end
post_antennae();
f_hist(1, 1) = f;

antennae_length_hist = zeros(max_iter+1, 1);

X_best = X;
f_best = f;

for i=1:max_iter
    antennae_length = antennae_length * antennae_decay_factor;
    antennae_length_hist(i) = antennae_length;
    dX_rand = (antennae_length) * randn(1, num_variables);
    
    X_left = X + dX_rand;
    f_left = obj_fun(X_left);
    post_antennae();
    
    X_right = X - dX_rand;
    f_right = obj_fun(X_right);
    post_antennae();
    
%     dir = X_left - X_right;
    
    X = X - sign(f_left - f_right) * dX_rand * step_size;
    if is_dual_output
        [f, f_data] = obj_fun(X);
        f_data_hist{i+1, 1} = f_data;
    else
        [f] = obj_fun(X);
    end
    
    if retain_best
        if f < f_best
            X_best = X;
            f_best = f;
        else
            X = X_best;
            f = f_best;
        end
    end
    
    X_hist(i+1, :) = X;
    f_hist(i+1, 1) = f;
    
    if is_dual_output
        if stop_fun(f_data)
            break
        end
    else
        if stop_fun(f)
            break
        end
    end
end

y = f;

X_hist(i+2:end, :) = [];
f_hist(i+2:end, :) = [];
f_data_hist(i+2:end, :) = [];
antennae_length_hist(i+2:end,:) = [];

info.num_iter = i;
info.X_hist = X_hist;
info.f_hist = f_hist;
info.f_data_hist = f_data_hist;
info.antennae_length_hist = antennae_length_hist;

end