//
//  DayModel.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PontoModel;

@interface DayModel : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSSet *pontos;
@end

@interface DayModel (CoreDataGeneratedAccessors)

- (void)addPontosObject:(PontoModel *)value;
- (void)removePontosObject:(PontoModel *)value;
- (void)addPontos:(NSSet *)values;
- (void)removePontos:(NSSet *)values;

@end
