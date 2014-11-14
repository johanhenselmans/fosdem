/* Copyright (c) 2013, Felix Paul Kühne and VideoLAN
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, 
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. */

#import "VDLViewController.h"

@interface VDLViewController () <VLCMediaPlayerDelegate>
{
    VLCMediaPlayer *_mediaplayer;
}

@end

@implementation VDLViewController

@synthesize contentVideo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    /* setup the media player instance, give it a delegate and something to draw into */
    _mediaplayer = [[VLCMediaPlayer alloc] init];
    _mediaplayer.delegate = self;
    _mediaplayer.drawable = self.movieView;

    if (contentVideo.length!=0){
    /* create a media object and give it to the player */
   _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:contentVideo]];
    }  // _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://video.fosdem.org/2014/Janson/Saturday/Welcome_to_FOSDEM_2014.webm"]];
 // _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://video.fosdem.org/2013/maintracks/Janson/The_Open_Observatory_of_Network_Interference.ogg"]];
  
 //  Does not work....
 // _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=vMQmf4hype4"]];
//  [_playButton setTitle:@"Play" forState:UIControlStateNormal];
//  [_playButton setTitle:@"Pauze" forState:UIControlStateHighlighted];

}

- (IBAction)playandPause:(id)sender
{
  if (_mediaplayer.isPlaying){
      [_mediaplayer pause];
      [_playButton setTitle:@"Play" forState:UIControlStateNormal];

  } else {
    [_mediaplayer play];
    [_playButton setTitle:@"Pauze" forState:UIControlStateNormal];

  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated
{
  [_mediaplayer pause];
  //_mediaplayer = nil;
}

@end
