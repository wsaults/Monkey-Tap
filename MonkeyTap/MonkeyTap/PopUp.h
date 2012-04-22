//
//  PopUp.h
//  Mole It
//
//  Created by Todd Perkins on 7/29/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "cocos2d.h"

@interface PopUp : CCSprite {
    CCSprite *window,*bg;
    CCNode *container;
}

+(id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite;
- (id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite;

-(void)closePopUp;

@end
