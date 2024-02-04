# EppsteinWangAlgorithm

[![ci](https://github.com/enricobolzonello/EppsteinWangAlgorithm/actions/workflows/ci.yml/badge.svg)](https://github.com/enricobolzonello/EppsteinWangAlgorithm/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/enricobolzonello/EppsteinWangAlgorithm/branch/main/graph/badge.svg)](https://codecov.io/gh/enricobolzonello/EppsteinWangAlgorithm)
[![CodeQL](https://github.com/enricobolzonello/EppsteinWangAlgorithm/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/enricobolzonello/EppsteinWangAlgorithm/actions/workflows/codeql-analysis.yml)

Implementation of the Eppstein-Wang algorithm [[1]](#1) for approximating closeness centrality in an undirected graph.
Closeness centrality is approximated as:
$$
c(v)=\frac{n-1}{n/k \cdot sum_v}
$$

where $sum_v$ is sum of all shortest paths from source $v$.

## References
<a id="1">[1]</a> 
Eppstein and J. Wang,
*Fast Approximation of Centrality*, 
JGAA, 8(1) 39–45 (2004)45.
