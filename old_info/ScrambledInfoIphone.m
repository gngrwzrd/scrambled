
#import "ScrambledInfoIphone.h"

static int kPuzzleImages = 0;
static int kBannerAd = 1;
static int kInterstitialAd = 2;
static int kResetSection = 3;
static int kInfo = 4;

@implementation ScrambledInfoIphone
@synthesize fcid = _fcid;
@synthesize preview = _preview;
@synthesize placement = _placement;
@synthesize delegate = _delegate;
@synthesize area = _area;
@synthesize defbuttonContainer = _defbuttonContainer;
@synthesize p1b;
@synthesize p2b;
@synthesize p3b;
@synthesize p4b;
@synthesize p5b;
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
	isphone = !([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	return 5;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if(section == kResetSection) return 1;
	if(section == kPuzzleImages) return 1;
	if(section == kBannerAd) return 2;
	if(section == kInterstitialAd) return 2;
	if(section == kInfo) return 2;
	return 0;
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {
	UIView * headerView = NULL;
	UILabel * label = NULL;
	if(section == kResetSection) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Reset";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kPuzzleImages) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Puzzle Images";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kBannerAd) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Say Media Banner Controls";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kInterstitialAd) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Say Media Interstitial Controls";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kInfo) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Information";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	return headerView;
	
}
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	UITableViewCell * cell = NULL;
	if(indexPath.section == kResetSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"reset"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,44) reuseIdentifier:@"reset"];
		[self setupResetCell:cell];
	}
	if(indexPath.section == kPuzzleImages) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"puzzles"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"puzzles"];
		[self setupPuzzleImages:cell];
	}
	if(indexPath.section == kBannerAd && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"banner_r0"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"banner_r0"];
		[self setupBannerRow0:cell];
	}
	if(indexPath.section == kBannerAd && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"banner_r1"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"banner_r1"];
		[self setupBannerRow1:cell];
	}
	if(indexPath.section == kInterstitialAd && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"inter_r0"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"banner_r0"];
		[self setupInterRow0:cell];
	}
	if(indexPath.section == kInterstitialAd && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"inter_r1"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"banner_r1"];
		[self setupInterRow1:cell];
	}
	if(indexPath.section == kInfo && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"version"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"version"];
		[self setupVersionCell:cell];
	}
	if(indexPath.section == kInfo && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"idk"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,282,52) reuseIdentifier:@"idk"];
		[self setupIDKCell:cell];
	}
	return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	if(indexPath.section == kResetSection) {
		[self resetHighScore];
		[_tableView deselectRowAtIndexPath:indexPath animated:FALSE];
	}
}

- (void) setupIDKCell:(UITableViewCell *) cell {
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(226,15,46,17)];
	[[cell textLabel] setText:@"IDK Version"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[label setTextAlignment:UITextAlignmentRight];
	[label setText:[(SMAdIPrivate *)[SMAd class] performSelector:@selector(IDKVersion)]];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor grayColor]];
	[[cell contentView] addSubview:label];
}

- (void) setupVersionCell:(UITableViewCell *) cell {
	NSBundle * main = [NSBundle mainBundle];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(226,15,46,17)];
	[[cell textLabel] setText:@"Version"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[label setTextAlignment:UITextAlignmentRight];
	[label setText:[[main infoDictionary] objectForKey:@"CFBundleVersion"]];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor grayColor]];
	[[cell contentView] addSubview:label];
}

- (void) setupBannerRow0:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Banner Ad"];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(234,15,46,17)];
	[label setText:@"Random"];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor grayColor]];
	[[cell contentView] addSubview:label];
}

- (void) setupBannerRow1:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Custom ID"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	_bannerField = [[UITextField alloc] initWithFrame:CGRectMake(153,11,120,21)];
	[_bannerField setTextAlignment:UITextAlignmentRight];
	[_bannerField setTextColor:[UIColor grayColor]];
	[_bannerField setText:@"3482919-12"];
	[[cell contentView] addSubview:_bannerField];
	[_bannerField setDelegate:self];
	[_bannerField setClearsOnBeginEditing:TRUE];
	[_bannerField setReturnKeyType:UIReturnKeyDone];
}

- (void) setupInterRow0:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Interstitial Ad"];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(234,15,46,17)];
	[label setText:@"Random"];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor grayColor]];
	[[cell contentView] addSubview:label];
}

