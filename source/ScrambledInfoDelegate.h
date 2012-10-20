
#import <UIKit/UIKit.h>

@protocol ScrambledInfoDelegate

@optional
- (void) infoWantsToClose;
- (void) infoWantsToResetBestTime;
- (void) infoWantsToStartNewGame;

@end
