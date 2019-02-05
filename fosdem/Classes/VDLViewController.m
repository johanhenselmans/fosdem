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
	NSTimer *_idleTimer;
	BOOL _setPosition;
	BOOL _displayRemainingTime;
	
	
}

@end

@implementation VDLViewController

@synthesize contentVideo;


- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
	/* setup the media player instance, give it a delegate and something to draw into */
	
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_mediaplayer = [[VLCMediaPlayer alloc] init];
	_mediaplayer.delegate = self;
	_mediaplayer.drawable = self.movieView;
	[self.timeDisplay setTitle:@"" forState:UIControlStateNormal];
	/* listen for notifications from the player */
	[_mediaplayer addObserver:self forKeyPath:@"time" options:0 context:nil];
	[_mediaplayer addObserver:self forKeyPath:@"remainingTime" options:0 context:nil];
	
	if (contentVideo.length!=0){
		/* create a media object and give it to the player and start playing*/
		_mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:contentVideo]];
		
	}
	// _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://video.fosdem.org/2014/Janson/Saturday/Welcome_to_FOSDEM_2014.webm"]];
	// _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://video.fosdem.org/2013/maintracks/Janson/The_Open_Observatory_of_Network_Interference.ogg"]];
	//  Does not work....
	// _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=vMQmf4hype4"]];
	
	[_mediaplayer play];
	
	[_playButton setTitle:@"Pauze" forState:UIControlStateNormal];
	
	[self _resetIdleTimer];
	
	
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (_mediaplayer) {
		@try {
			[_mediaplayer removeObserver:self forKeyPath:@"time"];
			[_mediaplayer removeObserver:self forKeyPath:@"remainingTime"];
		}
		@catch (NSException *exception) {
			NSLog(@"we weren't an observer yet");
		}
		
		if (_mediaplayer.media)
			[_mediaplayer stop];
		
		if (_mediaplayer)
			_mediaplayer = nil;
	}
	
	if (_idleTimer) {
		[_idleTimer invalidate];
		_idleTimer = nil;
	}
}

-(void) viewDidDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	//[_mediaplayer pause];
	//_mediaplayer = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	self.positionSlider.value = [_mediaplayer position];
	
	if (_displayRemainingTime)
		[self.timeDisplay setTitle:[[_mediaplayer remainingTime] stringValue] forState:UIControlStateNormal];
	else
		[self.timeDisplay setTitle:[[_mediaplayer time] stringValue] forState:UIControlStateNormal];
	// disaply the position in the file while scrolling..
	if(_setPosition){
		[self.timeDisplay setTitle:[NSString stringWithFormat:@"%f",_positionSlider.value] forState:UIControlStateNormal];
	//[self.timeDisplay setTitle:[@"calculating..."]];

	}
	
}



- (IBAction)toggleTimeDisplay:(id)sender
{
	[self _resetIdleTimer];
	_displayRemainingTime = !_displayRemainingTime;
}


- (UIResponder *)nextResponder
{
	[self _resetIdleTimer];
	return [super nextResponder];
}



- (IBAction)positionSliderAction:(UISlider *)sender
{
	[self _resetIdleTimer];
	
	/* we need to limit the number of events sent by the slider, since otherwise, the user
	 * wouldn't see the I-frames when seeking on current mobile devices. This isn't a problem
	 * within the Simulator, but especially on older ARMv7 devices, it's clearly noticeable. */
	[self performSelector:@selector(_setPositionForReal) withObject:nil afterDelay:0.3];
	_setPosition = NO;
}

- (void)_setPositionForReal
{
	if (!_setPosition) {
		_mediaplayer.position = _positionSlider.value;
		_setPosition = YES;
	}
}

- (IBAction)positionSliderDrag:(id)sender
{
	[self _resetIdleTimer];
}


- (void)_resetIdleTimer
{
	if (!_idleTimer){
		_idleTimer = [NSTimer scheduledTimerWithTimeInterval:5.
																									target:self
																								selector:@selector(idleTimerExceeded)
																								userInfo:nil
																								 repeats:NO];
	} else {
		if (fabs([_idleTimer.fireDate timeIntervalSinceNow]) < 5.){
			[_idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.]];
		}
	}
}

- (void)idleTimerExceeded
{
	_idleTimer = nil;
	
}



@end
