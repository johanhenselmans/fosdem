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

#import <UIKit/UIKit.h>
#import <MobileVLCKit/VLCMediaPlayer.h>

@interface VDLViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *movieView;
@property (nonatomic, strong) NSString  *contentVideo;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UISlider *positionSlider;
@property (nonatomic, strong) IBOutlet UIButton *timeDisplay;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;


- (IBAction)playandPause:(id)sender;
- (IBAction)positionSliderDrag:(id)sender;
- (IBAction)positionSliderAction:(id)sender;
- (IBAction)toggleTimeDisplay:(id)sender;
- (BOOL)hidesBottomBarWhenPushed;

@end
