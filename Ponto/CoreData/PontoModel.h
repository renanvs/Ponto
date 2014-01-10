//
//  PontoModel.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayModel;

@interface PontoModel : NSManagedObject

@property (nonatomic, retain) NSString * hour;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) DayModel *day;

@end
