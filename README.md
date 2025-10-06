# OpenPLC4

This version was just the old V3 version, copied by hand. 

Errors out on compile. 
[5:32:37 PM]: iec2c process exited with code 1

[5:32:37 PM]: C:\Development\Github\OpenPLC4\openPLC\build\P1AM-100\src\program.st:159-12..159-24: error: invalid expression in ST formal parameter out assignment.

Figured out that the issue was that some of the variables were mis-named in the table. Fixed issue, code compiles and runs. Horray!

Note that the version in the root won't open in V4.0.6-beta. But the code in the /openPLC subfolder will.
