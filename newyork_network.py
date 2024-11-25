import networkx as netx
import matplotlib.pyplot as plot

# Create a graph
G = netx.Graph()

# Define updated lines and their stations for New York City
lines = {
    "1": ["South Ferry", "Chambers St", "14 St", "Times Sq-42 St", "59 St-Columbus Circle"],
    "2": ["Flatbush Av-Brooklyn College", "Atlantic Av-Barclays Center", "14 St", "Times Sq-42 St", "96 St"],
    "3": ["New Lots Av", "Atlantic Av-Barclays Center", "14 St", "Times Sq-42 St", "96 St"],
    "4": ["Crown Hts-Utica Av", "Atlantic Av-Barclays Center", "14 St-Union Sq", "Grand Central-42 St", "125 St"],
    "5": ["Flatbush Av-Brooklyn College", "Atlantic Av-Barclays Center", "14 St-Union Sq", "Grand Central-42 St", "125 St"],
    "6": ["Brooklyn Bridge-City Hall", "14 St-Union Sq", "Grand Central-42 St", "59 St", "125 St"],
}

# Add edges and nodes for each line
for line, stations in lines.items():
    for i in range(len(stations) - 1):
        G.add_edge(stations[i], stations[i + 1], line=line)

# Identify transfer stations (nodes shared by multiple lines)
transfer_stations = {station for station in G.nodes if sum(station in line_stations for line_stations in lines.values()) > 1}

# Adding additional transfer connections for graph connectivity
additional_transfers = [
    ("14 St", "14 St-Union Sq"),
]
for station1, station2 in additional_transfers:
    G.add_edge(station1, station2, line="Transfer")

# Check if graph is connected
is_connected = netx.is_connected(G)
print("Graph is connected:", is_connected)


# Plot for question 1
plot.figure(figsize=(12, 12))
pos = netx.spring_layout(G, seed=42)  # Set seed for consistent layout
netx.draw(G, pos, with_labels=True, node_size=300, node_color="lightgray")
plot.show()



# Updated color map for new lines
color_map = {
    "1": "blue",
    "2": "green",
    "3": "red",
    "4": "orange",
    "5": "yellow",
    "6": "gray",
}

# Draw network
plot.figure(figsize=(12, 12))
pos = netx.spring_layout(G, seed=42)  # Set seed for consistent layout

# Draw each line with colors
for line, color in color_map.items():
    edges = [(u, v) for u, v, d in G.edges(data=True) if d["line"] == line]
    netx.draw_networkx_edges(G, pos, edgelist=edges, edge_color=color, width=2, label=line)

# Draw transfer stations in a larger size and different color
netx.draw_networkx_nodes(G, pos, nodelist=transfer_stations, node_color="lightblue", node_size=300, label="Transfer Stations")

# Draw other stations
netx.draw_networkx_nodes(G, pos, nodelist=set(G.nodes) - transfer_stations, node_color="lightgray", node_size=100)

# Draw labels
netx.draw_networkx_labels(G, pos, font_size=8)

# Plot for question 2
plot.figure(figsize=(12, 12))
pos = netx.spring_layout(G, seed=42)  # Set seed for consistent layout
netx.draw(G, pos, with_labels=True, node_size=300, node_color="lightgray")
plot.show()



# Set edge weights (distances in meters) for all pairs
distances = {
    ("South Ferry", "Chambers St"): 2000,
    ("Chambers St", "14 St"): 3000,
    ("14 St", "Times Sq-42 St"): 2000,
    ("Times Sq-42 St", "59 St-Columbus Circle"): 1500,
    ("Flatbush Av-Brooklyn College", "Atlantic Av-Barclays Center"): 5000,
    ("Atlantic Av-Barclays Center", "14 St"): 4000,
    ("14 St-Union Sq", "Grand Central-42 St"): 2000,
    ("Grand Central-42 St", "125 St"): 6000,
    ("Brooklyn Bridge-City Hall", "14 St-Union Sq"): 3000,
    ("Inwood-207 St", "59 St-Columbus Circle"): 8000,
    ("59 St-Columbus Circle", "125 St"): 7000,
    ("Flatbush Av-Brooklyn College", "Atlantic Av-Barclays Center"): 5000,
    ("Atlantic Av-Barclays Center", "14 St"): 4000,
    ("14 St", "Times Sq-42 St"): 2000,
    ("Times Sq-42 St", "96 St"): 5000,
    ("New Lots Av", "Atlantic Av-Barclays Center"): 6000,    
    ("Crown Hts-Utica Av", "Atlantic Av-Barclays Center"): 6000,
    ("125 St", "59 St"): 7000,
    ("Grand Central-42 St", "59 St"): 1500,
    ("14 St-Union Sq", "Atlantic Av-Barclays Center"): 4000,
}

# Update graph with distances
for (u, v), distance in distances.items():
    if G.has_edge(u, v):
        G[u][v]['distance'] = distance

# Draw edges with labels (distances)
edge_labels = {(u, v): f"{d['distance']}m" for u, v, d in G.edges(data=True) if 'distance' in d}
netx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=8)

# Add legend and title
plot.legend(color_map.keys(), loc='upper left', fontsize=10)
plot.title("New York City Subway Network with Multiple Lines and Transfer Stations")
plot.axis("off")
plot.show()
