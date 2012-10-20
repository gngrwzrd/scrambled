
#import "ScrambledIpad.h"

@implementation ScrambledIpad
@synthesize iPadPortraitView;
@synthesize iPadLandscapeView;
@synthesize ipdpCurrentTime;
@synthesize ipdpCurrent;
@synthesize ipdpBest;
@synthesize ipdpBestTime;
@synthesize ipdlCurrentTime;
@synthesize ipdlCurrent;
@synthesize ipdlBest;
@synthesize ipdlBestTime;

- (void) viewDidLoad {
	[super viewDidLoad];
	[ipdpBestTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdpBest setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdpCurrentTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdpCurrent setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdlBestTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdlBest setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdlCurrentTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	[ipdlCurrent setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:36.0]];
	if(isportrait) {
		[container addSubview:iPadPortraitView];
		currentView = iPadPortraitView;
	} else if(!isportrait) {
		[container addSubview:iPadLandscapeView];
		currentView = iPadLandscapeView;
	}
	[self defaultBoard];
}

- (void) infoWantsToResetBestTime {
	[super infoWantsToResetBestTime];
	[ipdpBestTime setText:@"00:00"];
	[ipdlBestTime setText:@"00:00"];
}

- (void) gameDidTick {
	if([ipdpCurrentTime superview]) [ipdpCurrentTime setText:timeDisplay];
	if([ipdlCurrentTime superview]) [ipdlCurrentTime setText:timeDisplay];
}

- (void) updateDefaults {
	[super updateDefaults];
	[ipdpBestTime setText:bestDisplay];
	[ipdlBestTime setText:bestDisplay];
}

- (void) updateBest {
	[super updateBest];
	[ipdpBestTime setText:bestDisplay];
	[ipdlBestTime setText:bestDisplay];
}

- (void) wonGame {
	[super wonGame];
	[self resetCurrentTime];
}

- (void) resetCurrentTime {
	[ipdpCurrentTime setText:@"00:00"];
	[ipdlCurrentTime setText:@"00:00"];
}

- (BOOL)
shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)
toInterfaceOrientation
{
	if(toInterfaceOrientation == UIDeviceOrientationPortrait) return true;
	if([[info view] superview]) return false;
	return true;
}

- (void)
willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
duration:(NSTimeInterval) duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
		[container addSubview:iPadPortraitView];
		currentView = iPadPortraitView;
	} else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
		[container addSubview:iPadLandscapeView];
		currentView = iPadLandscapeView;
	}
	[self invalidateBoardView];
}

- (void) dealloc {
	[ipdpCurrent release];
	[ipdpCurrentTime release];
	[ipdpBest release];
	[ipdpBestTime release];
	[ipdlCurrent release];
	[ipdlCurrentTime release];
	[ipdlBest release];
	[ipdlBestTime release];
	ipdlBestTime = NULL;
	[iPadPortraitView release];
	[iPadLandscapeView release];
	iPadLandscapeView = NULL;
	iPadPortraitView = NULL;
	ipdlBest = NULL;
	ipdlCurrentTime = NULL;
	ipdlCurrent = NULL;
	ipdpBestTime = NULL;
	ipdpBest = NULL;
	ipdpCurrentTime = NULL;
	ipdpCurrent = NULL;
	[super dealloc];
}

@end
