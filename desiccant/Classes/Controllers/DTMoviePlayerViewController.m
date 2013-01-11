//
//  DTMoviePlayerViewController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 8/6/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTMoviePlayerViewController.h"
#import "Zest.h"
#import "MediaPlayer/MPMoviePlayerController.h"

@interface DTMoviePlayerViewController()
@property (nonatomic, retain) NSURL  *movieURL;
@property (nonatomic, retain) MPMoviePlayerController *mp;
@property (nonatomic, retain) UIColor *oldWindowColor;
@end


@implementation DTMoviePlayerViewController
@synthesize movieURL, mp, oldWindowColor;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.movieURL = nil;
	self.mp = nil;
	self.oldWindowColor = nil;
	[super dealloc];
}

- (id)initWithURL:(NSURL *)theURL {
	// Initialize and create movie URL
	if ((self = [super init]))
	{
		self.movieURL = theURL;
		self.mp =  [[[MPMoviePlayerController alloc] initWithContentURL:movieURL] autorelease];
		if ([mp respondsToSelector:@selector(view)]) {
			[mp backgroundView].backgroundColor = [UIColor blackColor];
			[mp view].backgroundColor = [UIColor blackColor];
		}
	}
	return self;
}

+ (id)controllerWithURL:(NSURL *)theURL {
	return [[[self alloc] initWithURL:theURL] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	oldStatusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
	oldStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
	self.oldWindowColor = [UIApplication sharedApplication].keyWindow.backgroundColor;
}

- (void)viewDidAppear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	self.view.frame = self.view.window.bounds;
	self.view.window.backgroundColor = [UIColor blackColor];
	[super viewDidAppear:animated];
	[self.activityIndicator startAnimating];
	[self readyPlayer];
}

- (void) loadView
{
	[self setView:[[[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame] autorelease]];
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void) readyPlayer
{	
	// For 3.2 devices and above
	if ([mp respondsToSelector:@selector(loadState)]) 
	{		
		// Set movie player layout
		[mp setControlStyle:MPMovieControlStyleNone];
		[mp setFullscreen:YES];
		
		// May help to reduce latency
		[mp prepareToPlay];
		
		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] replaceObserver:self 
												 selector:@selector(moviePlayerLoadStateChanged:) 
													 name:MPMoviePlayerLoadStateDidChangeNotification 
												   object:nil];
	}  
	else
	{
		// Register to receive a notification when the movie is in memory and ready to play.
		[[NSNotificationCenter defaultCenter] replaceObserver:self 
												 selector:@selector(moviePreloadDidFinish:) 
													 name:MPMoviePlayerContentPreloadDidFinishNotification 
												   object:nil];
	}
	
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] replaceObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

/*---------------------------------------------------------------------------
 * For 3.1.x devices
 * For 3.2 and 4.x see moviePlayerLoadStateChanged: 
 *--------------------------------------------------------------------------*/
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerContentPreloadDidFinishNotification
	 object:nil];
	
	[self.activityIndicator stopAnimating];
	
	// Play the movie
	[mp play];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

/*---------------------------------------------------------------------------
 * For 3.2 and 4.x devices
 * For 3.1.x devices see moviePreloadDidFinish:
 *--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
	{
		// Remove observer
		[[NSNotificationCenter defaultCenter] 
		 removeObserver:self
		 name:MPMoviePlayerLoadStateDidChangeNotification 
		 object:nil];
		
		// When tapping movie, status bar will appear, it shows up
		// in portrait mode by default. Set orientation to landscape
		if ([mp respondsToSelector:@selector(loadState)]) {
			[[self view] setFrame:self.view.window.bounds];
			mp.view.frame = self.view.bounds;
			[mp setControlStyle:MPMovieControlStyleFullscreen];
		}
		else {
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
			// Rotate the view for landscape playback
			[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
			[[self view] setCenter:CGPointMake(160, 240)];
			[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
			[[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
		}
				
		// Set frame of movie player
		
		// Add movie player as subview
		[mp view].autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | 
									  UIViewAutoresizingFlexibleBottomMargin | 
									  UIViewAutoresizingFlexibleWidth | 
									  UIViewAutoresizingFlexibleHeight);
		[[self view] addSubview:[mp view]];
		
		[self.activityIndicator stopAnimating];

		// Play the movie
		[mp play];
	}
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    	
 	// Remove observer
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification 
	 object:nil];
	
	[[UIApplication sharedApplication] setStatusBarHidden:oldStatusBarHidden];
	[[UIApplication sharedApplication] setStatusBarStyle:oldStatusBarStyle];
	unless ([self.parentViewController shouldAutorotateToInterfaceOrientation:self.interfaceOrientation]) {
		[UIApplication sharedApplication].statusBarOrientation = oldStatusBarOrientation;
	}
	self.view.window.backgroundColor = oldWindowColor;
	
	[self dismissModalViewControllerAnimated:YES];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ([mp respondsToSelector:@selector(loadState)] || 
			interfaceOrientation == UIInterfaceOrientationLandscapeRight || 
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


@end
