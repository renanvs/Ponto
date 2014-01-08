//
//  MonthView.m
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MonthView.h"

#import "PontoModel.h"
#import "MonthManager.h"
#import "MonthCell.h"

@implementation MonthView

#pragma mark - internal methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self addObservers];
    }
    
    return self;
}

-(void)didMoveToWindow{
    NSLog(@"sdfs");
    [[MonthManager sharedinstance] refresh];
    [self refreshLabels];
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabels) name:NotificationContextSaved object:nil];
}

-(void)refreshLabels{
    MonthManager *monthManager = [MonthManager sharedinstance];
    
    [self.buttonBeforeMonth setTitle:monthManager.beforeMonth forState:UIControlStateNormal];
    [self.buttonAfterMonth setTitle:monthManager.nextMonth forState:UIControlStateNormal];
    [self.labelCurrentMonth setText:monthManager.currentMonth];
    
    [self.labelDescriptionResult setText:[NSString stringWithFormat:@"%@ horas",monthManager.currentTotalMonthHours]];
}

#pragma mark - IBAction's

- (IBAction)goToBackMonth:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[MonthManager sharedinstance] getMonthBefore];
    [tableViewPontoMonthList reloadData];
    [self refreshLabels];
}

- (IBAction)goToForwardMonth:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[MonthManager sharedinstance] getMonthAfter];
    [tableViewPontoMonthList reloadData];
    [self refreshLabels];
}

#pragma mark - tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier2 = @"MonthCell";
    MonthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil] objectAtIndex:0];
    }
    
    cell.dayStr = [[MonthManager sharedinstance] getDayByIndex:indexPath.row InList:[[MonthManager sharedinstance]currentMonthList]];
    cell.hoursStr = [[MonthManager sharedinstance] getHoursByDay:cell.dayStr InList:[[MonthManager sharedinstance]currentMonthList]];
    
    [cell setInfo];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGRect tableFrame = tableViewPontoMonthList.frame;
    tableFrame.size.height = 240;
    tableViewPontoMonthList.frame = tableFrame;
    
    return [[MonthManager sharedinstance]currentMonthList].count;
}

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end