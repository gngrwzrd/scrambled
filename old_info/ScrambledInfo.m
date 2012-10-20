
#import "ScrambledInfo.h"



@implementation ScrambledInfo
@synthesize fcid = _fcid;
@synthesize preview = _preview;
@synthesize placement = _placement;
@synthesize delegate = _delegate;
@synthesize area = _area;
@synthesize defbuttonContainer = _defbuttonContainer;
@synthesize tableView = _tableView;
@synthesize	 puzzleImagesContainer = _puzzleImagesContainer;
@synthesize puzzleImageBorder = _puzzleImageBorder;
@synthesize bg = _bg;

- (id) initWithCoder:(NSCoder *) aDecoder {
	if(!(self = [super initWithCoder:aDecoder])) return nil;
	_defbuttons = [[NSMutableArray alloc] init];
	[self loadInfo];
	return self;
}

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nil])) return NULL;
	_defbuttons = [[NSMutableArray alloc] init];
	[self loadInfo];
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	if(isphone) {
		[_bg setImage:[UIImage imageNamed:@"settings_bg_wood_iphone.jpg"]];
		[_bg setFrame:CGRectMake(0,0,320,480)];
	} else {
		[_bg setImage:[UIImage imageNamed:@"settings_bg_wood_ipad.jpg"]];
		[_bg setFrame:CGRectMake(0,0,768,1024)];
	}
	defaults = [NSUserDefaults standardUserDefaults];
	[_tableView setDataSource:self];
	[_tableView setDelegate:self];
	[_tableView setBackgroundColor:[UIColor clearColor]];
	[_tableView setSectionHeaderHeight:30];
	[_tableView setSectionFooterHeight:20];
	CGRect outlineFrame = CGRectMake(0,0,55,50);
	outlineFrame.origin.x = [defaults floatForKey:@"outlinex"];
	outlineFrame.origin.y = [defaults floatForKey:@"outliney"];
	[_puzzleImageBorder setFrame:outlineFrame];
	[self showButtons];
}





- (void) prepareButtons {
	NSArray * buttons = [infodict objectForKey:@"defaults"];
	ScrambledAdButton * ab = NULL;
	NSUInteger i = 0;
	UIImage * image = NULL;
	NSMutableData * imagedata = NULL;
	NSURL * imageurl = NULL;
	for(NSDictionary * info in buttons) {
		ab = [[ScrambledAdButton alloc] initWithFrame:CGRectMake((i*69)+i*2,15,69,50)];
		[ab setPlacement:[info objectForKey:@"placement"]];
		[ab setFcid:[info objectForKey:@"fcid"]];
		[ab setPreview:[info objectForKey:@"preview"]];
		imageurl = [NSURL URLWithString:[info objectForKey:@"image"]];
		imagedata = [NSData dataWithContentsOfURL:imageurl];
		image = [UIImage imageWithData:imagedata];
		[ab setImage:image forState:UIControlStateNormal];
		[ab addTarget:self action:@selector(onAdButton:) forControlEvents:UIControlEventTouchUpInside];
		[_defbuttons addObject:ab];
		[ab release];
		i++;
	}
}

- (void) showButtons {
	for(ScrambledAdButton * b in _defbuttons) {
		[_defbuttonContainer addSubview:b];
	}
}

- (void) onAdButton:(id) sender {
	ScrambledAdButton * ab = (ScrambledAdButton *)sender;
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	if([ab fcid] && ![[ab fcid] isEqualToString:@""]) [dic setObject:[ab fcid] forKey:@"fcid"];
	if([ab placement] && ![[ab placement] isEqualToString:@""]) [dic setObject:[ab placement] forKey:@"placement"];
	if([ab preview] && ![[ab preview] isEqualToString:@""]) [dic setObject:[ab preview] forKey:@"preview"];
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToLoadBannerWithValues:)]) {
		shouldReset = true;
		[_delegate infoWantsToLoadBannerWithValues:dic];
	}
}

- (void) didShow {
}

- (void) didHide {
}

- (IBAction) onReset {
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToResetBestTime)]) {
		[_delegate infoWantsToResetBestTime];
	}
}

- (IBAction) onClear {
	[_fcid setText:@""];
	[_preview setText:@""];
	[_placement setText:@""];
	[_area setText:@""];
	shouldReset = true;
}

- (IBAction) onCancel {
	if(shouldReset && [[_fcid text] isEqualToString:@""] &&  \
	   [[_preview text] isEqualToString:@""] && [[_area text] isEqualToString:@""])
	{
		shouldReset = false;
		if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToResetSMAD)]) {
			[_delegate infoWantsToResetSMAD];
		}
	}
	if([self parentViewController])[[self parentViewController] dismissModalViewControllerAnimated:TRUE];
	else if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToClose)]) {
		[_delegate infoWantsToClose];
	}
}

- (IBAction) onBanner {
	if([[_fcid text] isEqualToString:@""] && \
	   [[_preview text] isEqualToString:@""] && [[_area text] isEqualToString:@""]) {
		if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToClose)]) {
			[_delegate infoWantsToClose];
		}
		return;
	}
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToLoadBannerWithValues:)]) {
		shouldReset = true;
		NSMutableDictionary * values = [NSMutableDictionary dictionary];
		[values setObject:[_fcid text] forKey:@"fcid"];
		[values setObject:[_preview text] forKey:@"preview"];
		[values setObject:[_area text] forKey:@"area"];
		[_delegate infoWantsToLoadBannerWithValues:values];
	}
}

- (IBAction) onInterstitial {
	if([[_fcid text] isEqualToString:@""] && \
	   [[_preview text] isEqualToString:@""] && [[_area text] isEqualToString:@""]) {
		if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToClose)]) {
			[_delegate infoWantsToClose];
		}
		return;
	}
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToLoadInterstitialWithValues:)]) {
		shouldReset = true;
		NSMutableDictionary * values = [NSMutableDictionary dictionary];
		[values setObject:[_fcid text] forKey:@"fcid"];
		[values setObject:[_preview text] forKey:@"preview"];
		[values setObject:[_area text] forKey:@"area"];
		[_delegate infoWantsToLoadInterstitialWithValues:values];
	}
}





- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation {
	return TRUE;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
		[_tableView setFrame:CGRectMake(8,64,302,416)];
	} else {
		[_tableView setFrame:CGRectMake(8,64,302,256)];
	}
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
	[infodata appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
	if(connection == infoconn) {
		SBJsonParser * json = [[SBJsonParser alloc] init];
		infodict = [[json objectWithData:infodata] retain];
		[json release];
		[self prepareButtons];
	}
}

- (void) dealloc {
	_delegate = NULL;
	[_fcid release];
	[_preview release];
	[_placement release];
	[_area release];
	[infodata release];
	[infoconn cancel];
	[infoconn release];
	[infodict release];
	[_defbuttons release];
	[_defbuttonContainer release];
	[p1b release];
	[p2b release];
	[p3b release];
	[p4b release];
	[p5b release];
	p5b = NULL;
	p4b = NULL;
	p3b = NULL;
	p2b = NULL;
	p1b = NULL;
	_defbuttonContainer = NULL;
	_defbuttons = NULL;
	infodict = NULL;
	infoconn = NULL;
	infodata = NULL;
	_area = NULL;
	_placement = NULL;
	_preview = NULL;
	_fcid = NULL;
	[super dealloc];
}

@end
