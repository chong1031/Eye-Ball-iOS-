//
//  MenuScene.h
//  Goggle Ball
//
//  Created by Superstar on 11/2/15.
//  Copyright Superstar 2015. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MenuScene
@interface MenuScene : CCLayer <UIAlertViewDelegate>
{
    CCMenuItemImage *registerItem;
}

// returns a CCScene that contains the MenuScene as the only child
+(CCScene *) scene;

@end
