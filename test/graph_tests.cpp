#include <catch2/catch_test_macros.hpp>

#include <EppsteinWangAlgorithm/graph.hpp>

TEST_CASE("Graph initialization", "[init]")
{
  Graph *G = new Graph();
  G->addEdge("1", "2", false);
  REQUIRE(G->num_edges() == 1);
  REQUIRE(G->num_vertices() == 2);

  SECTION("init from file (no data)")
  {
    INFO("Graph with data");
    std::ifstream ifs1;
    const Graph *G1 =
      new Graph(ifs1, "/Users/enricobolzonello/Documents/GitHub/EppsteinWangAlgorithm/test/edgelist_data.txt");
    REQUIRE(static_cast<int>(G1->num_vertices()) == 15);
    REQUIRE(static_cast<int>(G1->num_edges()) == 30);
  }

  SECTION("init from file (with data)")
  {
    std::ifstream ifs2;
    const Graph *G2 =
      new Graph(ifs2, "/Users/enricobolzonello/Documents/GitHub/EppsteinWangAlgorithm/test/edgelist_nodata.txt");
    REQUIRE(static_cast<int>(G2->num_vertices()) == 50);
    REQUIRE(static_cast<int>(G2->num_edges()) == 389);
  }
}
