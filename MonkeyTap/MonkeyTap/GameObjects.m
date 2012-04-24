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

-(CCAnimation *)getAnimationWithFrames: (int)from to:(int)to
{
    NSMutableArray *anim = [[NSMutableArray alloc] init];
    for (int i = from; i <= to; i++) {
        NSString *frame = [NSString stringWithFormat:@"%@_%i.png",type, i];
        [anim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frame]];
    }
    CCAnimation *a = [CCAnimation animationWithFrames:anim delay:1.0f/24.0f];
    return a;
}

-(CCAnimation *)reverseAnimationWithFrames: (int)from to:(int)to
{
    NSMutableArray *anim = [[NSMutableArray alloc] init];
    for (int i = from; i >= to; i--) {
        NSString *frame = [NSString stringWithFormat:@"%@_%i.png",type, i];
        [anim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frame]];
    }
    CCAnimation *a = [CCAnimation animationWithFrames:anim delay:1.0f/24.0f];
    return a;
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

    
    // These three lines creates the sprite
//    CCSprite *sprite = [CCSprite spriteWithFile:@"monkey.png"];
//    sprite.anchorPoint = ccp(0,0);
//    [self addChild:sprite z:1 tag:6];
    
    [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:1 to:10] restoreOriginalFrame:NO]];
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:instanceUpTime],
                     [CCCallFunc actionWithTarget:self selector:@selector(stop)],
                     nil]];
}

-(void)reset
{
    isUp = NO;
    
    if (didMiss) {
        [self removeChildByTag:6 cleanup:YES];
        [(Game *)self.parent missedObject];
    }
    
}

-(void)stopEarly
{
    didMiss = NO;
    
    // Uncomment the following line to remove all sprites when one is missed.
//    [self removeAllChildrenWithCleanup:YES];
    [self stopAllActions];
    [self stop];
}

-(void)stop
{
    // The following line removes the sprite when missed.
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:[self reverseAnimationWithFrames:10 to:1] restoreOriginalFrame:NO],
                     [CCCallFunc actionWithTarget:self selector:@selector(reset)],
                     nil]];
}

-(BOOL)getIsUp
{
    return isUp;
}

-(void)wasTapped
{
    if (isUp) {
        [self stopAllActions];
//        [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:11 to:21] restoreOriginalFrame:NO]];
        [self runAction:[CCAnimate actionWithAnimation:[self reverseAnimationWithFrames:10 to:1] restoreOriginalFrame:NO]];
        // The following line removes the sprite when tapped.
//        [self removeChildByTag:6 cleanup:YES];
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
