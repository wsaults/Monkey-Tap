//
//  AppDelegate.m
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Game.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [FlurryAnalytics startSession:@"QD7EZYI76HY5T9Q48L9A"];
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    timesPlayed = [[NSUserDefaults standardUserDefaults] integerForKey:kTimesPlayed];
	currentSkin = SKIN;
    
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
        //		CCLOG(@"Retina Display Not supported");
        
        //
        // VERY IMPORTANT:
        // If the rotation is going to be controlled by a UIViewController
        // then the device orientation should be "Portrait".
        //
        // IMPORTANT:
        // By default, this template only supports Landscape orientations.
        // Edit the RootViewController.m file to edit the supported orientations.
        //
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
        [director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu node]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	if ([self isGameScene]) {
        [(Game *)[[CCDirector sharedDirector] runningScene] pauseGame];
    } else 
    {
        [[CCDirector sharedDirector] pause]; 
    }	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (![self isGameScene]) {
        [[CCDirector sharedDirector] resume];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    CCLOG(@"applicationDidReceiveMemoryWarning");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)finishedWithScore:(int)score
{
    if (score > 0) {
        score += [self getTotalCoins];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kTotalCoinsKey];
    }
    if (score > [self getHighScore]) {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kHighScoreKey];
//        [wiz reportScore:score forLeaderboard:kHighScoreKey];
    }
    
    timesPlayed++;
    [[NSUserDefaults standardUserDefaults] setInteger:timesPlayed forKey:kTimesPlayed];
//    if (timesPlayed % 10 == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:kDidRate]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like MonkeyTap?" message:@"If you like MonkeyTap, please rate it to show your support." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate", nil];
//        [alert show];
//    }
}

- (int)getHighScore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey];
}

- (int)getTotalCoins
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kTotalCoinsKey];
}
#pragma mark -------

- (void)pause
{
    if (![self isGameScene]) {
        [[CCDirector sharedDirector] pause];
    }
}
- (void)resume
{
    if (![self isGameScene]) {
        [[CCDirector sharedDirector] resume];
    }
}

- (BOOL)isGameScene
{
    return [[[CCDirector sharedDirector] runningScene] isKindOfClass:[Game class]];
}

- (NSString *)getCurrentSkin
{
    return currentSkin;
}
- (void)setCurrentSkin:(NSString *)skin
{
    currentSkin = skin;
}

- (UIViewController *)getViewController
{
    return viewController;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return;
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@""]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidRate];
    
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end

