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
    NSManagedObjectContext *context;
    NSString *currentDate;
    NSString *followingDate;
    NSString *previousDate;
    NSString *currentHourWorked;
    ViewType currentViewType;
}

@property (readonly ,strong) NSManagedObjectContext *context;
@property (nonatomic, assign) NSString *currentDate;
@property (nonatomic, assign) NSString *followingDate;
@property (nonatomic, assign) NSString *previousDate;
@property (nonatomic, assign) NSString *currentHourWorked;
@property (nonatomic, assign) ViewType currentViewType;

-(void)addPontoWithDay:(NSString*)day AndHour:(NSString*)hour AndMinute:(NSString*)minute AndType:(PointType)type;

-(void)getFollowingDay;
-(void)getPreviousDay;

-(void)setButtonStyle:(UIButton*)bt;

-(NSString*)getDayTime:(NSArray*)dayList;

+(PontoManager*) sharedInstance;

@end
