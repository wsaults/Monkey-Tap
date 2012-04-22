//
//  Game.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "cocos2d.h"

@class AppDelegate,Mole;

@interface Game : CCScene <CCStandardTouchDelegate> {
    CCArray *moles;
    CCLabelBMFont *scoreLabel;
    int score;
    CGSize s;
    bool isPaused;
    AppDelegate *delegate;
    CCMenuItemSprite *pauseButton;
}

-(void)didScore;
-(void)pauseGame;
-(void)resumeGame;
-(void)startGame;
-(void)initializeGame;
-(void)mainMenu;
-(void)playAgain;
-(void)gameOver;

@end
