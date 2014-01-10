//
//  PontoManager.m
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "PontoManager.h"

@implementation PontoManager

@synthesize context, currentDate, previousDate, followingDate, currentViewType, currentHourWorked;

static id _instance;

+ (PontoManager *) sharedInstance{
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
        [self context];
        currentViewType = ViewBlankType;
        [self setDates];
    }
    
    return self;
}

-(void)setDates{
    currentDate = [[NSString alloc ] initWithString:[self getDateByDayDelay:0]];
    followingDate =  [[NSString alloc ] initWithString:[self getDateByDayDelay:1]];
    previousDate = [[NSString alloc ] initWithString:[self getDateByDayDelay:-1]];
    [self timeInfo];
}

-(NSString *)getDateByDayDelay:(int)delay{
    NSString *dateStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:delay];
    
    NSDate *date = nil;
    
    if (!currentDate) {
        date= [NSDate date];
    }else{
        date = [formatter dateFromString:currentDate];
    }
    
    
    NSDate *dayFormated = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:date options:0];
    dateStr = [formatter stringFromDate:dayFormated];

    return dateStr;
    
}

-(void)addPontoWithDay:(NSString*)day AndHour:(NSString*)hour AndMinute:(NSString*)minute AndType:(PointType)type{
    DayModel *dayModel = [self getDayModel:day];
    
    [self setPontoModelWithHour:hour withMinute:minute AndDayModel:dayModel AndType:type];
    
    [self saveContext];
}

-(void)timeInfo{
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [self.context executeFetchRequest:request error:nil];
    
    NSMutableArray *currentDayPontoList = [[NSMutableArray alloc] init];
    for (PontoModel *pm in result) {
        if ([pm.day.date isEqualToString:currentDate]) {
            [currentDayPontoList addObject:pm];
        }
    }
    
    PontoStatus pontoStatus = [self getPontoTypeByDayList:currentDayPontoList];
    
    if (pontoStatus == PontoStatusDayInBlank) {
        currentHourWorked = @"00:00";
    }else if (pontoStatus == PontoStatusError) {
        currentHourWorked = @"error";
    }else if ((pontoStatus == PontoStatusStillWorking) || (pontoStatus == PontoStatusDayWorked)) {
        currentHourWorked = [[NSString alloc] initWithString:[self sumDayTime:currentDayPontoList]];
    }
    
}

-(NSString*)sumDayTime:(NSArray*)dayList{
    
    NSString *enter = nil;
    NSString *first = nil;
    NSString *second = nil;
    NSString *exit = nil;
    
    for (PontoModel *pm in dayList) {
        if ([pm.type integerValue] == PointEntraceType ) {
            enter = pm.hour;
        }else if ([pm.type integerValue] == PointFirstIntervalType ) {
            first = pm.hour;
        }else if ([pm.type integerValue] == PointSecondIntervalType ) {
            second = pm.hour;
        }else if ([pm.type integerValue] == PointExitType) {
            exit = pm.hour;
        }
    }
    
    if (dayList.count == 4) {
        NSString *hoursWorked = [[Utils sharedinstance] getTotalHoursSubtractByTimeIn:enter AndTimeOut:exit];
        NSString *lunchHours = [[Utils sharedinstance] getTotalHoursSubtractByTimeIn:first AndTimeOut:second];
        NSString *total = [[Utils sharedinstance] getTotalHoursSubtractByHours:[NSArray arrayWithObjects:hoursWorked, lunchHours, nil]];
        return total;
    }
    
    return @"00:00";
}

