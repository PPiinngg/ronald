rm --force ./ronald.clap
rm --force ./ronald.exp
rm --force ./ronald.lib
rm --force ./ronald.pdb

odin build ronald -o:none -build-mode:dll
mv ./ronald.dll ./ronald.clap

./clap-validator -v trace validate ./ronald.clap
