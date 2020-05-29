set -e
set -x

# run from covid-if-annotations folder

eval "$(conda shell.bash hook)"
conda activate base
CONDA_ROOT=`conda info --root`
source ${CONDA_ROOT}/bin/activate root

RELEASE_ENV=${CONDA_ROOT}/envs/covid-release

conda env remove -y -q -n covid-release

echo "Creating new release environment"
conda create -q -y -n covid-release covid-if-annotations py2app --override-channels -c kdominik -c conda-forge -c defaults
conda activate covid-release

${RELEASE_ENV}/bin/python deploy/osx/setup-alias-app.py py2app --alias --dist-dir .

echo "Writing qt.conf"
cat <<EOF > __main__.app/Contents/Resources/qt.conf
; Qt Configuration file
[Paths]
Plugins = covid-release/plugins
EOF

cat <<EOF > __main__.app/Contents/Resources/__main__.py
from napari_covid_if_annotations.__main__ import main

if __name__ == "__main__":
    main()

EOF

echo "Moving covid-release environment into __main__.app bundle..."
mv ${RELEASE_ENV} __main__.app/Contents/covid-release

echo "Updating bundle internal paths..."
# Fix __boot__ script
sed -i '' 's|^_path_inject|#_path_inject|g' __main__.app/Contents/Resources/__boot__.py
sed -i '' "s|${CONDA_ROOT}/envs/covid-release/||" __main__.app/Contents/Resources/__boot__.py
sed -i '' "s|DEFAULT_SCRIPT='/__main__.py'|DEFAULT_SCRIPT='__main__.py'|" __main__.app/Contents/Resources/__boot__.py

# Fix Info.plist
sed -i '' "s|${CONDA_ROOT}/envs/covid-release|@executable_path/../covid-release|" __main__.app/Contents/Info.plist
sed -i '' "s|\.dylib|m\.dylib|" __main__.app/Contents/Info.plist

# Fix python executable link
rm __main__.app/Contents/MacOS/python
cd __main__.app/Contents/MacOS && ln -s ../covid-release/bin/python
cd -

# Fix app icon link
rm __main__.app/Contents/Resources/covid-if.icns
cp deploy/release/covid-if.icns __main__.app/Contents/Resources


# Replace Resources/lib with a symlink
rm -rf __main__.app/Contents/Resources/lib
cd __main__.app/Contents/Resources && ln -s ../covid-release/lib
cd -