-(PontoStatus)getPontoTypeByDayList:(NSArray*)dayList{
    
    if (dayList.count == 0 || !dayList) {
        return PontoStatusDayInBlank;
    }
    
    if (dayList.count < 4) {
        return PontoStatusStillWorking;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [dayList sortedArrayUsingDescriptors:sortDescriptors];
    PontoModel *pm0 = [sortedArray objectAtIndex:0];
    PontoModel *pm1 = [sortedArray objectAtIndex:1];
    PontoModel *pm2 = [sortedArray objectAtIndex:2];
    PontoModel *pm3 = [sortedArray objectAtIndex:3];
    
    BOOL dayWorked = ((pm0.type == [NSNumber numberWithInt:PointEntraceType]) && (pm1.type == [NSNumber numberWithInt:PointFirstIntervalType]) && (pm2.type == [NSNumber numberWithInt:PointSecondIntervalType]) && (pm3.type == [NSNumber numberWithInt:PointExitType]));
    if (dayWorked && (dayList.count == 4)) {
        return PontoStatusDayWorked;
    }
    
    return PontoStatusError;
    
}

-(BOOL)validatePreviousValueWithTime:(NSString*)time AndType:(PointType)type{
    PointType typeToVerify = type -1;
    
    if (type == PointEntraceType) {
        return YES;
    }
    
    NSString *timeToVerify = [self getTimeByDate:currentDate AndType:typeToVerify];
    
    if ([NSString isStringEmpty:timeToVerify]) return YES;
    
    NSString *result = [[Utils sharedinstance] getTotalHoursSubtractByTimeIn:timeToVerify AndTimeOut:time];
    NSRange range = [result rangeOfString:@"error"];
    
    if (range.length > 0) {
        return NO;
    }
    
    
    return YES;
}

-(NSString*)getTimeByDate:(NSString*)date AndType:(PointType)type{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [self.context executeFetchRequest:request error:nil];
    
    for (PontoModel *pm in result) {
        BOOL dateValidate = [pm.day.date isEqualToString:date];
        BOOL typeValidate = (pm.type == [NSNumber numberWithInt:type]) ;
        
        if (dateValidate && typeValidate) {
            return pm.hour;
        }
    }
    
    return nil;
}

-(void)setPontoModelWithHour:(NSString*)hour withMinute:(NSString*)minute AndDayModel:(DayModel*)dayModel AndType:(PointType)type{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    
    NSArray *result = [self.context executeFetchRequest:request error:nil];
    NSString *time = [NSString stringWithFormat:@"%@:%@", hour, minute];
    
    if (![self validatePreviousValueWithTime:time AndType:type]){
        [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Hora inferior a anterior" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if (result.count > 0){
        for (PontoModel *pm in result) {
            if ((pm.day == dayModel) && (pm.type == [NSNumber numberWithInt:type])) {
                pm.hour = time;
                return;
            }
        }
    }
    
    PontoModel *pontoModel = (PontoModel*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
    pontoModel.hour = [[NSString alloc] initWithFormat:@"%@:%@", hour, minute];
    pontoModel.type = [NSNumber numberWithInt:type];
    
    [self.context insertObject:pontoModel];
    
    pontoModel.day = dayModel;
    
}

-(DayModel*)getDayModel:(NSString*)day{
    NSEntityDescription *entity = [NSEntityDescription entityForName:DayModelEntity inManagedObjectContext:self.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [self.context executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (DayModel *dm in result) {
            if ([dm.date isEqualToString:day]) {
                return dm;
            }
        }
    }
    
    DayModel *dm = [NSEntityDescription insertNewObjectForEntityForName:DayModelEntity inManagedObjectContext:context];
    
    dm.date = day;
    
    return dm;
}

-(void)getPontoModel:(PontoModel*)ponto withDay:(DayModel*)day{
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    
    NSArray *result = [self.context executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (PontoModel *pm in result) {
            if ((pm.day == day) && (pm.type == ponto.type)) {
                pm.hour = ponto.hour;
                return;
            }
        }
    }
    
    [self.context insertObject:ponto];
    
    ponto.day = day;
    
}

-(void)saveContext{
    NSError *error;
    if (![context save:&error]) {
        NSDictionary *informacoes = [error userInfo];
        NSArray *multiplosError = [informacoes objectForKey:NSDetailedErrorsKey];
        if (multiplosError) {
            for (NSError *error in multiplosError) {
                NSLog(@"Problema: %@", [error userInfo]);
            }
        }else{
            NSLog(@"Problema: %@", informacoes);
        }
    }else{
        [self timeInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationContextSaved object:nil];
    }
}

-(NSManagedObjectModel*)managedObjectModel{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)coordinator{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *pastaDocuments = [self applicationDocumentsDirectory];
    NSURL *localBancoDados = [pastaDocuments URLByAppendingPathComponent:@"PontoBanco.sqlite"];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localBancoDados options:nil error:nil];
    return coordinator;
}

-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)context{
    if (context != nil) {
        return context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}


-(void)getFollowingDay{
    currentDate = followingDate;
    [self setDates];
}

-(void)getPreviousDay{
    currentDate = previousDate;
    [self setDates];
}


@end
