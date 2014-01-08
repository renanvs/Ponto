//
//  MainViewController.m
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "MainViewController.h"
#import "PontoModel.h"
#import "PontoManager.h"
#import "PontoCell.h"



@implementation MainViewController

#pragma mark - internal methods

-(id)init{
    self = [super init];
    
    if (self) {
        [self addObservers];
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([PontoManager sharedinstance].currentViewType == ViewDayType) {
        dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil] objectAtIndex:0];
        [dayView refreshLabels];
        [self.view addSubview:dayView];
    }else{
        NSLog(@"failed to load view");
    }
    
}

-(void)addObservers{
    if (hasObservers) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKeyboard) name:NotificationRemoveKeyboard object:nil];
    
    hasObservers = YES;
}

-(void)keyboardDidShow{
    [self addCloseButtonToNumericKeyboard];
}

-(void)keyboardWillHide{
//    if (closeButton) {
//        [closeButton removeFromSuperview];
//        [closeButton release];
//        closeButton = nil;
//    }
}

-(void)addCloseButtonToNumericKeyboard{
    CGRect deviceSize = [[Utils sharedinstance] screenBoundsDependOnOrientation];
    deviceSize.origin.y = deviceSize.size.height-216-30;
    deviceSize.origin.x = deviceSize.size.width-70;
    
    closeKeyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeKeyboardButton setFrame:CGRectMake(deviceSize.origin.x, deviceSize.origin.y, 70, 30)];
    [closeKeyboardButton setTitle:@"Fechar" forState:UIControlStateNormal];
    [closeKeyboardButton setBackgroundColor:[UIColor whiteColor]];
    [closeKeyboardButton addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeKeyboardButton];
}

-(void)removeKeyboard{

    for (UITextField *tf in [self.view subviews]) {
        [tf resignFirstResponder];
        
    }
    
    for (UIView *view in [self.view subviews]) {
        [view endEditing:YES];
        
    }
    
    if (closeKeyboardButton) {
        [closeKeyboardButton removeFromSuperview];
        //[closeButton release];
        closeKeyboardButton = nil;
    }
}

#pragma mark - tabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == self.dayItem) {
        if (!dayView) dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil] objectAtIndex:0];
        [dayView refreshLabels];
        
        [self.view addSubview:dayView];
        [PontoManager sharedinstance].currentViewType = ViewDayType;
    }else if (item == self.monthItem) {
        if (!monthView) {
            monthView = [[[NSBundle mainBundle] loadNibNamed:@"MonthView" owner:self options:nil] objectAtIndex:0];
        }
        
        [self.view addSubview:monthView];
        //[monthView refreshLabels];
        
        [PontoManager sharedinstance].currentViewType = ViewMonthType;
    }else{
        [PontoManager sharedinstance].currentViewType = ViewOtherType;
    }
}

- (void)dealloc {
    [_dayItem release];
    [super dealloc];
}
@end
