
#import "ScrambledInfo.h"

/*
static int kPuzzleImages = 0;
static int kBannerAd = 1;
static int kInterstitialAd = 2;
static int kResetSection = 3;
static int kInfo = 4;
*/
 
static int kPuzzleImages = 0;
static int kResetSection = 1;
static int kBannerAd = 2;
static int kInterstitialAd = 3;
static int kInfo = 4;

@implementation ScrambledInfo
@synthesize tableview = _tableview;
@synthesize puzzleOutline = _puzzleOutline;
@synthesize puzzleImagesContainer = _puzzleImagesContainer;
@synthesize delegate = _delegate;
@synthesize p1b;
@synthesize p2b;
@synthesize p3b;
@synthesize p4b;
@synthesize p5b;

- (void) viewDidLoad {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
		isphone = !([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	} else {
		isphone = true;
	}
#else
	isphone = true;
#endif
	defaults = [NSUserDefaults standardUserDefaults];
	load = [[NSMutableDictionary alloc] init];
	if(isphone) bannerAdSel = [[ScrambledInfoAdSelector alloc] initWithNibName:@"ScrambledInfoAdSelectorIphone" bundle:nil];
	else bannerAdSel = [[ScrambledInfoAdSelector alloc] initWithNibName:@"ScrambledInfoAdSelectorIpad" bundle:nil];
	if(isphone) interAdSel = [[ScrambledInfoAdSelector alloc] initWithNibName:@"ScrambledInfoAdSelectorIphone" bundle:nil];
	else interAdSel = [[ScrambledInfoAdSelector alloc] initWithNibName:@"ScrambledInfoAdSelectorIpad" bundle:nil];
	[interAdSel setType:adtype_interstitial];
	[interAdSel setDelegate:self];
	[bannerAdSel setType:adtype_banner];
	[bannerAdSel setDelegate:self];
	[bannerAdSel loadInfo];
	[interAdSel loadInfo];
	[_tableview setDataSource:self];
	[_tableview setDelegate:self];
	[_tableview setBackgroundColor:[UIColor clearColor]];
	[_tableview setSectionHeaderHeight:30];
	[_tableview setSectionFooterHeight:30];
	CGRect outlineFrame;
	if(isphone) {
		outlineFrame = CGRectMake(0,0,55,50);
		outlineFrame.origin.x = [defaults floatForKey:@"outlinex"];
		outlineFrame.origin.y = [defaults floatForKey:@"outliney"];
	} else {
		outlineFrame = CGRectMake(0,0,126,50);
		outlineFrame.origin.x = [defaults floatForKey:@"outlinex_ipad"];
		outlineFrame.origin.y = [defaults floatForKey:@"outliney_ipad"];
	}
	[_puzzleOutline setFrame:outlineFrame];
	if(!isphone) {
		if([_tableview respondsToSelector:@selector(backgroundView)]) {
			[_tableview setBackgroundView:nil];
			[_tableview setBackgroundView:[[[UIView alloc] init] autorelease]];
		}
	}
}

- (void) adInfoSelector:(ScrambledInfoAdSelector *) selector didChooseItem:(NSDictionary *) item {
	[lastSelectedItem release];
	lastSelectedItem = [[NSMutableDictionary dictionaryWithDictionary:item] retain];
	lastSelector = selector;
	NSString * itemtype = [item objectForKey:@"type"];
	NSString * label = [item objectForKey:@"label"];
	NSString * fcid = [item objectForKey:@"fcid"];
	NSString * file = [item objectForKey:@"filename"];
	if([selector type] == adtype_interstitial) {
		[load removeObjectForKey:@"inter_fcid"];
		[load removeObjectForKey:@"inter_preview"];
		[_interLabelField setText:label];
		[_interstitialField setEnabled:FALSE];
		[_interstitialField setText:@""];
		[_interIdLabel setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
		if([itemtype isEqualToString:@"input"]) {
			[_interstitialField setEnabled:TRUE];
			[_interstitialField becomeFirstResponder];
			[_interIdLabel setTextColor:[UIColor blackColor]];
			//[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scroll) userInfo:nil repeats:false];
			NSUInteger paths[2] = {2,1};
			[_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:paths length:2] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
			return;
		}
		if([itemtype isEqualToString:@"direct"]) {
			[_interstitialField setText:fcid];
			[load setObject:fcid forKey:@"inter_fcid"];
		}
		if([itemtype isEqualToString:@"local"]) {
			[_interstitialField setText:@"N/A"];
			[load setObject:file forKey:@"file"];
		}
		if([itemtype isEqualToString:@"random"]) [_interstitialField setText:@"N/A"];
	}
	if([selector type] == adtype_banner) {
		[load removeObjectForKey:@"banner_fcid"];
		[load removeObjectForKey:@"banner_preview"];
		[load setObject:@"banner" forKey:@"type"];
		[_bannerIdLabel setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
		[_bannerField setText:@""];
		[_bannerField setEnabled:FALSE];
		[_bannerLabelField setText:label];
		if([itemtype isEqualToString:@"input"]) {
			[_bannerField setEnabled:TRUE];
			[_bannerField becomeFirstResponder];
			[_bannerIdLabel setTextColor:[UIColor blackColor]];
			NSUInteger paths[2] = {1,1};
			[_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:paths length:2] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
			return;
		}
		if([itemtype isEqualToString:@"direct"]) {
			[_bannerField setText:fcid];
			[load setObject:fcid forKey:@"banner_fcid"];
		}
		if([itemtype isEqualToString:@"local"]) {
			[_bannerField setText:@"N/A"];
			[load setObject:file forKey:@"file"];
		}
		if([itemtype isEqualToString:@"random"]) [_bannerField setText:@"N/A"];
	}
	if(_scrambledAdInfoSelectorDelegate && \
	    [_scrambledAdInfoSelectorDelegate respondsToSelector:@selector(adInfoSelector:didChooseItem:)])
	{
		[_scrambledAdInfoSelectorDelegate adInfoSelector:selector didChooseItem:load];
	}
}

- (void) scroll {
	
}

- (void) setScrambledInfoAdSelectDelegate:(NSObject <ScrambledInfoAdSelectorDelegate> *) delegate {
	_scrambledAdInfoSelectorDelegate = delegate;
}

- (IBAction) onClose {
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToClose)]) {
		[_delegate infoWantsToClose];
	}
}

