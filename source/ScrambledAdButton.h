
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScrambledAdButton : UIButton {
	NSString * _fcid;
	NSString * _placement;
	NSString * _preview;
}

@property (nonatomic,copy) NSString * fcid;
@property (nonatomic,copy) NSString * preview;
@property (nonatomic,copy) NSString * placement;

@end
