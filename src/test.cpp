#include <EppsteinWangAlgorithm/graph.hpp>

int main(){
    std::ifstream ifs2;
    Graph *G2 = new Graph(ifs2, "/Users/enricobolzonello/Documents/GitHub/EppsteinWangAlgorithm/test/edgelist_data.txt");
    printf("vertices: %d\n", static_cast<int>(G2->num_vertices()));
    printf("edges: %d\n", static_cast<int>(G2->num_edges()));

    G2->displayNodes("0");
    G2->displayNodes("1");

    printf("\nAdjacent nodes: ");
    std::vector<std::string> v = G2->adjNodes("0");
    // auto const& x -> original item and not modify
    // auto x -> copy
    // auto& x -> original item and modify
    // https://stackoverflow.com/questions/15176104/range-based-loop-get-item-by-value-or-reference-to-const
    for(auto const& a : v){ 
        std::cout << a << " ";
    }

    auto m = G2->shortestPath("0");
    std::cout << "\n Shortest paths: \n";
    // https://stackoverflow.com/questions/26281979/how-do-you-loop-through-a-stdmap
    for(auto const& [key, val] : m){
        std::cout << key << " : " << val << std::endl;
    }
    return 0;
}