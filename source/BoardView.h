
#import <UIKit/UIKit.h>
#import "defs.h"
#import "BoardModel.h"
#import "TileView.h"
#import "ScrambledSounds.h"

@interface BoardView : UIView {
	Boolean canWin;
	Boolean isRunning;
	NSMutableArray * _displayList;
	UIImageView * backgroundImage;
	UIImage * _bgImage;
	NSNotificationCenter * _center;
	BoardModel * _boardModel;
}

@property (nonatomic,assign) Boolean canWin;
@property (nonatomic,retain) BoardModel * boardModel;
@property (nonatomic,assign) Boolean isRunning;

- (void) lockAllTiles;
- (void) unlockAllTiles;
- (void) removeAllChildren;
- (void) constructBoard;
- (void) constructBoardWithImage:(UIImage *) image;
- (void) addTile:(TileView *) tile at:(int) idx;
- (void) setBackgroundImage:(UIImage *) image;
- (void) shuffle;
- (void) reset;
- (int) gridIndexFromPos:(TileView *) tile;
- (Boolean) isSolved;
- (CGPoint) convertIdxToPoint:(int) idx;
- (NSMutableArray *) makeTileImages:(UIImage *) image;

@end
