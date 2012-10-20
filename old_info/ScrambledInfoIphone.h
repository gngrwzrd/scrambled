
#import <UIKit/UIKit.h>
#import "SMAd.h"
#import "SMAdIPrivate.h"
#import "ScrambledInfoDelegate.h"
#import "ScrambledAdButton.h"
#import "JSON.h"

@interface ScrambledInfoIphone : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate> {
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
	UIButton * p1b;
	UIButton * p2b;
	UIButton * p3b;
	UIButton * p4b;
	UIButton * p5b;
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
@property (nonatomic,retain) IBOutlet UIButton * p1b;
@property (nonatomic,retain) IBOutlet UIButton * p2b;
@property (nonatomic,retain) IBOutlet UIButton * p3b;
@property (nonatomic,retain) IBOutlet UIButton * p4b;
@property (nonatomic,retain) IBOutlet UIButton * p5b;

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
- (void) setupResetCell:(UITableViewCell *) cell;
- (void) setupPuzzleImages:(UITableViewCell *) cell;
- (void) setupBannerRow0:(UITableViewCell *) cell;
- (void) setupBannerRow1:(UITableViewCell *) cell;
- (void) setupInterRow0:(UITableViewCell *) cell;
- (void) setupInterRow1:(UITableViewCell *) cell;
- (void) setupVersionCell:(UITableViewCell *) cell;
- (void) setupIDKCell:(UITableViewCell *) cell;
- (void) resetHighScore;

@end
