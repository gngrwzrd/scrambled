
#include <math.h>
#import <UIKit/UIKit.h>

#define BOARD_SIZE 4
#define HOLE_ID ((BOARD_SIZE*BOARD_SIZE)-1)

@interface BoardModel : NSObject {
	int _tileMap[BOARD_SIZE*BOARD_SIZE];//contains tile ID of each piece
	int _borderTiles[BOARD_SIZE*BOARD_SIZE][4];
}

- (void) scramble;
- (void) setSolved;
- (void) computeBoarderTiles;
- (void) setTilePositions:(const int *) posArr;
- (void) moveTile:(int) tileId From:(int) index To:(int) index;
- (int) getHoleIndex;
- (int) gridIndexFromTileID:(int) tileID;
- (int) getTileIDFromGridIndex:(int) index;
- (const int *) getTileArray;
- (const int *) getBorderTileIndicesAt:(int) index;
- (BOOL) isSolved;
- (BOOL) tileCanMoveVertical:(int) tileID;
- (BOOL) canMoveUp:(int) tileID;
- (BOOL) canMoveDown:(int) tileID;
- (BOOL) canMoveLeft:(int) tileID;
- (BOOL) canMoveRight:(int) tileID;

@end

//-(void) removeTiles;