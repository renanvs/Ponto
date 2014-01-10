//
//  Utils.h
//  Ponto
//
//  Created by renan veloso silva on 23/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PontoModelEntity @"PontoModel"
#define DayModelEntity @"DayModel"

#define NotificationRemoveKeyboard @"NotificationRemoveKeyboard"
#define NotificationContextSaved @"NotificationContextSaved"

typedef enum{
    PointEntraceType,
    PointFirstIntervalType,
    PointSecondIntervalType,
    PointExitType
}PointType;

typedef enum{
    ViewDayType,
    ViewMonthType,
    ViewOtherType,
    ViewBlankType,
}ViewType;

typedef enum{
    PontoStatusStillWorking,
    PontoStatusDayWorked,
    PontoStatusDayInBlank,
    PontoStatusError
}PontoStatus;

@interface Utils : NSObject

-(BOOL)isStringWithNumeric:(NSString*)text;

-(CGRect)screenBoundsOnOrientation;

-(NSString*)getTotalHoursSubtractByTimeIn:(NSString*)timeIn AndTimeOut:(NSString*)timeOut;
-(NSString*)getTotalHoursSubtractByHours:(NSArray*)hoursList;
-(NSString*)getTotalHoursSumByHours:(NSArray*)hoursList;

-(NSString*)currentDate;

+(Utils*) sharedinstance;

@end


@interface NSString (JRAdditions)

+ (BOOL)isStringEmpty:(NSString *)string;

@end