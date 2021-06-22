function nodes = getNodes(X, Y, Z)

    res = size(X,1);    
    X_node = reshape(X, res*res,1);
    Y_node = reshape(Y, res*res,1);
    Z_node = reshape(Z, res*res,1);

    nodes = [X_node Y_node Z_node];