//
//  GameObjects.m
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
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
        upTime = 2.5f;
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
    
    if ([type isEqualToString:OBJECT_TYPE_B]) {         // point bomb
        instanceUpTime = upTime * 1.25f;
        
    } else if ([type isEqualToString:OBJECT_TYPE_A]) {  // monkey
        instanceUpTime = upTime;
        
    } else if ([type isEqualToString:OBJECT_TYPE_C]) {  // life bomb
        instanceUpTime = upTime * 1.25f;
        
    } else if ([type isEqualToString:OBJECT_TYPE_D]) {  // banana
        instanceUpTime = upTime * 1.5f;
        
    } else if ([type isEqualToString:OBJECT_TYPE_E]) {  // clock
        instanceUpTime = upTime * 1.5f;
    }
    
    didMiss = YES;
    type = t;

    
    // These three lines creates the sprite
//    CCSprite *sprite = [CCSprite spriteWithFile:@"monkey.png"];
//    sprite.anchorPoint = ccp(0,0);
//    [self addChild:sprite z:1 tag:6];
    
    [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:0 to:10] restoreOriginalFrame:NO]];
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:instanceUpTime],
                     [CCCallFunc actionWithTarget:self selector:@selector(stop)],
                     nil]];
}

-(void)reset
{
    isUp = NO;
    
    if ([type isEqualToString:OBJECT_TYPE_A]) {
        if (didMiss) {
            [(Game *)self.parent missedObject];
        }
    } else if ([type isEqualToString:OBJECT_TYPE_B]){
    } else {
        
    }
    
}

-(void)doNothing
{
    // Don't do anything
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
                    [CCAnimate actionWithAnimation:[self reverseAnimationWithFrames:10 to:0] restoreOriginalFrame:NO],
                    [CCCallFunc actionWithTarget:self selector:@selector(reset)],
                    nil]];
}

-(BOOL)getIsUp
{
    return isUp;
}

-(void)wasTapped:(int)c
{
    if (isUp) {
        [self stopAllActions];
        
        if ([type isEqualToString:OBJECT_TYPE_B] || [type isEqualToString:OBJECT_TYPE_C]){ // if its a bomb
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:11 to:21] restoreOriginalFrame:NO]];
            isUp = NO;
            return;
        }
        
        
        if (c <= 29) {
            // Set multiplyer image to +10
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:11 to:21] restoreOriginalFrame:NO]];
        } else if (c >= 30 && c <= 59) {
            // Set multiplyer image to +20
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:22 to:32] restoreOriginalFrame:NO]];
        } else if (c >= 60 && c <= 89) {
            // Set multiplyer image to +30
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:33 to:43] restoreOriginalFrame:NO]];
        } else if (c >= 90 && c <= 119) {
            // Set multiplyer image to +40
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:44 to:54] restoreOriginalFrame:NO]];
        } else if (c >= 120 && c <= 149) {
            // Set multiplyer image to +50
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:55 to:65] restoreOriginalFrame:NO]];
        } else if (c >= 150) {
            // Set multiplyer image to +60
            [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:66 to:76] restoreOriginalFrame:NO]];
        }
        
        
//        [self runAction:[CCAnimate actionWithAnimation:[self reverseAnimationWithFrames:10 to:0] restoreOriginalFrame:NO]];
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
