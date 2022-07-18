environmentName="${1:-dev}"
scriptPath=`dirname $BASH_SOURCE`

# "building" is just copying the src folder into the dist folder for now.
# in the future, if we transform the src code before sending it to the dist folder, we can do so here.

srcPath=`realpath $scriptPath/../src/`
distPath=`realpath $scriptPath/../dist/`

rm -rf $distPath
cp -R $srcPath $distPath