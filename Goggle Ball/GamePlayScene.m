//
//  GamePlayScene.m
//  Goggle Ball
//
//  Created by Superstar on 11/3/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "GamePlayScene.h"
#import "MenuScene.h"
#import "GameInstruction.h"
#import "GamePurchase.h"
#import "HighScoreScene.h"
#import "TableViewController.h"
#import "SimpleAudioEngine.h"
#import "Define.h"

@implementation GamePlayScene

// Helper class method that creates a Scene with the MenuScene as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GamePlayScene *layer = [GamePlayScene node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        // ask director for the window size
        size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize the main background
        CCSprite *backSpr = [CCSprite spriteWithFile:@"gameplay_bg.png"];
        backSpr.position = ccp(size.width/2, size.height/2);
        backSpr.scaleX = size.width / [backSpr boundingBox].size.width;
        backSpr.scaleY = size.height / [backSpr boundingBox].size.height;
        
        [self addChild:backSpr];
        
//        CCSprite *playBackSpr = [CCSprite spriteWithFile:@"play_bg.png"];
//        playBackSpr.position = ccp(size.width/2, size.height/2);
//        playBackSpr.scaleX = size.width / [playBackSpr boundingBox].size.width;
//        playBackSpr.scaleY = size.height / [playBackSpr boundingBox].size.height;
//        
//        [self addChild:playBackSpr];
        
        // create and initialize the back item.
        back_btn = [CCMenuItemImage itemWithNormalImage:@"back1.png"
                                                           selectedImage:@"back2.png"
                                                                  target:self
                                                                selector:@selector(goMenuScene)];
        back_btn.position = ccp([back_btn boundingBox].size.width/3*2, [back_btn boundingBox].size.height/3*2);
        back_btn.scale = 0.8;
        
        // create and initialize the score display item.
        CCMenuItemImage *leftScore = [CCMenuItemImage itemWithNormalImage:@"score_btn_left.png"
                                                            selectedImage:@"score_btn_left.png"];
        leftScore.position = ccp(size.width/7, size.height/8*7);
        leftScore.scale = 0.5f;
        
        CCMenuItemImage *rightScore = [CCMenuItemImage itemWithNormalImage:@"score_btn_right.png"
                                                             selectedImage:@"score_btn_right.png"];
        rightScore.position = ccp(size.width/7*6, size.height/8*7);
        rightScore.scale = 0.5f;
        
        slowBall = [CCMenuItemImage itemWithNormalImage:@"useslowballs_normal.png"
                                                           selectedImage:@"useslowballs_pressed.png"
                                                                  target:self
                                                                selector:@selector(useSlowBalls)];
        slowBall.position = ccp(size.width/2, size.height/12);
        slowBall.scale = 0.5f;
        
        stopItem = [CCMenuItemImage itemWithNormalImage:@"start_btn.png"
                                          selectedImage:@"start_btn.png"
                                                 target:self
                                               selector:@selector(stopGame)];
        stopItem.anchorPoint = ccp(0, 0);
        stopItem.position = ccp(size.width * 605/1322, size.height * 226/746);
        stopItem.scaleX = backSpr.scaleX;
        stopItem.scaleY = backSpr.scaleY;
        
        CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.4 scale:1.03];
        CCScaleTo *scale2 = [CCScaleTo actionWithDuration:0.3 scale:1];
        
        id action = [CCSequence actions:scale1, scale2, nil];
        [stopItem runAction:[CCRepeatForever actionWithAction:action]];
        
        CCMenu *menu = [CCMenu menuWithItems:leftScore, rightScore, slowBall, stopItem, back_btn, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
        // create and initialize the throw background.
        CCSprite *throwBg = [CCSprite spriteWithFile:@"throw_background.png"];
        throwBg.position = ccp(size.width/2, size.height/8*7);
        [self addChild:throwBg z:2];
        
        // create and initialize the throw sprite.
        throwSpr = [CCSprite spriteWithFile:@"number_1.png"];
        throwSpr.position = throwBg.position;
        [self addChild:throwSpr z:3];
        
        // create and initialize the score label.
        leftscore_label = [CCLabelTTF labelWithString:@"0"
                                             fontName:@"Marker Felt"
                                             fontSize:18];
        leftscore_label.position = ccp(leftScore.position.x + 15, leftScore.position.y);
        [self addChild:leftscore_label];
        
        rightscore_label = [CCLabelTTF labelWithString:@"0"
                                              fontName:@"Marker Felt"
                                              fontSize:18];
        rightscore_label.position = ccp(rightScore.position.x - 15, rightScore.position.y);
        [self addChild:rightscore_label];
        
        // create and initialize the left target
        leftTarget = [CCSprite spriteWithFile:@"play_target.png"];
        leftTarget.position = ccp(size.width/4, size.height/2 - 10.0f);
        
        [self addChild:leftTarget z:2];
        
        leftEye = [CCSprite spriteWithFile:@"fly_eye.png"];
        leftEye.position = ccp(leftTarget.position.x, leftTarget.position.y);
        
        [self addChild:leftEye z:3];
        
        
        // create and initialize the right target
        rightTarget = [CCSprite spriteWithFile:@"play_target.png"];
        rightTarget.position = ccp(size.width/4*3, leftTarget.position.y);
        
        [self addChild:rightTarget z:2];
        
        rightEye = [CCSprite spriteWithFile:@"fly_eye.png"];
        rightEye.position = ccp(rightTarget.position.x, rightTarget.position.y);
        
        [self addChild:rightEye z:3];

        leftmoving_angle = 45;
        rightmoving_angle = 225;
        left_countflag = 0;
        right_countflag = 0;
        gamerun_flag = 0;       // game ready state.
        throw_index = 0;
        left_score = 0;
        right_score = 0;
        slowball_speed = 100;
        purchasedSlowBalls = 4;
        
        // create the eye fly animation.
        [[CCDirector sharedDirector] setAnimationInterval:1.0/10000.0];
    }
    
    return self;
}

