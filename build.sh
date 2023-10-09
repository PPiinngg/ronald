odin build ronald -build-mode:dll
mv ./ronald.so ./ronald.clap

clap-validator -v trace validate ./ronald.clap