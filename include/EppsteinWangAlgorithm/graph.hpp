#include<fstream>
#include<map>
#include<string>
#include<iostream>
#include<sstream>
#include <deque>


#define MAX_VERTICES 1000

struct node {
    node* nextptr;
    std::string nodeIdentifier;
    int data;
    bool hasData;
};

class Graph{
    public:
        Graph(); // empty graph
        //Graph(Graph& g); // copy constructor
        //Graph(int n); // n vertices and no edges
        explicit Graph(std::ifstream& input, std::string path); // from file
        //~Graph();
        
        size_t num_vertices() const;
        size_t num_edges() const;

        void addEdge(std::string u, std::string v, bool hasData, int data=0);
        bool removeEdge(std::string u, std::string v);

        std::vector<std::string> allVertices() const;
        std::vector<std::string> adjNodes(std::string id);

        // utilities for Eppstein-Wang algorithm
        std::map<std::string, int> shortestPath(std::string id); // single-source shortest path
        std::string randomVertex() const; // select random vertex with uniform probability, return its identifier

        void displayNodes(const std::string &key);

        private: 
            std::map<std::string, node*> vmap;
            size_t M;

            void addDirectedEdge(std::string u, std::string v, bool hasData, int data=0);
            static bool removeFromLinkedList(node* root, std::string id);
};