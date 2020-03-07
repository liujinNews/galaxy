//
//  updatePVController.m
//  galaxy
//
//  Created by 赵碚 on 15/7/24.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "updatePVController.h"
#import "MainLoginViewController.h"

@interface updatePVController ()<UITextFieldDelegate,GPClientDelegate>

@property(nonatomic,strong)UITextField * serectTF;
@property(nonatomic,strong)UITextField * repeatSTF;
@property (nonatomic, strong)UITextField *oldTF;
@property(nonatomic,strong)NSDictionary *parametersDic;
@property(nonatomic,strong)UIView * mainView;
@property (nonatomic,assign)NSInteger height;

@property(nonatomic,strong)NSString * getPWD;
@property(nonatomic,strong)NSTimer * endTimer;
@property(nonatomic,strong)UILabel * placeholder;

@end

@implementation updatePVController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.oldTF becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"修改登录密码", nil) backButton:self.type == 1 ? NO:YES];
    [self requestFixPasswordRule];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.serectTF resignFirstResponder];
    [self.oldTF resignFirstResponder];
}
//提交密码
-(void)savePassword:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }

    NSInteger minStr = [[NSString stringWithFormat:@"%@",self.userdatas.passwordMinLength] intValue];
    if (self.oldTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入原密码", nil) duration:1.5];
        return;
    }
    
    if (![self.oldTF.text isEqualToString:self.userdatas.password]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"原密码输入错误", nil) duration:1.5];
        return;
    }
    if (self.serectTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入新密码", nil) duration:1.5];
        return;
    }
    if (self.serectTF.text.length<minStr) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@-%@%@",Custing(@"密码长度", nil),self.userdatas.passwordMinLength,self.userdatas.passwordMaxLength,Custing(@"位，必须字母与数字组合", nil)]];
        return;
    }
    if ([self.oldTF.text isEqualToString:self.serectTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"新密码不能和原密码相同", nil) duration:1.5];
        return;
    }
    
        if (self.repeatSTF.text.length ==0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请再次输入新密码", nil) duration:1.5];
            return;
        }
        if (self.repeatSTF.text.length<minStr) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@-%@%@",Custing(@"密码长度", nil),self.userdatas.passwordMinLength,self.userdatas.passwordMaxLength,Custing(@"位，必须字母与数字组合", nil)] duration:1.5];
            return;
        }

    //密码必须要有字母加数字
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{0,50}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:self.serectTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"您设置的密码太简单,必须字母与数字组合", nil) duration:1.5];
        [self.serectTF becomeFirstResponder];
        return;
    }
    
    if ([self.serectTF.text isEqual:self.repeatSTF.text]) {
        [self requestRetrievePasswordList];
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"两次输入新密码不一样", nil) duration:1.5];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
        case 5:
            if (string.length == 0) {
                self.placeholder.hidden = NO;
            }else{
                self.placeholder.hidden = YES;
            }
            break;
            
        default:
            break;
    }
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    NSInteger maxStr = [[NSString stringWithFormat:@"%@",self.userdatas.passwordMaxLength] intValue];
    
    if (textField.text.length >= maxStr && string.length>0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@-%@%@",Custing(@"密码长度", nil),self.userdatas.passwordMinLength,self.userdatas.passwordMaxLength,Custing(@"位，必须字母与数字组合", nil)]];
        
        return NO;
    }
    
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORDLIMIT]invertedSet];
    NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
    if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
        return YES;
    }
    else
    {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@-%@%@",Custing(@"密码长度", nil),self.userdatas.passwordMinLength,self.userdatas.passwordMaxLength,Custing(@"位，必须字母与数字组合", nil)]];
        return NO;
    }
    
    return YES;
}// return NO to not change text


