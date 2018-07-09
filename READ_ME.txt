Hmm, I'm not exactly sure what the dependencies are to run my code, especially since you're on Windows and I'm on Linux.  But for me, I had to run

$ sudo gem install nokogiri
$ sudo gem install open-uri
$ sudo gem install parallel

To at least make sure those packages were there.  (To confirm, that reads "gem" not "get" -- "gem" is a package manager dedicated to the language of Ruby, which is what all these scripts were written in).

The script compiles an HTML document with all the data from the writings, then uses Calibre to convert that HTML doc into a MOBI (kindle format) document.  Therefore, you'll need calibre installed, and _might_ have to be on unix so that Ruby's call to the system actually cooperates with the operating system.  Not very robust on my part, but this was quick (?) and dirty, so bummer.  If the lines at the end of get_essays.rb don't work on your machine, you can set the "convert" flag to false, and it'll skip that, just producing the HTML file, which you can then convert on your own, either from the command line or from the calibre app.

Once you're ready (possibly), you just type

$ ruby get_essays.rb

and it should whip everything up!
