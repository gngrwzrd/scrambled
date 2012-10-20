
#import "ScrambledGame.h"

bool
__accelerometerIsShaking__(UIAcceleration * last, UIAcceleration * current,
double threshold)
{
	double deltaX = fabs(last.x - current.x);
	double deltaY = fabs(last.y - current.y);
	double deltaZ = fabs(last.z - current.z);
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

@implementation ScrambledGame
@synthesize container;
@synthesize pboard;
@synthesize lboard;
@synthesize info;

- (void) viewDidLoad {
	[super viewDidLoad];
	time = 0;
	paused = true;
	isportrait = true;
	canShake = true;
	orientation = UIDeviceOrientationPortrait;
	device = [UIDevice currentDevice];
	accel = [UIAccelerometer sharedAccelerometer];
	_nfcenter = [NSNotificationCenter defaultCenter];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
		isphone = !([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	} else isphone = true;
#else
	isphone = true;
#endif
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick) userInfo:nil repeats:true];
	[info setScrambledInfoAdSelectDelegate:self];
	[info setDelegate:self];
	[accel setDelegate:self];
	[self registerAppNotifications];
	[self updateDefaults];
}

- (void) updateDefaults {
	defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary * def = [NSMutableDictionary dictionary];
	[def setObject:@"00:00" forKey:@"Scrambled:BestTime"];
	[def setObject:@"ip_puzzle1.jpg" forKey:@"ip_puzzle"];
	[def setObject:@"ipd_puzzle1.jpg" forKey:@"ipd_puzzle"];
	[defaults registerDefaults:def];
	bestDisplay = [[defaults objectForKey:@"Scrambled:BestTime"] copy];
}

