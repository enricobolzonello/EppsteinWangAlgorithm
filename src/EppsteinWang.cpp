#include <EppsteinWangAlgorithm/cxxopts.hpp>
#include <EppsteinWangAlgorithm/graph.hpp>
#include "unistd.h"

std::map<std::string, float> ClosenessCentrality(Graph *G, float epsilon, float delta)
{
  std::map<std::string, float> sum_v;
  int n = G->num_vertices();

  float k =
    1 / (2 * pow(epsilon, 2)) * log((2 * n) / delta) * pow((n / (n - 1)), 2);// >= 1/2epsilon^2 log(2n/delta)(n/(n-1))^2

  for (int i = 0; i < k; i++) {
    std::string v = G->randomVertex();
    std::map<std::string, int> dist = G->shortestPath(v);

    for (auto const &u : G->allVertices()) {
      if (sum_v.find(u) == sum_v.end()) {
        sum_v.insert(std::make_pair(u, (float)dist[u]));
      } else {
        sum_v[u] += dist[u];
      }
    }
  }

  std::map<std::string, float> c;
  for (auto const &u : G->allVertices()) {
    float temp = (n-1) / ((n / k) * sum_v[u]);
    c.insert(std::make_pair(u, temp));
  }

  return c;
}

int main(int argc, char **argv)
{
  cxxopts::Options options(
    "EppsteinWang", "Computes the approximated closeness centrality with the Eppstein-Wang algorithm");
  options.add_options()("e,epsilon", "Accuracy parameter", cxxopts::value<float>())("d,delta",
    "Probability parameter",
    cxxopts::value<float>())("f,file", "File name", cxxopts::value<std::string>())("h,help", "Print usage");

  auto result = options.parse(argc, argv);

  if (result.count("help")) {
    std::cout << options.help() << std::endl;
    exit(0);
  }

  std::string file_name = result["file"].as<std::string>();

  // check if file exists
  if (access(file_name.c_str(), F_OK) != 0) {
    std::cout << "file does not exist!" << std::endl;
    exit(0);
} 

  float epsilon = result["epsilon"].as<float>();
  float delta = result["delta"].as<float>();

  std::ifstream input;
  Graph* G = new Graph(input, file_name);
  std::map<std::string, float> c = ClosenessCentrality(G, epsilon, delta);

  for(auto const& [key, value] : c){
    std::cout << "node: " << key << " cc: " << value << std::endl;
  }

  return 0;
}