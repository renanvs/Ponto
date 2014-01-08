//
//  PontoManager.h
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthManager : NSObject{
    NSString *beforeMonth;
    NSString *nextMonth;
    NSString *currentMonth;
    NSString *currentTotalMonthHours;
    NSMutableArray *currentMonthList;
    NSManagedObjectContext *context;
}

@property (nonatomic, assign) NSString *beforeMonth;
@property (nonatomic, assign) NSString *nextMonth;
@property (nonatomic, assign) NSString *currentMonth;
@property (nonatomic, assign) NSString *currentTotalMonthHours;
@property (nonatomic, assign) NSMutableArray *currentMonthList;

-(void)getMonthBefore;
-(void)getMonthAfter;
-(NSString*)getDayByIndex:(int)index InList:(NSArray*)list;
-(NSString*)getHoursByDay:(NSString*)day InList:(NSArray*)list;
-(void)refresh;


+(MonthManager*) sharedinstance;

@end
