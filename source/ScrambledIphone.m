
#import "ScrambledIphone.h"

@implementation ScrambledIphone
@synthesize iPhonePortraitView;
@synthesize iPhoneLandscapeView;
@synthesize ippCurrentTime;
@synthesize ippCurrent;
@synthesize ippBest;
@synthesize ippBestTime;
@synthesize iplCurrentTime;
@synthesize iplCurrent;
@synthesize iplBest;
@synthesize iplBestTime;

- (void) viewDidLoad {
	[super viewDidLoad];
	[ippBestTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[ippBest setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[ippCurrentTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[ippCurrent setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[iplBestTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[iplBest setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[iplCurrentTime setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	[iplCurrent setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:22.0]];
	if(isportrait) {
		[container addSubview:iPhonePortraitView];
		currentView = iPhonePortraitView;
	} else if(!isportrait) {
		[container addSubview:iPhoneLandscapeView];
		currentView = iPhoneLandscapeView;
	}
	[self defaultBoard];
}

- (void) infoWantsToResetSMAD {
}

- (void) infoWantsToResetBestTime {
	[super infoWantsToResetBestTime];
	[iplBestTime setText:@"00:00"];
	[ippBestTime setText:@"00:00"];
}

- (void) gameDidTick {
	if([ippCurrentTime superview]) [ippCurrentTime setText:timeDisplay];
	if([iplCurrentTime superview]) [iplCurrentTime setText:timeDisplay];
}

- (void) updateDefaults {
	[super updateDefaults];
	[ippBestTime setText:bestDisplay];
	[iplBestTime setText:bestDisplay];
}

- (void) updateBest {
	[super updateBest];
	[ippBestTime setText:bestDisplay];
	[iplBestTime setText:bestDisplay];
}

- (void) wonGame {
	[super wonGame];
	[self resetCurrentTime];
}

- (void) resetCurrentTime {
	[ippCurrentTime setText:@"00:00"];
	[iplCurrentTime setText:@"00:00"];
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
	//CGRect frame;
	//UIDeviceOrientation current = orientation;
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	if(toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		[currentView removeFromSuperview];
		[container addSubview:iPhonePortraitView];
		currentView = iPhonePortraitView;
	} else if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
		[currentView removeFromSuperview];
		[container addSubview:iPhonePortraitView];
		currentView = iPhonePortraitView;
	} else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
		[currentView removeFromSuperview];
		[container addSubview:iPhoneLandscapeView];
		currentView = iPhoneLandscapeView;
	}
	[self invalidateBoardView];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
	//CGRect frame;
	if(orientation == UIDeviceOrientationPortraitUpsideDown) {
	} else if(UIDeviceOrientationIsPortrait(orientation)) {
	} else if(UIDeviceOrientationIsLandscape(orientation)) {
	}
}

- (void) dealloc {
	[super dealloc];
}

@end