//
-(void)createCredentialsView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.height = 165;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, self.height)];
    self.mainView .backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainView ];
    NSArray * setArr = @[
                         @{@"name":Custing(@"原密码", nil)},
                         @{@"name":Custing(@"新密码", nil)},
                         @{@"name":Custing(@"确认新密码", nil)}];
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    
    for (int j = 0 ; j < [setArr count] ; j ++ ) {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55+10, WIDTH(self.mainView), 45)];
        whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.mainView  addSubview:whiteView];
        
        UILabel * number = [GPUtils createLable:CGRectMake(15, 0, ((lan)?50:70), 45) text:[[setArr objectAtIndex:j] objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        number.backgroundColor = [UIColor clearColor];
        number.numberOfLines = 0;
        [whiteView  addSubview:number];
        if (j ==2) {
            number.frame = CGRectMake(15, 0, ((lan)?80:100), 45);
        }
        
    }
   
    
    self.oldTF = [GPUtils createTextField:CGRectMake(((lan)?75:90), 10, WIDTH(self.mainView)-((lan)?75:90), 45) placeholder:Custing(@"请输入原密码", nil) delegate:self font:Font_Same_14_20 textColor:Color_form_TextField_20];
    self.oldTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.oldTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.oldTF.tag = 11;
    self.oldTF.delegate=self;
    self.oldTF.keyboardType = UIKeyboardTypeEmailAddress;
    self.oldTF.secureTextEntry = YES;
    [self.mainView addSubview:self.oldTF];
    
    self.serectTF = [GPUtils createTextField:CGRectMake(((lan)?75:90), 65, WIDTH(self.mainView)-((lan)?75:90), 45) placeholder:@"" delegate:self font:Font_Same_14_20 textColor:Color_form_TextField_20];
    self.serectTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.serectTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.serectTF.tag = 5;
    self.serectTF.delegate=self;
    self.serectTF.keyboardType = UIKeyboardTypeEmailAddress;
    self.serectTF.secureTextEntry = YES;
    [self.mainView addSubview:self.serectTF];
    
    self.placeholder = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.mainView)-((lan)?75:90), 45) text:Custing(@"请输入6-16密码，必须字母与数字组合",nil) font:Font_Same_14_20 textColor:RGB(195, 195, 202) textAlignment:NSTextAlignmentLeft];
    self.placeholder.backgroundColor = [UIColor clearColor];
    self.placeholder.numberOfLines = 0;
    [self.serectTF  addSubview:self.placeholder];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEnterPasswordUpdatePVEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.serectTF];
    
    
    self.repeatSTF = [GPUtils createTextField:CGRectMake(((lan)?105:90), 120, WIDTH(self.mainView)-((lan)?105:100), 45) placeholder:Custing(@"请再次输入新密码", nil) delegate:self font:Font_Same_14_20 textColor:Color_form_TextField_20];
    self.repeatSTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.repeatSTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.repeatSTF.tag = 1;
    self.repeatSTF.delegate=self;
    self.repeatSTF.keyboardType = UIKeyboardTypeEmailAddress;
    self.repeatSTF.secureTextEntry = YES;
    [self.mainView addSubview:self.repeatSTF];
    
    
    UIButton * sureBtn = [GPUtils createButton:CGRectMake(15, 185, Main_Screen_Width-30, 49) action:@selector(savePassword:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"确定", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [sureBtn setBackgroundColor:Color_Blue_Important_20];
    sureBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:sureBtn];
    
}

-(void)textFiledEnterPasswordUpdatePVEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField.text.length > 0) {
        self.placeholder.hidden = YES;
    }
    if (textField.text.length == 0) {
        self.placeholder.hidden = NO;
    }
    
}
-(void)requestRetrievePasswordList{
    //Retrieve password
    self.parametersDic = @{@"OldPassword":[NSString stringWithFormat:@"%@",self.oldTF.text],@"NewPassword":self.serectTF.text};
    
    [[GPClient shareGPClient]REquestByPostWithPath:XB_ChangePaw Parameters:self.parametersDic Delegate:self SerialNum:0 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //FDE55D29E567D879//
}
//修改密码规则
-(void)requestFixPasswordRule{
    
    [[GPClient shareGPClient]REquestByPostWithPath:XB_PawRule Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    if (serialNum ==0) {
        userData *datas = [userData shareUserData];
        datas.password = nil;
        [datas storeUserInfo];
    }
    
    if (serialNum ==1) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        self.userdatas.isPasswordComplexity = [NSString stringWithFormat:@"%@",[result objectForKey:@"isPasswordComplexity"]];
        self.userdatas.passwordMinLength = [NSString stringWithFormat:@"%@",[result objectForKey:@"passwordMinLength"]];
        self.userdatas.passwordMaxLength = [NSString stringWithFormat:@"%@",[result objectForKey:@"passwordMaxLength"]];
        [self createCredentialsView];
    }
    
    switch (serialNum) {
        case 0://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"密码修改成功", nil) duration:2.0];
            self.endTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pushLoginViewController:) userInfo:nil repeats:NO];
            break;
        case 1://
            //[self pushPersonDocoumentViewController];
            break;
        default:
            break;
    }
    
}
-(void)pushLoginViewController:(NSTimer*)timer{
    [self.endTimer invalidate];
    self.endTimer = nil;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    MainLoginViewController *vc=[[MainLoginViewController alloc]init];
    vc.isGoLoginView=1;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    delegate.window.rootViewController = nav;
}


-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}

-(void)dealloc{
    self.serectTF = nil;
    self.repeatSTF = nil;
    self.oldTF = nil;
    self.placeholder = nil;
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
