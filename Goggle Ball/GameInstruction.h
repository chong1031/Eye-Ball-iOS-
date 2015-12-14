//
//  GameInstruction.h
//  Goggle Ball
//
//  Created by Superstar on 11/3/15.
//  Copyright 2015 Superstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Helpers.h"

@interface GameInstruction : CCLayer {
    
    NSInteger pageNumber;
    CCLayer *pageLayer;
    CCMenuItemImage* back;
    CCMenuItemImage* next;
    CGPoint touchStart;
    CGSize size;
}

// returns a CCScene that contains the MenuScene as the only child
+(CCScene *) scene;

@end
