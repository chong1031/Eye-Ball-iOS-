//
//  MenuScene.m
//  Goggle Ball
//
//  Created by Superstar on 11/2/15.
//  Copyright Superstar 2015. All rights reserved.
//


// Import the interfaces
#import "MenuScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "GamePlayScene.h"
#import "GameInstruction.h"
#import "GamePurchase.h"
#import "HighScoreScene.h"
#import "SimpleAudioEngine.h"

#pragma mark - MenuScene

// MenuScene implementation
@implementation MenuScene

// Helper class method that creates a Scene with the MenuScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScene *layer = [MenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
 
        // ask director for the window size
        CGSize size = [CCDirector sharedDirector].winSize;
        
        // Create and initialzie a background sprite.
        CCSprite *backSpr = [CCSprite spriteWithFile:@"gamescreen_bg.png"];
        backSpr.position = ccp(size.width/2, size.height/2);
        backSpr.scaleX = size.width / [backSpr boundingBox].size.width;
        backSpr.scaleY = size.height / [backSpr boundingBox].size.height;
        NSLog(@"%f %f", backSpr.scaleX, backSpr.scaleY);
        
        
        [self addChild:backSpr];

        // create game menu items.
        registerItem = [CCMenuItemImage itemWithNormalImage:@"register_normal.png" selectedImage:@"register_pressed.png" target:self selector:@selector(registerPlayUser)];
        registerItem.position = ccp(size.width/7, size.height/10);
        registerItem.scale = 0.5;
        
        CCMenuItemImage *howToPlayItem = [CCMenuItemImage itemWithNormalImage:@"howtoplay_normal.png" selectedImage:@"howtoplay_pressed.png" target:self selector:@selector(howToPlay)];
        howToPlayItem.position = ccp(size.width/3 + 20, size.height/10);
        howToPlayItem.scale = 0.5;
        
        CCMenuItemImage *buySlowBallItem = [CCMenuItemImage itemWithNormalImage:@"buyslowball_normal.png" selectedImage:@"buyslowball_pressed.png" target:self selector:@selector(startPurchase)];
        buySlowBallItem.position = ccp(size.width/3*2 - 30, size.height/10);
        buySlowBallItem.scale = 0.5;
        
        CCMenuItemImage *highScoreItem = [CCMenuItemImage itemWithNormalImage:@"highscore_normal.png" selectedImage:@"highscore_pressed.png" target:self selector:@selector(showHighScore)];
        highScoreItem.position = ccp(size.width/7*6, size.height/10);
        highScoreItem.scale = 0.5;
        
        CCMenuItemImage *noseItem = [CCMenuItemImage itemWithNormalImage:@"play_btn.png" selectedImage:@"play_btn.png" target:self selector:@selector(startGame)];
        noseItem.anchorPoint = ccp(0, 0);
        noseItem.position = ccp(size.width * 605/1322, size.height * 226/746);
        noseItem.scaleX = backSpr.scaleX;
        noseItem.scaleY = backSpr.scaleY;
        
        CCMenu *menu = [CCMenu menuWithItems:registerItem, howToPlayItem, buySlowBallItem, highScoreItem, noseItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:2];
        
        CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.5 scale:1.05];
        CCScaleTo *scale2 = [CCScaleTo actionWithDuration:0.3 scale:1];
        
        id action = [CCSequence actions:scale1, scale2, nil];
        [noseItem runAction:[CCRepeatForever actionWithAction:action]];
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if (userName != NULL) {
            registerItem.isEnabled = NO;
            registerItem.opacity = 180;
        }
        
        // create and initialize the start button(nose)
//        CCMenuItemImage *noseItem = [CCMenuItemImage itemWithNormalImage:@"nose.png" selectedImage:@"nose.png" target:self selector:@selector(startGame)];
//        noseItem.position = ccp(size.width * 662/1322, size.height * 480/746);
        
//        // create and initialize the shadow sprite.
//        CCSprite *shadow_spr = [CCSprite spriteWithFile:@"shadow.png"];
//        shadow_spr.position = backSpr.position;
//        shadow_spr.scaleX = size.width / [shadow_spr boundingBox].size.width;
//        shadow_spr.scaleY = size.height / [shadow_spr boundingBox].size.height;
//        
//        [self addChild:shadow_spr z:3];
//        
	}
	return self;
}

-(void) startGame
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSLog(@"%@", userName);
    if (userName == nil) {
        UIAlertView *registerAlert_start = [[UIAlertView alloc] initWithTitle:@"Username"
                                                                message:@"Please enter a username to register"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Register", nil];
        registerAlert_start.alertViewStyle = UIAlertViewStylePlainTextInput;
        registerAlert_start.tag = 111;
        [registerAlert_start show];

    } else {

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene scene]]];
    }
}

-(void) registerPlayUser
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    UIAlertView *registerAlert = [[UIAlertView alloc] initWithTitle:@"Username"
                                                            message:@"please enter a username to register"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Register", nil];
    registerAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    registerAlert.tag = 222;
    [registerAlert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str =  [alertView buttonTitleAtIndex:buttonIndex];
    if ([str isEqualToString:@"Register"]) {

        UITextField *userName = [alertView textFieldAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:@"userName"];
        NSLog(@"username : '%@'", [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]);
        
        registerItem.isEnabled = NO;
        registerItem.opacity = 180;
        
        if (alertView.tag == 111) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene scene]]];
        }
    }
}

-(BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *userName = [alertView textFieldAtIndex:0];
    if ([userName.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

-(void) howToPlay
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:[GameInstruction scene]]];
}

-(void) startPurchase
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePurchase scene]]];
}

-(void) showHighScore
{
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HighScoreScene scene]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    CCScene *newScene = [CCTransitionFade transitionWithDuration:.3
                                                               scene:[HighScoreScene node]];
    
    [[CCDirector sharedDirector] replaceScene:newScene];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

