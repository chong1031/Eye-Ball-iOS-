//
//  GamePlayScene.h
//  Goggle Ball
//
//  Created by Superstar on 11/3/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class TableViewController;

@interface GamePlayScene : CCLayer {

    TableViewController *tableViewController;
    
    CGSize size;
    CCMenuItemImage *stopItem;
    CCMenuItemImage *back_btn;
    CCMenuItemImage *slowBall;
    CCSprite *throwSpr;
    CCSprite *leftTarget;
    CCSprite *rightTarget;
    CCSprite *leftEye;
    CCSprite *rightEye;
    CCLabelTTF *leftscore_label;
    CCLabelTTF *rightscore_label;
    int leftmoving_angle;
    int rightmoving_angle;
    int left_countflag;
    int right_countflag;
    int gamerun_flag, throw_index;
    int left_score, right_score;
    int slowball_speed;
    int purchasedSlowBalls;
}

// returns a CCScene that contains the MenuScene as the only child
+(CCScene *) scene;

-(int) getRandomLeft:(float)posX andPox:(float)posY;
-(int) getRandomRight:(float)posX andPox:(float)posY;

@end
