//
//  GKWizard.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GKWizard : NSObject {
    BOOL isLoggedinToGC;
    int highScore;
}


-(void)reportScore: (int)score forLeaderboard:(NSString *)leaderboard;
-(bool) isGameCenterAvailable;
- (void) authenticateLocalPlayer;
-(int)getHighScore;

@end
