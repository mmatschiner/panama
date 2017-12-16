#! /usr/bin/env python

import sys
import dendropy
from dendropy.simulate import treesim

species_tree_file_name = sys.argv[1]
population_size = int(sys.argv[2])
sample_size = int(sys.argv[3])

species_tree = dendropy.Tree.get_from_path(species_tree_file_name, "nexus")
gene_to_species_map = dendropy.TaxonNamespaceMapping.create_contained_taxon_mapping(containing_taxon_namespace=species_tree.taxon_namespace, num_contained=sample_size)
gene_tree = treesim.contained_coalescent_tree(containing_tree=species_tree, gene_to_containing_taxon_map=gene_to_species_map, default_pop_size=population_size)
print(gene_tree.as_string(schema='newick'))
