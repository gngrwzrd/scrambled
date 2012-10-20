
#import <UIKit/UIKit.h>
#import "ScrambledInfoDelegate.h"
#import "JSON.h"
#import "ScrambledAdButton.h"
#import "SMAd.h"
#import "SMAdIPrivate.h"

@interface ScrambledInfo : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate> {
	Boolean shouldReset;
	Boolean isphone;
	NSObject <ScrambledInfoDelegate> * _delegate;
	UITextField * _fcid;
	UITextField * _preview;
	UITextField * _placement;
	UITextField * _area;
	NSMutableData * infodata;
	NSURLConnection * infoconn;
	NSDictionary * infodict;
	NSMutableArray * _defbuttons;
	UIView * _defbuttonContainer;
	UIView * _puzzleImagesContainer;
	UITableView * _tableView;
	UIImageView * _puzzleImageBorder;
	UITextField * _bannerField;
	UITextField * _interstitialField;
	NSUserDefaults * defaults;
	UIImageView * _bg;
}

@property (nonatomic,assign) NSObject <ScrambledInfoDelegate> * delegate;
@property (nonatomic,retain) IBOutlet UIView * defbuttonContainer;
@property (nonatomic,retain) IBOutlet UIView * puzzleImagesContainer;
@property (nonatomic,retain) IBOutlet UIImageView * puzzleImageBorder;
@property (nonatomic,retain) IBOutlet UIImageView * bg;
@property (nonatomic,retain) IBOutlet UITableView * tableView;
@property (nonatomic,retain) IBOutlet UITextField * fcid;
@property (nonatomic,retain) IBOutlet UITextField * preview;
@property (nonatomic,retain) IBOutlet UITextField * placement;
@property (nonatomic,retain) IBOutlet UITextField * area;

- (IBAction) onBanner;
- (IBAction) onInterstitial;
- (IBAction) onCancel;
- (IBAction) onClear;
- (IBAction) onPuzzleButton:(id) sender;
- (IBAction) onReset;
- (IBAction) onClose;
- (void) didShow;
- (void) didHide;
- (void) loadInfo;
- (void) prepareButtons;
- (void) showButtons;

@end
