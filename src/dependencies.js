const orderDependencies = (_dependencies, _dependents, result = []) => {
    const stack = [];

    for (const fqn of _dependencies.keys()) {
        if (_dependencies.get(fqn).size === 0) {
            stack.push(fqn);
            _dependencies.delete(fqn);
        }
    }

    while (stack.length !== 0) {
        const fqn = stack.shift();

        result.push(fqn);

        if (!_dependents.has(fqn)) {
            continue;
        }

        for (const dependent of _dependents.get(fqn)) {
            const dependencies = _dependencies.get(dependent);
            dependencies.delete(fqn);

            if (dependencies.size === 0) {
                stack.push(dependent);
                _dependencies.delete(dependent);
            }
        }

        _dependents.delete(fqn);
    }

    processCircular(_dependencies, _dependents, result); // eslint-disable-line no-use-before-define

    for (const fqn of _dependencies.keys()) {
        result.push(fqn);
        _dependencies.delete(fqn);
        _dependents.delete(fqn);
    }

    return result;
};

const processCircular = (_dependencies, _dependents, result) => {
    let size = 0;
    while (_dependencies.size !== size) {
        size = _dependencies.size;
        for (const fqn of _dependencies.keys()) {
            disjoin(_dependencies, _dependents, result, fqn); // eslint-disable-line no-use-before-define
        }
    }
};

const disjoin = (_dependencies, _dependents, result, node) => {
    const nodes = new Set();
    walk(_dependencies, _dependents, nodes, node); // eslint-disable-line no-use-before-define
    if (nodes.size === _dependencies.size) {
        return;
    }

    const _new_dependencies = new Map();
    const _new_dependents = new Map();

    for (const fqn of nodes) {
        _new_dependencies.set(fqn, new Set());
        _new_dependents.set(fqn, new Set());
    }

    for (const fqn of nodes) {
        for (const other of _dependencies.get(fqn)) {
            _new_dependencies.get(fqn).add(other);
            _new_dependents.get(other).add(fqn);
        }

        if (!_dependents.has(fqn)) {
            continue;
        }

        for (const other of _dependents.get(fqn)) {
            if (nodes.has(other)) {
                _new_dependencies.get(other).add(fqn);
                _new_dependents.get(fqn).add(other);
            } else {
                _dependencies.get(other).delete(fqn);
            }
        }
    }

    for (const fqn of nodes) {
        _dependencies.delete(fqn);
        _dependents.delete(fqn);
    }

    orderDependencies(_new_dependencies, _new_dependents, result);
};

/**
 * walk until already encountered of no dependencies
 * @param  {[type]} _dependencies [description]
 * @param  {[type]} _dependents   [description]
 * @param  {[type]} nodes         [description]
 * @param  {[type]} fqn           [description]
 * @return {[type]}               [description]
 */
const walk = (_dependencies, _dependents, nodes, node) => {
    if (nodes.has(node)) {
        return;
    }
    nodes.add(node);

    for (const next of _dependencies.get(node)) {
        walk(_dependencies, _dependents, nodes, next);
    }
};

exports.orderDependencies = orderDependencies;
