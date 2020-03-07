//
//  InitializationDataViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "InitializationDataViewController.h"

@interface InitializationDataViewController ()<UIScrollViewDelegate,UITextFieldDelegate,GPClientDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)UIView * informationView;
@property (nonatomic,strong)UIView * phoneView;
@property (strong,nonatomic)UITextField * accountTF;

@property (strong,nonatomic)UITextField * verificationTF;
@property (strong,nonatomic)UIButton * verificationBtn;
@property (assign,nonatomic) NSUInteger count;
@property (assign,nonatomic) NSUInteger verificationCount;
@property(nonatomic,strong)NSTimer * timer;
@property (copy, nonatomic) NSString * canGetCheckcode;//是否正在获取checkcode
@property (nonatomic,strong)NSString * numberStr;
@property (nonatomic,strong)NSString * isRightVer;

@property (nonatomic,strong)UIButton * sureBtn;
@end

@implementation InitializationDataViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.numberStr = type;
    }
    
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
//    self.mainView.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
//    [self.mainView registerAsDodgeViewForMLInputDodger];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"初始化数据", nil) backButton:YES ];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*1.5);
    [self.view addSubview:self.scrollView];
    [self createInfomationView];
    
    [self createNumberPhoneView];
    
    [self createVerificationView];
    // Do any additional setup after loading the view.
}

-(void)createInfomationView{
    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 30)];
    infoView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:infoView];
    
    UIImageView * leftIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    leftIV.backgroundColor = Color_Orange_Weak_20;
    [infoView addSubview:leftIV];
    
    UILabel * infoLa = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width - 30, 28) text:Custing(@"说明", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    infoLa.backgroundColor = [UIColor clearColor];
    [infoView addSubview:infoLa];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 29, Main_Screen_Width-30, 1)];
    lineView.backgroundColor = Color_GrayLight_Same_20;
    [infoView addSubview:lineView];
    
    CGSize size1 = [Custing(@"正式使用喜报系统前，需要清空测试的教程。", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-45, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [Custing(@"每个企业只能对测试数据进行一次清空。", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-45, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size3 = [Custing(@"每个企业提交的申请小于等于20条，才能执行清空操作，超过20条不能执行清空操作。", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-45, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size4 = [Custing(@"系统仅对提交的申请，消费记录进行清空。", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-45, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    NSInteger heght;
    if (size3.height >18) {
        heght = 70;
    }else{
        heght = 60;
    }
   
    self.informationView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, size1.height+size2.height+size3.height+size4.height +heght)];
    self.informationView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:self.informationView];
    //条件描述
    
    UILabel * title11La = [GPUtils createLable:CGRectMake(15,8, 15, 25) text:@"1)" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.informationView addSubview:title11La];
    
    UILabel * title1La = [GPUtils createLable:CGRectMake(30,8, WIDTH(self.informationView)-45, size1.height+10) text:Custing(@"正式使用喜报系统前，需要清空测试的教程。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title1La.numberOfLines=0;
    [self.informationView addSubview:title1La];
    
    UILabel * title21La = [GPUtils createLable:CGRectMake(15,Y(title1La) + HEIGHT(title1La), 15, 25) text:@"2)" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.informationView addSubview:title21La];
    
    UILabel * title2La = [GPUtils createLable:CGRectMake(30,Y(title1La) + HEIGHT(title1La), WIDTH(self.informationView)-45, size2.height+10) text:Custing(@"每个企业只能对测试数据进行一次清空。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title2La.numberOfLines=0;
    [self.informationView addSubview:title2La];
    
    UILabel * title31La = [GPUtils createLable:CGRectMake(15,Y(title2La) + HEIGHT(title2La), 15, 25) text:@"3)" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.informationView addSubview:title31La];
    
    UILabel * title3La = [GPUtils createLable:CGRectMake(30,Y(title2La) + HEIGHT(title2La), WIDTH(self.informationView)-45, size3.height+10) text:Custing(@"每个企业提交的申请小于等于20条，才能执行清空操作，超过20条不能执行清空操作。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title3La.numberOfLines=0;
    
    if (size3.height >18) {
        title3La.frame = CGRectMake(30,Y(title2La) + HEIGHT(title2La), WIDTH(self.informationView)-45, size3.height+20);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:Custing(@"每个企业提交的申请小于等于20条，才能执行清空操作，超过20条不能执行清空操作。", nil)];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:7];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [Custing(@"每个企业提交的申请小于等于20条，才能执行清空操作，超过20条不能执行清空操作。", nil) length])];
        [title3La setAttributedText:attributedString1];
    }
    
    [self.informationView addSubview:title3La];
    
    UILabel * title41La = [GPUtils createLable:CGRectMake(15,Y(title3La) + HEIGHT(title3La), 15, 25) text:@"4)" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.informationView addSubview:title41La];
    
    UILabel * title4La = [GPUtils createLable:CGRectMake(30,Y(title3La) + HEIGHT(title3La), WIDTH(self.informationView)-45, size4.height+10) text:Custing(@"系统仅对提交的申请，消费记录进行清空。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title4La.numberOfLines=0;
    [self.informationView addSubview:title4La];
    
}

-(void)createNumberPhoneView{
    
    self.phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, Y(self.informationView)+HEIGHT(self.informationView)+10, Main_Screen_Width, 49)];
    self.phoneView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:self.phoneView];
    
    UIImageView * phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 15, 15)];
    phoneImage.backgroundColor = [UIColor clearColor];
    phoneImage.image = GPImage(@"login_phone");
    [self.phoneView addSubview:phoneImage];
    
    self.accountTF = [GPUtils createTextField:CGRectMake(45, 0, 150, 49) placeholder:Custing(@"请输入手机号", nil) delegate:self font:Font_Same_14_20 textColor:Color_form_TextField_20];
    self.accountTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.accountTF.tag = 0;
    self.accountTF.delegate=self;
    self.accountTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.accountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.phoneView addSubview:self.accountTF];
    self.accountTF.text = self.numberStr;
    
}

-(void)createVerificationView{
    
    UIView * verificationView = [[UIView alloc]initWithFrame:CGRectMake(0, Y(self.phoneView)+HEIGHT(self.phoneView)+10, Main_Screen_Width, 49)];
    verificationView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:verificationView];
    
    UIImageView * verificationImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 15, 15)];
    verificationImage.image = GPImage(@"login_info");
    [verificationView addSubview:verificationImage];
    
    self.verificationTF = [GPUtils createTextField:CGRectMake(45, 0, WIDTH(verificationView)-185, 49) placeholder:Custing(@"请输入验证码", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.verificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTF.tag = 2;
    self.verificationTF.delegate=self;
    [verificationView addSubview:self.verificationTF];
    

    self.verificationBtn = [GPUtils createButton:CGRectMake(WIDTH(verificationView)-140, 0, 140, 49) action:@selector(initVerificationRegisterCode:) delegate:self title:Custing(@"获取验证码", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    [self.verificationBtn setBackgroundColor:Color_Orange_Weak_20];
    [verificationView addSubview:self.verificationBtn];
    
    
    self.sureBtn = [GPUtils createButton:CGRectMake(15, Y(verificationView)+HEIGHT(verificationView)+30, Main_Screen_Width-30, 49) action:@selector(sureClearnData:) delegate:self title:Custing(@"确定初始化数据", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [self.sureBtn setBackgroundColor:Color_Blue_Important_20];
    self.sureBtn.layer.cornerRadius = 25.0f;
    [self.scrollView addSubview:self.sureBtn];
    
    
}

-(void)sureClearnData:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    if (self.accountTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.5];
        [self.accountTF becomeFirstResponder];
        return;
    }
    if (self.accountTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) duration:1.5];
        [self.accountTF becomeFirstResponder];
        return;
    }
    NSString *emailRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.accountTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
        return;
    }
    
    if (self.verificationTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入验证码", nil) duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    if (self.verificationTF.text.length >6) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    if ([self.isRightVer isEqualToString:@"yes"]) {
        [self requestCompanyClearTestData];
    }else{
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
        [self.verificationTF becomeFirstResponder];
        return;
    }
    
}


