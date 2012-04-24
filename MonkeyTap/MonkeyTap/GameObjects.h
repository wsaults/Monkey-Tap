//
//  GameObjects.h
//  MonkeyTap
//
//  Created by William Saults on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@class AppDelegate;

@interface GameObjects : CCSprite {
    bool isUp, didMiss;
    float instanceUpTime,upTime;
    NSString *type;
    AppDelegate *delegate;
}

-(void)wasTapped;
-(BOOL)getIsUp;
-(CCAnimation *)getAnimationWithFrames: (int)from to:(int)to;
-(CCAnimation *)reverseAnimationWithFrames: (int)from to:(int)to;
-(void)startWithType: (NSString *)t;
-(void)stop;
-(void)stopEarly;
-(void)reset;
-(NSString *)getType;

@end
