//
//  GraphCircle.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 14/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicalCircle : UIViewController{
    
    NSString *width;
    NSString *height;
    NSString *graphicTitle;
    NSString *type;
    NSDictionary *data;
    
    IBOutlet UIWebView *webView;
    NSString *format_tool;
    NSString *format_label;
}

@property (nonatomic, assign) NSString *graphicTitle;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, assign) NSDictionary *data;

-(void)initGraphCreation;

-(IBAction)back:(id)sender;

@end
