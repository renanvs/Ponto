//
//  PontoManager.m
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "PontoManager.h"

@implementation PontoManager

@synthesize contexto, currentDate, beforeDate, nextDate, currentViewType, currentHourWorked;

static id _instance;

+ (PontoManager *) sharedinstance{
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
        [self contexto];
        currentViewType = ViewDayType;
        [self setDates];
    }
    
    return self;
}

-(void)setDates{
    currentDate = [[NSString alloc ] initWithString:[self getDayByDayDelay:0]];
    nextDate =  [[NSString alloc ] initWithString:[self getDayByDayDelay:1]];
    beforeDate = [[NSString alloc ] initWithString:[self getDayByDayDelay:-1]];
    [self timeInfo];
}

-(NSString *)getDayByDayDelay:(int)delay{
    NSString *dateStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:delay];
    
    NSDate *currentDay = nil;
    
    if (!currentDate) {
        currentDay= [NSDate date];
    }else{
        currentDay = [formatter dateFromString:currentDate];
    }
    
    
    NSDate *dayFormated = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:currentDay options:0];
    dateStr = [formatter stringFromDate:dayFormated];

    return dateStr;
    
}

-(void)addPontoWithDay:(NSString*)day AndHour:(NSString*)hour AndMinute:(NSString*)minute AndType:(PointType)type{
    DayModel *dayModel = [self getDayModel:day];
    
    [self getPontoModelWithHour:hour withMinute:minute AndDayModel:dayModel AndType:type];
    
    [self saveContext];
}

-(void)timeInfo{
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.contexto];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [self.contexto executeFetchRequest:request error:nil];
    
    NSMutableArray *currentDayPontosList = [[NSMutableArray alloc] init];
    for (PontoModel *pm in result) {
        if ([pm.days.data isEqualToString:currentDate]) {
            [currentDayPontosList addObject:pm];
        }
    }
    
    PontoStatus pontoStatus = [self getPontoTypeByDayList:currentDayPontosList];
    
    if (pontoStatus == PontoStatusDayInBlank) {
        currentHourWorked = @"00:00";
    }else if (pontoStatus == PontoStatusError) {
        currentHourWorked = @"error";
    }else if ((pontoStatus == PontoStatusStillWorking) || (pontoStatus == PontoStatusDayWorked)) {
        currentHourWorked = [[NSString alloc] initWithString:[self sumDayTime:currentDayPontosList]];
    }
    
}

-(NSString*)sumDayTime:(NSArray*)dayList{
    
    NSString *enter = nil;
    NSString *first = nil;
    NSString *second = nil;
    NSString *exit = nil;
    
    for (PontoModel *pm in dayList) {
        if ([pm.type integerValue] == PointEntraceType ) {
            enter = pm.hora;
        }else if ([pm.type integerValue] == PointFirstIntervalType ) {
            first = pm.hora;
        }else if ([pm.type integerValue] == PointSecondIntervalType ) {
            second = pm.hora;
        }else if ([pm.type integerValue] == PointExitType) {
            exit = pm.hora;
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

-(void)getPontoModelWithHour:(NSString*)hour withMinute:(NSString*)minute AndDayModel:(DayModel*)dayModel AndType:(PointType)type{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.contexto];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    
    NSArray *result = [self.contexto executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (PontoModel *pm in result) {
            if ((pm.days == dayModel) && (pm.type == [NSNumber numberWithInt:type])) {
                pm.hora = [NSString stringWithFormat:@"%@:%@", hour, minute];
                return;
            }
        }
    }
    
    PontoModel *pontoModel = (PontoModel*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.contexto];
    
    pontoModel.hora = [[NSString alloc] initWithFormat:@"%@:%@", hour, minute];
    pontoModel.type = [NSNumber numberWithInt:type];
    
    [self.contexto insertObject:pontoModel];
    
    pontoModel.days = dayModel;
    
}

-(DayModel*)getDayModel:(NSString*)day{
    NSEntityDescription *entity = [NSEntityDescription entityForName:DayModelEntity inManagedObjectContext:self.contexto];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [self.contexto executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (DayModel *dm in result) {
            if ([dm.data isEqualToString:day]) {
                return dm;
            }
        }
    }
    
    DayModel *dm = [NSEntityDescription insertNewObjectForEntityForName:DayModelEntity inManagedObjectContext:contexto];
    
    dm.data = day;
    
    return dm;
}

-(void)getPontoModel:(PontoModel*)ponto withDay:(DayModel*)day{
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:self.contexto];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    
    NSArray *result = [self.contexto executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (PontoModel *pm in result) {
            if ((pm.days == day) && (pm.type == ponto.type)) {
                pm.hora = ponto.hora;
                return;
            }
        }
    }
    
    [self.contexto insertObject:ponto];
    
    ponto.days = day;
    
}

-(void)saveContext{
    NSError *error;
    if (![contexto save:&error]) {
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

-(NSManagedObjectContext *)contexto{
    if (contexto != nil) {
        return contexto;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    contexto = [[NSManagedObjectContext alloc] init];
    [contexto setPersistentStoreCoordinator:coordinator];
    return contexto;
}


-(void)getDayAfter{
    currentDate = nextDate;
    [self setDates];
}

-(void)getDayBefore{
    currentDate = beforeDate;
    [self setDates];
}


@end
