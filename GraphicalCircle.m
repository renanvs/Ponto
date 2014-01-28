//
//  GraphicalCircle
//  daily Expenses
//
//  Created by Renan Veloso Silva on 14/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "GraphicalCircle.h"

@implementation GraphicalCircle
@synthesize graphicTitle, type, data;

-(void)initGraphCreation{
    [self setFormaters:type];
    
    [self createrWebview];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    float widthFloat = [[formatter numberFromString:width] floatValue];
    float heightFloat = [[formatter numberFromString:height] floatValue];
    CGRect rect = CGRectMake(0, 0, widthFloat, heightFloat);
    
    //[self.view setFrame:rect];
    //[webView setFrame:rect];
    
    //[self.view addSubview:webView];
}

-(void)setFormaters:(NSString*)typeR{
    if ([typeR isEqualToString:@"percent"]) {
        format_tool = @"{series.name}: <b>{point.percentage:.1f}%</b>";
        format_label = @"<p style='font-size:14px;font-weight:bolder'>{point.name}</p> :  {point.percentage:.2f}%";
    }else if ([typeR isEqualToString:@"money"]) {
        format_tool = @"{series.name}: <b>R$ {point.y:.1f}</b>";
        format_label = @"<p style='font-size:14px;font-weight:bolder'>{point.name}</p> : R$ {point.y:.2f}";
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self initGraphCreation];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self initGraphCreation];
}

-(void)createrWebview{
    
    NSURL *paintUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    NSString *html = [NSString stringWithContentsOfURL:paintUrl encoding:NSUTF8StringEncoding error:nil];
    
    html = [html stringByReplacingOccurrencesOfString:@"%header_declarations%" withString:[self header_declarations]];
    width = [NSString stringWithFormat:@"%.0f", webView.frame.size.width];
    height = [NSString stringWithFormat:@"%.0f", webView.frame.size.height];
    html = [html stringByReplacingOccurrencesOfString:@"%WIDTH%" withString:width];
    html = [html stringByReplacingOccurrencesOfString:@"%HEIGHT%" withString:height];
    html = [html stringByReplacingOccurrencesOfString:@"%DATA_FIELD%" withString:[self getData]];
    html = [html stringByReplacingOccurrencesOfString:@"%FORMAT_LABEL%" withString:format_label];
    html = [html stringByReplacingOccurrencesOfString:@"%FORMAT_TOOL%" withString:format_tool];
    html = [html stringByReplacingOccurrencesOfString:@"%TITLE%" withString:graphicTitle];
    //webView = [[UIWebView alloc] init];
    [webView loadHTMLString:html baseURL:nil];
}

-(NSString*)header_declarations{
    NSURL *jqueryUrl = [[NSBundle mainBundle] URLForResource:@"jquery.min" withExtension:@"js"];
    NSURL *highchartsUrl = [[NSBundle mainBundle] URLForResource:@"highcharts" withExtension:@"js"];
    
    NSString *scripsDeclaration = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script>",jqueryUrl,highchartsUrl];
    
    return scripsDeclaration;
}

-(NSString*)getData{
    NSMutableString *dataStr = [[NSMutableString alloc] init];
    NSArray *allKeys = [data allKeys];
    for (NSString *key in allKeys) {
        [dataStr appendFormat:@"['%@', %@],",key, [data objectForKey:key]];
    }
    
    NSRange range;
    range.length = 1;
    range.location = dataStr.length -1;
    [dataStr deleteCharactersInRange:range];
    NSLog(@"dsfsd");
    return dataStr;
}

-(void)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
