#include <EppsteinWangAlgorithm/graph.hpp>

Graph::Graph(){
    M = 0;
}

// edge list file
// format: X    Y   D(optional) where X and Y are nodes identifiers and D is data
Graph::Graph(std::ifstream& input, std::string path){
    input.open(path);

    M = 0;

    std::string line;
    while(std::getline(input, line)){
        std::stringstream linestream(line);
        std::string X, Y;
        int D;

        linestream >> X >> Y;

        if (linestream >> D){
            addEdge(X,Y,true, D);
        }else{
            addEdge(X,Y, false);
        }
    }

    input.close();
}

size_t Graph::num_vertices() const{
    return vmap.size();
}

size_t Graph::num_edges() const{
    return M;
}

void Graph::addEdge(std::string u, std::string v, bool hasData, int data){
    addDirectedEdge(u,v, hasData, data);
    addDirectedEdge(v,u, hasData, data);
    M += 1;
}

void Graph::addDirectedEdge(std::string u, std::string v, bool hasData, int data){
    auto itr = vmap.find(u);
    if(itr != vmap.end()){
        node* existingNode = itr->second;

        // create a new node
        node* newNode = new node;
        newNode->nodeIdentifier = v;
        newNode->hasData = true;
        if (hasData){
            newNode->data = data;
            newNode->hasData = true;
        }
        newNode->nextptr = existingNode;
        vmap[u] = newNode;
    }else{
        // create a new node
        node* newNode = new node;
        newNode->nodeIdentifier = v;
        newNode->hasData = true;
        if (hasData){
            newNode->data = data;
            newNode->hasData = true;
        }
        newNode->nextptr = nullptr;

        vmap.insert(std::make_pair(u, newNode));
    }
    return;
}

bool Graph::removeEdge(std::string u, std::string v){
    if (vmap.find(u) == vmap.end() || vmap.find(v) == vmap.end()){
        printf("edge not found!");
        return false;
    }

    return removeFromLinkedList(vmap[v], u) && removeFromLinkedList(vmap[u], v);
}

bool Graph::removeFromLinkedList(node* root, std::string id){
    node* temp;

    bool success = false;
    if(root->nodeIdentifier == id){
        temp = root;
        root = root->nextptr;
        free(temp);
        success = true;
    }else{
        node* current = root;
        while(current->nextptr != nullptr && !success){
            if(current->nextptr->nodeIdentifier == id){
                temp = current->nextptr;
                current->nextptr = current->nextptr->nextptr;
                free(temp);
                success = true;
            }else{
                current = current->nextptr;
            }
        }
    }
    return success;
}

std::vector<std::string> Graph::allVertices() const{
    std::vector<std::string> vertices;
    for(auto const& [key, value]: vmap){
        vertices.push_back(key);
    }
    return vertices;
}

std::vector<std::string> Graph::adjNodes(std::string id){
    auto it = vmap.find(id);
    if(it == vmap.end()){
        throw std::invalid_argument( "There's no such node!" );
    }else{
        node *head = it->second;
        std::vector<std::string> v;
        while(head != nullptr){
            v.push_back(head->nodeIdentifier);
            head = head->nextptr;
        }

        return v;
    }
}

// SSSP for unweighted graphs with BFS
std::map<std::string, int> Graph::shortestPath(std::string id){
    std::map<std::string, bool> visited;
    std::deque<std::string> queue;
    std::map<std::string, int> dist;

    visited.insert(std::make_pair(id, true));
    dist.insert(std::make_pair(id, 0));
    queue.push_back(id);

    while(!queue.empty()){
        std::string s = queue.front();
        queue.pop_front();
        
        for(auto adj : adjNodes(s)){
            auto it = visited.find(adj);
            // node has node been visited
            if(it == visited.end()){
                visited.insert(std::make_pair(adj, true));

                auto it2 = dist.find(s);
                if(it2 != dist.end()){
                    dist.insert(std::make_pair(adj, it2->second + 1));   
                }else{
                    throw std::out_of_range("shortestPath.dist: key not found");
                }

                queue.push_back(adj);
            }
        }
    }

    return dist;
}

// select a random vertex with uniform probability
std::string Graph::randomVertex() const{
    auto it = vmap.begin();
    std::advance(it, (size_t)rand() % vmap.size());
    return it->first;
}

// Display the data of nodes associated with a key
void Graph::displayNodes(const std::string &key)
{
    auto it = vmap.find(key);
    if (it != vmap.end())
    {
        // Node found, display the data of all linked nodes
        node *currentNode = it->second;

        while (currentNode != nullptr)
        {
            std::cout << "Key: " << key << "\tIdentifier: " << currentNode->nodeIdentifier << std::endl;
            currentNode = currentNode->nextptr;
        }
    }
    else
    {
        std::cout << "Node with key '" << key << "' not found." << std::endl;
    }
}