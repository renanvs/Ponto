//
//  pontoCell.m
//  Ponto
//
//  Created by renan veloso silva on 24/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "PontoCell.h"
#import "PontoManager.h"

@implementation PontoCell

@synthesize date, type;

#pragma mark - set Type
-(void)setType:(PointType)typeR{
    if (typeR == 0) {
        self.typeLabel.text = @"Entrada";
    }else if (typeR == 1) {
        self.typeLabel.text = @"Intervalo 1";
    }else if (typeR == 2) {
        self.typeLabel.text = @"Intervalo 2";
    }else if (typeR == 3) {
        self.typeLabel.text = @"Saida";
    }
    
    type = typeR;
    [self populateInfo];
    [self setDefault];
}

#pragma mark - dafault Method
-(void)setDefault{
    self.hours.keyboardType = UIKeyboardTypeNumberPad;
    self.minutes.keyboardType = UIKeyboardTypeNumberPad;
    
    [[PontoManager sharedInstance]setButtonStyle:self.buttonAction];
}

#pragma mark - load info
-(void)populateInfo{
    PontoManager *pontoManager = [PontoManager sharedInstance];
    NSEntityDescription *entity = [NSEntityDescription entityForName:PontoModelEntity inManagedObjectContext:pontoManager.context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = entity;
    NSArray *result = [pontoManager.context executeFetchRequest:request error:nil];
    
    if (result.count > 0){
        for (PontoModel *pm in result) {
            if ([pm.day.date isEqualToString:date] && (pm.type == [NSNumber numberWithInt:type])) {
                NSArray *components = [pm.hour componentsSeparatedByString:@":"];
                self.hours.text = [components objectAtIndex:0];
                self.minutes.text = [components objectAtIndex:1];
                return;
            }
        }
    }
    
    [self.hours setText:@"--"];
    [self.minutes setText:@"--"];
    
}

#pragma mark - add info
-(void)addInfoToModel{
    
    PontoManager *pontoManager = [PontoManager sharedInstance];
    
    NSString *hour = [self safeTimeUnity:self.hours.text WithTimeType:@"hour"];
    NSString *minute = [self safeTimeUnity:self.minutes.text WithTimeType:@"minute"];
    NSString *day = [pontoManager currentDate];
    
    [pontoManager addPontoWithDay:day AndHour:hour AndMinute:minute AndType:type];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRemoveKeyboard object:nil];
}

#pragma mark - IBAction's
- (IBAction)action:(id)sender{
    [self addInfoToModel];
    
}

#pragma mark - auxiliar methods
-(NSString*)safeTimeUnity:(NSString*)timeUnity WithTimeType:(NSString*)timeType{
    //verifica se é vazia ou não é numerica ou tamanho maior que 2
    BOOL validate = (([NSString isStringEmpty:timeUnity]) || (![NSString isStringWithNumeric:timeUnity]) || ([timeUnity length] > 2));
    
    if (validate) {
        return @"--";
    }
    
    if ([timeUnity length] == 1 && [NSString isStringWithNumeric:timeUnity]) {
        return [NSString stringWithFormat:@"0%@",timeUnity];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    int num= [[formatter numberFromString:timeUnity] intValue];
    if ([timeType isEqualToString:@"hour"]) {
        if (num > 24 || num < 0){
            return @"Er";
        }
    }else if ([timeType isEqualToString:@"minute"]) {
        if (num > 59 || num < 0){
            return @"Er";
        }
    }
    
    return timeUnity;
}

#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self addInfoToModel];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.hours) {
        textField.text = [self safeTimeUnity:textField.text WithTimeType:@"hour"];
    }else if (textField == self.minutes){
        textField.text = [self safeTimeUnity:textField.text WithTimeType:@"minute"];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSRange rangeError = [textField.text rangeOfString:@"Er"];
    NSRange rangeNew = [textField.text rangeOfString:@"--"];
    
    bool validateToClean = (rangeError.length > 0) || (rangeNew.length > 0) || (textField.text.length > 2) || !([NSString isStringWithNumeric:textField.text]);
    
    if (validateToClean) {
        textField.text = @"";
    }
}

@end
