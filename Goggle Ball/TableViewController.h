//
//  MyUITableView.h
//  UITableView-cocos2d
//
//  Created by Alexander Alemayhu on 14.11.11.
//  Copyright 2011 Flexnor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    BOOL useAccessory;
    
    int total;
    NSArray *arrayValues;
    NSMutableArray *totalAry;
}
    
-(void) addToHighscore:(NSNumber *)scored_value;
-(int) getTotalScore;
-(int) getScoreOrder:(NSNumber *)scored_value;
-(int) getPostion;
-(void) getScore;

@property (assign, nonatomic) NSMutableArray *total_score;
@property (assign, nonatomic) NSArray *sorted_total_score;
@property (assign, nonatomic) NSMutableArray *sorted_score;
@property (assign, nonatomic) NSMutableArray *scored_date;

@end
