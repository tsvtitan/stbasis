I have not tried to launch the daemon when linux starts yet.
To test it just run it like this:
./daemon
You will be brought back to the prompt because the program forked.
From there you can do a ps ax|grep daemon to see the proc ID.
Use the ID to send a signal like this:
kill -HUP processID
This will tell the daemon to rewrite the log file which is created in the same directory as the daemon.
It will not kill the process.
To finally kill it do:
kill -TERM processID


There are some test procedures listed in the source code.
This daemon example was ported from the Free Pascal Distribution

Windows and linux clients are provided for you to test.


I hope this helps others out, I learned a lot from it.


Tony Caduto