//
//  MainMenu.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "GameButton.h"
#import "CCMenuPopup.h"

@implementation MainMenu

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[Game node]];
}


-(void)selectSkin
{
}

-(void)otherGames
{
    
}


- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
