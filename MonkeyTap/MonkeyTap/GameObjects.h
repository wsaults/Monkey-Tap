//
//  GameObjects.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//

#import "CCSprite.h"
#import "Game.h"

@class AppDelegate;

@interface GameObjects : CCSprite {
    bool isUp, didMiss;
    float instanceUpTime,upTime;
    NSString *type;
    AppDelegate *delegate;
}

-(void)wasTapped:(int)c;
-(BOOL)getIsUp;
-(CCAnimation *)getAnimationWithFrames: (int)from to:(int)to;
-(CCAnimation *)reverseAnimationWithFrames: (int)from to:(int)to;
-(void)startWithType: (NSString *)t;
-(void)stop;
-(void)stopEarly;
-(void)reset;
-(NSString *)getType;

@end
