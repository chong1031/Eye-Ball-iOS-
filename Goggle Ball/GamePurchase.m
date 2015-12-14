//
//  GamePurchase.m
//  Goggle Ball
//
//  Created by Superstar on 11/3/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "GamePurchase.h"

#import "MenuScene.h"
#import "GamePlayScene.h"
#import "MGIAPHelper.h"
#import "SimpleAudioEngine.h"

@implementation GamePurchase

// Helper class method that creates a Scene with the MenuScene as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GamePurchase *layer = [GamePurchase node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {

        CGSize size = [CCDirector sharedDirector].winSize;
        
        // create and initialize the main background
        CCSprite *backSpr = [CCSprite spriteWithFile:@"purchasescreen_bg.png"];
        backSpr.position = ccp(size.width/2, size.height/2);
        backSpr.scaleX = size.width / [backSpr boundingBox].size.width;
        backSpr.scaleY = size.height / [backSpr boundingBox].size.height;
        
        [self addChild:backSpr];
        
        // create and initialize the back item.
        CCMenuItemImage *back_btn = [CCMenuItemImage itemWithNormalImage:@"back1.png"
                                                           selectedImage:@"back2.png"
                                                                  target:self selector:@selector(goMenuScene)];
        back_btn.position = ccp([back_btn boundingBox].size.width/3*2, [back_btn boundingBox].size.height/5*3);
        back_btn.scale = 0.8f;

        CCMenuItemImage *startgameItem = [CCMenuItemImage itemWithNormalImage:@"startgame_normal.png"
                                                                selectedImage:@"startgame_pressed.png"
                                                                       target:self selector:@selector(startGame)];
        startgameItem.position = ccp(size.width/2, back_btn.position.y);
        startgameItem.scale = 0.5f;
        
        // create game menu items.
        CCMenuItemImage *btn1 = [CCMenuItemImage itemWithNormalImage:@"0.99_btn.png"
                                                       selectedImage:@"0.99_btn.png"
                                                              target:self selector:@selector(goPurchase1)];
        btn1.position = ccp(size.width/6, size.height/4);
        btn1.scale = 0.5;
        
        CCMenuItemImage *btn2 = [CCMenuItemImage itemWithNormalImage:@"2.49_btn.png"
                                                       selectedImage:@"2.49_btn.png"
                                                              target:self selector:@selector(goPurchase2)];
        btn2.position = ccp(size.width/5*2 - 5.0f, btn1.position.y);
        btn2.scale = 0.5;
        
        CCMenuItemImage *btn3 = [CCMenuItemImage itemWithNormalImage:@"3.99_btn.png"
                                                       selectedImage:@"3.99_btn.png"
                                                              target:self selector:@selector(goPurchase3)];
        btn3.position = ccp(size.width/5*3 + 5.0f, btn1.position.y);
        btn3.scale = 0.5;
        
        CCMenuItemImage *btn4 = [CCMenuItemImage itemWithNormalImage:@"6.99_btn.png"
                                                       selectedImage:@"6.99_btn.png"
                                                              target:self selector:@selector(goPurchase4)];
        btn4.position = ccp(size.width/6*5, btn1.position.y);
        btn4.scale = 0.5;
        
        CCMenu *menu = [CCMenu menuWithItems:back_btn, startgameItem, btn1, btn2, btn3, btn4, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu z:2];
        
        // create and initialize the shadow effect.
        CCSprite *shadow_spr = [CCSprite spriteWithFile:@"shadow.png"];
        shadow_spr.position = backSpr.position;
        shadow_spr.scaleX = size.width / [shadow_spr boundingBox].size.width;
        shadow_spr.scaleY = size.height / [shadow_spr boundingBox].size.height;
        
        [self addChild:shadow_spr z:3];
    }
    
    return self;
}

-(void) goMenuScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene scene]]];
}

-(void) startGame
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene scene]]];
}

-(void) goPurchase1
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
//    [[MGIAPHelper sharedInstance] restoreCompletedTransactions];
    
    
}

-(void) goPurchase2
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:@"Purchase Slow Balls : 2.49$" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancal", nil];
    
    [alert show];
}

-(void) goPurchase3
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:@"Purchase Slow Balls : 3.99$" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancal", nil];
    
    [alert show];
}

-(void) goPurchase4
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:@"Purchase Slow Balls : 6.99$" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancal", nil];
    
    [alert show];
}


@end