-(void) flyLeftEye
{
    float left_stepX = cosf(leftmoving_angle * M_PI/180) * 10;
    float left_stepY = sinf(leftmoving_angle * M_PI/180) * 10;
    
    float right_stepX = cosf(rightmoving_angle * M_PI/180) * 10;
    float right_stepY = sinf(rightmoving_angle * M_PI/180) * 10;

    leftEye.position = ccp(leftEye.position.x + left_stepX, leftEye.position.y + left_stepY);
    rightEye.position = ccp(rightEye.position.x + right_stepX, rightEye.position.y + right_stepY);
    
    NSLog(@"%ff %f", [leftTarget boundingBox].size.width, [rightTarget boundingBox].size.width);

    if (pow(leftEye.position.x - leftTarget.position.x, 2) + pow(leftEye.position.y - leftTarget.position.y, 2) >
        pow([leftTarget boundingBox].size.width/2 - [leftEye boundingBox].size.width/2, 2)) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"spinning.mp3"];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5];

        NSLog(@" %f", pow([leftTarget boundingBox].size.width/2 - [leftEye boundingBox].size.width/2, 2));
        leftmoving_angle = [self getRandomLeft:leftEye.position.x andPox:leftEye.position.y];
        left_countflag = 0;
    }
    
    if (pow(rightEye.position.x - rightTarget.position.x, 2) + pow(rightEye.position.y - rightTarget.position.y, 2) >
        pow([rightTarget boundingBox].size.width/2 - [rightEye boundingBox].size.width/2, 2)) {

        [[SimpleAudioEngine sharedEngine] playEffect:@"spinning.mp3"];

        rightmoving_angle = [self getRandomRight:rightEye.position.x andPox:rightEye.position.y];
        right_countflag = 0;
    }
    
    
//    float left_stepX = cosf(leftmoving_angle * M_PI/180) * 30;
//    float left_stepY = sinf(leftmoving_angle * M_PI/180) * 30;
//    
//    float right_stepX = cosf(rightmoving_angle * M_PI/180) * 20;
//    float right_stepY = sinf(rightmoving_angle * M_PI/180) * 20;
//    
//    leftEye.position = ccp(leftEye.position.x + left_stepX, leftEye.position.y + left_stepY);
//    rightEye.position = ccp(rightEye.position.x + right_stepX, rightEye.position.y + right_stepY);
    

    
    left_countflag++;
    right_countflag++;
}

