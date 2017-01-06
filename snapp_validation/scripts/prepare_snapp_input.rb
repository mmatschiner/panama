# m_matschiner Wed Sep 21 16:39:36 CEST 2016

# Use the phylsim and the fileutils libraries.
$libPath = "./resources/phylsim/"
require "./resources/phylsim/main.rb"

# Get the command line arguments.
phylip_file_name = ARGV[0]
tree_file_name = ARGV[1]
constraint_type = ARGV[2]
snapp_file_name = ARGV[3]

# Read the phylip file.
phylip_file = File.open(phylip_file_name)
phylip_lines = phylip_file.readlines
specimen_ids = []
seqs = []
phylip_lines[1..-1].each do |l|
	specimen_ids << l.split[0]
	seqs << l.split[1]
end
species_ids = []
specimen_ids.each do |i|
	species_ids << i.split("_")[0]
end
species_ids.uniq!

# Translate the sequences into SNAPP's "0", "1", "2" code, where "1" is heterozygous.
binary_seqs = []
total_number_of_first_allele = 0
total_number_of_second_allele = 0
seqs.size.times{binary_seqs << ""}
seqs[0].size.times do |pos|
	# Collect all bases at this position.
	bases_at_this_pos = []
	seqs.each do |s|
		if s[pos] == "A"
			bases_at_this_pos << "A"
			bases_at_this_pos << "A"
		elsif s[pos] == "C"
			bases_at_this_pos << "C"
			bases_at_this_pos << "C"
		elsif s[pos] == "G"
			bases_at_this_pos << "G"
			bases_at_this_pos << "G"
		elsif s[pos] == "T"
			bases_at_this_pos << "T"
			bases_at_this_pos << "T"
		elsif s[pos] == "R"
			bases_at_this_pos << "A"
			bases_at_this_pos << "G"
		elsif s[pos] == "Y"
			bases_at_this_pos << "C"
			bases_at_this_pos << "T"
		elsif s[pos] == "S"
			bases_at_this_pos << "G"
			bases_at_this_pos << "C"
		elsif s[pos] == "W"
			bases_at_this_pos << "A"
			bases_at_this_pos << "T"
		elsif s[pos] == "K"
			bases_at_this_pos << "G"
			bases_at_this_pos << "T"
		elsif s[pos] == "M"
			bases_at_this_pos << "A"
			bases_at_this_pos << "C"
		else
			raise "ERROR: Found unexpected base at position #{pos+1}: #{s[pos]}!"
		end
	end
	uniq_bases_at_this_pos = bases_at_this_pos.uniq
	# Make sure all sites are biallelic.
	raise "ERROR: Found a non-biallelic site at position #{pos+1}!" unless uniq_bases_at_this_pos.size == 2
	# Randomly define what's "0" and "2".
	uniq_bases_at_this_pos.shuffle!
	seqs.size.times do |x|
		if seqs[x][pos] == uniq_bases_at_this_pos[0]
			binary_seqs[x] << "0"
			total_number_of_first_allele += 2
		elsif seqs[x][pos] == uniq_bases_at_this_pos[1]
			binary_seqs[x] << "2"
			total_number_of_second_allele += 2
		else
			binary_seqs[x] << "1"
			total_number_of_first_allele += 1
			total_number_of_second_allele += 1
		end
	end
end

# Read the tree input file.
tree_file = File.open(tree_file_name)
tree_string = tree_file.readlines[0]

# Parse the tree using phylsim.
tree = Tree.parse(fileName=tree_file_name, fileType="newick", diversityFileName = nil, treeNumber = 0, verbose = false)
# tree.treeOrigin is the age of the root.

# Find the branch for which the termination time is closes to a third of the root age.
selected_branch = tree.branch[0]
tree.branch[1..-1].each do |b|
	if (b.termination-(tree.treeOrigin/3.0))**2 < (selected_branch.termination-(tree.treeOrigin/3.0))**2
		selected_branch = b
	end
end

# Get a list of extant species for the branch selected above.
species_in_constrained_clade = []
selected_branch.extantProgenyId.each do |p|
	tree.branch.each do |b|
		if b.id == p
			species_in_constrained_clade << b.speciesId
		end
	end
end

# Set run parameters.
number_of_mcmc_generations = 500000
store_frequency = 500
screen_frequency = 100
snapp_log_file_name = "snapp.log"
snapp_trees_file_name = "snapp.trees"
add_comments = true

