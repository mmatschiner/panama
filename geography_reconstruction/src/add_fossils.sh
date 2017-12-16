# m_matschiner Fri Dec 9 12:35:17 CET 2016

# Make the output directory if it doesn't exist yet.
mkdir -p ../res/stochastic_mapping/trees

# Use the script add_fossils.rb to add fossil taxa to the posterior set of trees.
ruby add_fossils.rb "../data/trees/ariidae_1000.trees" "../res/stochastic_mapping/trees/ariidae_w_fossils_1000.trees"

