//
//  registerVController.m
//  galaxy
//
//  Created by 赵碚 on 15/9/1.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//
#import "reimProtelViewController.h"
#import "lostPasswordViewController.h"
#import "GPVerification.h"
#import "homeVController.h"
#import "registerVController.h"
#import "UIView+MLInputDodger.h"

@interface registerVController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,GPClientDelegate>

@property (copy, nonatomic) NSString * canGetCheckcode;//是否正在获取checkcode
@property (assign,nonatomic) NSUInteger verificationCount;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,assign)NSInteger height;
@property (nonatomic,strong)NSString * isRightVer;

//注册视图
@property(nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UITextField * nameTF;
@property(nonatomic,strong)UITextField * photoTF;
@property(nonatomic,strong)UITextField * verificationTF;
@property(nonatomic,strong)UIButton * verificationBtn;
@property(nonatomic,strong)UIButton * registerBtn;
@property(nonatomic,strong)NSDictionary * parametersDic;

@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)NSTimer * endTimer;

@property(nonatomic,strong)GPVerification * ChooseVerification;

@property(nonatomic,strong)userData * datas;



@end

@implementation registerVController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [userData shareUserData];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBarHidden = YES;
    
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, HEIGHT(self.view)*0.045, HEIGHT(self.view)*0.045)];
    [leftbtn addTarget:self action:@selector(sideslipBar:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    UIImageView * leftImage = [[UIImageView alloc]initWithImage:GPImage(@"ShutDown")];
    leftImage.frame = CGRectMake(0, 0, 22, 22);
    leftImage.backgroundColor = [UIColor clearColor];
    [leftbtn addSubview:leftImage];
    [self.view addSubview:leftbtn];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-50, 30, 100, 25) text:@"" font:Font_filterTitle_17 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLa];
    self.isRightVer = @"no";
    if ([self.status isEqualToString: @"register"]) {
        titleLa.text = Custing(@"logIn_registered", nil);
    }
    [self createRegisterView];
    [self createRegisterButton];
    
}


-(void)sideslipBar:(id)btn
{
    [self.timer invalidate];
    self.timer = nil;
    [self.endTimer invalidate];
    self.endTimer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//隐藏导航栏
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.navigationController.navigationBarHidden=YES;
    self.mainView.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.mainView registerAsDodgeViewForMLInputDodger];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTF   resignFirstResponder];
    [self.photoTF    resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}
#pragma mark 注册区域

-(void)createRegisterView{
    
    self.height = Main_Screen_Height*0.324;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(32, Main_Screen_Height*0.138, ScreenRect.size.width-64, self.height)];
    self.mainView .backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainView ];
    
    NSLog(@"%@",[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(@"forget_phone") value:@"" table:nil]);
    
    
    
    NSArray * setArr = @[
                         @{@"name":Custing(@"forget_phone", nil)},
                         @{@"name":Custing(@"forget_GraphicalVerification", nil)},
                         @{@"name":Custing(@"forget_Verification", nil)}];
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/320.0f;
    
    for (int j = 0 ; j < [setArr count] ; j ++ ) {
        UILabel * number = [GPUtils createLable:CGRectMake(0, j*self.height/3+self.height/15, WIDTH(self.mainView)/2, 18) text:[[setArr objectAtIndex:j]objectForKey:@"name"] font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentLeft];
        [self.mainView  addSubview:number];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, j*self.height/3+self.height/15*5, WIDTH(self.mainView ), 1)];
        line.backgroundColor = [GPUtils colorHString:LineColor];
        [self.mainView  addSubview:line];
    }
    
    self.nameTF = [GPUtils createTextField:CGRectMake(0, self.height/15*2.5, WIDTH(self.mainView ), 28) placeholder:Custing(@"forget_intoPhone", nil) delegate:self font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorBlack]];
    self.nameTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.nameTF.tag = 0;
    self.nameTF.delegate=self;
    self.nameTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainView addSubview:self.nameTF];
    
    
    self.photoTF = [GPUtils createTextField:CGRectMake(0, self.height/15*7.8, WIDTH(self.mainView )/2, 28) placeholder:Custing(@"forget_intoGraphicalVerification", nil) delegate:self font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorBlack]];
    self.photoTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.photoTF.keyboardType = UIKeyboardTypeNumberPad;
    self.photoTF.tag = 1;
    self.photoTF.delegate = self;
    [self.photoTF addTarget:self action:@selector(PhotoTextFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.mainView addSubview:self.photoTF];
    
    self.ChooseVerification = [[GPVerification alloc]initWithFrame:CGRectMake(WIDTH(self.mainView )-Main_Screen_Width*0.27, self.height/15*7,Main_Screen_Width*0.27, 28)];
    [self.mainView addSubview:self.ChooseVerification];

    
    self.verificationTF = [GPUtils createTextField:CGRectMake(0, self.height/15*12.8, WIDTH(self.mainView)/2, 28) placeholder:Custing(@"forget_intoVerification", nil) delegate:self font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorBlack]];
    self.verificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTF.tag = 2;
    self.verificationTF.delegate=self;
    [self.mainView addSubview:self.verificationTF];
    
    
    self.verificationBtn = [GPUtils createButton:CGRectMake(WIDTH(self.mainView)-WIDTH(self.mainView)*0.307, self.height/15*12, WIDTH(self.mainView)*0.307, HEIGHT(self.mainView)*0.14) action:@selector(VerificationRegisterCode:) delegate:self title:Custing(@"forget_HaveVerification", nil) font:Font_cellTitle_14 titleColor:[UIColor whiteColor]];
    
    [self.verificationBtn setBackgroundColor:[GPUtils colorHString:ColorGray]];
    self.verificationBtn.layer.cornerRadius = 10.5f*scale;
    [self.mainView addSubview:self.verificationBtn];
    
    self.verificationBtn.userInteractionEnabled = NO;
    
}
#pragma mark 输入框代理，点击return 按钮
- (BOOL)PhotoTextFieldWithText:(UITextField *)textField
{
    //判断输入的是否为验证图片中显示的验证码
    if ([self.photoTF.text isEqualToString:self.ChooseVerification.authCodeStr])
    {
        if (self.nameTF.text.length==11) {
            self.verificationBtn.backgroundColor = [GPUtils colorHString:ColorPink];
            self.verificationBtn.userInteractionEnabled = YES;
            
            [self.photoTF resignFirstResponder];
        }
        else
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"请输入正确的电话号码" duration:2.0];
        }
    }
    else
    {
        self.verificationBtn.backgroundColor = [GPUtils colorHString:ColorGray];
        self.verificationBtn.userInteractionEnabled = NO;
        //验证不匹配，验证码和输入框抖动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
       
        [self.photoTF.layer addAnimation:anim forKey:nil];
    }
    
    return YES;
}