# Prepare SNAPP input string.
snapp_string = ""
snapp_string << "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
snapp_string << "<beast beautitemplate='SNAPP' beautistatus='' namespace=\"beast.core:beast.evolution.alignment:beast.evolution.tree.coalescent:beast.core.util:beast.evolution.nuc:beast.evolution.operators:beast.evolution.sitemodel:beast.evolution.substitutionmodel:beast.evolution.likelihood\" version=\"2.0\">\n"
snapp_string << "\n"
snapp_string << "<!-- Data -->\n"
snapp_string << "<data id=\"snps\" dataType=\"integer\" name=\"rawdata\">\n"
specimen_ids.size.times do |x|
	snapp_string << "    <sequence id=\"seq_#{specimen_ids[x]}\" taxon=\"#{specimen_ids[x]}\" totalcount=\"3\" value=\"#{binary_seqs[x]}\"/>\n"
end
snapp_string << "</data>\n"
snapp_string << "\n"
snapp_string << "<!-- Maps -->\n"
snapp_string << "<map name=\"Uniform\" >beast.math.distributions.Uniform</map>\n"
snapp_string << "<map name=\"Exponential\" >beast.math.distributions.Exponential</map>\n"
snapp_string << "<map name=\"LogNormal\" >beast.math.distributions.LogNormalDistributionModel</map>\n"
snapp_string << "<map name=\"Normal\" >beast.math.distributions.Normal</map>\n"
snapp_string << "<map name=\"Gamma\" >beast.math.distributions.Gamma</map>\n"
snapp_string << "<map name=\"OneOnX\" >beast.math.distributions.OneOnX</map>\n"
snapp_string << "<map name=\"prior\" >beast.math.distributions.Prior</map>\n"
snapp_string << "\n"
snapp_string << "<run id=\"mcmc\" spec=\"MCMC\" chainLength=\"#{number_of_mcmc_generations}\" storeEvery=\"#{store_frequency}\">\n"
snapp_string << "\n"
snapp_string << "    <!-- State -->\n"
snapp_string << "    <state id=\"state\" storeEvery=\"#{store_frequency}\">\n"
snapp_string << "        <stateNode id=\"tree\" spec=\"beast.util.TreeParser\" IsLabelledNewick=\"true\" nodetype=\"snap.NodeData\" newick=\"#{tree_string};\">\n"
snapp_string << "            <taxa id=\"data\" spec=\"snap.Data\" dataType=\"integerdata\">\n"
snapp_string << "                <rawdata idref=\"snps\"/>\n"
species_ids.each do |s|
	snapp_string << "                <taxonset id=\"#{s}\" spec=\"TaxonSet\">\n"
	specimen_ids.size.times do |x|
		if specimen_ids[x].split("_")[0] == s
			snapp_string << "                    <taxon id=\"#{specimen_ids[x]}\" spec=\"Taxon\"/>\n"
		end
	end
	snapp_string << "                </taxonset>\n"
end
snapp_string << "            </taxa>\n"
snapp_string << "        </stateNode>\n"
snapp_string << "        <!-- Parameter starting values -->\n"
snapp_string << "        <parameter id=\"lambda\" lower=\"0.0\" name=\"stateNode\">0.1</parameter>\n"
snapp_string << "        <parameter id=\"coalescenceRate\" lower=\"0.0\" name=\"stateNode\">200.0</parameter>\n"
snapp_string << "        <parameter id=\"clockRate\" lower=\"0.0\" name=\"stateNode\">0.01</parameter>\n"
snapp_string << "    </state>\n"
snapp_string << "\n"
snapp_string << "    <!-- Posterior -->\n"
snapp_string << "    <distribution id=\"posterior\" spec=\"util.CompoundDistribution\">\n"
snapp_string << "        <distribution id=\"prior\" spec=\"util.CompoundDistribution\">\n"
snapp_string << "\n"
snapp_string << "            <!-- Divergence age priors -->\n"
if constraint_type == "root"
	snapp_string << "            <distribution id=\"All.prior\" monophyletic=\"true\" spec=\"beast.math.distributions.MRCAPrior\" tree=\"@tree\">\n"
	snapp_string << "                <taxonset id=\"All\" spec=\"TaxonSet\">\n"
	species_ids.each do |s|
		snapp_string << "                    <taxon idref=\"#{s}\"/>\n"
	end
	snapp_string << "                </taxonset>\n"
    snapp_string << "                <LogNormal meanInRealSpace=\"true\" name=\"distr\" offset=\"#{tree.treeOrigin/2.0}\">\n"
    snapp_string << "                    <parameter estimate=\"false\" name=\"M\">#{tree.treeOrigin/2.0}</parameter>\n"
    snapp_string << "                    <parameter estimate=\"false\" lower=\"0.0\" name=\"S\" upper=\"5.0\">0.1</parameter>\n"
    snapp_string << "                </LogNormal>\n"
	snapp_string << "            </distribution>\n"
