
#import <UIKit/UIKit.h>
#import "BoardModel.h"
#import "ScrambledSounds.h"

@interface TileView : UIImageView {
	int tileID;
	Boolean canMoveVertical;
	CGPoint _stp;
	CGPoint _start;
	BoardModel * boardModel;
	UIImageView * bezel;
}

@property (nonatomic) int tileID;
@property (nonatomic,retain) BoardModel * boardModel;

- (void) setSize:(CGSize) size;
- (Boolean) restrictMovement:(CGPoint) ctp;

@end
