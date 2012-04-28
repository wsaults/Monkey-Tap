//
//  Game.m
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
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
        
        livesLeft = 5;
        objectsAtOnce = 4;
        timeBetweenObjects = 0.5f;
        increaseObjectsAtTime = 10.0f;
        gameTime = 60.0f;
        
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
    
    //Shared frame cache
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [delegate getCurrentSkin]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
    
    lives = [[CCArray alloc] init];
    objects = [[CCArray alloc] init];
    
    float hPad = 25;
    float vPad = 30;
    
    for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 4; j++) {
            GameObjects *m = [GameObjects spriteWithFile:@"BallWhite.png"];
            m.position = ccp(j * (m.contentSize.width + 10) + hPad, i * (m.contentSize.height + 15)+ vPad);
            [objects addObject:m];
            [self addChild:m z:1];
        }
    }
    
    
    // Set the BG
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"game_bg.png"]];
//    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_bg.png", [delegate getCurrentSkin]]];
    bg.anchorPoint = ccp(0,0);
    [self addChild:bg z:-1];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    for (int i = 0; i < livesLeft; i++) {
        CCSprite *l = [CCSprite spriteWithSpriteFrameName:@"banana.png"];
        l.anchorPoint = ccp(1,1);
        l.position = ccp((s.width - i * l.contentSize.width) - l.contentSize.width/5, s.height-l.contentSize.height/4);
        [lives addObject:l];
        [self addChild:l z:10];
    }
    
    // Coin image
    CCSprite *coinImg = [CCSprite spriteWithFile:@"coin.png"]; // Use the following line if the coin.png is in the sprite sheet
//    CCSprite *coinImg = [CCSprite spriteWithSpriteFrameName:@"coin.png"];
    coinImg.anchorPoint = ccp(0,1);
    coinImg.position = ccp(1,s.height);
    coinImg.visible = NO;
    [self addChild:coinImg];
    
    // Create the score label in the top left of the screen
    fSize = 24;
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"0"] 
                                    fontName:@"CPMono_v07_Bold.otf" 
                                    fontSize:fSize];
    
    scoreLabel.anchorPoint = ccp(0,1);
    scoreLabel.position = ccp(1+coinImg.contentSize.width*1.8f,s.height-scoreLabel.contentSize.height/4);
    [self addChild:scoreLabel];
    
    timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.00f", gameTime] 
                                   fontName:@"CPMono_v07_Bold.otf"
                                   fontSize:fSize];
    
    timeLabel.anchorPoint = ccp(.5,1);
    timeLabel.position = ccp(s.width/2+timeLabel.contentSize.width/2.5, s.height-timeLabel.contentSize.height/4);
    [self addChild:timeLabel];
    
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
    
    int k = 0;
    
    // If score is greater than 200
    
    if (CCRANDOM_0_1() < .1 && score > 50) {
        // have a random chance for OBJECT_TYPE_B (p_bomb)
        k = 2;
    } else if (CCRANDOM_0_1() < .07) {
        // have a random chance for OBJECT_TYPE_C (l_bomb)
        k = 3;
        
    } else if (CCRANDOM_0_1() < .05 && livesLeft < 3) {
        // have a random chance for OBJECT_TYPE_D (banana)
        //k = 4;
        
    } else if (gameTime < 45.00f && CCRANDOM_0_1() < .05) {
        // If there is less than 45 seconds on the clock then
        // have a randome chance or a clock bonus OBJECT_TYPE_E
        // k = 5
    } else {
        
    }
    
    switch (k) {
            
        case 2:
            // Point bomb
            nextObjectType = OBJECT_TYPE_B;
            break;
            
        case 3:
            // Life bomb
            nextObjectType = OBJECT_TYPE_C;
            break;
            
        case 4:
            // Banana
            nextObjectType = OBJECT_TYPE_D;
            break;
            
        case 5:
            // Clock
            nextObjectType = OBJECT_TYPE_E;
            break;
            
        default:
            // Monkey
            nextObjectType = OBJECT_TYPE_A;
            break;
    }
    
    [self showObject];
}