elsif constraint_type == "young"
	snapp_string << "            <distribution id=\"Clade.prior\" monophyletic=\"true\" spec=\"beast.math.distributions.MRCAPrior\" tree=\"@tree\">\n"
	snapp_string << "                <taxonset id=\"Clade\" spec=\"TaxonSet\">\n"
	species_in_constrained_clade.each do |s|
		snapp_string << "                    <taxon idref=\"#{s}\"/>\n"
	end
	snapp_string << "                </taxonset>\n"
    snapp_string << "                <LogNormal meanInRealSpace=\"true\" name=\"distr\" offset=\"#{selected_branch.termination/2.0}\">\n"
    snapp_string << "                    <parameter estimate=\"false\" name=\"M\">#{selected_branch.termination/2.0}</parameter>\n"
    snapp_string << "                    <parameter estimate=\"false\" lower=\"0.0\" name=\"S\" upper=\"5.0\">0.1</parameter>\n"
    snapp_string << "                </LogNormal>\n"
	snapp_string << "            </distribution>\n"
else
	raise "ERROR: Constraint type should be either 'root' or 'young'!"
end
if add_comments
	snapp_string << "            <!--.\n"
	snapp_string << "            The clock rate affects the model only by scaling branches before likelihood calculations.\n"
	snapp_string << "            A One-over-x prior distribution is used.\n"
	# snapp_string << "            A uniform prior between 0.0 and 1.0 is reasonable when using a SNP data matrix for which\n"
	# snapp_string << "            the frequency of multiple substitutions per site can be neglected, and when the total length\n"
	# snapp_string << "            of all branches of the species is at least 1.0 (which is usually the case if the species\n"
	# snapp_string << "            tree is scaled in millions of years). Under these conditions, no more than one substitution\n"
	# snapp_string << "            per site will have occurred per time unit, meaning that with a clock rate between 0.0 and\n"
	# snapp_string << "            1.0 branch lengths can be scaled down so that one substitution occurred per time unit, in\n"
	# snapp_string << "            agreement with the mutation rate parameters u and v, which are set so that one mutation\n"
	# snapp_string << "            is expected per time unit (see below).\n"
	snapp_string << "            -->\n"
end
snapp_string << "            <prior name=\"distribution\" x=\"@clockRate\">\n"
# snapp_string << "                <Uniform name=\"distr\" lower=\"0.0\" upper=\"1.0\"/>\n"
snapp_string << "                <OneOnX name=\"distr\"/>\n"
snapp_string << "            </prior>\n"
if add_comments
	snapp_string << "            <!--.\n"
	snapp_string << "            The scaling of branch lengths based on the clock rate does not affect the evaluation of the\n"
	snapp_string << "            likelihood of the species tree given the speciation rate lambda. Thus, lambda is measured in\n"
	snapp_string << "            the same time units as the unscaled species tree, which is assumed to be in million years.\n"
	snapp_string << "            A One-over-x prior distribution is used.\n"
	# snapp_string << "            To account for extremely fast speciation as observed in some vertebrate radiations (e.g.\n"
	# snapp_string << "            Lake Victoria cichlid fishes), a uniform prior probability distribution with a conservative\n"
	# snapp_string << "            upper bound of 1000 is used.\n"
	snapp_string << "            -->\n"
