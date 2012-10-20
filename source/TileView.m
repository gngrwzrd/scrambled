
#import "TileView.h"
#import "BoardModel.h"

@implementation TileView
@synthesize boardModel;
@synthesize tileID;

- (id) initWithImage:(UIImage *) image {
	if(!(self = [super initWithImage:image])) return nil;
	bezel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ip_cellshade.png"]];
	[self addSubview:bezel];
	[bezel setOpaque:NO];
	[bezel release];
	[self setUserInteractionEnabled:TRUE];
	return self;
}

- (void) setSize:(CGSize) size {
	[bezel setFrame:CGRectMake(0,0,size.width,size.height)];
	[self setBounds:CGRectMake(0,0,size.width,size.height)];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"tileTouched" object:self];
	UITouch * touch = [touches anyObject];
	_stp = [touch locationInView:self];
	_stp = [self convertPoint:_stp toView:self.superview];
	canMoveVertical = [boardModel tileCanMoveVertical:self.tileID];
	if(canMoveVertical) _stp.x = self.center.x;
	else _stp.y = self.center.y;
	_start = self.center;
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [[event allTouches] anyObject];
	CGPoint ctp = [touch locationInView:self];
	if(!CGRectContainsPoint(self.bounds,ctp)) return;
	ctp = [self convertPoint:ctp toView:self.superview];
    if(canMoveVertical) ctp.x = _stp.x;
	else ctp.y = _stp.y;
	if([self restrictMovement:ctp]) return;
	self.center = ctp;
}

- (Boolean) restrictMovement:(CGPoint) ctp {
	CGRect parent = self.superview.bounds;
	float deltaW = parent.size.width / 4.0f;
	float deltaH = parent.size.height / 4.0f;
	if(canMoveVertical) {
		if(_start.y > ctp.y) {
			if(![boardModel canMoveUp:tileID] ) return YES;
		} else {
			if(![boardModel canMoveDown:tileID]) return YES;
		}
	} else {
		if(_start.x < ctp.x) {
			if(![boardModel canMoveRight:tileID]) return YES;
		} else {
			if(![boardModel canMoveLeft:tileID]) return YES;
		}
	}
	if(fabsf( _start.x - ctp.x ) > deltaW) return YES;
	else if(fabsf( _start.y - ctp.y ) > deltaH) return YES;
	return NO;
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"tileReleased" object:self];
}

- (void) dealloc {
	[super dealloc];
}

@end
