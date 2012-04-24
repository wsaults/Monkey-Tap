//
//  PopUp.h
//  MonkeyTap
//
//  Created by William Saults on 4/18/12.
//  Copyright UTVCA 2012. All rights reserved.
//

@interface PopUp : CCSprite {
    CCSprite *window,*bg;
    CCNode *container;
}

+(id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite;
- (id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite;

-(void)closePopUp;

@end
