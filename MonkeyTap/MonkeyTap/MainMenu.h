//
//  MainMenu.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "CCScene.h"

@class AppDelegate;

@interface MainMenu : CCScene {
    AppDelegate *delegate;
}

- (void)intro;
- (void)playGame;
- (void)showFreeCoins;
- (void)showLeaderboard;
- (void)showAchievements;
- (void)finish;

@end

