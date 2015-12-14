//
//  MyTableViewCell.h
//  Goggle Ball
//
//  Created by Superstar on 11/18/15.
//  Copyright (c) 2015 Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *positionLbl;
@property (nonatomic, strong) IBOutlet UILabel *scoreLbl;
@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) IBOutlet UILabel *dateLbl;

@end
