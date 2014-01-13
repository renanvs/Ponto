//
//  MonthCell.m
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MonthCell.h"

@implementation MonthCell

@synthesize day, hours;

-(void)setInfo{
    labelDay.text = day;
    labelMonthHours.text = hours;
}

@end