- (IBAction) onPuzzleButton:(id) sender {
	UIButton * bsender = (UIButton *)sender;
	[_puzzleOutline setFrame:[bsender frame]];
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
	CGRect frame = [_puzzleOutline frame];
	if(isphone) {
		[defaults setFloat:frame.origin.x forKey:@"outlinex"];
		[defaults setFloat:frame.origin.y forKey:@"outliney"];
	} else {
		[defaults setFloat:frame.origin.x forKey:@"outlinex_ipad"];
		[defaults setFloat:frame.origin.y forKey:@"outliney_ipad"];
	}
	[defaults synchronize];
	if(_scrambledAdInfoSelectorDelegate && \
	   [_scrambledAdInfoSelectorDelegate respondsToSelector:@selector(adInfoSelector:didChooseItem:)])
	{
		[_scrambledAdInfoSelectorDelegate adInfoSelector:lastSelector didChooseItem:load];
	}
	if(_delegate && [_delegate respondsToSelector:@selector(infoWantsToStartNewGame)]) {
		[_delegate infoWantsToStartNewGame];
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	return 2;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if(section == kResetSection) return 1;
	if(section == kPuzzleImages) return 1;
	//if(section == kBannerAd) return 2;
	//if(section == kInterstitialAd) return 2;
	//if(section == kInfo) return 2;
	return 0;
}

- (UIView *) tableView:(UITableView *) tableView viewForFooterInSection:(NSInteger) section {
	NSUInteger footerHeight = [tableView sectionFooterHeight];
	UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,footerHeight)];
	UILabel * label = NULL;
	if(section == kInterstitialAd) {
		label = [[UILabel alloc] initWithFrame:CGRectMake((isphone)?39:250,0,320,20)];
		[label setText:@"Interstitial ad shown when starting a new game"];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:12.0]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextColor:[UIColor whiteColor]];
		[footerView addSubview:label];
		[label release];
	}
	return footerView;
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {
	UIView * headerView = NULL;
	UILabel * label = NULL;
	float x = (isphone) ? 10 : 45;
	if(section == kResetSection) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(x,3,tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Reset";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kPuzzleImages) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(x,3,tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Puzzle Images";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kBannerAd) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(x,3,tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Say Media Banner Controls";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kInterstitialAd) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(x,3,tableView.bounds.size.width-10,18)] autorelease];
		label.text = @"Say Media Interstitial Controls";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[label setFont:[UIFont fontWithName:@"Alexoid Hand Condensed" size:19.0]];
		[headerView addSubview:label];
	}
	if(section == kInfo) {
		headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,30)] autorelease];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(x,3,tableView.bounds.size.width-10,18)] autorelease];
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reset"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,44)];
		[self setupResetCell:cell];
	}
	if(indexPath.section == kPuzzleImages) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"puzzles"];
		if(cell) return cell;
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"puzzles"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		[self setupPuzzleImages:cell];
	}
	if(indexPath.section == kBannerAd && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"banner_r0"];
		if(cell) return cell;
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"banner_r0"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"banner_r0"];
		//[self setupBannerRow0:cell];
	}
	if(indexPath.section == kBannerAd && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"banner_r1"];
		if(cell) return cell;
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"banner_r1"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"banner_r1"];
		//[self setupBannerRow1:cell];
	}
	if(indexPath.section == kInterstitialAd && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"inter_r0"];
		if(cell) return cell;
		
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"inter_r0"];
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inter_r0"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		
		[self setupInterRow0:cell];
		
	}
	if(indexPath.section == kInterstitialAd && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"inter_r1"];
		if(cell) return cell;
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"inter_r1"];
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inter_r1"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		
		[self setupInterRow1:cell];
	}
	if(indexPath.section == kInfo && indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"version"];
		if(cell) return cell;
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"version"];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"version"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		[self setupVersionCell:cell];
	}
	if(indexPath.section == kInfo && indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"idk"];
		if(cell) return cell;
		//cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,52) reuseIdentifier:@"idk"];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idk"];
		[cell setFrame:CGRectMake(0,0,tableView.bounds.size.width,52)];
		[self setupIDKCell:cell];
	}
	return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[_bannerField resignFirstResponder];
	[_interstitialField resignFirstResponder];
	if(indexPath.section == kResetSection) {
		[self resetHighScore];
		[tableView deselectRowAtIndexPath:indexPath animated:FALSE];
	}
	if(indexPath.section == kBannerAd && indexPath.row == 0) {
		[self presentModalViewController:bannerAdSel animated:TRUE];
	}
	if(indexPath.section == kInterstitialAd && indexPath.row == 0) {
		[self presentModalViewController:interAdSel animated:TRUE];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:FALSE];
}

