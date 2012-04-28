//
//  AppDelegate.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAnalytics.h"
#import "GKWizard.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    BOOL hasPlayedBefore;
    NSString *currentSkin;
    int timesPlayed,currentAction;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

- (void)finishedWithScore:(double)score;
- (double)getHighScore;
- (double)getTotalCoins;
- (void)pause;
- (void)resume;
- (BOOL)isGameScene;
- (NSString *)getCurrentSkin;
- (UIViewController *)getViewController;

@end