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
    }
    
    return self;
}

-(void)initializeGame
{
    
        [self startGame];
}

-(void)startGame
{
    [self schedule:@selector(tick:)];
}

-(void)tick: (ccTime)dt
{
    
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isPaused) {
        return;
    }
}

-(void)didScore
{
    score++;
    [scoreLabel setString:[NSString stringWithFormat:@"score:%i",score]];
}

-(void)gameOver
{
    
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

}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end