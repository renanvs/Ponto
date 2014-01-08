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

@interface MainViewController : UIViewController<UITabBarControllerDelegate, UITabBarDelegate>{
    DayView *dayView;
    MonthView *monthView;
    
    BOOL hasObservers;
    UIButton *closeKeyboardButton;
}

@property (assign, nonatomic) IBOutlet UITabBar *tabBar;
@property (retain, nonatomic) IBOutlet UITabBarItem *dayItem;
@property (retain, nonatomic) IBOutlet UITabBarItem *monthItem;


@end
