odin build ronald -o:none -build-mode:dll
mv ./ronald.so ./ronald.clap

# clap-validator -v trace validate ./ronald.clap