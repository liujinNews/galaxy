//
//  ChangePhoneNumController.m
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ChangePhoneNumController.h"

@interface ChangePhoneNumController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *txf_numData;//修改内容

@end

@implementation ChangePhoneNumController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    NSString *title = @"";
    if (self.type == 1) {
        title = Custing(@"修改联系方式", nil);
    }else if (self.type == 2){
        title = Custing(@"修改银行账号", nil);
    }
    [self setTitle:title backButton:YES];
    [self createView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.txf_numData becomeFirstResponder];
}
//MARK:视图创建
-(void)createView{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Add_AgentSave":@"NavBarImg_Tick" target:self action:@selector(SaveNumber)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 50)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view];
    
    _txf_numData = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-30, 20) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_GrayDark_Same_20];
    [view addSubview:_txf_numData];
    
    if (self.type == 1) {
        _txf_numData.keyboardType = UIKeyboardTypeNumberPad;
        _txf_numData.text = self.str_content;
    }else if (self.type == 2){
        _txf_numData.keyboardType = UIKeyboardTypeEmailAddress;
    }
}

//MARK:保存电话号码
-(void)SaveNumber{
    if (self.type == 1 && (_txf_numData.text.length < 7 || _txf_numData.text.length > 11)) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入正确联系方式", nil) duration:2.0];
        return;
    }else if (self.type == 1 && _txf_numData == 0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入银行账号", nil) duration:2.0];
        return;
    }
    if (self.numDataChangeBlock) {
        self.numDataChangeBlock(self.txf_numData.text, self.type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.type == 1) {
        if ([toBeString characterAtIndex:0] == '0') {
            return NO;
        }
        for (NSInteger i = 0; i < string.length; i++) {
            unichar single = [string characterAtIndex:i];
            if (!(single >= '0' && single <= '9')){
                return NO;
            }
        }
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