- (void) setupIDKCell:(UITableViewCell *) cell {
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((isphone)?226:580,15,46,17)];
	[[cell textLabel] setText:@"IDK Version"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[label setTextAlignment:UITextAlignmentRight];
	[label setBackgroundColor:[UIColor clearColor]];
	//[label setText:[(SMAdIPrivate *)[SMAd class] performSelector:@selector(IDKVersion)]];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	[[cell contentView] addSubview:label];
}

- (void) setupVersionCell:(UITableViewCell *) cell {
	NSBundle * main = [NSBundle mainBundle];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((isphone)?226:580,15,46,17)];
	[[cell textLabel] setText:@"Version"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[label setTextAlignment:UITextAlignmentRight];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setText:[[main infoDictionary] objectForKey:@"CFBundleVersion"]];
	[label setFont:[UIFont systemFontOfSize:10]];
	[label setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	[[cell contentView] addSubview:label];
}

- (void) setupBannerRow0:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Banner Ad"];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	_bannerLabelField = [[UILabel alloc] initWithFrame:CGRectMake((isphone)?133:487,13,120,17)];
	[_bannerLabelField setText:@"Random"];
	[_bannerLabelField setBackgroundColor:[UIColor clearColor]];
	[_bannerLabelField setTextAlignment:UITextAlignmentRight];
	[_bannerLabelField setFont:[UIFont systemFontOfSize:10]];
	[_bannerLabelField setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	[[cell contentView] addSubview:_bannerLabelField];
}

