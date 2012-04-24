//
//  CCSprite+DisableTouch.m
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//

#import "CCSprite+DisableTouch.h"


@implementation CCSprite (DisableTouch)

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)disableTouch
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1000 swallowsTouches:YES];
}

-(void)enableTouch
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

@end
