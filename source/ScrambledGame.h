
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BoardView.h"
#import "ScrambledSounds.h"
#import "ScrambledInfo.h"
#import "ScrambledInfoDelegate.h"
#import "JSON.h"

@interface ScrambledGame : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate,
MFMailComposeViewControllerDelegate,UIAccelerometerDelegate,
ScrambledInfoDelegate,ScrambledInfoAdSelectorDelegate>
{
	Boolean paused;
	Boolean isportrait;
	Boolean isphone;
	Boolean showInterstitial;
	Boolean isShaking;
	Boolean canShake;
	NSUInteger time;
	NSUInteger hours;
	NSUInteger mins;
	NSUInteger secs;
	UIDeviceOrientation orientation;
	NSTimer * timer;
	NSString * timeDisplay;
	NSString * bestDisplay;
	UIAccelerometer * accel;
	MFMailComposeViewController * mail;
	NSNotificationCenter * _nfcenter;
	NSMutableDictionary * config;
	NSMutableDictionary * loadinfo;
	NSUserDefaults * defaults;
	UIAcceleration * last;
	UIDevice * device;
	UIView * container;
	UIView * currentView;
	UIImage * pickedImage;
	UIButton * start;
	UIImagePickerController * picker;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	UIPopoverController * popover;
#else
	id popover;
#endif
	UIAlertView * newGameAlert;
	UIAlertView * winAlert;
	ScrambledInfo * info;
	BoardView * pboard;
	BoardView * lboard;
}

@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet BoardView * pboard;
@property (nonatomic,retain) IBOutlet BoardView * lboard;
@property (nonatomic,retain) IBOutlet ScrambledInfo * info;

- (IBAction) onNewGame;
- (IBAction) onChallange;
- (IBAction) onChoosePhoto;
- (IBAction) onInfo;
- (void) newGame;
- (void) defaultBoard;
- (void) invalidateBoardView;
- (void) showStartButton;
- (void) registerAppNotifications;
- (void) updateBest;
- (UIImage *) scaleAndCrop:(UIImage *) image;

//override these
- (void) gameDidTick;
- (void) didSelectPicture;
- (void) updateDefaults;
- (void) wonGame;
- (void) resetCurrentTime;

@end