end
snapp_string << "            <prior name=\"distribution\" x=\"@lambda\">\n"
# snapp_string << "                <Uniform name=\"distr\" lower=\"0.0\" upper=\"1000\"/>\n"
snapp_string << "                <OneOnX name=\"distr\"/>\n"
snapp_string << "            </prior>\n"
if add_comments
	snapp_string << "            <!--.\n"
	snapp_string << "            The below distribution defines the prior probability for the population mutation rate Theta.\n"
	snapp_string << "            In standard SNAPP analyses, a gamma distribution is commonly used to define this probability,\n"
	snapp_string << "            with a mean according to expectations based on the assumed mean effective population size\n"
	snapp_string << "            (across all branches) and the assumed mutation rate per site and generation. However, with\n"
	snapp_string << "            SNP matrices, the mutation rate of selected SNPs usually differs strongly from the genome-wide\n"
	snapp_string << "            mutation rate, and the degree of this difference depends on the way in which SNPs were selected\n"
	snapp_string << "            for the analysis. The SNP matrices used for this analysis are assumed to all be bi-allelic,\n"
	snapp_string << "            excluding invariable sites, and are thus subject to ascertainment bias that will affect the\n"
	snapp_string << "            mutation rate estimate. If only a single species would be considered, this ascertainment bias\n"
	snapp_string << "            could be accounted for (Kuhner et al. 2000; Genetics 156: 439–447). However, with multiple\n"
	snapp_string << "            species, the proportion of SNPs that are variable among individuals of the same species,\n"
	snapp_string << "            compared to the overall number of SNPs variable among all species, depends on relationships\n"
	snapp_string << "            between species and the age of the phylogeny, parameters that are to be inferred in the analysis.\n"
	snapp_string << "            Thus, SNP ascertainment bias can not be accounted for before the analysis, and the prior\n"
	snapp_string << "            expectation of Theta is extremely vague. Therefore, a uniform prior probability distribution\n"
	snapp_string << "            is here used for this parameter, instead of the commonly used gamma distribution. By default,\n"
	snapp_string << "            SNAPP uses a lower boundary of 0 and an upper boundary of 10000 when a uniform prior probability\n"
	snapp_string << "            distribution is chosen for Theta, and these lower and upper boundaries can not be changed without\n"
	snapp_string << "            editing the SNAPP source code. Regardless of the wide boundaries, the uniform distribution works\n"
	snapp_string << "            well in practice, at least when the Theta parameter is constrained to be identical on all branches\n"
	snapp_string << "            (see below).\n"
	snapp_string << "            -->\n"
end
snapp_string << "            <distribution spec=\"snap.likelihood.SnAPPrior\" coalescenceRate=\"@coalescenceRate\" lambda=\"@lambda\" rateprior=\"uniform\" tree=\"@tree\">\n"
if add_comments
	snapp_string << "                <!--.\n"
	snapp_string << "                SNAPP requires input for parameters alpha and beta regardless of the chosen type of prior,\n"
	snapp_string << "                however, the values of these two parameters are ignored when a uniform prior is selected.\n"
	snapp_string << "                Thus, they are both set arbitrarily to 1.0.\n"
	snapp_string << "                -->\n"
end
snapp_string << "                <parameter estimate=\"false\" lower=\"0.0\" name=\"alpha\">1.0</parameter>\n"
snapp_string << "                <parameter estimate=\"false\" lower=\"0.0\" name=\"beta\">1.0</parameter>\n"
snapp_string << "            </distribution>\n"
snapp_string << "        </distribution>\n"
snapp_string << "        <distribution id=\"likelihood\" spec=\"util.CompoundDistribution\">\n"
snapp_string << "            <distribution spec=\"snap.likelihood.SnAPTreeLikelihood\" data=\"@data\" non-polymorphic=\"false\" pattern=\"coalescenceRate\" tree=\"@tree\">\n"
snapp_string << "                <siteModel spec=\"SiteModel\">\n"
snapp_string << "                    <substModel spec=\"snap.likelihood.SnapSubstitutionModel\" coalescenceRate=\"@coalescenceRate\">\n"
if add_comments
	snapp_string << "                        <!--.\n"
	snapp_string << "                        The forward and backward mutation rates are fixed so that the total number of expected\n"
	snapp_string << "                        mutations per time unit (after scaling branch lengths with the clock rate) is 1.0.\n"
	snapp_string << "                        This is done to avoid non-identifability of rates, given that the clock rate is estimated.\n"
	snapp_string << "                        Both parameters are fixed at the same values, since it is assumed that alleles were trans-\n"
	snapp_string << "                        lated to binary code by random assignment of '0' and '2' to homozygous alleles, at each\n"
	snapp_string << "                        site individually. Thus, the probabilities for '0' and '2' are identical and the resulting\n"
	snapp_string << "                        frequencies of '0' and '2' in the data matrix should be very similar.\n"
	snapp_string << "                        -->\n"
end
snapp_string << "                        <parameter estimate=\"false\" lower=\"0.0\" name=\"mutationRateU\">1.0</parameter>\n"
snapp_string << "                        <parameter estimate=\"false\" lower=\"0.0\" name=\"mutationRateV\">1.0</parameter>\n"
snapp_string << "                    </substModel>\n"
snapp_string << "                </siteModel>\n"
if add_comments
	snapp_string << "                <!--.\n"
	snapp_string << "                A strict clock rate is used, assuming that only closely related species are used in SNAPP\n"
	snapp_string << "                analyses and that branch rate variation among closely related species is negligible.\n"
	snapp_string << "                The use of a relaxed clock is not supported in SNAPP.\n"
	snapp_string << "                -->\n"
