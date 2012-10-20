
#import "BoardView.h"

@implementation BoardView
@synthesize boardModel = _boardModel;
@synthesize canWin;
@synthesize isRunning;

- (void) shuffle {
	[_boardModel scramble];
	[ScrambledSounds shuffle];
}

- (void) reset {
	[_boardModel setSolved];
}

- (void) lockAllTiles {
	for(TileView * tv in _displayList) {
		[tv setUserInteractionEnabled:FALSE];
	}
}

- (void) unlockAllTiles {
	for(TileView * tv in _displayList) {
		[tv setUserInteractionEnabled:TRUE];
	}
}

- (Boolean) isSolved {
	return [_boardModel isSolved];
}

- (void) destroyOldBoard {
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:@"boardModelChange" object:_boardModel];
	[self removeAllChildren];
	[_bgImage release];
	[_displayList release];
	_bgImage = NULL;
	_displayList = NULL;
}

- (void) constructBoardWithImage:(UIImage *) image {
	[self destroyOldBoard];
	CGRect f = [self frame];
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	if(!_displayList) _displayList = [[NSMutableArray alloc] initWithCapacity:(BOARD_SIZE*BOARD_SIZE)];
	if(_bgImage) [_bgImage release];
	_bgImage = [image retain];
	if(!_boardModel) _boardModel = [[BoardModel alloc] init];
	if(backgroundImage) {
		[backgroundImage setImage:nil];
		[backgroundImage removeFromSuperview];
		[backgroundImage release];
	}
	backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,f.size.width,f.size.height)];
	[self addSubview:backgroundImage];
	[self setBackgroundImage:_bgImage];
	[self constructBoard];
	[center addObserver:self selector:@selector(onBoardModelChange:) name:@"boardModelChange" object:_boardModel];
}

- (void) onBoardModelChange:(NSNotification *) notification {
	[self constructBoard];
}

- (void) constructBoard {
	TileView * tileView = NULL;
	if(!_center) _center = [NSNotificationCenter defaultCenter];
	NSUInteger capacity = BOARD_SIZE*BOARD_SIZE;
	NSUInteger capacity_m1 = BOARD_SIZE*BOARD_SIZE-1;
	NSMutableArray * images = [self makeTileImages:_bgImage];
	NSMutableArray * tileArr = [[NSMutableArray alloc] initWithCapacity:capacity_m1];
	CGRect f = [self frame];
	[self removeAllChildren];
	for(int idx = 0; idx < capacity_m1; idx++) {
		tileView = [[TileView alloc] initWithImage:[images objectAtIndex:idx]];
		[_center addObserver:self selector:@selector(onTileReleased:) name:@"tileReleased" object:tileView];
		[tileView setBoardModel:_boardModel];
		[tileView setTileID:idx];
		[tileView setSize:CGSizeMake(f.size.width/(float)BOARD_SIZE,f.size.height/(float)BOARD_SIZE)];
		[tileArr insertObject:tileView atIndex:idx];
		[tileView release];
	}
	int tileID;
	for(int destIdx = 0; destIdx < capacity; destIdx++) {
		tileID = [_boardModel getTileIDFromGridIndex:destIdx];
		if(tileID == -1) continue;
		[self addTile:[tileArr objectAtIndex:tileID] at:destIdx];
	}
    [tileArr release];
	if(!isRunning) [self lockAllTiles];
}

- (NSMutableArray *) makeTileImages:(UIImage *) image {
	NSUInteger capacity_m1 = BOARD_SIZE * BOARD_SIZE-1;
	NSMutableArray * imgArray = [[NSMutableArray alloc] initWithCapacity:capacity_m1];
	CGImageRef iRef = [image CGImage];
	float cWidth = image.size.width / (float)BOARD_SIZE;
	float cHeight = image.size.height / (float)BOARD_SIZE;
	CGRect clipRect = {0,0,cWidth,cHeight};
	UIImage * clip = NULL;
	for(int row = 0, idx = 0; row < BOARD_SIZE; row++) {
		for(int col = 0; col < BOARD_SIZE; col++, idx++) {
			if(idx == capacity_m1) break;
			clipRect.origin = CGPointMake(col*cWidth,row*cHeight);
			CGImageRef cRef = CGImageCreateWithImageInRect(iRef,clipRect);
			clip = [UIImage imageWithCGImage:cRef];
			[imgArray insertObject:clip atIndex:idx];
		}
	}
	return [imgArray autorelease];
}

- (void) removeAllChildren {
	[_displayList makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_displayList release];
	_displayList = NULL;
}

- (void) onTileReleased:(NSNotification *) notification {
	if(!canWin) return;
	TileView * tile = [notification object];
	int tID = tile.tileID;
	int pos = [_boardModel gridIndexFromTileID:tID];
	int newPos = [self gridIndexFromPos:tile];
	if(pos != newPos) [_boardModel moveTile:tID From:pos To:newPos];
	CGPoint srcPoint = tile.center;
	CGPoint dstPoint = [self convertIdxToPoint:newPos];
	float dist = fabsf( srcPoint.x - dstPoint.x + srcPoint.y - dstPoint.y );
	float duration = 1.0f / (70.0 / dist);
	
	//Animate the tile into place if it's not already there
	[UIView beginAnimations:nil context:NULL];
	if(pos != newPos) [UIView setAnimationDelegate:self];
	else [UIView setAnimationDelegate:nil];
	[UIView setAnimationDuration:duration];
	tile.center = dstPoint;
	[UIView commitAnimations];
	
	if([_boardModel isSolved]) {
		[_center postNotificationName:@"wonGame" object:self];
	} else {
		[ScrambledSounds tilemove];
		[_center postNotificationName:@"tileReleased" object:self];
	}
}

- (void) setBackgroundImage:(UIImage *) image {
	UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width,self.bounds.size.height));
	CGContextRef ref = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(ref,0.0f,0.0f,0.0f,1.0f);
	UIRectFill(self.bounds);
	[image drawInRect:self.bounds blendMode:kCGBlendModeLuminosity alpha:0.25f];
	UIImage * bg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	backgroundImage.image = bg;
}

- (void) addTile:(TileView *) tile at:(int) idx {
	if(!_displayList) _displayList = [[NSMutableArray alloc] initWithCapacity:(BOARD_SIZE * BOARD_SIZE)];
	[_displayList addObject:tile];
	UIView * tileView = (UIView *)tile;
	CGPoint center = [self convertIdxToPoint:idx];
	tileView.center = center;
	[self addSubview:tileView];
}

- (CGPoint) convertIdxToPoint:(int) idx {
	CGRect rect = self.bounds;
	int tW = rect.size.width / BOARD_SIZE;
	int tH = rect.size.height / BOARD_SIZE;
	int cIdx = idx % BOARD_SIZE;
	int rIdx = idx / BOARD_SIZE;
	CGPoint center = CGPointMake(tW*cIdx+(tW/2.0f),tH*rIdx+(tH/2.0f));
	return center;
}

- (int) gridIndexFromPos:(TileView *) tile {
	CGRect board = [self bounds];
	int bWidth = board.size.width;
	int bHeight = board.size.height;
	int tW = bWidth / BOARD_SIZE;
	int tH = bHeight / BOARD_SIZE;
	int row = tile.center.y / tH;
	int col = tile.center.x / tW;    
	return row * BOARD_SIZE + col;
}

- (void) dealloc {
	[_boardModel release];
	[super dealloc];
}

@end
