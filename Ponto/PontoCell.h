//
//  pontoCell.h
//  Ponto
//
//  Created by renan veloso silva on 24/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PontoCell : UITableViewCell<UITextFieldDelegate>{
    NSString *date;
    PointType type;

}

@property (nonatomic, assign) IBOutlet UITextField  *hours;
@property (nonatomic, assign) IBOutlet UITextField  *minutes;
@property (nonatomic, assign) IBOutlet UILabel      *typeLabel;
@property (nonatomic, assign) IBOutlet UIButton     *buttonAction;

@property (nonatomic, assign) NSString *date;
@property (nonatomic, assign) PointType type;

- (IBAction)action:(id)sender;
- (IBAction)chooseImage:(id)sender;

@end
