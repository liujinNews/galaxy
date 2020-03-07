//
//  STAlertView.m
//  STAlertView
//
//  Created by Nestor on 09/28/2014.
//  Copyright (c) 2014 Nestor. All rights reserved.
//

#import "STAlertView.h"


typedef enum {
    STAlertViewTypeNormal,
    STAlertViewTypeTextField,
    STAlertViewTypeTextFieldIndex
} STAlertViewType;

@implementation STAlertView{
    STAlertViewBlock cancelButtonBlock;
    STAlertViewBlock otherButtonBlock;
    
    STAlertViewStringBlock textFieldBlock;
}



- (void) alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && cancelButtonBlock)
        cancelButtonBlock();
    else if (buttonIndex == 1 && theAlertView.tag == STAlertViewTypeNormal && otherButtonBlock)
        otherButtonBlock();
    else if (buttonIndex == 1 && theAlertView.tag == STAlertViewTypeTextField && textFieldBlock)
        textFieldBlock([self.alertView textFieldAtIndex:0].text);
    else if (buttonIndex ==1 & theAlertView.tag == STAlertViewTypeTextFieldIndex &&textFieldBlock)textFieldBlock([self.alertView textFieldAtIndex:1].text);
    
}

- (void) alertViewCancel:(UIAlertView *)theAlertView
{
    if (cancelButtonBlock)
        cancelButtonBlock();
}

- (id) initWithTitle:(NSString*)title
             message:(NSString*)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles
   cancelButtonBlock:(STAlertViewBlock)theCancelButtonBlock
    otherButtonBlock:(STAlertViewBlock)theOtherButtonBlock
{

    cancelButtonBlock = [theCancelButtonBlock copy];
    otherButtonBlock = [theOtherButtonBlock copy];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.alertView.tag = STAlertViewTypeNormal;
    
    [self.alertView show];
    
    return self;
}

- (id) initWithTitle:(NSString*)title
             message:(NSString*)message
       textFieldHint:(NSString*)textFieldMessage
      textFieldValue:(NSString *)texttFieldValue
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles
   cancelButtonBlock:(STAlertViewBlock)theCancelButtonBlock
    otherButtonBlock:(STAlertViewStringBlock)theOtherButtonBlock
{
    
    cancelButtonBlock = [theCancelButtonBlock copy];
    textFieldBlock = [theOtherButtonBlock copy];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.alertView.tag = STAlertViewTypeTextField;

    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[self.alertView textFieldAtIndex:0] setPlaceholder:textFieldMessage];
    [[self.alertView textFieldAtIndex:0] setText:texttFieldValue];
    
    [self.alertView show];
    
    return self;
}

- (id) initWithTitle:(NSString *)title
             message:(NSString *)message
       textFieldHint:(NSString *)textFieldMessage
      textFieldValue:(NSString *)texttFieldValue
       textFieldPass:(NSString *)textFieldPMessage
  textFieldPassValue:(NSString *)texttFieldPValue
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles
   cancelButtonBlock:(STAlertViewBlock)theCancelButtonBlock
    otherButtonBlock:(STAlertViewStringBlock)theOtherButtonBlock
{
    
    cancelButtonBlock = [theCancelButtonBlock copy];
    textFieldBlock = [theOtherButtonBlock copy];
    //UIAlertViewStyleLoginAndPasswordInput
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.alertView.tag = STAlertViewTypeTextFieldIndex;
    
//    UIAlertViewStyleDefault = 0,
//    UIAlertViewStyleSecureTextInput,
//    UIAlertViewStylePlainTextInput,
//    UIAlertViewStyleLoginAndPasswordInput
    
    self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[self.alertView textFieldAtIndex:0] setPlaceholder:textFieldMessage];
    [[self.alertView textFieldAtIndex:0] setText:texttFieldValue];
    
    [[self.alertView textFieldAtIndex:0] setUserInteractionEnabled:NO];
    [[self.alertView textFieldAtIndex:1] setPlaceholder:textFieldPMessage];
    [[self.alertView textFieldAtIndex:1] setText:texttFieldPValue];
    [[self.alertView textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeEmailAddress];
    [[self.alertView textFieldAtIndex:1] setSecureTextEntry:YES];
    [[self.alertView textFieldAtIndex:1] setUserInteractionEnabled:YES];
    
    [self.alertView show];
    
    return self;
}




@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
