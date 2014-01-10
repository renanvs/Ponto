//
//  Utils.m
//  Ponto
//
//  Created by renan veloso silva on 23/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "Utils.h"

@implementation NSString (JRAdditions)

+ (BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

@end

@implementation Utils

static id _instance;

+ (Utils *) sharedinstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(BOOL)isStringWithNumeric:(NSString*)text{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:text];
    bool status = number != nil;
    
    return status;
}

-(CGRect) screenBoundsOnOrientation{
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
    }
    return screenBounds ;
}

-(NSString*)getTotalHoursSubtractByTimeIn:(NSString*)timeIn AndTimeOut:(NSString*)timeOut{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSDate *dateIn = [formatter dateFromString:timeIn];
    NSDate *dateOut = [formatter dateFromString:timeOut];
    
    CGFloat newDate = [dateOut timeIntervalSinceDate:dateIn]/60;
    
    if (newDate < 0) {
        return @"error";
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute = [[NSString stringWithFormat:@"%f",newDate] intValue];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSString *dateStr = [formatter stringFromDate:date];

    return dateStr;
}

-(NSString*)getTotalHoursSubtractByHours:(NSArray*)hoursList{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSMutableArray *minutesListInt = [[NSMutableArray alloc] init];
    
    for (NSString *hour in hoursList) {
        NSArray *hoursComp = [hour componentsSeparatedByString:@":"];
        NSString *_hoursStr = [hoursComp objectAtIndex:0];
        NSString *_minutesStr = [hoursComp objectAtIndex:1];
        int _hoursInt = [_hoursStr integerValue]*60;
        int _minutesInt = [_minutesStr integerValue];
        
        int total = _hoursInt + _minutesInt;
        
        [minutesListInt addObject:[NSNumber numberWithInteger:total]];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [minutesListInt sortedArrayUsingDescriptors:sortDescriptors];
    int totalMinutes = [[sortedArray objectAtIndex:0] integerValue];
    for (int i =1; i < sortedArray.count; i++) {
        totalMinutes = totalMinutes - [[sortedArray objectAtIndex:i] integerValue];
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute = totalMinutes;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

-(NSString*)getTotalHoursSumByHours:(NSArray*)hoursList{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSMutableArray *minutesListInt = [[NSMutableArray alloc] init];
    
    for (NSString *hour in hoursList) {
        NSArray *hoursComp = [hour componentsSeparatedByString:@":"];
        NSString *_hoursStr = [hoursComp objectAtIndex:0];
        NSString *_minutesStr = [hoursComp objectAtIndex:1];
        int _hoursInt = [_hoursStr integerValue]*60;
        int _minutesInt = [_minutesStr integerValue];
        
        int total = _hoursInt + _minutesInt;
        
        [minutesListInt addObject:[NSNumber numberWithInteger:total]];
    }
    
    int totalMinutes = 0;
    for (int i = 0; i < minutesListInt.count; i++) {
        totalMinutes = totalMinutes + [[minutesListInt objectAtIndex:i] integerValue];
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute = totalMinutes;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}


-(NSString*)currentDate{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter stringFromDate:date];
    
}

@end
