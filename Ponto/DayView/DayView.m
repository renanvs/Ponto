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

-(void)didMoveToSuperview{
    if ([PontoManager sharedInstance].currentViewType == ViewDayType){
        
        
        [self setDefaultStyle];
        [self refreshLabels];
    }
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabels) name:NotificationContextSaved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDisappear) name:UIKeyboardDidHideNotification object:nil];
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

-(IBAction)AddAll:(id)sender{
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

#pragma mark - auxiliar methods

-(void)refreshLabels{
    
    PontoManager *pontoManager = [PontoManager sharedInstance];
    
    [self.buttonPreviousDay setTitle:pontoManager.previousDate forState:UIControlStateNormal];
    [self.buttonFollowingDay setTitle:pontoManager.followingDate forState:UIControlStateNormal];
    [self.labelCurrentDay setText:pontoManager.currentDate];
    
    [self.labelResult setText:pontoManager.currentHourWorked];
}

-(void)setDefaultStyle{
    [[PontoManager sharedInstance]setButtonStyle:self.buttonPreviousDay];
    [[PontoManager sharedInstance]setButtonStyle:self.buttonFollowingDay];
    [[PontoManager sharedInstance]setButtonStyle:self.buttonAddAll];
    
    tableViewOriginalRect = tableViewPontoDayList.frame;
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

-(void)keyboardDidShow:(NSNotification*)notification{
    
    //todo extract method
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat keyboardHeight = keyboardFrameBeginRect.size.height;
    CGRect deviceRect = [[Utils sharedinstance] screenBoundsOnOrientation];
    CGFloat deviceHeight = deviceRect.size.height;
    CGFloat topbarHeight = topBar.frame.size.height;
    CGFloat gap = 18;
    
    CGFloat tableViewNewHeight = deviceHeight - (keyboardHeight + topbarHeight + gap + 30);
    
    CGRect tableViewNewRect = CGRectMake(tableViewOriginalRect.origin.x, tableViewOriginalRect.origin.y, tableViewOriginalRect.size.width, tableViewNewHeight);
    
    [tableViewPontoDayList setFrame:tableViewNewRect];
    [tableViewPontoDayList setBounces:YES];
    [tableViewPontoDayList setScrollEnabled:YES];
}

-(void)keyboardDidDisappear{
    [tableViewPontoDayList setBounces:NO];
    [tableViewPontoDayList setScrollEnabled:NO];
    [tableViewPontoDayList setFrame:tableViewOriginalRect];
    
}

//todo next previous
-(void)addCloseButtonToNumericKeyboard{
    CGRect deviceSize = [[Utils sharedinstance] screenBoundsOnOrientation];
    deviceSize.origin.y = deviceSize.size.height-216-50;
    deviceSize.origin.x = deviceSize.size.width-70;
    
    [self createButton:nextFieldButton WithTitle:@"Proximo"];
    [self createButton:previousFieldButton WithTitle:@"Anterior"];
    
    [previousFieldButton setFrame:CGRectMake(deviceSize.origin.x, deviceSize.origin.y, 70, 30)];
    [nextFieldButton setFrame:CGRectMake(deviceSize.origin.x, deviceSize.origin.y, 70, 30)];
    
    [previousFieldButton addTarget:self action:@selector(previousField) forControlEvents:UIControlEventTouchUpInside];
    [nextFieldButton addTarget:self action:@selector(nextField) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:previousFieldButton];
    [self addSubview:nextFieldButton];
}

-(void)createButton:(UIButton*)bt WithTitle:(NSString*)title{
    bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor whiteColor]];
    [[PontoManager sharedInstance] setButtonStyle:bt];
}

-(void)nextField{

}

-(void)previousField{
    
}

#pragma mark - finish methods

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
