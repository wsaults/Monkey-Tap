//
//  Game.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "Game.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "CCMenuPopup.h"

@implementation Game

@synthesize state = _state;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        objectsAtOnce = 4;
        timeBetweenObjects = 0.5f;
        increaseObjectsAtTime = 10.f;
        
        // Add at end of init
        self.state = kGameStatePlaying;
    }
    
    return self;
}

-(void)initializeGame
{
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[CCDirector sharedDirector] resume];
    s = [[CCDirector sharedDirector] winSize];
    
    // Add sounds here:
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [delegate getCurrentSkin]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];

    
    objects = [[CCArray alloc] init];
    
    float hPad = 0;
    float vPad = 40;
    
    for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 4; j++) {
            GameObjects *m = [GameObjects spriteWithFile:@"BallWhite.png"];
            m.position = ccp(j * (m.contentSize.width + 5) + hPad, i * (m.contentSize.height + 10)+ vPad);
            [objects addObject:m];
            [self addChild:m z:1];
        }
    }
    
    
    // Set the BG
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg.png"]];
//    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_bg.png", [delegate getCurrentSkin]]];
    bg.anchorPoint = ccp(0,0);
    [self addChild:bg z:-1];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // Create the score label in the top left of the screen
    fSize = 18;
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins:0"] 
                                    fontName:@"SF_Cartoonist_Hand_Bold.ttf" 
                                    fontSize:fSize];
    
    scoreLabel.anchorPoint = ccp(0,1);
    scoreLabel.position = ccp(1,s.height);
    [self addChild:scoreLabel];
    
    [self startGame];
}

-(void)startGame
{
    [self schedule:@selector(tick:)];
}

-(void)chooseWhichObjectToMake
{
    if ([self getObjectsUp] >= objectsAtOnce) {
        return;
    }
    nextObjectType = @"a";
    
    [self showObject];
}

-(void)tick: (ccTime)dt
{
    if (!isPaused) {
        // Time remaing = 60 seconds - totalTime
        
        timeElapsed += dt;
        increaseElapsed += dt;
        if(timeElapsed >= timeBetweenObjects)
        {
            [self chooseWhichObjectToMake];
            timeElapsed = 0;
        }
        if (increaseElapsed >= increaseObjectsAtTime) {
            int maxObjectsAtOnce = 18;
            if (objectsAtOnce < maxObjectsAtOnce) {
                objectsAtOnce++;
                float minObjectTime = .1f;
                timeBetweenObjects -= (timeBetweenObjects > minObjectTime) ? 0.05f : 0;
                increaseObjectsAtTime += 10.0f;
            }
        }
    }
    
}

-(void)showObject
{
    GameObjects *object = [[CCArray arrayWithNSArray:[self getDownObjects]] randomObject];
    [object startWithType:nextObjectType];
}

-(NSArray *)getDownObjects
{
    NSMutableArray *downObjects = [[NSMutableArray alloc] init];
    for (GameObjects *m in objects) {
        if (![m getIsUp]) {
            [downObjects addObject:m];
        }
    }
    return downObjects;
}

-(NSArray *)getUpObjects
{
    NSMutableArray *upObjects = [[NSMutableArray alloc] init];
    for (GameObjects *m in objects) {
        if ([m getIsUp]) {
            [upObjects addObject:m];
        }
    }
    return upObjects;
}

-(int)getObjectsUp 
{
    int upObjects = 0;
    for (GameObjects *object in objects) {
        if ([object getIsUp]) {
            upObjects++;
        }
    }
    return upObjects;
}
-(void)missedObject {
    
    // What do you want to do when the object vanishes?
    
    // Play sound
    
    // Deduct points?
    
    for (GameObjects *object in [self getUpObjects]) {
        [object stopEarly];
    }
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isPaused) {
        return;
    }
    NSMutableArray *objectsTappedAtOnce = [[NSMutableArray alloc] init];
    for (UITouch *touch in [event allTouches]) {
        for (GameObjects *object in objects) {
            CGPoint location = [touch locationInView:touch.view];
            location = [[CCDirector sharedDirector] convertToGL:location];
            if (CGRectContainsPoint([object boundingBox], location)) {
                if (![object getIsUp] || [objectsTappedAtOnce containsObject:object]) {
                    continue;
                }
                
                bool monkeyWasWhacked = ([[object getType] isEqualToString:OBJECT_TYPE_A]);
                if (monkeyWasWhacked) {
                    [object wasTapped];
                    [self didScore];
                    // Play a sound here... eg. splat!
                }
            }
        }
    }
    if ([objectsTappedAtOnce count] > 1) {
        for (GameObjects *object in objectsTappedAtOnce) {
            [object wasTapped];
            [self didScore];
        }
        // Play a sound here... eg. splat!
    }
    [objectsTappedAtOnce removeAllObjects];
}

-(void)didScore
{
    score++;
    [scoreLabel setString:[NSString stringWithFormat:@"Coins:%i",score]];
}

-(void)gameOver
{
    // If time reaches 0 then gameOver
    
    for (GameObjects *m in objects) {
        [m stopAllActions];
        [m unscheduleAllSelectors];
    }
    
    [delegate finishedWithScore:score];
    [self unscheduleAllSelectors];
    
    // Play a sound
    
//    CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"play again"] selectedSprite:NULL target:self selector:@selector(playAgain)];
//    CCMenuItemSprite *mainButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"main menu"] selectedSprite:NULL target:self selector:@selector(mainMenu)];
//    CCMenuPopup *menu = [CCMenuPopup menuWithItems:playAgainButton,mainButton, nil];
//    [menu alignItemsHorizontallyWithPadding:10];
//    PopUp *pop = [PopUp popUpWithTitle:@"-game over-" description:@"" sprite:menu];
//    [self addChild:pop z:1000];
}


-(void)pauseGame
{
    if(isPaused)
    {
        return;
    }
    
    [self unschedule:@selector(tick:)];
    isPaused = YES;
}
-(void)resumeGame
{
    [self schedule:@selector(tick:)];
    isPaused = NO;
}

-(void)mainMenu
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

-(void)playAgain
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[[self class] node]];
}

-(void)onEnterTransitionDidFinish
{
    [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    [[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
    [self initializeGame];
}

-(void)onExit
{
    [objects release];
    // Unload sounds here
    [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end