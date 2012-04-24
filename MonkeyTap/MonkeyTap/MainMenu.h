//
//  MainMenu.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
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

