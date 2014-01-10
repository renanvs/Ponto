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

-(void)adjustViewButtons{
    
    ViewType type = [PontoManager sharedInstance].currentViewType;
    
    if (type == ViewDayType) {
        [self.buttonDay setAlpha:0.5];
        [self.buttonMonthList setAlpha:1];
    }else if (type == ViewMonthType){
        [self.buttonDay setAlpha:1];
        [self.buttonMonthList setAlpha:0.5];
    }else{
        [self.buttonDay setAlpha:1];
        [self.buttonMonthList setAlpha:1];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([PontoManager sharedInstance].currentViewType == ViewBlankType) {
        dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil] objectAtIndex:0];
        [PontoManager sharedInstance].currentViewType = ViewDayType;
        //[dayView refreshLabels];
        [viewContainer addSubview:dayView];
    }else{
        NSLog(@"failed to load view");
    }
    
    [self adjustViewButtons];
    
}

-(void)addObservers{
    if (hasObservers) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKeyboard) name:NotificationRemoveKeyboard object:nil];
    
    hasObservers = YES;
}

-(void)keyboardDidShow{
    [self addCloseButtonToNumericKeyboard];
}

-(void)addCloseButtonToNumericKeyboard{
    CGRect deviceSize = [[Utils sharedinstance] screenBoundsOnOrientation];
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
        closeKeyboardButton = nil;
    }
}

#pragma mark - tabBarDelegate

-(IBAction)buttonAction:(id)sender{
    if (sender == self.buttonDay) {
        if (!dayView){
            dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil] objectAtIndex:0];
        }
        [PontoManager sharedInstance].currentViewType = ViewDayType;
        [viewContainer addSubview:dayView];
        [self removeSubviewsExceptionView:dayView];
    }else if (sender == self.buttonMonthList) {
        if (!monthView){
            monthView = [[[NSBundle mainBundle] loadNibNamed:@"MonthView" owner:self options:nil] objectAtIndex:0];
        }
        [PontoManager sharedInstance].currentViewType = ViewMonthType;
        [viewContainer addSubview:monthView];
        [self removeSubviewsExceptionView:monthView];
    }else{
        [PontoManager sharedInstance].currentViewType = ViewOtherType;
    }
    
    [self adjustViewButtons];
}

- (void)dealloc {
    [_buttonDay release];
    [_buttonMonthList release];
    [super dealloc];
}

-(void)removeSubviewsExceptionView:(UIView*)viewE{
    for (UIView *view in viewContainer.subviews) {
        if ((view != viewE) && (view.superview != nil)) {
            [view retain];
            [view removeFromSuperview];
        }
    }
}

@end
