//
//  VideoSamples.h
//  TealiumiOSTaggerTestApp
//
//  Created by Jason Koo on 11/21/12.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoSamplesViewController : UIViewController <UIWebViewDelegate>{
    NSURL *_avURL;
}

@property (nonatomic, strong) AVPlayer  *avPlayer;
@property (nonatomic, strong) MPMoviePlayerViewController *mPlayerController;

@property (weak, nonatomic) IBOutlet UIWebView *webViewPlayer;
@property (weak, nonatomic) IBOutlet UIView *avPlayerView;
@property (weak, nonatomic) IBOutlet UIView *mPlayerView;

- (void) loadWebView;
- (void) loadAvPlayer;
- (IBAction)playAv:(id)sender;
- (IBAction)pauseAv:(id)sender;
- (IBAction)playVideo:(id)sender;

@end
