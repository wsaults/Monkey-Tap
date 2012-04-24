//
//  Game.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "GameObjects.h"

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
    
    CCArray *objects;
    CCLabelBMFont *scoreLabel;
    
    int count, score, numberOfObjects, maxNumberOfObjects, fSize, objectsAtOnce;
    float timeBetweenObjects, timeElapsed, increaseObjectsAtTime, increaseElapsed, lastObjectHitTime, totalTime;
    CGSize s;
    bool isPaused;
    NSString *nextObjectType;
    
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

-(void)showObject;
-(int)getObjectsUp;
-(void)missedObject;
-(NSArray *)getUpObjects;
-(NSArray *)getDownObjects;
-(void)chooseWhichObjectToMake;

@end
