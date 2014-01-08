//
//  MonthView.h
//  Ponto
//
//  Created by Renan Veloso Silva on 08/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthView : UIView <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tableViewPontoMonthList;
}

@property (assign, nonatomic) IBOutlet UILabel *labelCurrentMonth;
@property (assign, nonatomic) IBOutlet UIButton *buttonPreviousMonth;
@property (assign, nonatomic) IBOutlet UIButton *buttonFollowingMonth;

@property (assign, nonatomic) IBOutlet UILabel *labelResult;

- (IBAction)goToPreviousMonth:(id)sender;
- (IBAction)goToFollowingMonth:(id)sender;
- (void)refreshLabels;


@end
