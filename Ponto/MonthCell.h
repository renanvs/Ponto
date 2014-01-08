//
//  MonthCell.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCell : UITableViewCell{
    IBOutlet UILabel  *day;
    IBOutlet UILabel  *hours;
    NSString *dayStr;
    NSString *hoursStr;
}

@property (nonatomic, assign) NSString  *dayStr;
@property (nonatomic, assign) NSString  *hoursStr;

-(void)setInfo;

@end
