//
//  VideoSamples.m
//  TealiumiOSTaggerTestApp
//
//  Created by Jason Koo on 11/21/12.
//  Copyright (c) 2012 Tealium, Inc. All rights reserved.
//

#import "VideoSamplesViewController.h"

@interface VideoSamplesViewController ()

@end

@implementation VideoSamplesViewController

@synthesize webViewPlayer;
@synthesize avPlayer;
@synthesize avPlayerView;
@synthesize mPlayerController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"VideoSamplesViewController";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAvPlayer];
    [self playVideo:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WEBVIEW
- (void) loadWebView{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO )
    {
        NSLog(@"No video file found. Path:%@", path);
        return;
    }
    
    [webViewPlayer loadHTMLString:@"<video src=\"sample.mp4\">Sample Video</video>"
                     baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%s: error:%@", __FUNCTION__, error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%s:", __FUNCTION__);
    
}

#pragma mark - AVPlayer
- (void) loadAvPlayer{
    
#ifdef TRACKVIDEO
    NSURL *url = [self localMovieURL:@"sample"];
    avPlayer = [[AVPlayer alloc]initWithURL:url];
    
    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    playerLayer.frame = avPlayerView.bounds;
    [avPlayerView.layer addSublayer:playerLayer];

#endif
}

- (IBAction)playAv:(id)sender {
#ifdef TRACKVIDEO
    if(!avPlayer) [self loadAvPlayer];
    [avPlayer play];
#endif
}

- (IBAction)pauseAv:(id)sender {
#ifdef TRACKVIDEO
    [avPlayer pause];
#endif
}


#pragma mark - MPMOVIEPLAYER

- (IBAction)playVideo:(id)sender {
    
    NSURL *url = [self localMovieURL:@"sample"];
    
    if (!mPlayerController) mPlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self setupPlayer:mPlayerController.moviePlayer];
    [self setupPlayerController:mPlayerController];
    [self installMovieNotificationObservers:mPlayerController.moviePlayer];

}

-(NSURL *)localMovieURL:(NSString*)filename
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:filename ofType:@"mp4"];
		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}

- (void) setupPlayerController:(MPMoviePlayerViewController*) playerViewController{
    
    [playerViewController.view setFrame:self.mPlayerView.bounds];
    [self.mPlayerView addSubview:playerViewController.view];
}


- (void) setupPlayer:(MPMoviePlayerController*) player{
    
    [player prepareToPlay];
    player.shouldAutoplay = NO;
    player.repeatMode = MPMovieRepeatModeNone;
    player.movieSourceType = MPMovieSourceTypeFile;
    player.controlStyle = MPMovieControlModeHidden;
    player.scalingMode = MPMovieScalingModeAspectFit;
    
}

-(void)installMovieNotificationObservers:(MPMoviePlayerController*)player
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playBackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playBackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey
                                               object:player];
    
}

- (void) playBackComplete:(NSNotification*) notification{
        
        NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        switch ([reason integerValue])
        {
                /* The end of the movie was reached. */
            case MPMovieFinishReasonPlaybackEnded:
                break;
                
                /* An error was encountered during playback. */
            case MPMovieFinishReasonPlaybackError:                
                [mPlayerController.moviePlayer stop];
                [mPlayerController.moviePlayer.view removeFromSuperview];
                mPlayerController = nil;
                [[NSNotificationCenter defaultCenter] removeObserver:self];

                break;
                
                /* The user stopped playback. */
            case MPMovieFinishReasonUserExited:                
                [mPlayerController.moviePlayer stop];
                [mPlayerController.moviePlayer.view removeFromSuperview];
                mPlayerController = nil;
                [[NSNotificationCenter defaultCenter] removeObserver:self];

                break;
                
            default:
                break;
        }

}


- (void)viewDidUnload {
    [self setWebViewPlayer:nil];
    [self setMPlayerView:nil];
    [self setMPlayerController:nil];
    [super viewDidUnload];
}

@end