-(void)tick: (ccTime)dt
{
    if (!isPaused) {
        
        timeElapsed += dt;
        
        if (gameTime > 0) {
            gameTime -= dt;
        }
        
        if (gameTime <= 0) {
            [timeLabel setVisible:NO];
            [self gameOver];
        }
        
        [timeLabel setString:[NSString stringWithFormat:@"%.00f",gameTime]];
        
        increaseElapsed += dt;
        if(timeElapsed >= timeBetweenObjects)
        {
            [self chooseWhichObjectToMake];
            timeElapsed = 0;
        }
        if (increaseElapsed >= increaseObjectsAtTime) {
            int maxObjectsAtOnce = 10;
            if (objectsAtOnce < maxObjectsAtOnce) {
                objectsAtOnce++;
                float minObjectTime = .1f;
                timeBetweenObjects -= (timeBetweenObjects > minObjectTime) ? 0.03f : 0;
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
    
    [self reduceLives];
    
    for (GameObjects *object in [self getUpObjects]) {
        [object stopEarly];
    }
}

-(void)reduceLives
{
    [self resetCount];
    livesLeft--;
    // Play sound
    if([lives count] > 0)
    {
        [self removeChild:[lives objectAtIndex:[lives count] - 1] cleanup:YES];
        [lives removeLastObject];
    }
    
    if(livesLeft <= 0)
    {
        [self gameOver];
    }
}

-(void)deductPoints
{
    // Point bomb was tapped
    
    if (score >= 50) {
        [self setScore:-50];
        [self resetCount];
    }
}

-(void)resetCount
{
    count = 0;
    // Set multiplyer image to X1
}

-(void)setScore:(int)i
{
    score += i;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
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
                bool p_bombWasWhacked = ([[object getType] isEqualToString:OBJECT_TYPE_B]);
                bool l_bombWasWhacked = ([[object getType] isEqualToString:OBJECT_TYPE_C]);
                if (monkeyWasWhacked) {
                    [object wasTapped:count];
                    [self didScore];
                    // Play a sound here... eg. splat!
                } else if (p_bombWasWhacked) {
                    [object wasTapped:count];
                    [self deductPoints];
                } else if (l_bombWasWhacked) {
                    [object wasTapped:count];
                    [self reduceLives];
                }
            }
        }
    }
    if ([objectsTappedAtOnce count] > 1) {
        for (GameObjects *object in objectsTappedAtOnce) {
            [object wasTapped:count];
            [self didScore];
        }
        // Play a sound here... eg. splat!
    }
    [objectsTappedAtOnce removeAllObjects];
}

-(void)didScore
{
    count++;
//    CCLOG(@"Count: %d", count);
    if (count <= 29) {
        // Set multiplyer image to X1
        [self setScore:1];
    } else if (count >= 30 && count <= 59) {
        // Set multiplyer image to X2
        [self setScore:2];
    } else if (count >= 60 && count <= 89) {
        // Set multiplyer image to X3
        [self setScore:3];
    } else if (count >= 90 && count <= 119) {
        // Set multiplyer image to X4
        [self setScore:4];
    } else if (count >= 120 && count <= 149) {
        // Set multiplyer image to X5
        [self setScore:5];
    } else if (count >= 150) {
        // Set multiplyer image to X6
        [self setScore:6];
    }
    
    // score % 30 = number of units to fill multiplier bar.
    /* if (score >= 150) {
     *      score bar stays full
     * } else {
     *      score bar is full number of units = score % 30
     * }
     */
}

-(void)gameOver
{
    // If time or life reaches 0 then gameOver
    CCLOG(@"GAME OVER!");
    
    for (GameObjects *m in objects) {
        [m stopAllActions];
        [m unscheduleAllSelectors];
    }
    [delegate finishedWithScore:score];
    [self unscheduleAllSelectors];
    
    // Stop BG music
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
    [lives release];
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