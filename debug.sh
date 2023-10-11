odin build ronald -o:none -build-mode:dll -debug
mv ./ronald.so ./ronald.clap

clap-validator -v trace validate ./ronald.clap && gdb -iex="attach clap-validator"