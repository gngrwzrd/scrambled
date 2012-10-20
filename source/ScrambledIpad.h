
#import <UIKit/UIKit.h>
#import "ScrambledGame.h"

@interface ScrambledIpad : ScrambledGame {
	UILabel * ipdpCurrent;
	UILabel * ipdpCurrentTime;
	UILabel * ipdpBest;
	UILabel * ipdpBestTime;
	UILabel * ipdlCurrent;
	UILabel * ipdlCurrentTime;
	UILabel * ipdlBest;
	UILabel * ipdlBestTime;
	UIView * iPadPortraitView;
	UIView * iPadLandscapeView;
}

@property (nonatomic,retain) IBOutlet UIView * iPadPortraitView;
@property (nonatomic,retain) IBOutlet UIView * iPadLandscapeView;
@property (nonatomic,retain) IBOutlet UILabel * ipdpCurrent;
@property (nonatomic,retain) IBOutlet UILabel * ipdpCurrentTime;
@property (nonatomic,retain) IBOutlet UILabel * ipdpBest;
@property (nonatomic,retain) IBOutlet UILabel * ipdpBestTime;
@property (nonatomic,retain) IBOutlet UILabel * ipdlCurrent;
@property (nonatomic,retain) IBOutlet UILabel * ipdlCurrentTime;
@property (nonatomic,retain) IBOutlet UILabel * ipdlBest;
@property (nonatomic,retain) IBOutlet UILabel * ipdlBestTime;

@end
