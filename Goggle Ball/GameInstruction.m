//
//  GameInstruction.m
//  Goggle Ball
//
//  Created by Superstar on 11/3/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import "GameInstruction.h"
#import "MenuScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation GameInstruction

// Helper class method that creates a Scene with the MenuScene as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameInstruction *layer = [GameInstruction node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        self.touchEnabled = YES;

        size = [CCDirector sharedDirector].winSize;
        
        // background
        CCSprite *playBackSpr = [CCSprite spriteWithFile:@"instruction_background.png"];
        playBackSpr.position = ccp(size.width/2, size.height/2);
        playBackSpr.scaleX = size.width / [playBackSpr boundingBox].size.width;
        playBackSpr.scaleY = size.height / [playBackSpr boundingBox].size.height;
        
        [self addChild:playBackSpr];
        
        // menu
        back = [CCMenuItemImage itemWithNormalImage:@"instructions_back.png"
                                      selectedImage:@"instructions_back2.png"
                                             target:self selector:@selector(onBack:)];
        back.opacity = 64;
        
        next = [CCMenuItemImage itemWithNormalImage:@"instructions_next.png"
                                      selectedImage:@"instructions_next2.png"
                                             target:self selector:@selector(onNext:)];

        CCMenuItemImage *backToMenu = [CCMenuItemImage itemWithNormalImage:@"instructions_menu.png"
                                                             selectedImage:@"instructions_menu2.png"
                                                                    target:self selector:@selector(onMenu:)];

        CCMenu* menu = [CCMenu menuWithItems:back, backToMenu, next, nil];
        [menu alignItemsHorizontallyWithPadding:50];
        menu.position = ccp(size.width/2, 20.5);
        [self addChild:menu z:2];
        
        // the page
        pageNumber = 1;
        pageLayer = [CCLayer node];
        [self addChild:pageLayer];
        CCSprite* page1 = [CCSprite spriteWithFile:@"instruction_page1.png"];
        CCSprite* page2 = [CCSprite spriteWithFile:@"instruction_page2.png"];
        CCSprite* page3 = [CCSprite spriteWithFile:@"instruction_page3.png"];
        CCSprite* page4 = [CCSprite spriteWithFile:@"instruction_page4.png"];
        page1.position = ccp(size.width/2, size.height/2);
        page2.position = ccp(size.width/2*3, size.height/2);
        page3.position = ccp(size.width/2*5, size.height/2);
        page4.position = ccp(size.width/2*7, size.height/2);
        [pageLayer addChild:page1];
        [pageLayer addChild:page2];
        [pageLayer addChild:page3];
        [pageLayer addChild:page4];
        
//        // create and initialize the back item.
//        CCMenuItemImage *back_btn = [CCMenuItemImage itemWithNormalImage:@"back1.png" selectedImage:@"back2.png" target:self selector:@selector(goMenuScene)];
//        back_btn.position = ccp([back_btn boundingBox].size.width/3*2, [back_btn boundingBox].size.height/5*3);
//        back_btn.scale = 0.8f;
//        
//        CCMenu *menu = [CCMenu menuWithItems:back_btn, nil];
//        menu.position = CGPointZero;
//        
//        [self addChild:menu z:2];

    }
    
    return self;
}

-(void) goMenuScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene scene]]];
}

- (void) onBack:(id)sender {
    NSLog(@"InstructionsScene onBack");
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [self moveBack];
}

- (void) onNext:(id)sender {
    NSLog(@"InstructionsScene onNext");
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [self moveNext];
}

- (void) onMenu:(id)sender {
    NSLog(@"InstructionsScene onMenu");
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[MenuScene scene] backwards:YES]];
}

- (void) moveBack {
    if(pageNumber > 1) {
        pageNumber--;
        if(pageNumber == 1)
            back.opacity = 64;
        next.opacity = 255;
        [self scroll];
    }
}

- (void) moveNext {
    if(pageNumber < 4) {
        pageNumber++;
        if(pageNumber == 4)
            next.opacity = 64;
        back.opacity = 255;
        [self scroll];
    }
}

- (void) scroll {
    CGFloat x = (pageNumber-1)*size.width*-1;
    [pageLayer runAction:[CCMoveTo actionWithDuration:0.2 position:ccp(x, 0)]];
}

- (void) registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    touchStart = [self convertTouchToNodeSpace:touch];
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchEnd = [self convertTouchToNodeSpace:touch];
    
    switch([Helpers swipeDirectionStart:touchStart end:touchEnd]) {
        case GameDirLeft:
            [self moveNext];
            break;
        case GameDirRight:
            [self moveBack];
            break;
    }
}

- (void) dealloc {
    NSLog(@"InstructionsScene dealloc");
    [super dealloc];
}

@end
