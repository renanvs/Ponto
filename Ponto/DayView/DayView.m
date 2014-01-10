//
//  DayView.m
//  Ponto
//
//  Created by Renan Veloso Silva on 06/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "DayView.h"
#import "PontoModel.h"
#import "PontoManager.h"
#import "PontoCell.h"

@implementation DayView

#pragma mark - internal methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self addObservers];
    }
    
    return self;
}

-(void)didAddSubview:(UIView *)subview{
    NSLog(@"Day Add");
}

-(void)didMoveToSuperview{
    if ([PontoManager sharedInstance].currentViewType == ViewDayType){
        [self refreshLabels];
    }
}

-(void)didMoveToWindow{
    NSLog(@"Day Move W");
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabels) name:NotificationContextSaved object:nil];
}

-(void)refreshLabels{
    PontoManager *pontoManager = [PontoManager sharedInstance];
    
    [self.buttonPreviousDay setTitle:pontoManager.previousDate forState:UIControlStateNormal];
    [self.buttonFollowingDay setTitle:pontoManager.followingDate forState:UIControlStateNormal];
    [self.labelCurrentDay setText:pontoManager.currentDate];
    
    [self.labelResult setText:pontoManager.currentHourWorked];
}

#pragma mark - IBAction's

- (IBAction)goToBackDay:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[PontoManager sharedInstance] getPreviousDay];
    [tableViewPontoDayList reloadData];
    [self refreshLabels];
}

- (IBAction)goToForwardDay:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[PontoManager sharedInstance] getFollowingDay];
    [tableViewPontoDayList reloadData];
    [self refreshLabels];
}

-(void)AddAll:(id)sender{
    NSArray *cells = [tableViewPontoDayList visibleCells];
    
    for (PontoCell *cell in cells) {
        [cell addInfoToModel];
    }
}

#pragma mark - tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"PontoCell";
    PontoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.date = [[PontoManager sharedInstance] currentDate];
    cell.type = [self getTypeByIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGRect tableFrame = tableViewPontoDayList.frame;
    tableFrame.size.height = 240;
    tableViewPontoDayList.frame = tableFrame;
    
    return 4;
}


-(PointType)getTypeByIndex:(int)index{
    PointType type;
    
    switch (index) {
        case 0:
            type = PointEntraceType;
            break;
        case 1:
            type = PointFirstIntervalType;
            break;
        case 2:
            type = PointSecondIntervalType;
            break;
        case 3:
            type = PointExitType;
            break;
    }
    
    return type;
}

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
