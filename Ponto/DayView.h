//
//  DayView.h
//  Ponto
//
//  Created by Renan Veloso Silva on 06/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayModel.h"

@interface DayView : UIView <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tableViewPontoDayList;
}

@property (assign, nonatomic) IBOutlet UILabel *labelCurrentDay;
@property (assign, nonatomic) IBOutlet UIButton *buttonBeforeDay;
@property (assign, nonatomic) IBOutlet UIButton *buttonAfterDay;

@property (assign, nonatomic) IBOutlet UILabel *labelDescription;
@property (assign, nonatomic) IBOutlet UILabel *labelDescriptionResult;

- (IBAction)goToBackDay:(id)sender;
- (IBAction)goToForwardDay:(id)sender;
- (void)refreshLabels; 




@end