-(int) getRandomLeft:(float)posX andPox:(float)posY
{
    int lowerAngle, upperAngle;
    
    if (posX > leftTarget.position.x && posY >= leftTarget.position.y) {
        lowerAngle = 180;
        upperAngle = 270;
    }
    if (posX <= leftTarget.position.x && posY > leftTarget.position.y) {
        lowerAngle = 270;
        upperAngle = 360;
    }
    if (posX < leftTarget.position.x && posY <= leftTarget.position.y) {
        lowerAngle = 0;
        upperAngle = 90;
    }
    if (posX >= leftTarget.position.x && posY < leftTarget.position.y) {
        lowerAngle = 90;
        upperAngle = 180;
    }
    
    int currentAngle = lowerAngle + arc4random() % (upperAngle-lowerAngle);
    
    return currentAngle;
}

-(int) getRandomRight:(float)posX andPox:(float)posY
{
    int lowerAngle, upperAngle;
    
    if (posX > rightTarget.position.x && posY >= rightTarget.position.y) {
        lowerAngle = 180;
        upperAngle = 270;
    }
    if (posX <= rightTarget.position.x && posY > rightTarget.position.y) {
        lowerAngle = 270;
        upperAngle = 360;
    }
    if (posX < rightTarget.position.x && posY <= rightTarget.position.y) {
        lowerAngle = 0;
        upperAngle = 90;
    }
    if (posX >= rightTarget.position.x && posY < rightTarget.position.y) {
        lowerAngle = 90;
        upperAngle = 180;
    }
    
    int currentAngle = lowerAngle + arc4random() % (upperAngle-lowerAngle);
    
    return currentAngle;
}		

-(void) goMenuScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene scene]]];
}

-(void) goHighscoreScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HighScoreScene node]]];
}

-(void) useSlowBalls
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    purchasedSlowBalls--;
    NSString *str = [NSString stringWithFormat:@"useslowball_%davailable.png", purchasedSlowBalls];
    NSString *str1 = [NSString stringWithFormat:@"useslowball_%davailable.png", purchasedSlowBalls];
    
    if (purchasedSlowBalls == 0) {
        str = [NSString stringWithFormat:@"buyslowball_normal.png"];
        str1 = [NSString stringWithFormat:@"buyslowball_pressed.png"];
    }
    if (purchasedSlowBalls == -1) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GamePurchase scene]]];
        return;
    }
    
    [slowBall setNormalImage:[CCSprite spriteWithFile:str]];
    [slowBall setSelectedImage:[CCSprite spriteWithFile:str1]];
}

-(void) replayGame
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene scene]]];
}

