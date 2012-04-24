//
//  CCSprite+DisableTouch.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//


@interface CCSprite (DisableTouch) <CCTargetedTouchDelegate>  {
    
}

-(void)disableTouch;
-(void)enableTouch;

@end
