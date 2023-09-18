{ writers, python }:

writers.writePython3Bin "backup-encrypted-drives" { flakeIgnore = [ "E501" ]; } (builtins.readFile ./encrypted-drives.py)
