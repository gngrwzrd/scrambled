
#import <UIKit/UIKit.h>

@class ScrambledIpad;
@class ScrambledIphone;

@interface ScrambledUniversalAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow * window;
}

@property(nonatomic,retain) IBOutlet UIWindow * window;

@end
