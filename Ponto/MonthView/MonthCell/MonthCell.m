//
//  MonthCell.m
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MonthCell.h"
#import "MonthManager.h"

@implementation MonthCell

@synthesize model;

-(void)setInfo{
    NSString *day = [[model.date componentsSeparatedByString:@"/"] objectAtIndex:0];
    labelDay.text = model.date;
    
    NSString *hours = [[MonthManager sharedinstance] getHoursByDay:day InMonthList:[[MonthManager sharedinstance]currentMonthList]];
    labelMonthHours.text = [NSString stringWithFormat:@"%@ horas",hours];
}

@end
