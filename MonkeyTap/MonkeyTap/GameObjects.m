//
//  GameObjects.m
//  MonkeyTap
//
//  Created by William Saults on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjects.h"
#import "Game.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation GameObjects

- (id)init
{
    self = [super init];
    if (self) {
        upTime = 2.0f;
        type = OBJECT_TYPE_A;
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)startWithType: (NSString *)t
{
    [self stopAllActions];
    isUp = YES;
    
    if ([type isEqualToString:OBJECT_TYPE_B]) {
        instanceUpTime = upTime * 1.25f;
    }
    else if ([type isEqualToString:OBJECT_TYPE_A]) {
        instanceUpTime = upTime;
    }
    else if ([type isEqualToString:OBJECT_TYPE_C]) {
        instanceUpTime = upTime * 1.5f;
    }
    
    didMiss = YES;
    type = t;
    self.scaleX = (CCRANDOM_0_1() >= .5) ? 1 : -1;
    
    CCSprite *sprite = [CCSprite spriteWithFile:@"Ball.png"];
    [self addChild:sprite];
    
//    [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:1 to:10] restoreOriginalFrame:NO]];
//    [self runAction:[CCSequence actions:
//                     [CCDelayTime actionWithDuration:instanceUpTime],
//                     [CCCallFunc actionWithTarget:self selector:@selector(stop)],
//                     nil]];
}

-(void)reset
{
    isUp = NO;
    
    if (didMiss) {
        [(Game *)self.parent missedObject];
    }
    
}

-(void)stopEarly
{
    didMiss = NO;
    [self stopAllActions];
    [self stop];
}

-(void)stop
{
    
}

-(BOOL)getIsUp
{
    return isUp;
}

-(void)wasTapped
{
    if (isUp) {
        [self stopAllActions];
        
        isUp = NO;
    }
}

-(NSString *)getType
{
    return type;
}

- (void)dealloc
{
    [super dealloc];
}

@end
