
#import "ScrambledUniversalAppDelegate.h"
#import "ScrambledIphone.h"
#import "ScrambledIpad.h"

@implementation ScrambledUniversalAppDelegate
@synthesize window;

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
	UIDevice * device = [UIDevice currentDevice];
	UIViewController * vc = NULL;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		if([device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			vc = [[ScrambledIpad alloc] initWithNibName:@"ScrambledIpad" bundle:nil];
		} else {
			vc = [[ScrambledIphone alloc] initWithNibName:@"ScrambledIphone" bundle:nil];
		}
	} else {
		vc = [[ScrambledIphone alloc] initWithNibName:@"ScrambledIphone" bundle:nil];
	}
#else
	vc = [[ScrambledIphone alloc] initWithNibName:@"ScrambledIphone" bundle:nil];
#endif
	self.window.rootViewController = vc;
	[[self window] addSubview:[vc view]];
	[self.window makeKeyAndVisible];
	[vc release];
	return YES;
}

- (void) dealloc {
	[window release];
	[super dealloc];
}

@end
