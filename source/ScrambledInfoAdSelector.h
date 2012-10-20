
#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ScrambledInfoAdSelectorDelegate.h"

enum adtype {
	adtype_banner       = 0,
	adtype_interstitial = 1,
};
typedef enum adtype adtype;

@interface ScrambledInfoAdSelector : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	adtype type;
	Boolean isphone;
	Boolean loaded;
	Boolean showAfterLoad;
	UITableView * _tableview;
	NSMutableData * infodata;
	NSURLConnection * infoconn;
	NSMutableDictionary * infodict;
	NSArray * items;
	NSObject <ScrambledInfoAdSelectorDelegate> * _delegate;
	UITableViewCell * checkedcell;
}

@property (nonatomic,assign) NSObject <ScrambledInfoAdSelectorDelegate> * delegate;
@property (nonatomic,retain) IBOutlet UITableView * tableview;
@property (nonatomic,assign) adtype type;

- (void) loadInfo;
- (void) loadTableData;
- (void) setupRandomCell:(UITableViewCell *) cell withItem:(NSDictionary *) item;
- (void) setupDirectCell:(UITableViewCell *) cell withItem:(NSDictionary *) item;
- (void) setupInputCell:(UITableViewCell *) cell withItem:(NSDictionary *) item;
- (void) setupLocalCell:(UITableViewCell *) cell withItem:(NSDictionary *) item;

@end