#pragma mark 警告框中方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //清空输入框内容，收回键盘
    if (buttonIndex==0)
    {
        self.photoTF.text = @"";
        [self.photoTF resignFirstResponder];
    }
}

//获取验证码
-(void)VerificationRegisterCode:(UIButton *)btn{
    if ([[GPClient shareGPClient].networkIsReachable isEqualToString:@"no"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"当前网络不可用，请检查您的网络" duration:2.0];
        return;
    }
    //判断输入的是否为验证图片中显示的验证码
    if (![self.photoTF.text isEqualToString:self.ChooseVerification.authCodeStr])
    {
        self.verificationBtn.backgroundColor = [GPUtils colorHString:ColorGray];
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"验证码错误" duration:1.5];
        return;
    }
    NSString *emailRegex = @"^1[34578][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.nameTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的手机号"];
        return;
    }
    if (self.nameTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的手机号" duration:1.5];
        return;
    }else{
        
        [self requestGetregcode];
    }
    
    self.verificationCount = COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerMinCount:) userInfo:nil repeats:YES];
    self.verificationBtn.userInteractionEnabled = NO;
    self.photoTF.userInteractionEnabled = NO;
    [self.verificationBtn setBackgroundColor:[GPUtils colorHString:ColorGray]];
    self.canGetCheckcode = FcanGetCheckcode_no;
    [self.timer fire];
}

