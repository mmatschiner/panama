# m_matschiner Sun Nov 13 00:00:41 CET 2016

# Use the script get_proportional_node_age_errors.rb to get the proportional age errors from SNAPP and concatenated BEAST analyses.
ruby plot_proportional_node_age_errors.rb ../res/beast/ex5/root/summary/node_ages.txt ../res/snapp/ex4/variants_corrected/summary/node_ages.txt ../res/plots/experiment5a.svg
ruby plot_proportional_node_age_errors.rb ../res/beast/ex5/young/summary/node_ages.txt ../res/snapp/ex1/young/m/summary/node_ages.txt ../res/plots/experiment5b.svg
ruby plot_proportional_node_age_errors.rb ../res/beast/ex5/root_200000/summary/node_ages.txt ../res/snapp/ex2/large_pop/summary/node_ages.txt ../res/plots/experiment5c.svg
ruby plot_proportional_node_age_errors.rb ../res/beast/ex5/root_800000/summary/node_ages.txt ../res/snapp/ex2/huge_pop/summary/node_ages.txt ../res/plots/experiment5d.svg