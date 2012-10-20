
#import "ScrambledSounds.h"

SystemSoundID finished;
SystemSoundID shuffled;
SystemSoundID tilemove;

@implementation ScrambledSounds

+ (void) initialize {
	NSString * sound = NULL;
	NSURL * surl = NULL;
	
	//finished
	sound = [[NSBundle mainBundle] pathForResource:@"sound_win" ofType:@"aiff"];
	surl = [NSURL fileURLWithPath:sound isDirectory:NO];
	AudioServicesCreateSystemSoundID((CFURLRef)surl,&finished);
	
	//shuffled
	sound = [[NSBundle mainBundle] pathForResource:@"sound_shuffle" ofType:@"aif"];
	surl = [NSURL fileURLWithPath:sound isDirectory:NO];
	AudioServicesCreateSystemSoundID((CFURLRef)surl,&shuffled);
	
	//tile moved
	sound = [[NSBundle mainBundle] pathForResource:@"sound_tilemove" ofType:@"aif"];
	surl = [NSURL fileURLWithPath:sound isDirectory:NO];
	AudioServicesCreateSystemSoundID((CFURLRef)surl,&tilemove);
}

+ (void) shuffle {
	AudioServicesPlaySystemSound(shuffled);
}

+ (void) finished {
	AudioServicesPlaySystemSound(finished);
}

+ (void) tilemove {
	AudioServicesPlaySystemSound(tilemove);
}

@end
