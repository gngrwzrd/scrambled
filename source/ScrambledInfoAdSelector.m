
#import "ScrambledInfoAdSelector.h"

@implementation ScrambledInfoAdSelector
@synthesize type;
@synthesize tableview = _tableview;
@synthesize delegate = _delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
		isphone = !([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	} else {
		isphone = true;
	}
#else
	isphone = true;
#endif
	return self;
}

- (void) viewDidLoad {
	if([_tableview respondsToSelector:@selector(backgroundView)]) {
		[_tableview setBackgroundView:nil];
		[_tableview setBackgroundView:[[[UIView alloc] init] autorelease]];
	}
	[_tableview setBackgroundColor:[UIColor clearColor]];
	if(loaded) [self loadTableData];
	else showAfterLoad = true;
}

- (void) loadInfo {
	NSURL * url = NULL;
	if(isphone) {
		if(type == 0) url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_banner_iphone.js"];
		if(type == 1) url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_inter_iphone.js"];
	} else {
		if(type == 0) url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_banner_ipad.js"];
		if(type == 1) url = [NSURL URLWithString:@"http://clientpreview.videoegg.com/demo/mobile/scrambled/defaults_inter_ipad.js"];
	}
	NSURLRequest * req = [NSURLRequest requestWithURL:url];
	infodata = [[NSMutableData alloc] init];
	infoconn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	[infoconn start];
}

- (void) loadTableData {
	[_tableview setDataSource:self];
	[_tableview setDelegate:self];
	[_tableview reloadData];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	NSArray * arr = [infodict objectForKey:@"defaults"];
	return [arr count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	NSDictionary * item = [items objectAtIndex:indexPath.row];
	NSString * itemtype = [item objectForKey:@"type"];
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ad"];
	if(!cell) cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,200,44)];
	if([itemtype isEqualToString:@"random"]) {
		[self setupRandomCell:cell withItem:item];
	}
	if([itemtype isEqualToString:@"direct"]) {
		[self setupDirectCell:cell withItem:item];
	}
	if([itemtype isEqualToString:@"input"]) {
		[self setupInputCell:cell withItem:item];
	}
	if([itemtype isEqualToString:@"local"]) {
		[self setupLocalCell:cell withItem:item];
	}
	return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	NSDictionary * item = [items objectAtIndex:indexPath.row];
	[[self parentViewController] dismissModalViewControllerAnimated:TRUE];
	[tableView deselectRowAtIndexPath:indexPath animated:FALSE];
	if(_delegate && [_delegate respondsToSelector:@selector(adInfoSelector:didChooseItem:)]) {
		[_delegate adInfoSelector:self didChooseItem:item];
	}
	if(checkedcell) [checkedcell setAccessoryType:UITableViewCellAccessoryNone];
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	checkedcell = cell;
}

- (void) setupInputCell:(UITableViewCell *) cell withItem:(NSDictionary *) item {
	NSString * label = [item objectForKey:@"label"];
	[[cell textLabel] setText:label];
}

- (void) setupLocalCell:(UITableViewCell *) cell withItem:(NSDictionary *) item {
	NSString * label = [item objectForKey:@"label"];
	[[cell textLabel] setText:label];
}

- (void) setupDirectCell:(UITableViewCell *) cell withItem:(NSDictionary *) item {
	NSString * label = [item objectForKey:@"label"];
	[[cell textLabel] setText:label];
}

- (void) setupRandomCell:(UITableViewCell *) cell withItem:(NSDictionary *) item {
	NSString * label = [item objectForKey:@"label"];
	[[cell textLabel] setText:label];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	checkedcell = cell;
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
	[infodata appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
	if(connection == infoconn) {
		loaded = true;
		SBJsonParser * json = [[SBJsonParser alloc] init];
		infodict = [[json objectWithData:infodata] retain];
		items = [[infodict objectForKey:@"defaults"] retain];
		[json release];
		if(showAfterLoad) [self loadTableData];
	}
}

- (void) dealloc {
	[super dealloc];
}

@end
