//
//  MainMenu.m
//  catnmouse
//
//  Created by William Saults on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "CCMenuPopup.h"

@implementation MainMenu

- (id)init 
{
    if((self = [super init])) {
        // Initiliaztion code here.
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Create the HighScore label in the top left corner
        int fSize = 18;
        CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Coins: %d", [delegate getHighScore]] fontName:@"SF_Cartoonist_Hand_Bold.ttf" fontSize:fSize];
        highScore.anchorPoint = ccp(0,1);
        highScore.position = ccp(1,s.height);
        [self addChild:highScore];
        
#pragma mark - Play
        // Play button
        CCSprite *bigButton = [CCSprite spriteWithFile:@"button_big.png"];
        CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:bigButton 
                                                               selectedSprite:NULL 
                                                                       target:self 
                                                                     selector:@selector(playGame)];
        // Play button menu
        CCMenu *mainPlay = [CCMenu menuWithItems:playButton, nil];
        mainPlay.position = ccp(s.width/2,s.height/2 - s.height/8.5f);
        [self addChild:mainPlay];
        
#pragma mark - Free coins
        // Free Coins button
        CCSprite *freeCoinsButtonSprite = [CCSprite spriteWithFile:@"button_small.png"];
        CCMenuItemSprite *freeCoinsButton = [CCMenuItemSprite itemFromNormalSprite:freeCoinsButtonSprite 
                                                                    selectedSprite:NULL
                                                                            target:self selector:@selector(showFreeCoins)];
        // Free coins menu
        CCMenu *freeCoinsMenu = [CCMenu menuWithItems:freeCoinsButton, nil];
        freeCoinsMenu.position = ccp(s.width/2, s.height/5.5f);
        [self addChild:freeCoinsMenu];
        
#pragma mark - Leaderboard, achievements, and store
        /*
         * Group the next two buttons in a menu
         */
        // Add Leaderboard button
        CCSprite *leaderboardButtonSprite = [CCSprite spriteWithFile:@"button_small.png"];
        CCMenuItemSprite *leaderboardsButton = [CCMenuItemSprite itemFromNormalSprite:leaderboardButtonSprite
                                                                       selectedSprite:NULL 
                                                                               target:self 
                                                                             selector:@selector(showLeaderboard)];
        
        // Add Achievements button
        CCSprite *achievementsButtonSprite = [CCSprite spriteWithFile:@"button_small.png"];
        CCMenuItemSprite *achievementsButton = [CCMenuItemSprite itemFromNormalSprite:achievementsButtonSprite
                                                                       selectedSprite:NULL 
                                                                               target:self 
                                                                             selector:@selector(showAchievements)];
        
        //        // Store button
        //        CCSprite *storeButtonSprite = [CCSprite spriteWithFile:@"button_small.png"];
        //        CCMenuItemSprite *storeButton = [CCMenuItemSprite itemFromNormalSprite:storeButtonSprite 
        //                                                                selectedSprite:NULL
        //                                                                        target:self selector:@selector(showStore)];
        
        // Add the leaderboard button and achievements button to a menu
        CCMenu *menu = [CCMenu menuWithItems:leaderboardsButton, achievementsButton, nil];
        [menu alignItemsHorizontallyWithPadding:20];
        menu.position = ccp(s.width/2, 20);
        [self addChild:menu];
        
        // BG
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        CCSprite *bg = [CCSprite spriteWithFile:@"monkey_bg.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
    }
    return self;
}

- (void)intro 
{
    
}

- (void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

- (void)showFreeCoins
{
    // Popup alert from the delegate asking user to complete some task and earn coins
}

- (void)showLeaderboard
{
    //    [delegate showLeaderboard];
}

- (void)showAchievements
{
    //    [delegate showAchievements];
}

- (void)finish {
    
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
