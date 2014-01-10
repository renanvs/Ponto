//
//  PontoManager.m
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "MonthManager.h"
#import "PontoManager.h"

@implementation MonthManager

@synthesize previousMonth, followingMonth, currentMonth, currentMonthList, currentTotalMonthHours;

static id _instance;

+ (MonthManager *) sharedinstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(id)init{
    self = [super init];
    
    if (self) {
        context = [[PontoManager sharedInstance]context];
        currentMonthList = [[NSMutableArray alloc] init];
        [self getMonthListByDate:[[Utils sharedinstance] currentDate]];
        [self setDates];
    }
    
    return self;
}

-(void)setDates{
    currentMonth = [[NSString alloc ] initWithString:[self getMonthByMonthDelay:0]];
    previousMonth = [[NSString alloc ] initWithString:[self getMonthByMonthDelay:-1]];
    followingMonth = [[NSString alloc ] initWithString:[self getMonthByMonthDelay:1]];
}

-(void)getMonthListByDate:(NSString*)date{
    [currentMonthList removeAllObjects];
    NSArray *dateComp = [date componentsSeparatedByString:@"/"];
    NSString *month = nil;
    NSString *year = nil;
    NSString *monthYear = nil;
    
    if (dateComp.count == 3) {
        month = [[date componentsSeparatedByString:@"/"] objectAtIndex:1];
        year = [[date componentsSeparatedByString:@"/"] objectAtIndex:2];
        
    }else if (dateComp.count == 2) {
        month = [[date componentsSeparatedByString:@"/"] objectAtIndex:0];
        year = [[date componentsSeparatedByString:@"/"] objectAtIndex:1];
    }
    
    monthYear = [NSString stringWithFormat:@"%@/%@",month,year];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DayModelEntity inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *resultSorted = [result sortedArrayUsingDescriptors:sortDescriptors];
    
    for (DayModel *dm in resultSorted) {
        NSRange range = [dm.date rangeOfString:monthYear];
        if (range.length > 0) {
            [currentMonthList addObject:dm];
        }
    }
    
    currentTotalMonthHours = [[NSString alloc] initWithString:[self sumMonthHoursByList:currentMonthList]];
    
}

-(NSString*)sumMonthHoursByList:(NSArray*)list{
    NSMutableArray *hoursList = [[NSMutableArray alloc]init];
    for (DayModel *day in list) {
        NSString *dayStr = [[day.date componentsSeparatedByString:@"/"] objectAtIndex:0];
        [hoursList addObject:[self getHoursByDay:dayStr InMonthList:list]];
    }
    
    return [[Utils sharedinstance]getTotalHoursSumByHours:hoursList];
}

-(NSString*)getMonthByMonthDelay:(int)delay{
    NSString *dateStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/yyyy"];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setMonth:delay];
    
    NSDate *currentDay = nil;
    
    if (!currentMonth) {
        currentDay= [NSDate date];
    }else{
        currentDay = [formatter dateFromString:currentMonth];
    }
    
    
    NSDate *dayFormated = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:currentDay options:0];
    dateStr = [formatter stringFromDate:dayFormated];
    
    return dateStr;

}

-(void)getFollowingMonth{
    currentMonth = followingMonth;
    [self setDates];
    [self getMonthListByDate:currentMonth];
}

-(void)getPreviousMonth{
    currentMonth = previousMonth;
    [self setDates];
    [self getMonthListByDate:currentMonth];
}

-(void)refresh{
    [self setDates];
    [self getMonthListByDate:currentMonth];
}

-(NSString*)getDayByIndex:(int)index InMonthList:(NSArray*)list{
    
    DayModel *dm = [list objectAtIndex:index];
    NSString *day = [[dm.date componentsSeparatedByString:@"/"] objectAtIndex:0];
    
    return day;
}

-(NSString*)getHoursByDay:(NSString*)day InMonthList:(NSArray*)list{
    
    DayModel *dayM = nil;
    for (DayModel *dm in list) {
        NSString *day_ = [[dm.date componentsSeparatedByString:@"/"] objectAtIndex:0];
        if([day isEqualToString:day_]){
            dayM = dm;
        }
    }
    
    NSArray *dayList = [[dayM pontos] allObjects];
    if (dayList.count != 4) {
        return @"00:00";//r//
    }
    
    NSString *hours = [[PontoManager sharedInstance] sumDayTime:dayList];
    
    return hours;
}


@end
