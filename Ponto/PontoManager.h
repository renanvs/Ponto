//
//  PontoManager.h
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PontoModel.h"
#import "DayModel.h"

@interface PontoManager : NSObject{
    NSManagedObjectContext *contexto;
    NSString *currentDate;
    NSString *nextDate;
    NSString *beforeDate;
    NSString *currentHourWorked;
    ViewType currentViewType;
}

@property (readonly ,strong) NSManagedObjectContext *contexto;;
@property (nonatomic, assign) NSString *currentDate;
@property (nonatomic, assign) NSString *nextDate;
@property (nonatomic, assign) NSString *beforeDate;
@property (nonatomic, assign) NSString *currentHourWorked;
@property (nonatomic, assign) ViewType currentViewType;

-(void)addPontoWithDay:(NSString*)day AndHour:(NSString*)hour AndMinute:(NSString*)minute AndType:(PointType)type;

-(void)getDayAfter;
-(void)getDayBefore;

-(NSString*)sumDayTime:(NSArray*)dayList;

+(PontoManager*) sharedInstance;

@end
