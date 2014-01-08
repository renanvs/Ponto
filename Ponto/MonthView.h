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
@property (assign, nonatomic) IBOutlet UIButton *buttonBeforeMonth;
@property (assign, nonatomic) IBOutlet UIButton *buttonAfterMonth;

@property (assign, nonatomic) IBOutlet UILabel *labelDescription;
@property (assign, nonatomic) IBOutlet UILabel *labelDescriptionResult;

- (IBAction)goToBackMonth:(id)sender;
- (IBAction)goToForwardMonth:(id)sender;
- (void)refreshLabels;


@end
