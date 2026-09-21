fosdem
======

Note: this package is obsolete, I have converted most of the functionality to an app written in Flutter, 
which you can find at https://github.com/johanhenselmans/fosdemall.

If you want something to look at, go to that repo.


An expanded iPhone application for FOSDEM in Brussels. You can browse the conference per year, and if 
there is a video available of the session, you can play it. 

To compile it, use at least Xcode 6,0, and install cocoapods (via "sudo gem install cocoapods").

Then in the mainfolder, run "pod install", which will create a fosdem.xcworkspace, and download the 
VLCKit that is needed to play webm video's.

After that, always use the workspace to compile the fosdem app. 
