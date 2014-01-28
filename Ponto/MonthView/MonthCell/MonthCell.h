//
//  MonthCell.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayModel.h"

@interface MonthCell : UITableViewCell{
    IBOutlet UILabel  *labelDay;
    IBOutlet UILabel  *labelMonthHours;
    DayModel *model;
}

@property (nonatomic, assign) DayModel *model;

-(void)setInfo;

@end
