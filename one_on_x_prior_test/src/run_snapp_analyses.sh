# m_matschiner Thu Dec 14 15:52:12 CET 2017

# Memorize the home directory.
home=`pwd`

# Navigate to the directory for the one_on_x analysis.
cd ../res/one_on_x

# Run the modified version of snapp.
java -jar -Dbeast.user.package.dir="." -Xmx4g beast.jar -threads 4 snapp_one_on_x.xml

# Navigate to the directory for the uniform analysis.
cd ${home}
cd ../res/uniform

# Run the unmodified version of snapp.
java -jar -Dbeast.user.package.dir="." -Xmx4g beast.jar -threads 4 snapp_uniform.xml
