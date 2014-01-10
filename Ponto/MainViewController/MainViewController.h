//
//  MainViewController.h
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayView.h"
#import "MonthView.h"

@interface MainViewController : UIViewController{
    DayView *dayView;
    MonthView *monthView;
    
    IBOutlet UIView *viewContainer;
    
    BOOL hasObservers;
    UIButton *closeKeyboardButton;
}

@property (retain, nonatomic) IBOutlet UIButton *buttonDay;
@property (retain, nonatomic) IBOutlet UIButton *buttonMonthList;

-(IBAction)buttonAction:(id)sender;

@end
