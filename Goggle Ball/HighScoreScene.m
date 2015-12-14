//
//  TableViewLayer.m
//  UITableView-cocos2d
//
//  Created by Alexander Alemayhu on 14.11.11.
//  Copyright 2011 Flexnor. All rights reserved.
//

#import "HighScoreScene.h"
#import "MenuScene.h"
#import "TableViewController.h"
#import "com.ccColor3B.h"
#import "SimpleAudioEngine.h"

@interface HighScoreScene(privateMethods)
-(void)returnToHelloWorldLayer;
-(void) toggleAccesoryToTable;
-(void) toggleThumbNail;
@end

@implementation HighScoreScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoreScene *layer = [HighScoreScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
        
        size = [CCDirector sharedDirector].winSize;
        
        // create and initialize the main background
        CCSprite *backSpr = [CCSprite spriteWithFile:@"highscore_background.png"];
        backSpr.position = ccp(size.width/2, size.height/2);
        backSpr.scaleX = size.width / [backSpr boundingBox].size.width;
        backSpr.scaleY = size.height / [backSpr boundingBox].size.height;
        
        [self addChild:backSpr];

        // create the totalscore label
        int totalScore = 0;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        NSString *str = [NSString stringWithFormat:@"%@ Total Points  :  %d", userName, totalScore];
        totalscore_label = [CCLabelTTF labelWithString:str
                                              fontName:@"Arial Rounded MT Bold"
                                              fontSize:20];
        //        totalscore_label.color = ccc3(255, 177, 114);
        totalscore_label.color = ccRED;
        totalscore_label.position = ccp(size.width/2, size.height/3*2 + 20);
        
        [self addChild:totalscore_label];
        
        
        // create and initialize the highscore topic sprite.
        CCSprite *highscore_topic = [CCSprite spriteWithFile:@"highscore_table_topic.png"];
        highscore_topic.position = ccp(size.width/2, totalscore_label.position.y - [totalscore_label boundingBox].size.height*1.5f);
        highscore_topic.scale = size.width/4*3 / [highscore_topic boundingBox].size.width;
        
        [self addChild:highscore_topic];
        
        // create and initialize the score table view.
        //Add the tableview when the transition is done
        tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableViewController.view.frame = CGRectMake(size.width/8,
                                                    highscore_topic.position.y - size.height/4 + [highscore_topic boundingBox].size.height/2,
                                                    size.width/4*3,
                                                    size.height/2);
        tableViewController.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.12 blue:0.12 alpha:1];
        view = tableViewController.view;
        
        // get the user name
        totalScore = [tableViewController getTotalScore];
        if (userName == nil) userName = @"";
        
        
        str = [NSString stringWithFormat:@"%@ Total Points  :  %d", userName, totalScore];
        if (userName == nil) {
            str = @"";
        }
        [totalscore_label setString:str];

        // create and initialize the back item.
        CCMenuItemImage *back_btn = [CCMenuItemImage itemWithNormalImage:@"back1.png"
                                                           selectedImage:@"back2.png"
                                                                  target:self
                                                                selector:@selector(goMenuScene)];
        back_btn.position = ccp([back_btn boundingBox].size.width/3+5, [back_btn boundingBox].size.height/5*3);
        back_btn.scale = 0.8f;
        
        CCMenuItemLabel *write_label = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"write" fontName:@"Arial" fontSize:20]
                                                              target:self selector:@selector(writePlist)];
        write_label.position = ccp(size.width/9*8, size.height/2);

        CCMenu *menu = [CCMenu menuWithItems:back_btn, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
	}
	return self;
}

-(void) onEnterTransitionDidFinish{

//    //Add the tableview when the transition is done
//    tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
//    tableViewController.view.frame = CGRectMake(size.width/8, size.height/3 + [totalscore_label boundingBox].size.height/4, size.width/4*3, size.height/2);
//    tableViewController.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.12 blue:0.12 alpha:1];
//    UIView *view = tableViewController.view;
//    
    [[[CCDirector sharedDirector] openGLView] addSubview:view];
}

-(void) goMenuScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];

    [tableViewController.view removeFromSuperview];
    [tableViewController.view isHidden];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene scene]]];
}

-(void) writePlist
{
    [tableViewController addToHighscore:100];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [tableViewController release];
	[super dealloc];
}
@end
