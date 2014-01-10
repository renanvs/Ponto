//
//  PontoManager.h
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthManager : NSObject{
    NSString *previousMonth;
    NSString *followingMonth;
    NSString *currentMonth;
    NSString *currentTotalMonthHours;
    NSMutableArray *currentMonthList;
    NSManagedObjectContext *context;
}

@property (nonatomic, assign) NSString *previousMonth;
@property (nonatomic, assign) NSString *followingMonth;
@property (nonatomic, assign) NSString *currentMonth;
@property (nonatomic, assign) NSString *currentTotalMonthHours;
@property (nonatomic, assign) NSMutableArray *currentMonthList;

-(void)getPreviousMonth;
-(void)getFollowingMonth;
-(NSString*)getDayByIndex:(int)index InMonthList:(NSArray*)list;
-(NSString*)getHoursByDay:(NSString*)day InMonthList:(NSArray*)list;
-(void)refresh;


+(MonthManager*) sharedinstance;

@end