-(void) stopGame
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    // 1 - 50, 2 - 90, 3 - 125, 4 - 158, 5 - 200
    
    gamerun_flag = !gamerun_flag;
    if (gamerun_flag) {

        // reset the eye position again.
        leftEye.position = leftTarget.position;
        rightEye.position = rightTarget.position;
        
        [stopItem setNormalImage:[CCSprite spriteWithFile:@"stop_btn.png"]];

        throw_index++;
        if (throw_index > 5) {
            throw_index = 1;
        }
        
        [throwSpr setTexture:[[CCTextureCache sharedTextureCache]
                              addImage:[NSString stringWithFormat:@"number_%d.png", throw_index]]];
        
        
        [self schedule:@selector(flyLeftEye) interval:0.005f];

    } else if (!gamerun_flag) {
        
        [stopItem setNormalImage:[CCSprite spriteWithFile:@"start_btn.png"]];
        
        [self unschedule:@selector(flyLeftEye)];
        
        // calculate the score.
        float left_distance = sqrt(pow(leftEye.position.x - leftTarget.position.x, 2) + pow(leftEye.position.y - leftTarget.position.y, 2));
        float right_distance = sqrt(pow(rightEye.position.x - rightTarget.position.x, 2) + pow(rightEye.position.y - rightTarget.position.y, 2));

        // Get the left score
        if ( left_distance < FIRST_POINTS_DISTANCE) {       // 50 points
            left_score += 50;
        }
        if (left_distance >= FIRST_POINTS_DISTANCE && left_distance < SECOND_POINTS_DISTANCE) {     // 40 points

            left_score += 40;
        }
        if (left_distance >= SECOND_POINTS_DISTANCE && left_distance < THIRD_POINTS_DISTANCE) {     // 30 points
            
            left_score += 30;
        }
        if (left_distance >= THIRD_POINTS_DISTANCE && left_distance < FOURTH_POINTS_DSITANCE) {     // 20 points
            
            left_score += 20;
        }
        if (left_distance >= FOURTH_POINTS_DSITANCE && left_distance < FIFTH_POINTS_DISTANCE) {     // 10 points
            
            left_score += 10;
        }
        
        // Get the right score.
        if ( right_distance < FIRST_POINTS_DISTANCE) {       // 50 points
            right_score += 50;
        }
        if (right_distance >= FIRST_POINTS_DISTANCE && right_distance < SECOND_POINTS_DISTANCE) {     // 40 points
            
            right_score += 40;
        }
        if (right_distance >= SECOND_POINTS_DISTANCE && right_distance < THIRD_POINTS_DISTANCE) {     // 30 points
            
            right_score += 30;
        }
        if (right_distance >= THIRD_POINTS_DISTANCE && right_distance < FOURTH_POINTS_DSITANCE) {     // 20 points
            
            right_score += 20;
        }
        if (right_distance >= FOURTH_POINTS_DSITANCE && right_distance < FIFTH_POINTS_DISTANCE) {     // 10 points
            
            right_score += 10;
        }

        [leftscore_label setString:[NSString stringWithFormat:@"%d", left_score]];
        [rightscore_label setString:[NSString stringWithFormat:@"%d", right_score]];
        
        NSLog(@"total score = %d + %d", left_score, right_score);
    
        if (throw_index == 5) {

            CCLayerColor *completeLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
            [completeLayer runAction:[CCFadeTo actionWithDuration:1.0 opacity:220]];
            [self addChild:completeLayer z:5];
            
            // get the table view
            //Add the tableview when the transition is done
            tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
            tableViewController.view.frame = CGRectMake(size.width/2*3, size.height/3, size.width/4*3, size.height/2);
            tableViewController.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.12 blue:0.12 alpha:1];
            UIView *view = tableViewController.view;
            
            [[[CCDirector sharedDirector] openGLView] addSubview:view];
            
            [tableViewController.view removeFromSuperview];
            [tableViewController.view isHidden];
            
            NSNumber *score_value = left_score + right_score;
            [tableViewController addToHighscore:score_value];
            
            // get the scored order from the highscore table.
//            int order = [tableViewController getScoreOrder:score_value];

            // create and initialize the end sprite.
            CCLabelTTF* completeLabel;
            completeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"TOTAL SCORE : %d POINTS\n", left_score+right_score]
                                               fontName:@"Arial Rounded MT Bold"
                                               fontSize:25];
            [completeLabel runAction:[CCFadeIn actionWithDuration:0.5]];
            completeLabel.position = ccp(size.width/2, size.height/3*2);
            [completeLayer addChild:completeLabel z:6];

            CCMenuItemImage *mainmenuItem = [CCMenuItemImage itemWithNormalImage:@"mainmenu_label_normal.png"
                                                                   selectedImage:@"mainmenu_label_pressed.png"
                                                                          target:self
                                                                        selector:@selector(goMenuScene)];
            mainmenuItem.position = ccp(size.width/10, size.height/3-30);
            
            CCMenuItemImage *playagainItem = [CCMenuItemImage itemWithNormalImage:@"playagain_label_normal.png"
                                                                    selectedImage:@"playagain_label_pressed.png"
                                                                           target:self selector:@selector(replayGame)];
            playagainItem.position = ccp(size.width/2, size.height/3-30);
            
            CCMenuItemImage *highscoreItem = [CCMenuItemImage itemWithNormalImage:@"highscore_label_normal.png"
                                                                    selectedImage:@"highscore_label_pressed.png"
                                                                           target:self
                                                                         selector:@selector(goHighscoreScene)];
            highscoreItem.position = ccp(size.width/10*9, size.height/3-30);
            
            CCMenu *completeMenu = [CCMenu menuWithItems:mainmenuItem, playagainItem, highscoreItem, nil];
            
            completeMenu.position = CGPointZero;
            completeMenu.scaleX = 0.6;
            completeMenu.scaleY = 0.8;
            [self addChild:completeMenu z:6];
            
            stopItem.isEnabled = NO;
            back_btn.isEnabled = NO;
            slowBall.isEnabled = NO;
        }
    }
}

-(void) dealloc
{
    [self release];
    [super dealloc];
}

@end
