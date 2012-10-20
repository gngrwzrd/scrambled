
#import <UIKit/UIKit.h>

@class ScrambledInfoAdSelector;

@protocol ScrambledInfoAdSelectorDelegate
- (void) adInfoSelector:(ScrambledInfoAdSelector *) selector didChooseItem:(NSDictionary *) item;

@end