//获取验证码
-(void)initVerificationRegisterCode:(UIButton *)btn{
    if ([[GPClient shareGPClient].networkIsReachable isEqualToString:@"no"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    NSString *emailRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.accountTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
        return;
    }
    if (self.accountTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
        return;
    }else{
        
        [self requestGetVerifyCodeCompany];
    }
    
    self.verificationCount = COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerMinCount:) userInfo:nil repeats:YES];
    self.verificationBtn.userInteractionEnabled = NO;
    self.accountTF.userInteractionEnabled = NO;
    [self.verificationBtn setBackgroundColor:Color_Blue_Important_20];
    self.canGetCheckcode = FcanGetCheckcode_no;
    [self.timer fire];
}

-(void)registerMinCount:(NSTimer*)timer
{   self.verificationCount--;
    
    //    NSLog(@"%lu",(unsigned long)self.verificationCount);
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"%lu s",(unsigned long)self.verificationCount] forState:UIControlStateNormal];
    self.verificationBtn.showsTouchWhenHighlighted = YES;
    
    if (self.verificationCount<=0) {
        [timer invalidate];
        self.canGetCheckcode = canGetCheckcode_yes;
        self.verificationCount = COUNT;
        [self.verificationBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
        self.verificationBtn.userInteractionEnabled = YES;
        [self.verificationBtn setBackgroundColor:Color_Orange_Weak_20];
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
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号不超过11位", nil)];
                return NO;
                NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
                NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
                return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
            }
            
            
        }
            break;
        case 2:
        {
            if (textField.text.length >= 4 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"验证码不超过4位", nil)];
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


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}

//获取验证码
-(void)requestGetVerifyCodeCompany{
    NSDictionary * acountDic = @{@"UserAccount":[NSString stringWithFormat:@"%@",self.accountTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",companyGetVerifyCode] Parameters:acountDic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

    
}

//清空测试数据
-(void)requestCompanyClearTestData{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",ClearTestData] Parameters:@{@"UserAccount":[NSString stringWithFormat:@"%@",self.accountTF.text],@"AccessToken":[NSString stringWithFormat:@"%@",self.verificationTF.text]} Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }

    if (serialNum ==0) {
        if ([success isEqualToString:@"0"]) {
            
            [self.timer invalidate];
            self.timer = nil;
            [self.verificationBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
            [self.verificationBtn setBackgroundColor:Color_Orange_Weak_20];
            self.verificationBtn.userInteractionEnabled = YES;
            self.accountTF.userInteractionEnabled = YES;
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
        
    }
    if (serialNum ==1) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self backEditCompany];
        });
    }
    switch (serialNum) {
        case 0://
            self.isRightVer = @"yes";
            break;
        case 1:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"初始化数据成功", nil) duration:2.0];
            
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)backEditCompany{
    [self.navigationController popViewControllerAnimated:YES];
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
