//
//  Game.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

enum GameStatePP {
    kGameStatePlaying,
    kGameStatePaused
};

@class AppDelegate,Mole;

@interface Game : CCScene <CCStandardTouchDelegate> {
    
    // Add inside @interface
    RootViewController *viewController;
    
    enum GameStatePP _state;
    
    AppDelegate *delegate;
    
    CCArray *moles;
    CCLabelBMFont *scoreLabel;
    int score;
    CGSize s;
    bool isPaused;
    CCMenuItemSprite *pauseButton;
}

@property(nonatomic) enum GameStatePP state;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)didScore;
-(void)pauseGame;
-(void)resumeGame;
-(void)startGame;
-(void)initializeGame;
-(void)mainMenu;
-(void)playAgain;
-(void)gameOver;

@end
