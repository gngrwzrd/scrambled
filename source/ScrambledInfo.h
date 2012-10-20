
#import <UIKit/UIKit.h>
//#import "SMAd.h"
//#import "SMAdIPrivate.h"
#import "ScrambledInfoDelegate.h"
#import "ScrambledInfoAdSelector.h"

@interface ScrambledInfo : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, ScrambledInfoAdSelectorDelegate> {
	Boolean isphone;
	NSUserDefaults * defaults;
	NSObject <ScrambledInfoDelegate> * _delegate;
	UIView * _puzzleImagesContainer;
	UIImageView * _puzzleOutline;
	UITableView * _tableview;
	UILabel * _bannerLabelField;
	UILabel * _interLabelField;
	UITextField * _bannerField;
	UITextField * _interstitialField;
	UILabel * _bannerIdLabel;
	UILabel * _interIdLabel;
	UIButton * p1b;
	UIButton * p2b;
	UIButton * p3b;
	UIButton * p4b;
	UIButton * p5b;
	NSMutableDictionary * lastSelectedItem;
	NSMutableDictionary * load;
	id lastSelector;
	ScrambledInfoAdSelector * bannerAdSel;
	ScrambledInfoAdSelector * interAdSel;
	NSObject <ScrambledInfoAdSelectorDelegate> * _scrambledAdInfoSelectorDelegate;
}

@property (nonatomic,assign) IBOutlet NSObject <ScrambledInfoDelegate> * delegate;
@property (nonatomic,retain) IBOutlet UITableView * tableview;
@property (nonatomic,retain) IBOutlet UIImageView * puzzleOutline;
@property (nonatomic,retain) IBOutlet UIView * puzzleImagesContainer;
@property (nonatomic,retain) IBOutlet UIButton * p1b;
@property (nonatomic,retain) IBOutlet UIButton * p2b;
@property (nonatomic,retain) IBOutlet UIButton * p3b;
@property (nonatomic,retain) IBOutlet UIButton * p4b;
@property (nonatomic,retain) IBOutlet UIButton * p5b;

- (IBAction) onClose;
- (IBAction) onPuzzleButton:(id) sender;
- (void) resetHighScore;
- (void) setupResetCell:(UITableViewCell *) cell;
- (void) setupPuzzleImages:(UITableViewCell *) cell;
- (void) setupBannerRow0:(UITableViewCell *) cell;
- (void) setupBannerRow1:(UITableViewCell *) cell;
- (void) setupInterRow0:(UITableViewCell *) cell;
- (void) setupInterRow1:(UITableViewCell *) cell;
- (void) setupVersionCell:(UITableViewCell *) cell;
- (void) setupIDKCell:(UITableViewCell *) cell;
- (void) setScrambledInfoAdSelectDelegate:(NSObject <ScrambledInfoAdSelectorDelegate> *) delegate;

@end