end
snapp_string << "                <branchRateModel spec=\"beast.evolution.branchratemodel.StrictClockModel\" clock.rate=\"@clockRate\"/>\n"
snapp_string << "            </distribution>\n"
snapp_string << "        </distribution>\n"
snapp_string << "    </distribution>\n"
snapp_string << "\n"
snapp_string << "    <!-- Operators -->\n"
snapp_string << "    <!--The node swapper operator is removed to fix the tree topology-->\n"
snapp_string << "    <!--<operator id=\"treeNodeSwapper\" spec=\"snap.operators.NodeSwapper\" tree=\"@tree\" weight=\"1.0\"/>-->\n"
snapp_string << "    <operator id=\"treeNodeBudger\" spec=\"snap.operators.NodeBudger\" size=\"0.5\" tree=\"@tree\" weight=\"1.0\"/>\n"
snapp_string << "    <operator id=\"treeScaler\" spec=\"snap.operators.ScaleOperator\" scaleFactor=\"0.95\" tree=\"@tree\" weight=\"1.0\"/>\n"
if add_comments
	snapp_string << "    <!--.\n"
	snapp_string << "    To constrain the Theta parameter so that all branches always share the same value (and thus\n"
	snapp_string << "    the same population size estimates), a single operator is used to modify Theta values by scaling\n"
	snapp_string << "    the Thetas of all branches up or down by the same factor. Instead, SNAPP's default Theta operator\n"
	snapp_string << "    types 'GammaMover' and 'RateMixer' are not not used.\n"
	snapp_string << "    -->\n"
end
snapp_string << "    <operator id=\"thetaScaler\" spec=\"snap.operators.ScaleOperator\" parameter=\"@coalescenceRate\" scaleFactor=\"0.75\" scaleAll=\"true\" weight=\"1.0\"/>\n"
snapp_string << "    <operator id=\"lamdaScaler\" spec=\"snap.operators.ScaleOperator\" parameter=\"@lambda\" scaleFactor=\"0.75\" weight=\"1.0\"/>\n"
snapp_string << "    <operator id=\"clockScaler\" spec=\"snap.operators.ScaleOperator\" parameter=\"@clockRate\" scaleFactor=\"0.75\" weight=\"1.0\"/>\n"
snapp_string << "\n"
snapp_string << "    <!-- Loggers -->\n"
snapp_string << "    <logger fileName=\"#{snapp_log_file_name}\" logEvery=\"#{store_frequency}\">\n"
snapp_string << "        <log idref=\"posterior\"/>\n"
snapp_string << "        <log idref=\"likelihood\"/>\n"
snapp_string << "        <log idref=\"prior\"/>\n"
snapp_string << "        <log idref=\"lambda\"/>\n"
snapp_string << "        <log id=\"treeHeightLogger\" spec=\"beast.evolution.tree.TreeHeightLogger\" tree=\"@tree\"/>\n"
snapp_string << "        <log idref=\"clockRate\"/>\n"
snapp_string << "    </logger>\n"
snapp_string << "    <logger logEvery=\"#{screen_frequency}\">\n"
snapp_string << "        <log idref=\"posterior\"/>\n"
snapp_string << "        <log spec=\"util.ESS\" arg=\"@posterior\"/>\n"
snapp_string << "        <log idref=\"likelihood\"/>\n"
snapp_string << "        <log idref=\"prior\"/>\n"
snapp_string << "        <log idref=\"treeHeightLogger\"/>\n"
snapp_string << "        <log idref=\"clockRate\"/>\n"
snapp_string << "    </logger>\n"
snapp_string << "    <logger fileName=\"#{snapp_trees_file_name}\" logEvery=\"#{store_frequency}\" mode=\"tree\">\n"
snapp_string << "        <log spec=\"beast.evolution.tree.TreeWithMetaDataLogger\" tree=\"@tree\">\n"
snapp_string << "            <metadata spec=\"snap.RateToTheta\" coalescenceRate=\"@coalescenceRate\"/>\n"
snapp_string << "        </log>\n"
snapp_string << "    </logger>\n"
snapp_string << "\n"
snapp_string << "</run>\n"
snapp_string << "\n"
snapp_string << "</beast>\n"

# Write the SNAPP input file.
snapp_file = File.open(snapp_file_name,"w")
snapp_file.write(snapp_string)
