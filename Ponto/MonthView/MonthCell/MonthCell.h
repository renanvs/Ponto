//
//  MonthCell.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCell : UITableViewCell{
    IBOutlet UILabel  *labelDay;
    IBOutlet UILabel  *labelMonthHours;
    NSString *day;
    NSString *hours;
}

@property (nonatomic, assign) NSString  *day;
@property (nonatomic, assign) NSString  *hours;

-(void)setInfo;

@end
