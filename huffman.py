import os
from collections import defaultdict, namedtuple
from heapq import heappush, heappop, heapify
import struct
from pathlib import Path

import numpy as np
import torch

Node = namedtuple('Node', 'freq value left right')
Node.__lt__ = lambda x, y: x.freq < y.freq





def huffman_encode(imProj, drawTree = False):
    """
    Encodes numpy array 'arr' and saves to `save_dir`
    The names of binary files are prefixed with `prefix`
    returns the number of bytes for the tree and the data after the compression
    """

    int_img = torch.round(imProj).long().flatten()
    counts = torch.bincount(int_img)
#    counts = counts.float() / torch.sum(counts)
    freq_map = list(counts.cpu().numpy())


    # Make heap
    heap = [Node(frequency, value, None, None) for value, frequency in enumerate(freq_map)]
    heapify(heap)

    if drawTree:
        import networkx as nx
        from networkx.drawing.nx_agraph import write_dot, graphviz_layout
        import matplotlib.pyplot as plt
        G = nx.DiGraph()

    # Merge nodes
    while(len(heap) > 1):
        node1 = heappop(heap)
        node2 = heappop(heap)
  #      merged = Node(node1.freq + node2.freq, '(' + str(node1.value) + ',' + str(node2.value) + ')',
   #                    node1, node2)
        merged = Node(node1.freq + node2.freq, None, node1, node2)
        heappush(heap, merged)

        if drawTree:
            G.add_node(str(node1.freq))
            G.add_node(str(node1.freq))
            G.add_node(str(merged.freq))

            G.add_edge(str(merged.freq), str(node2.freq))
            G.add_edge(str(merged.freq), str(node1.freq))

            # write dot file to use with graphviz
            # run "dot -Tpng test.dot >test.png"


    if drawTree:
        write_dot(G, 'test.dot')

        # same layout using matplotlib with no labels
        pos = graphviz_layout(G, prog='dot')
        nx.draw(G, pos, with_labels=False, arrows=True)
        plt.savefig('nx_test.png')

    # Generate code value mapping
    value2code = {}


    def generate_code(node, code):
        if node is None:
            return
        if node.value is not None:
            value2code[node.value] = code
            return
        generate_code(node.left, code + '0')
        generate_code(node.right, code + '1')

    root = heappop(heap)
    generate_code(root, '')

    bit_countH = np.sum([len(value2code[i]) * freq_map[i] for i in range(len(freq_map))])

    return bit_countH