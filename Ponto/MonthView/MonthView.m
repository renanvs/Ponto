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

-(void)didMoveToSuperview{
    if ([PontoManager sharedInstance].currentViewType == ViewMonthType){
        [[MonthManager sharedinstance] refresh];
        [self refreshLabels];
        [self setDefaultLayout];
    }
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabels) name:NotificationContextSaved object:nil];
}


#pragma mark - Auxiliar method's
-(void)refreshLabels{
    
    
    MonthManager *monthManager = [MonthManager sharedinstance];
    
    [self.buttonPreviousMonth setTitle:monthManager.previousMonth forState:UIControlStateNormal];
    [self.buttonFollowingMonth setTitle:monthManager.followingMonth forState:UIControlStateNormal];
    [self.labelCurrentMonth setText:monthManager.currentMonth];
    
    [self.labelResult setText:[NSString stringWithFormat:@"%@ horas",monthManager.currentTotalMonthHours]];
    [tableViewPontoMonthList reloadData];
}

-(void)setDefaultLayout{
    [[PontoManager sharedInstance]setButtonStyle:self.buttonFollowingMonth];
    [[PontoManager sharedInstance]setButtonStyle:self.buttonPreviousMonth];
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
    cell.model = [[[MonthManager sharedinstance]currentMonthList] objectAtIndex:indexPath.row];
    
    [cell setInfo];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGRect tableFrame = tableViewPontoMonthList.frame;
    tableFrame.size.height = 300;
    tableViewPontoMonthList.frame = tableFrame;
    
    return [[MonthManager sharedinstance]currentMonthList].count;
}

#pragma mark - Finish method's
-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end