- (void) setupBannerRow1:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Custom ID"];
	[[cell textLabel] setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	_bannerIdLabel = [cell textLabel];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	_bannerField = [[UITextField alloc] initWithFrame:CGRectMake((isphone)?153:507,11,120,21)];
	[_bannerField setText:@"N/A"];
	[_bannerField setBackgroundColor:[UIColor clearColor]];
	[_bannerField setEnabled:FALSE];
	[_bannerField setTextAlignment:UITextAlignmentRight];
	[_bannerField setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	//[_bannerField setText:@"3482919-12"];
	[[cell contentView] addSubview:_bannerField];
	[_bannerField setDelegate:self];
	[_bannerField setClearsOnBeginEditing:TRUE];
	[_bannerField setReturnKeyType:UIReturnKeyDone];
}

- (void) setupInterRow0:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Interstitial Ad"];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	_interLabelField = [[UILabel alloc] initWithFrame:CGRectMake((isphone)?133:487,13,120,17)];
	[_interLabelField setText:@"Random"];
	[_interLabelField setBackgroundColor:[UIColor clearColor]];
	[_interLabelField setTextAlignment:UITextAlignmentRight];
	[_interLabelField setFont:[UIFont systemFontOfSize:10]];
	[_interLabelField setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	[[cell contentView] addSubview:_interLabelField];
}

- (void) setupInterRow1:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Custom ID"];
	[[cell textLabel] setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	_interIdLabel = [cell textLabel];
	_interstitialField = [[UITextField alloc] initWithFrame:CGRectMake((isphone)?153:507,11,120,21)];
	[_interstitialField setText:@"N/A"];
	[_interstitialField setBackgroundColor:[UIColor clearColor]];
	[_interstitialField setEnabled:FALSE];
	[_interstitialField setTextAlignment:UITextAlignmentRight];
	[_interstitialField setTextColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1]];
	//[_interstitialField setText:@"3482919-12"];
	[[cell contentView] addSubview:_interstitialField];
	[_interstitialField setDelegate:self];
	[_interstitialField setClearsOnBeginEditing:TRUE];
	[_interstitialField setReturnKeyType:UIReturnKeyDone];
}

- (void) setupPuzzleImages:(UITableViewCell *) cell {
	if([cell respondsToSelector:@selector(backgroundView)]) {
		[cell setBackgroundView:nil];
		[cell setBackgroundView:[[[UIView alloc] init] autorelease]];
	}
	[cell setBackgroundColor:[UIColor clearColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[[cell contentView] addSubview:_puzzleImagesContainer];
}

- (void) setupResetCell:(UITableViewCell *) cell {
	[[cell textLabel] setText:@"Reset Best Time"];
}

- (CGRect) rectForFooterInSection:(NSInteger) section {
	if(section == kBannerAd) return CGRectMake(0, 0, 320, 10);
	return CGRectMake(0, 0, 320, 30);
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	if(isphone) [_tableview setFrame:CGRectMake(8,64,302,416)];
	else [_tableview setFrame:CGRectMake(20,121,728,903)];
	[_interstitialField resignFirstResponder];
	[_bannerField resignFirstResponder];
	return TRUE;
}

- (void) textFieldDidEndEditing:(UITextField *) textField {
	if(isphone) [_tableview setFrame:CGRectMake(8,64,302,416)];
	else [_tableview setFrame:CGRectMake(20,121,728,903)];
	[_interstitialField resignFirstResponder];
	[_bannerField resignFirstResponder];
	
	NSString * type = [lastSelectedItem objectForKey:@"type"];
	NSString * itype = [lastSelectedItem objectForKey:@"input_type"];
	
	if(lastSelector == bannerAdSel) {
		if([type isEqualToString:@"input"] && [itype isEqualToString:@"preview"]) {
			[load setObject:[_bannerField text] forKey:@"banner_preview"];
		}
		if([type isEqualToString:@"input"] && [itype isEqualToString:@"fcid"]) {
			[load setObject:[_bannerField text] forKey:@"banner_fcid"];
		}
	}
	
	if(lastSelector == interAdSel) {
		if([type isEqualToString:@"input"] && [itype isEqualToString:@"preview"]) {
			[load setObject:[_interstitialField text] forKey:@"inter_preview"];
		}
		if([type isEqualToString:@"input"] && [itype isEqualToString:@"fcid"]) {
			[load setObject:[_interstitialField text] forKey:@"inter_fcid"];
		}
	}
	
	if(_scrambledAdInfoSelectorDelegate && \
	   [_scrambledAdInfoSelectorDelegate respondsToSelector:@selector(adInfoSelector:didChooseItem:)])
	{
		[_scrambledAdInfoSelectorDelegate adInfoSelector:lastSelector didChooseItem:load];
	}
}

- (void) textFieldDidBeginEditing:(UITextField *) textField {
	if(isphone && _tableview.frame.size.height > 200) [_tableview setFrame:CGRectMake(8,64,302,200)];
	if(!isphone && _tableview.frame.size.height > 639) [_tableview setFrame:CGRectMake(20,121,728,639)];
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

- (void) dealloc {
	[super dealloc];
}

@end
