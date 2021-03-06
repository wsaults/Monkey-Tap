//
//  Game.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
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
    
    CCArray *objects, *lives;
    CCLabelBMFont *scoreLabel, *timeLabel;
    
    int count, score, numberOfObjects, maxNumberOfObjects, fSize, objectsAtOnce, livesLeft;
    float timeBetweenObjects, timeElapsed, increaseObjectsAtTime, increaseElapsed, lastObjectHitTime, totalTime, gameTime;
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
-(void)reduceLives;
-(void)deductPoints;
-(void)resetCount;
-(void)setScore:(int)i;
-(NSArray *)getUpObjects;
-(NSArray *)getDownObjects;
-(void)chooseWhichObjectToMake;

@end