- (void) registerAppNotifications {
	[_nfcenter addObserver:self selector:@selector(onAppBG) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
	[_nfcenter addObserver:self selector:@selector(onAppFG) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
}

- (void) defaultBoard {
	UIImage * puzzle = NULL;
	if(isphone) {
		puzzle = [UIImage imageNamed:[defaults objectForKey:@"ip_puzzle"]];
		if(!pboard) pboard = [[BoardView alloc] initWithFrame:CGRectMake(23,88,276,276)];
		if(!lboard) lboard = [[BoardView alloc] initWithFrame:CGRectMake(182,30,252,252)];
	} else {
		puzzle = [UIImage imageNamed:[defaults objectForKey:@"ipd_puzzle"]];
		if(!pboard) pboard = [[BoardView alloc] initWithFrame:CGRectMake(73,178,628,628)];
		if(!lboard) lboard = [[BoardView alloc] initWithFrame:CGRectMake(346,72,576,576)];
	}
	[_nfcenter addObserver:self selector:@selector(wonGame) name:@"wonGame" object:pboard];
	[_nfcenter addObserver:self selector:@selector(wonGame) name:@"wonGame" object:lboard];
	[pboard constructBoardWithImage:puzzle];
	[lboard constructBoardWithImage:puzzle];
	[pboard lockAllTiles];
	[lboard lockAllTiles];
	[pboard setCanWin:false];
	[lboard setCanWin:false];
	if(isportrait) [container addSubview:pboard];
	else [container addSubview:lboard];
	[self showStartButton];
}

- (void) wonGame {
	paused = true;
	[self updateBest];
	[ScrambledSounds finished];
	if(winAlert) [winAlert release];
	winAlert = [[UIAlertView alloc] init];
	[winAlert setMessage:@"You won! Can you do it faster?"];
	[winAlert addButtonWithTitle:@"OK"];
	[winAlert setDelegate:self];
	[winAlert show];
}

- (void) resetCurrentTime {
	
}

- (void) showStartButton {
	if(!start) {
		start = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[start addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
		[start setTitle:@"Shake To Scramble Tiles" forState:UIControlStateNormal];
		[start setFrame:CGRectMake(0,0,250,50)];
		[start setBackgroundColor:[UIColor clearColor]];
		[start setAdjustsImageWhenHighlighted:YES];
	}
	if(isportrait && isphone) [start setCenter:CGPointMake(160,240)];
	if(!isportrait && isphone) [start setCenter:CGPointMake(240,160)];
	if(isportrait && !isphone) [start setCenter:CGPointMake(384,512)];
	if(!isportrait && !isphone) [start setCenter:CGPointMake(512,384)];
	[container addSubview:start];
}

- (void) newGame {
	[self defaultBoard];
	[pboard reset];
	[lboard reset];
	[self showStartButton];
	[lboard lockAllTiles];
	[pboard lockAllTiles];
}

- (void) startGame {
	time = 0;
	paused = false;
	[pboard shuffle];
	[lboard shuffle];
	[pboard setCanWin:TRUE];
	[lboard setCanWin:TRUE];
	[lboard unlockAllTiles];
	[pboard unlockAllTiles];
	[start removeFromSuperview];
}

- (void) adInfoSelector:(ScrambledInfoAdSelector *) selector didChooseItem:(NSDictionary *) item {
	if(loadinfo) [loadinfo release];
	loadinfo = [[NSMutableDictionary dictionaryWithDictionary:item] retain];
}

- (void) infoWantsToStartNewGame {
	paused = true;
    canShake = true;
	[self dismissModalViewControllerAnimated:TRUE];
	[self defaultBoard];
	[pboard reset];
	[lboard reset];
	[pboard lockAllTiles];
	[lboard lockAllTiles];
	[self showStartButton];
}

- (void) infoWantsToClose {
    canShake = true;
	[self dismissModalViewControllerAnimated:TRUE];
}

- (void) infoWantsToResetBestTime {
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	[def setObject:@"00:00" forKey:@"Scrambled:BestTime"];
}

- (IBAction) onInfo {
	paused = true;
    canShake = false;
	[self presentModalViewController:info animated:TRUE];
}

- (IBAction) onNewGame {
	paused = true;
	newGameAlert = [[UIAlertView alloc] init];
	[newGameAlert setMessage:@"Start a New Game?"];
	[newGameAlert addButtonWithTitle:@"No"];
	[newGameAlert addButtonWithTitle:@"Yes"];
	[newGameAlert show];
	[newGameAlert setDelegate:self];
}

- (IBAction) onChallange {
	if(![MFMailComposeViewController canSendMail]) {
		UIAlertView * alert = [[UIAlertView alloc] init];
		[alert setMessage:@"Please configure your mail client"];
		[alert addButtonWithTitle:@"OK"];
		[alert show];
		[alert autorelease];
		return;
	}
	if(!mail) mail = [[MFMailComposeViewController alloc] init];
	NSString * devName = device.name;
	NSString * msg = [NSString stringWithFormat:@"%@ has challenged you to "
	"Scrambled, the addictive photo slide puzzle! "
	"Search Scrambled at the App Store for more info or follow the "
	"link below.<br/><br/><a href='http://itunes.apple.com/us/app/scrambled/"
	"id297716312?mt=8'>Scrambled in the App Store.</a>",devName];
	NSString * subject = [NSString stringWithFormat:@"You've been challenged!"];
	[mail setSubject:subject];
	[mail setMessageBody:msg isHTML:TRUE];
	[mail setMailComposeDelegate:self];
	[self presentModalViewController:mail animated:TRUE];
}

- (IBAction) onChoosePhoto {
	if(picker == nil) {
		picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	paused = true;
	Class cl = NSClassFromString(@"UIPopoverController");
	if(cl && [device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		popover = [[UIPopoverController alloc] initWithContentViewController:picker];
		CGRect frame;
		if(isportrait) {
			frame = CGRectMake(210,800,340,1000);
			[popover presentPopoverFromRect:frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionDown animated:TRUE];
		} else {
			frame = CGRectMake(0,250,320,279);
			[popover presentPopoverFromRect:frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionLeft animated:TRUE];
		}
	} else {
		[self presentModalViewController:picker animated:YES];
	}
}

- (void) updateBest {
	bestDisplay = [timeDisplay copy];
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:bestDisplay forKey:@"Scrambled:BestTime"];
	[defaults synchronize];
}

- (void)
mailComposeController:(MFMailComposeViewController *) controller
didFinishWithResult:(MFMailComposeResult) result error:(NSError *) error
{
	[self dismissModalViewControllerAnimated:TRUE];
	[mail autorelease];
	mail = NULL;
}

//Code for shaking up the tiles
- (void) accelerometer:(UIAccelerometer *) accelerometer didAccelerate:(UIAcceleration *) acceleration {
	if(!canShake) return;
	if(!isShaking && __accelerometerIsShaking__(last,acceleration,.8)) {
		if ([start superview] == nil) return; // prevent multiple shaking EL
        isShaking = true;
		[self startGame];
	} else if(isShaking && !__accelerometerIsShaking__(last,acceleration,.8)) {
		isShaking = false;
	}
	if(last) [last release];
	last = [acceleration retain];
}

- (void)
imagePickerController:(UIImagePickerController *) _picker
didFinishPickingImage:(UIImage *) image
editingInfo:(NSDictionary *) editingInfo
{
	if(pickedImage) [pickedImage release];
	pickedImage = [[self scaleAndCrop:image] retain];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		if([device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			[popover dismissPopoverAnimated:TRUE];
		} else {
			[picker dismissModalViewControllerAnimated:TRUE];
		}
	} else {
		[picker dismissModalViewControllerAnimated:TRUE];
	}
#else
	[picker dismissModalViewControllerAnimated:TRUE];
#endif
	
	[pboard reset];
	[lboard reset];
	[pboard constructBoardWithImage:pickedImage];
	[lboard constructBoardWithImage:pickedImage];
	[self showStartButton];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
	paused = false;
	[self dismissModalViewControllerAnimated:TRUE];
}

- (void) alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
	if(alertView == winAlert) {
		[self newGame];
	} else if(alertView == newGameAlert) {
		if(buttonIndex == 0) {
			paused = false;
			return;
		}
		[self resetCurrentTime];
		[self newGame];
	}
}

- (void) onAppBG {
	paused = true;
}

- (void) onAppFG {
	if([start superview]) return;
	paused = false;
}

- (void) onTick {
	if(paused) return;
	time++;
	hours = (time / 60) / 60;
	mins = time / 60;
	secs = time - (mins * 60);
	[timeDisplay release];
	timeDisplay = [[NSString stringWithFormat:@"%0.2i:%0.2i",mins,secs] copy];
	[self gameDidTick];
}

- (void) invalidateBoardView {
	Boolean st = !([start superview] == NULL);
	if(UIDeviceOrientationIsPortrait(orientation)) {
		[lboard removeFromSuperview];
		[currentView addSubview:pboard];
	} else {
		[pboard removeFromSuperview];
		[currentView addSubview:lboard];
	}
	if(st) [self showStartButton];
}

- (void)
willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
duration:(NSTimeInterval) duration
{
	UIDeviceOrientation current = orientation;
	orientation = toInterfaceOrientation;
	if(UIDeviceOrientationIsPortrait(current) && orientation == UIDeviceOrientationPortraitUpsideDown) {
		isportrait = true;
	} else if(current == UIDeviceOrientationPortraitUpsideDown && UIDeviceOrientationIsPortrait(orientation)) {
		isportrait = true;
	} else if(UIDeviceOrientationIsPortrait(current) && !UIDeviceOrientationIsPortrait(orientation)) {
		isportrait = false;
		[lboard setIsRunning:([start superview]==nil)];
		[[lboard boardModel] setTilePositions:[[pboard boardModel] getTileArray]];
	} else if(UIDeviceOrientationIsPortrait(orientation)) {
		[pboard setIsRunning:([start superview]==nil)];
		[[pboard boardModel] setTilePositions:[[lboard boardModel] getTileArray]];
		isportrait = true;
	} else {
		[lboard setIsRunning:([start superview]==nil)];
		[[lboard boardModel] setTilePositions:[[pboard boardModel] getTileArray]];
		isportrait = false;
	}
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIImage *) scaleAndCrop:(UIImage *) image {
	CGSize srcSize = image.size;
	CGImageRef iRef = [image CGImage];
	CGFloat width = CGImageGetWidth(iRef);
	CGFloat height = CGImageGetHeight(iRef);
	CGFloat kMaxResolution = 0;
	if(isphone) kMaxResolution = 280;
	else kMaxResolution = 630;
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if(width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if(ratio > 1) {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		} else {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
	}
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(iRef), CGImageGetHeight(iRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {	
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	//UIGraphicsBeginImageContext(bounds.size);
    UIGraphicsBeginImageContext(CGSizeMake(kMaxResolution,kMaxResolution));
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);	
	CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), iRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    srcSize = imageCopy.size;
    UIImage * result = nil;
	
	//crop image if necessary
    if((srcSize.width > kMaxResolution || srcSize.height > kMaxResolution) && 0) {
        CGRect clipRect = CGRectMake(0,0,kMaxResolution,kMaxResolution);
        iRef = [imageCopy CGImage];
        CGImageRef cRef = CGImageCreateWithImageInRect(iRef,clipRect);
        UIImage *  clip = [UIImage imageWithCGImage:cRef];
        result = clip;
	} else result = imageCopy;
	return result;
}

- (void) didSelectPicture {}
- (void) gameDidTick {}

- (void) dealloc {
	[timer invalidate];
	[timeDisplay release];
	[container release];
	[start release];
	[pickedImage release];
	[picker release];
	[popover release];
	[mail release];
	[config release];
	[pboard release];
	[lboard release];
	[winAlert release];
	[newGameAlert release];
	[bestDisplay release];
	bestDisplay = NULL;
	newGameAlert = NULL;
	winAlert = NULL;
	lboard = NULL;
	pboard = NULL;
	config = NULL;
	mail = NULL;
	popover = NULL;
	picker = NULL;
	pickedImage = NULL;
	start = NULL;
	currentView = NULL;
	container = NULL;
	timeDisplay = NULL;
	timer = NULL;
	[super dealloc];
}

@end
