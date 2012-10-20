
#import "ScrambledAdButton.h"

@implementation ScrambledAdButton
@synthesize fcid = _fcid;
@synthesize placement = _placement;
@synthesize preview = _preview;

- (void) dealloc {
	[_fcid release];
	[_placement release];
	[_preview release];
	_fcid = NULL;
	_preview = NULL;
	_placement = NULL;
	[super dealloc];
}

@end
