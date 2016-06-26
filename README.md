fosdem
======

An expanded iPhone application for FOSDEM in Brussels. You can browse the conference per year, and if 
there is a video available of the session, you can play it. 

To compile it, use at least Xcode 6,0, and install cocoapods (via "sudo gem install -n /usr/local/bin cocoapods").

Then in the mainfolder, run "pod install --verbose", which will create a fosdem.xcworkspace, and download the 
VLCKit that is needed to play webm video's.

After that, always use the workspace 'fosdem.xcworkspace' to compile the fosdem app. 