- (void) setupInterRow1:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Custom ID"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	_interstitialField = [[UITextField alloc] initWithFrame:CGRectMake(153,11,120,21)];
	[_interstitialField setTextAlignment:UITextAlignmentRight];
	[_interstitialField setTextColor:[UIColor grayColor]];
	[_interstitialField setText:@"3482919-12"];
	[[cell contentView] addSubview:_interstitialField];
	[_interstitialField setDelegate:self];
	[_interstitialField setClearsOnBeginEditing:TRUE];
	[_interstitialField setReturnKeyType:UIReturnKeyDone];
}

- (void) setupPuzzleImages:(UITableViewCell *) cell {
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[cell contentView] addSubview:_puzzleImagesContainer];
}

- (void) setupResetCell:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Reset Best Time"];
}

- (void) loadInfo {
	NSURL * url = NULL;
	if(isphone) url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_iphone.js"];
	else url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_ipad.js"];
	NSURLRequest * req = [NSURLRequest requestWithURL:url];
	infodata = [[NSMutableData alloc] init];
	infoconn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	[infoconn start];
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

- (IBAction) onPuzzleButton:(id) sender {
	UIButton * bsender = (UIButton *)sender;
	[_puzzleImageBorder setFrame:[bsender frame]];
	if(isphone) {
		if(sender == p1b) [defaults setObject:@"ip_puzzle1.jpg" forKey:@"ip_puzzle"];
		if(sender == p2b) [defaults setObject:@"ip_puzzle2.jpg" forKey:@"ip_puzzle"];
		if(sender == p3b) [defaults setObject:@"ip_puzzle3.jpg" forKey:@"ip_puzzle"];
		if(sender == p4b) [defaults setObject:@"ip_puzzle4.jpg" forKey:@"ip_puzzle"];
		if(sender == p5b) [defaults setObject:@"ip_puzzle5.jpg" forKey:@"ip_puzzle"];
	} else {
		if(sender == p1b) [defaults setObject:@"ipd_puzzle1.jpg" forKey:@"ipd_puzzle"];
		if(sender == p2b) [defaults setObject:@"ipd_puzzle2.jpg" forKey:@"ipd_puzzle"];
		if(sender == p3b) [defaults setObject:@"ipd_puzzle3.jpg" forKey:@"ipd_puzzle"];
		if(sender == p4b) [defaults setObject:@"ipd_puzzle4.jpg" forKey:@"ipd_puzzle"];
		if(sender == p5b) [defaults setObject:@"ipd_puzzle5.jpg" forKey:@"ipd_puzzle"];
	}
	CGRect frame = [_puzzleImageBorder frame];
	[defaults setFloat:frame.origin.x forKey:@"outlinex"];
	[defaults setFloat:frame.origin.y forKey:@"outliney"];
	[defaults synchronize];
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToStartNewGame)]) {
		[_delegate infoWantsToStartNewGame];
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

- (IBAction) onClose {
	
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToClose)]) {
		[_delegate infoWantsToClose];
	}
}

- (CGRect) rectForFooterInSection:(NSInteger) section {
	if(section == kBannerAd) {
		return CGRectMake(0, 0, 320, 10);
	}
	return CGRectMake(0, 0, 320, 30);
}

- (void) resetHighScore {
	UIAlertView * alert = [[UIAlertView alloc] init];
	[alert setMessage:@"Are you sure you want to reset your best time?"];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
	[alert setDelegate:self];
	[alert autorelease];
	[alert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToResetBestTime)]) {
			[_delegate infoWantsToResetBestTime];
		}
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[_fcid resignFirstResponder];
	[_preview resignFirstResponder];
	[_area resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	[_tableView setFrame:CGRectMake(8,64,302,416)];
	[_interstitialField resignFirstResponder];
	[_bannerField resignFirstResponder];
	return TRUE;
}

- (void) textFieldDidEndEditing:(UITextField *) textField {
	[_tableView setFrame:CGRectMake(8,64,302,416)];
	[_interstitialField resignFirstResponder];
	[_bannerField resignFirstResponder];
}

- (void) textFieldDidBeginEditing:(UITextField *) textField {
	if(_tableView.frame.size.height > 200) [_tableView setFrame:CGRectMake(8,64,302,200)];
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
