OS=`uname -o`

# unpack archive
tar xjf sepp-package.tar.bz
cd sepp-package

# patch main script to make it relocatable
patch run-sepp.sh < ../reloc.patch
mv run-sepp.sh seppgg

# run sepp configuration
cd sepp
python setup.py config -c
sed -i 's|path=.*/|path=/opt/anaconda1anaconda2anaconda3/bin/|' .sepp/main.config

# install files into correct directories
cd ../
install -d $PREFIX/bin
install seppgg $PREFIX/bin/

# copy correct versions of bundled binaries into target bin directory
if [[ $OS == *"linux"* ]]; then
	DIRARCH='Linux';
	if [[ $ARCH == "64" ]]; then
		SUFFIXBIT='-64';
	else
		SUFFIXBIT='-32';
	fi;
else
	DIRARCH='Darwin';
	SUFFIXBIT='';
fi;
echo "OS is '$OS' with '$target_platform' bits. Using $DIRARCH$SUFFIXBIT bundled binaries."
install sepp/tools/bundled/$DIRARCH/guppy$SUFFIXBIT $PREFIX/bin/guppy
install sepp/tools/bundled/$DIRARCH/hmmalign$SUFFIXBIT $PREFIX/bin/hmmalign
install sepp/tools/bundled/$DIRARCH/hmmbuild$SUFFIXBIT $PREFIX/bin/hmmbuild
install sepp/tools/bundled/$DIRARCH/hmmsearch$SUFFIXBIT $PREFIX/bin/hmmsearch
install sepp/tools/bundled/$DIRARCH/pplacer$SUFFIXBIT $PREFIX/bin/pplacer
install sepp/tools/merge/seppJsonMerger.jar $PREFIX/bin/seppJsonMerger.jar

install -d $PREFIX/share/seppgg
install ref/* $PREFIX/share/seppgg/
install ../tiny_fragments.mfa $PREFIX/share/seppgg/
install ../tiny_reference.aln $PREFIX/share/seppgg/
install ../tiny_reference.newick $PREFIX/share/seppgg/


cp -r sepp $PREFIX/share/seppgg/
echo '/opt/anaconda1anaconda2anaconda3/share/seppgg/sepp/.sepp' > $PREFIX/share/seppgg/sepp/home.path
