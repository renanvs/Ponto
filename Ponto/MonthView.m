//
//  MonthView.m
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "MonthView.h"
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
    [[MonthManager sharedinstance] refresh];
    [self refreshLabels];
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabels) name:NotificationContextSaved object:nil];
}

-(void)refreshLabels{
    MonthManager *monthManager = [MonthManager sharedinstance];
    
    [self.buttonPreviousMonth setTitle:monthManager.previousMonth forState:UIControlStateNormal];
    [self.buttonFollowingMonth setTitle:monthManager.followingMonth forState:UIControlStateNormal];
    [self.labelCurrentMonth setText:monthManager.currentMonth];
    
    [self.labelResult setText:[NSString stringWithFormat:@"%@ horas",monthManager.currentTotalMonthHours]];
}

#pragma mark - IBAction's

- (IBAction)goToPreviousMonth:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[MonthManager sharedinstance] getPreviousMonth];
    [tableViewPontoMonthList reloadData];
    [self refreshLabels];
}

- (IBAction)goToFollowingMonth:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationRemoveKeyboard object:nil];
    [[MonthManager sharedinstance] getFollowingMonth];
    [tableViewPontoMonthList reloadData];
    [self refreshLabels];
}

#pragma mark - tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"MonthCell";
    MonthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.day = [[MonthManager sharedinstance] getDayByIndex:indexPath.row InMonthList:[[MonthManager sharedinstance]currentMonthList]];
    cell.hours = [[MonthManager sharedinstance] getHoursByDay:cell.day InMonthList:[[MonthManager sharedinstance]currentMonthList]];
    
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