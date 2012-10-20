
#import "BoardModel.h"

@implementation BoardModel

- (id) init {
	if(!(self = [super init])) return nil;
	[self setSolved];
	[self computeBoarderTiles];
	return self;
}

- (void) computeBoarderTiles {
	//0 | 1 | 2 | 3
	//-------------
	//4 | 5 | 6 | 7
	//-------------
	//8 | 9 |10 |11
	//-------------
	//12|13 |14 |15
    _borderTiles[0][0] = 1;
	_borderTiles[0][1] = 4;
	_borderTiles[0][2] = -1;
    _borderTiles[1][0] = 0;
	_borderTiles[1][1] = 2;
	_borderTiles[1][2] = 5;
	_borderTiles[1][3] = -1;
    _borderTiles[2][0] = 1;
	_borderTiles[2][1] = 3;
	_borderTiles[2][2] = 6;
	_borderTiles[2][3] = -1;
    _borderTiles[3][0] = 2;
	_borderTiles[3][1] = 7;
	_borderTiles[3][2] = -1;    
    _borderTiles[4][0] = 0;
	_borderTiles[4][1] = 5;
	_borderTiles[4][2] = 8;
	_borderTiles[4][3] = -1;
    _borderTiles[5][0] = 1;
	_borderTiles[5][1] = 4;
	_borderTiles[5][2] = 6;
	_borderTiles[5][3] = 9;
    _borderTiles[6][0] = 2;
	_borderTiles[6][1] = 5;
	_borderTiles[6][2] = 7;
	_borderTiles[6][3] = 10;
    _borderTiles[7][0] = 3;
	_borderTiles[7][1] = 6;
	_borderTiles[7][2] = 11;
	_borderTiles[7][3] = -1; 
    _borderTiles[8][0] = 4;
	_borderTiles[8][1] = 9;
	_borderTiles[8][2] = 12;
	_borderTiles[8][3] = -1;
    _borderTiles[9][0] = 5;
	_borderTiles[9][1] = 8;
	_borderTiles[9][2] = 10;
	_borderTiles[9][3] = 13;
    _borderTiles[10][0] = 6;
	_borderTiles[10][1] = 9;
	_borderTiles[10][2] = 11;
	_borderTiles[10][3] = 14;
    _borderTiles[11][0] = 7;
	_borderTiles[11][1] = 10;
	_borderTiles[11][2] = 15;
	_borderTiles[11][3] = -1;
    _borderTiles[12][0] = 8;
	_borderTiles[12][1] = 13;
	_borderTiles[12][2] = -1;
    _borderTiles[13][0] = 9;
	_borderTiles[13][1] = 12;
	_borderTiles[13][2] = 14;
	_borderTiles[13][3] = -1;
    _borderTiles[14][0] = 10;
	_borderTiles[14][1] = 13;
	_borderTiles[14][2] = 15;
	_borderTiles[14][3] = -1;
    _borderTiles[15][0] = 11;
	_borderTiles[15][1] = 14;
	_borderTiles[15][2] = -1;
}

- (BOOL) isSolved {
	for(int idx = 0; idx < (BOARD_SIZE * BOARD_SIZE) - 1; idx++) {
		if(_tileMap[idx] != idx) return NO;
	}
	return YES;
}

- (void) setSolved {
	for(int idx = 0; idx < BOARD_SIZE * BOARD_SIZE - 1; idx++) _tileMap[idx] = idx;
	_tileMap[ BOARD_SIZE * BOARD_SIZE - 1 ] = -1;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"boardModelChange" object:self];
}

- (void) scramble {
	int randIdx;
	int tmp;
	for(int idx = 0; idx < BOARD_SIZE * BOARD_SIZE; idx++) {
		randIdx = random() % ((BOARD_SIZE * BOARD_SIZE)-idx);
		tmp = _tileMap[idx];
		_tileMap[idx] = _tileMap[randIdx];
		_tileMap[randIdx] = tmp;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"boardModelChange" object:self];
}

- (int) getTileIDFromGridIndex:(int) index {
    return _tileMap[index];
}

- (int) getHoleIndex {
	int idx = 0;
	for(;idx<BOARD_SIZE*BOARD_SIZE;idx++) {
		if(_tileMap[ idx ]==-1) break;
	}
	return idx;
}

- (int) gridIndexFromTileID:(int) tileID {
	int idx = 0;
	for(;idx<BOARD_SIZE*BOARD_SIZE;idx++) {
		if(_tileMap[idx] == tileID) break;
	}
	return idx;
}

- (BOOL) tileCanMoveVertical:(int) tileID {
	int gridIdx = [self gridIndexFromTileID:tileID];
	int holeIdx = [self getHoleIndex];
	//If the index we're in is moving the a hole index
	//even->even or odd->odd T<-->B
	//even->odd or odd->even L<-->R
	if((gridIdx & 1) ^ (holeIdx & 1)) return NO;
    return YES;
}

- (const int *) getBorderTileIndicesAt:(int) index {
	return _borderTiles[index];
}

-(void) moveTile:(int) tileId From:(int) srcIdx To:(int) dstIdx {
	int temp = _tileMap[srcIdx];
	_tileMap[srcIdx] = _tileMap[ dstIdx ];
	_tileMap[dstIdx] = temp;
}

- (BOOL) canMoveUp:(int) tileID {
	int gridIdx = [self gridIndexFromTileID:tileID];
	int aboveIdx = gridIdx - BOARD_SIZE;
	if(aboveIdx < 0) return NO;
	if([self getTileIDFromGridIndex:aboveIdx] != -1) return NO;
    return YES;
}

- (BOOL) canMoveDown:(int) tileID {
	int gridIdx = [self gridIndexFromTileID:tileID];
	int belowIdx = gridIdx + BOARD_SIZE;
	if(belowIdx > (BOARD_SIZE * BOARD_SIZE)) return NO;
	if([self getTileIDFromGridIndex:belowIdx] != -1) return NO;
    return YES;
}

- (BOOL) canMoveLeft:(int) tileID {
	int gridIdx = [self gridIndexFromTileID:tileID];
	int leftIdx = gridIdx - 1;
	if((gridIdx % BOARD_SIZE) == 0) return NO;
	if([self getTileIDFromGridIndex:leftIdx] != -1) return NO;
    return YES;
}

- (BOOL) canMoveRight:(int) tileID {
	int gridIdx = [self gridIndexFromTileID:tileID];
	int rightIdx = gridIdx + 1;
	if((gridIdx % BOARD_SIZE) == (BOARD_SIZE - 1)) return NO;
	if([self getTileIDFromGridIndex:rightIdx] != -1) return NO;
	return YES;
}

- (const int *) getTileArray {
	return _tileMap;
}

- (void) setTilePositions:(const int *) posArr {
	for(int idx = 0; idx < BOARD_SIZE * BOARD_SIZE; idx++) _tileMap[idx] = posArr[idx];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"boardModelChange" object:self];
}

- (void) dealloc {
	[super dealloc];
}

@end
