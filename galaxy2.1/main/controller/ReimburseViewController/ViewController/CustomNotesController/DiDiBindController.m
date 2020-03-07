//
//  DiDiBindController.m
//  galaxy
//
//  Created by hfk on 2017/8/24.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "DiDiBindController.h"

@interface DiDiBindController ()<UITextFieldDelegate,GPClientDelegate>
@property(nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UITextField * phoneTF;
@property(nonatomic,strong)UITextField * verifTF;
@property(nonatomic,strong)UIButton * SMSBtn;
@property(nonatomic,strong)UIButton * SureBtn;
@property(nonatomic,strong)NSTimer * timer;
@property(assign,nonatomic) NSUInteger verificationCount;

@end

@implementation DiDiBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    [self setTitle:Custing(@"绑定", nil) backButton:YES];
    [self createUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
-(void)createUI{
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width,101)];
    self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.mainView ];

    //手机号
    self.phoneTF = [GPUtils createTextField:CGRectMake(12, 0, Main_Screen_Width-24, 50) placeholder:Custing(@"请输入手机号", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneTF.tag = 0;
    self.phoneTF.delegate = self;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainView addSubview:self.phoneTF];
    
    UIView *lineUp = [[UIView alloc]initWithFrame:CGRectMake(12,50, Main_Screen_Width,0.5)];
    lineUp.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:lineUp];

    
    self.verifTF = [GPUtils createTextField:CGRectMake(12, 50.5, Main_Screen_Width-12-100, 50) placeholder:Custing(@"请输入验证码", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.verifTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verifTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verifTF.tag = 2;
    self.verifTF.delegate = self;
    [self.mainView addSubview:self.verifTF];
    
    self.SMSBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width-90, 50.5, 80, 50) action:@selector(haveSMSCode:) delegate:self title:Custing(@"获取验证码", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
    [self.mainView addSubview:self.SMSBtn];
    
    
    _SureBtn = [GPUtils createButton:CGRectMake(12, 150, Main_Screen_Width-24, 40) action:@selector(sureto:) delegate:self title:Custing(@"确定", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [_SureBtn setBackgroundColor:Color_Blue_Important_20];
    _SureBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:_SureBtn];
}

-(void)haveSMSCode:(UIButton *)btn{
    _SMSBtn.userInteractionEnabled = NO;
    if (_phoneTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.5];
        _SMSBtn.userInteractionEnabled = YES;
        return;
    }
    if ([GPUtils isPhoneNoWithString:_phoneTF.text] == NO) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
        _SMSBtn.userInteractionEnabled = YES;
        return;
    }
    [self requestGetDiDicode];
}
-(void)sureto:(UIButton *)btn{
    [self keyClose];
    if (_phoneTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.5];
        return;
    }
    if ([GPUtils isPhoneNoWithString:_phoneTF.text] == NO) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
        return;
    }
    if (_verifTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入验证码", nil) duration:1.5];
        return;
    }
    [self requestDiDiUserAuth];
    
    
}

-(void)requestGetDiDicode{
    NSString *url = [NSString stringWithFormat:@"%@",GETDIDICODE] ;
    NSDictionary *parameters = @{@"UserAccount":[NSString stringWithFormat:@"%@",self.phoneTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)requestDiDiUserAuth{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url = [NSString stringWithFormat:@"%@",DIDIUserAuth] ;
    NSDictionary *parameters = @{@"Phone":[NSString stringWithFormat:@"%@",self.phoneTF.text],@"Code":[NSString stringWithFormat:@"%@",self.verifTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];

}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        _SMSBtn.userInteractionEnabled = YES;
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
            self.verificationCount = COUNT;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(registerMinCount:)
                                                        userInfo:nil
                                                         repeats:YES];

            self.SMSBtn.userInteractionEnabled = NO;
//            [self.timer fire];
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"绑定成功", nil) duration:1.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:2];
        }
            break;
        default:
            break;
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    _SMSBtn.userInteractionEnabled = YES;
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



-(void)registerMinCount:(NSTimer*)timer{
    self.verificationCount -- ;
    [self.SMSBtn setTitle:[NSString stringWithFormat:@"%lu s",(unsigned long)self.verificationCount] forState:UIControlStateNormal];
    [self.SMSBtn setTitleColor:Color_LineGray_Same_20 forState:UIControlStateNormal];
    if (self.verificationCount <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.SMSBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
        [self.SMSBtn setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        self.SMSBtn.userInteractionEnabled = YES;
    }
}

//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField == _phoneTF && toBeString.length>11) {
        return NO;
    }else if (textField == _verifTF && toBeString.length>6){
        return NO;
    }
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _phoneTF && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }else if (textField == _verifTF && textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
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
