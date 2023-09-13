# CTIFT
Concert Tape Info File Trimmer

# Changelog
2023-09-11 (v3.0) - Updated script to be semi-automatic. The user is no longer prompted to input the needed values. Instead, a hellish regex pattern is used instead. It works with no issue roughly 95% of the time. Occasionally some issues will pop up which really aren't easy to fix (typos in the original file for one), and putting in a case for every single fix would be ridiculous. Some editing afterwards might be needed. The script also has a boolean flag to enable exporting a file with no arrows (->, -->, >, etc.), mainly useful if you want to batch rename files.

2023-08-04 (v2.0) - Rewrote script to make it much cleaner and easier to use. Auto exports files to same directory as inputted info file. Reason for the big jump in version numbers is because I basically rewrote the script from scratch, and felt it changed enough to warrant it. And at various points I cba to make sure I did the version numbers right, also explains the jumps.

Also removed the .exe file, as it was unnecessary.

2023-01-07 (v1.4) - small fixes to regex

2022-11-27 (v1.3?) - The pop-up to select a file is now gone, it was quite buggy and at times would disappear behind other windows (and no taskbar icon to find it). Replaced with just a simple "enter file path here" prompt.

2022-09-14 (v1.2) - small fixes

2022-07-24 (v1.1) - regex files

2022-07-21 (v1.0) - initial release

# Info:
Introduction:
I created this program as a way to trim the info files that come with many concert tapes and bootlegs (the kind traded around on sites like etree, lossless legs, and the like). These trimmed files can then be used with a program like MP3Tag to tag the audio files with proper song titles. When you download a show, it usually comes with a info file like this:

```
Grateful Dead
Jai-Alai Fronton
Miami, FL
June 22, 1974

Jerry Garcia - Lead Guitar, Vocals
Donna Jean Godchaux - Vocals
Keith Godchaux - Keyboards
Bill Kreutzmann - Drums
Phil Lesh - Electric Bass, Vocals
Bob Weir - Rhythm Guitar, Vocals

*Matrix* 

----------------------------------------------------
SBD (shnid=90200): 

Recording Info:
SBD -> Master Reel -> Cassette -> Dat -> CD

...

Set I
-----
d1t01 - Tuning
d1t02 - Promised Land ->
d1t03 - Bertha ->
d1t04 - Greatest Story Ever Told
```

It contains all the info on the tape you just downloaded, the lineage of the various tapes involved, and a tracklist. Now, for most people, the tracklist is the only important info in the info file (along with the artist, date, and venue). The rest means nothing. So I created a script to trim all that info out and just leave the tracklist. 

Well, I created a few actually. The first was a collection of sed commands to extract the tracklist from the info file. It worked, but it was only a shell script, and while it would output to a txt file, it needed to create temporary files first to complete all the sed commands (it wouldn't work for me without these). Also, no file picker support. It would only work with files named "info.txt", and would only work in the folder the script file was in. Unless a filepath was supplied manually, but this isn't super user friendly unless you know bash scripting.

So, to the drawing board it was. I had to find a method to create this program, that would also be able to do everything the bash script did plus anything extra. The bulk of the script relies on regular expressions (REGEX), so whatever language I chose needed to be able to use that. 

I have experience in Java, CPP, Python and a bit of C. Shockingly, while these languages have functions to match regex, none of them are able to *output* the matches, just a boolean flag for true or false (it either matches or doesn't match). Another feature I wanted is a file picker, which would open a windows explorer dialog to pick files (which is much easier than the shell script). Java has one but its pretty bad, imagine something like this. Kinda like the file choosers in linux.

![image](https://user-images.githubusercontent.com/9311410/174844581-2139c819-8391-4e14-a4fe-6be190af9a82.png)

While this would make it crossplatform, it is again pretty user unfriendly. You'd have to manually navigate to the path of the txt file, which if you store tapes on an external drive and several folders deep, it's a huge pain.

So, it left me with learning Powershell. Which supports native file choosers, and regex matching and outputting. So that crosses off the two checkboxes. Much of the code was found from searching around the internet on how to get several features I wanted implemented in PS. Much was from Microsofts documentation, but I used this to fix an issue with Windows not liking paths with hard brackets in them. https://stackoverflow.com/questions/64770913/get-content-error-cannot-bind-argument-to-parameter-path-because-it-is-null.

In this repo is the Powershell script, ~~and an EXE which is the script compiled into an executable file using PS2EXE~~. One small issue I've found is that if you have Powertoys installed, an error will pop up with the enhanced file preview PT includes with it. This might stop the program from proceeding, but closing and opening again fixes that. It won't stop the code from running to my knowledge.

~~This script works with basically every kind of info file I have thrown at it. It might match some extraneous lines, which can be removed manually, since I don't know of a way to trim those out without impacting the tracklist.~~
Script works with most files that i've tested. I'm going through my show collection and any needed fixes are added as I go. Can't catch everything and some things might need manual editing, but it works no issue on most things.
