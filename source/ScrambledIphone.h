
#import <UIKit/UIKit.h>
#import "ScrambledGame.h"

@interface ScrambledIphone : ScrambledGame {
	UILabel * ippCurrent;
	UILabel * ippCurrentTime;
	UILabel * ippBest;
	UILabel * ippBestTime;
	UILabel * iplCurrent;
	UILabel * iplCurrentTime;
	UILabel * iplBest;
	UILabel * iplBestTime;
	UIView * iPhonePortraitView;
	UIView * iPhoneLandscapeView;
}

@property (nonatomic,retain) IBOutlet UIView * iPhonePortraitView;
@property (nonatomic,retain) IBOutlet UIView * iPhoneLandscapeView;
@property (nonatomic,retain) IBOutlet UILabel * ippCurrent;
@property (nonatomic,retain) IBOutlet UILabel * ippCurrentTime;
@property (nonatomic,retain) IBOutlet UILabel * ippBest;
@property (nonatomic,retain) IBOutlet UILabel * ippBestTime;
@property (nonatomic,retain) IBOutlet UILabel * iplCurrent;
@property (nonatomic,retain) IBOutlet UILabel * iplCurrentTime;
@property (nonatomic,retain) IBOutlet UILabel * iplBest;
@property (nonatomic,retain) IBOutlet UILabel * iplBestTime;

@end