-(void)registerMinCount:(NSTimer*)timer
{   self.verificationCount--;
    
//    NSLog(@"%lu",(unsigned long)self.verificationCount);
    self.verificationBtn.titleLabel.text = [NSString stringWithFormat:@"验证码(%lu)",(unsigned long)self.verificationCount];
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"验证码(%lu)",(unsigned long)self.verificationCount] forState:UIControlStateNormal];
    self.verificationBtn.showsTouchWhenHighlighted = YES;
    
    if (self.verificationCount<=0) {
        [timer invalidate];
        self.canGetCheckcode = canGetCheckcode_yes;
        self.verificationCount = COUNT;
        [self.verificationBtn setTitle:Custing(@"forget_HaveVerification", nil) forState:UIControlStateNormal];
        self.verificationBtn.userInteractionEnabled = YES;
        self.photoTF.userInteractionEnabled = YES;
        [self.verificationBtn setBackgroundColor:[GPUtils colorHString:ColorPink]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //不允许输入空格
    if ([string isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 11 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"手机号不超过11位"];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            
            if ([self.photoTF.text isEqualToString:self.ChooseVerification.authCodeStr])
            {
                if (self.nameTF.text.length+string.length==11&&![string isEqualToString:@""]) {
                    self.verificationBtn.backgroundColor = [GPUtils colorHString:ColorPink];
                    self.verificationBtn.userInteractionEnabled = YES;
                    
                    [self.photoTF resignFirstResponder];
                }
                else
                {
                    self.verificationBtn.backgroundColor = [GPUtils colorHString:ColorGray];
                    self.verificationBtn.userInteractionEnabled = NO;                }
            }
            
            return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
        }
            break;
        case 1:
        {
            if (textField.text.length >= 4 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"验证码不超过4位"];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
            break;
        case 2:
        {
            if (textField.text.length >= 6 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"验证码不超过6位"];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark 注册按钮
-(void)createRegisterButton{
    
//    [self pushAddPersonView];
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/320.0f;
    
    self.registerBtn = [GPUtils createButton:CGRectMake(32, Y(self.mainView)+HEIGHT(self.mainView)+Main_Screen_Height*0.07, WIDTH(self.mainView), Main_Screen_Height*0.082) action:@selector(submitPassword:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:@"下一步" font:Font_cellmoney_20 color:[UIColor whiteColor]];
    [self.registerBtn setBackgroundColor:[GPUtils colorHString:ColorPurple]];
    self.registerBtn.layer.cornerRadius = 3.0f*scale;
    [self.view addSubview:self.registerBtn];
    
    NSString *agree=Custing(@"forget_touchAgree", nil);
    CGSize size = [NSString sizeWithText:agree font:[UIFont systemFontOfSize:12.f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel * number = [GPUtils createLable:CGRectMake((Main_Screen_Width -size.width - 80)/2, Y(self.registerBtn)+HEIGHT(self.registerBtn)+Main_Screen_Height*0.03, size.width, 30) text:Custing(@"forget_TouchAgree", nil) font:Font_cellTime_12 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentRight shadowColor:nil shadowOffset:CGSizeMake(0, 0)];
    
    number.backgroundColor = [UIColor clearColor];
    [self.view addSubview:number];
    
    UIButton * protelBtn = [GPUtils createButton:CGRectMake(number.frame.origin.x+size.width, Y(number), 80, 30) action:@selector(RegisterReimbursementProtel:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"forget_accountAgreement", nil) font:Font_cellTime_12 color:[GPUtils colorHString:ColorPink]];
    protelBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [protelBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [protelBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:protelBtn];
   
    
}
-(void)RegisterReimbursementProtel:(id)btn{
    //报销协议文本
    reimProtelViewController * reim = [[reimProtelViewController alloc]initWithType:@""];
    [self.navigationController pushViewController:reim animated:YES];
    
}

-(void)submitPassword:(id)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"当前网络不可用，请检查您的网络" duration:2.0];
        return;
    }
    if (self.nameTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入手机号" duration:1.5];
        [self.nameTF becomeFirstResponder];
        return;
    }
    if (self.nameTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的手机号" duration:1.5];
        [self.nameTF becomeFirstResponder];
        return;
    }
    NSString *emailRegex = @"^1[34578][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.nameTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的手机号"];
        return;
    }
    if (self.photoTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入图形验证码" duration:1.5];
        [self.photoTF becomeFirstResponder];
        return;
    }
    if (self.photoTF.text.length !=4) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的图形验证码" duration:1.5];
        [self.photoTF becomeFirstResponder];
        return;
    }
    if (self.verificationTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入验证码" duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    if (self.verificationTF.text.length >6) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的验证码" duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    if ([self.isRightVer isEqualToString:@"yes"]) {
        [self pushAddPersonView];
    }else{
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入正确的验证码" duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    
}

-(void)pushAddPersonView{
    
    lostPasswordViewController * lost = [[lostPasswordViewController alloc]initWithType:@"register"can:@{@"name":[NSString stringWithFormat:@"%@",self.nameTF.text],@"verification":[NSString stringWithFormat:@"%@",self.verificationTF.text]}];
    [self.navigationController pushViewController: lost animated:YES];
}


//获取验证码
-(void)requestGetregcode{
    
    NSDictionary * acountDic = @{@"Account":[NSString stringWithFormat:@"%@",self.nameTF.text]};
    
    [[GPClient shareGPClient]requestByPostWithPath:[NSString stringWithFormat:@"%@%@",kServer,getregcode] Parameters:acountDic Delegate:self SerialNum:0 IfUserCache:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    
    if (serialNum ==0) {
        if ([success isEqualToString:@"0"]) {
            
            [self.timer invalidate];
            self.timer = nil;
            [self.verificationBtn setTitle:Custing(@"forget_HaveVerification", nil) forState:UIControlStateNormal];
            [self.verificationBtn setBackgroundColor:[GPUtils colorHString:ColorPink]];
            self.verificationBtn.userInteractionEnabled = YES;
            self.photoTF.userInteractionEnabled = YES;
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
        
    }
   self.isRightVer = @"yes";
    switch (serialNum) {
        case 0://
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    if ([responceFail isEqualToString:@"The request timed out."]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"服务器请求超时" duration:2.0];
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",responceFail] duration:2.0];
//        NetErrorViewController *netError=[[NetErrorViewController alloc]init];
//        [self.navigationController pushViewController:netError animated:YES];
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
