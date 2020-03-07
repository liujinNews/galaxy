//
//  createNeViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define EMAIL @"1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm@._%\\+-"

#import "IndustryOnController.h"
#import "UIView+MLInputDodger.h"
#import "createNeViewController.h"

@interface createNeViewController ()<GPClientDelegate,companyIndustryDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSArray * comDocArray;


@property (nonatomic,strong)UIView * mainView;

@property (nonatomic,strong)UITextField * companyName;
@property (nonatomic,strong)UITextField * companyContact;
@property (nonatomic,strong)UITextField * JobTitle;
@property (nonatomic,strong)UITextField * mobile;
@property (nonatomic,strong)UITextField * Telephone;
@property (nonatomic,strong)UITextField * Email;

@property (nonatomic,strong)UIButton * LocationBtn;
@property (nonatomic,strong)UIButton * IndustryBtn;
@property (nonatomic,strong)UIButton * CompanySizeBtn;

@property (nonatomic,strong)UILabel * locationLa;
@property (nonatomic,strong)UILabel * IndustryLa;
@property (nonatomic,strong)UILabel * CompanySizeLa;

@property (nonatomic,strong)NSString * companyNameStr;
@property (nonatomic,strong)NSString * companyContactStr;
@property (nonatomic,strong)NSString * JobTitleStr;
@property (nonatomic,strong)NSString * mobileStr;
@property (nonatomic,strong)NSString * TelephoneStr;
@property (nonatomic,strong)NSString * EmailStr;
@property (nonatomic,strong)NSString * locationStr;
@property (nonatomic,strong)NSString * IndustryStr;
@property (nonatomic,strong)NSString * CompanySizeStr;


@property (nonatomic,strong)NSString * locationID;
@property (nonatomic,strong)NSString * IndustryID;
@property (nonatomic,strong)NSString * CompanySizeID;

@property (nonatomic,strong)UISwitch * shuilvSw;
@property (nonatomic,strong)NSString * shuilvStr;
@property (nonatomic,strong)NSString * companyId;


@end

@implementation createNeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
      
    self.mainView.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.mainView registerAsDodgeViewForMLInputDodger];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(editCompany:)];

    
    [self setTitle:Custing(@"创建新公司", nil) backButton:YES ];
    [self createCompanyView];
    
    
    // Do any additional setup after loading the view.
}
-(void)back:(UIButton *)btn{
    [YXSpritesLoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)editCompany:(UIButton *)btn{
    [self.Email resignFirstResponder];
    [self.mobile resignFirstResponder];
    [self.JobTitle resignFirstResponder];
    [self.Telephone resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.companyContact resignFirstResponder];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    if (self.companyName.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司名称",nil) duration:1.5];
        [self.companyName becomeFirstResponder];
        return;
    }
    if (self.companyContact.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司联系人", nil) duration:1.5];
        [self.companyContact becomeFirstResponder];
        return;
    }
    
    if (self.mobile.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司手机", nil) duration:1.5];
        [self.mobile becomeFirstResponder];
        return;
    }
    NSString *mobileRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    if (![mobilePredicate evaluateWithObject:self.mobile.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)];
        return;
    }
    
    if (self.Email.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司邮箱", nil) duration:1.5];
        [self.Email becomeFirstResponder];
        return;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.Email.text]) {//邮箱地址不正确吧？
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的邮箱号码", nil)];
        return;
    }
    if ([self.locationLa.text isEqualToString:Custing(@"请选择公司所属地区", nil)]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择公司所属地区", nil) duration:1.5];
        [self.locationLa becomeFirstResponder];
        return;
    }
    if ([self.IndustryLa.text isEqualToString:Custing(@"请选择公司所属行业", nil)]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择公司所属行业", nil) duration:1.5];
        [self.IndustryLa becomeFirstResponder];
        return;
    }
    if ([self.CompanySizeLa.text isEqualToString:Custing(@"请选择公司规模", nil)]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择公司规模", nil) duration:1.5];
        [self.CompanySizeLa becomeFirstResponder];
        return;
    }
    
    [self RequestAddCompanyDocument];
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Email resignFirstResponder];
    [self.mobile resignFirstResponder];
    [self.JobTitle resignFirstResponder];
    [self.Telephone resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.companyContact resignFirstResponder];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.companyName];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.companyContact];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.JobTitle];
}

-(void)createCompanyView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    
//    self.comDocArray = @[
//                         @{@"image":@"",@"name":Custing(@"公司名称", nil),@"height":@"10"},
//                         @{@"image":@"",@"name":Custing(@"联系人", nil),@"height":@"10"},
//                         @{@"image":@"",@"name":Custing(@"职位", nil),@"height":@"0"},
//                         @{@"image":@"",@"name":Custing(@"手机", nil),@"height":@"0"},
//                         @{@"image":@"",@"name":Custing(@"电话", nil),@"height":@"-10"},
//                         @{@"image":@"",@"name":Custing(@"邮箱", nil),@"height":@"-20"},
//                         @{@"image":@"skipImage",@"name":Custing(@"所属地区", nil),@"height":@"-20"},
//                         @{@"image":@"skipImage",@"name":Custing(@"所属行业", nil),@"height":@"-30"},
//                         @{@"image":@"skipImage",@"name":Custing(@"公司规模", nil),@"height":@"-40"},
//                         @{@"image":@"",@"name":Custing(@"税额", nil),@"height":@"-40"}];
    self.comDocArray = @[
                         @{@"image":@"",@"name":Custing(@"公司名称", nil),@"height":@"10"},
                         @{@"image":@"",@"name":Custing(@"联系人", nil),@"height":@"10"},
                         @{@"image":@"",@"name":Custing(@"职位", nil),@"height":@"0"},
                         @{@"image":@"",@"name":Custing(@"手机", nil),@"height":@"0"},
                         @{@"image":@"",@"name":Custing(@"电话", nil),@"height":@"-10"},
                         @{@"image":@"",@"name":Custing(@"邮箱", nil),@"height":@"-20"},
                         @{@"image":@"skipImage",@"name":Custing(@"所属地区", nil),@"height":@"-20"},
                         @{@"image":@"skipImage",@"name":Custing(@"所属行业", nil),@"height":@"-30"},
                         @{@"image":@"skipImage",@"name":Custing(@"公司规模", nil),@"height":@"-40"}];
    self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*1.9);
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    
    for (int j = 0 ; j < [self.comDocArray count] ; j ++ ) {
        NSInteger heightCell = [[[self.comDocArray objectAtIndex:j] objectForKey:@"height"] integerValue];
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, j*58+heightCell, Main_Screen_Width,48)];
        self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.scrollView addSubview:self.mainView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 47.5, Main_Screen_Width - 30,0.5)];
        lineView .backgroundColor = Color_GrayLight_Same_20;
        [self.mainView addSubview:lineView];
        
        
        UILabel * titleLa = [GPUtils createLable:CGRectMake(15, j*58+heightCell, 75, 48) text:[[self.comDocArray objectAtIndex:j] objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLa.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:titleLa];
        titleLa.numberOfLines = 0;
        
        
        if (j == self.comDocArray.count-1) {
            self.mainView.frame = CGRectMake(0, j*58+heightCell, Main_Screen_Width, 58);
//            titleLa.frame = CGRectMake(15, j*58+heightCell, 75, 28);
            titleLa.textColor = Color_Black_Important_20;
            titleLa.font = Font_Important_15_20;
            lineView.frame = CGRectMake(15, 57.5, Main_Screen_Width - 30, 0.5);
        }
        
        UIImageView * viewImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-35,j*58+heightCell+15 , 18, 18)];
        viewImage.image = GPImage([[self.comDocArray objectAtIndex:j] objectForKey:@"image"]);
        viewImage.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:viewImage];
        
    }
    
    NSInteger height = 0;
    
    
    self.companyName = [GPUtils createTextField:CGRectMake(90, 10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司名称", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.companyName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.companyName setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.companyName.tag = 0;
    self.companyName.delegate=self;
    self.companyName.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.companyName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editCompanyTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.companyName];
    
    if ([NSString isEqualToNull:self.companyNameStr]) {
        self.companyName.text = self.companyNameStr;
    }
    
    self.companyContact = [GPUtils createTextField:CGRectMake(90, 58+10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司联系人", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.companyContact.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.companyContact setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.companyContact.tag = 1;
    self.companyContact.delegate=self;
    self.companyContact.keyboardType = UIKeyboardTypeDefault;
    self.companyContact.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.companyContact];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editNameTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.companyContact];
    
    self.companyContactStr = [NSString stringWithFormat:@"%@",self.userdatas.userDspName];
    if ([NSString isEqualToNull:self.companyContactStr]) {
        self.companyContact.text = self.companyContactStr;
    }
    
    self.JobTitle = [GPUtils createTextField:CGRectMake(90, 58*2+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入职位", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.JobTitle.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.JobTitle setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.JobTitle.tag = 2;
    self.JobTitle.delegate=self;
    self.JobTitle.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.JobTitle];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editJobTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.JobTitle];
    
    if ([NSString isEqualToNull:self.JobTitleStr]) {
        self.JobTitle.text = self.JobTitleStr;
    }
    
    self.mobile = [GPUtils createTextField:CGRectMake(90, 58*3+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司手机", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.mobile.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.mobile setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.mobile.tag = 3;
    self.mobile.delegate=self;
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.mobile.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.mobile];
    
    self.mobileStr = [NSString stringWithFormat:@"%@",self.userdatas.logName];
    if ([NSString isEqualToNull:self.mobileStr]) {
        self.mobile.text = self.mobileStr;
    }
   
    self.Telephone = [GPUtils createTextField:CGRectMake(90, 58*4-10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司电话", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.Telephone.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.Telephone setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.Telephone.tag = 4;
    self.Telephone.delegate=self;
    self.Telephone.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.Telephone];
    
    if ([NSString isEqualToNull:self.TelephoneStr]) {
        self.Telephone.text = self.TelephoneStr;
    }
    
    self.Email = [GPUtils createTextField:CGRectMake(90, 58*5-20+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司邮箱", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.Email.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.Email setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.Email.tag = 5;
    self.Email.delegate=self;
    self.Email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.scrollView addSubview:self.Email];
    
    if ([NSString isEqualToNull:self.EmailStr]) {
        self.Email.text = self.EmailStr;
    }
    
    
    self.LocationBtn = [GPUtils createButton:CGRectMake(0, 58*6-20+height, WIDTH(self.mainView), 48) action:@selector(pushAdress:) delegate:self normalImage:nil highlightedImage:nil];
    self.LocationBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.LocationBtn];
    
    
    self.locationLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.locationLa.backgroundColor = [UIColor clearColor];
    [self.LocationBtn addSubview:self.locationLa];
    
    if ([NSString isEqualToNull:self.locationStr]) {
        self.locationLa.text = self.locationStr;
    }else{
        self.locationLa.text = Custing(@"请选择公司所属地区", nil);
        self.locationLa.textColor = Color_cellPlace;
    }
    
    self.IndustryBtn = [GPUtils createButton:CGRectMake(0, 58*7-30+height, WIDTH(self.mainView), 48) action:@selector(SubordinateToIndustry:) delegate:self normalImage:nil highlightedImage:nil];
    self.IndustryBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.IndustryBtn];
    
    
    self.IndustryLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.IndustryLa.backgroundColor = [UIColor clearColor];
    [self.IndustryBtn addSubview:self.IndustryLa];
    
    if ([NSString isEqualToNull:self.IndustryStr]) {
        self.IndustryLa.text = self.IndustryStr;
    }else{
        self.IndustryLa.text = Custing(@"请选择公司所属行业", nil);
        self.IndustryLa.textColor = Color_cellPlace;
    }
    
    
    self.CompanySizeBtn = [GPUtils createButton:CGRectMake(0, 58*8-40+height, WIDTH(self.mainView), 48) action:@selector(pushCompanySize:) delegate:self normalImage:nil highlightedImage:nil];
    self.CompanySizeBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.CompanySizeBtn];
    
    
    self.CompanySizeLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.CompanySizeLa.backgroundColor = [UIColor clearColor];
    [self.CompanySizeBtn addSubview:self.CompanySizeLa];
    
    if ([NSString isEqualToNull:self.CompanySizeStr]) {
        self.CompanySizeLa.text = self.CompanySizeStr;
    }else{
        self.CompanySizeLa.text = Custing(@"请选择公司规模", nil);
        self.CompanySizeLa.textColor = Color_cellPlace;
    }
//    “添加消费”
//    UILabel * shuilv = [GPUtils createLable:CGRectMake(15, 58*9-22+height, WIDTH(self.mainView)-80, 40) text:Custing(@"开启后,在记一笔中填写“增值税专用发票税额”", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    shuilv.numberOfLines = 0;
//    shuilv.backgroundColor = [UIColor clearColor];
//    [self.scrollView addSubview:shuilv];
    
//    self.shuilvSw = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-70, 58*9-28+height, 40, 25)];
//    self.shuilvSw.backgroundColor = [UIColor clearColor];
//    self.shuilvStr = @"0";
//    [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
//    [self.shuilvSw addTarget:self action:@selector(isOpenShuiLv:) forControlEvents:UIControlEventValueChanged];
//    self.shuilvSw.onTintColor = Color_Blue_Important_20;
//    [self.scrollView addSubview:self.shuilvSw];
    
}

-(void)isOpenShuiLv:(UISwitch *)open {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    if ([self.shuilvStr isEqualToString:@"0"]) {
        self.shuilvStr = @"1";
        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:YES];
    }
    else
    {
        self.shuilvStr = @"0";
        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
    }
    
}



-(void)pushAdress:(UIButton *)btn{
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"location"];
    industry.dataStr =[NSString stringWithFormat:@"%@", self.locationLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
    
}

-(void)SubordinateToIndustry:(UIButton *)btn{
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"industry"];
    industry.dataStr = [NSString stringWithFormat:@"%@", self.IndustryLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
}

-(void)pushCompanySize:(UIButton *)btn{
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"companySize"];
    industry.dataStr = [NSString stringWithFormat:@"%@", self.CompanySizeLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
    
}


-(void)companyIndustryClickedLoadBtn:(NSDictionary *)dic type:(NSString *)type{
    if ([type isEqualToString:@"industry"]) {
        self.IndustryID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.IndustryLa.text = dic[@"industry"];
        self.IndustryLa.textColor = Color_form_TextField_20;
    }else if ([type isEqualToString:@"location"]){
        self.locationID = [NSString stringWithFormat:@"%@",dic[@"location"]];
        self.locationLa.text = dic[@"location"];
        self.locationLa.textColor = Color_form_TextField_20;
    }
    else{
        self.CompanySizeID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.CompanySizeLa.text = dic[@"scale"];
        self.CompanySizeLa.textColor = Color_form_TextField_20;
    }
    
    
}

-(void)editCompanyTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不超过20位", nil)];
        }
    }
    
}
-(void)editNameTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过20位", nil)];
        }
    }
    
}
-(void)editJobTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"职位不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"职位不超过20位", nil)];
        }
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
            
        case 3:
        {
            if (textField.text.length >= 11 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号不超过11位", nil)];
                return NO;
            }
            
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
            
        }
            break;
        case 4:
        {
            if (textField.text.length >= 12 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"电话号码不超过12位", nil)];
                return NO;
            }
            
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
            
        }
            break;
        case 5:
            
            if (textField.text.length >= 30 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"邮箱号不超过30位", nil)];
                return NO;
                NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:EMAIL]invertedSet];
                NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
                return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
            }
            
            break;
        default:
            break;
    }
    
    return YES;
}

//保存企业信息
-(void)RequestAddCompanyDocument{
    
    NSDictionary *dic = @{@"companyName":self.companyName.text,
                          @"companyContact":self.companyContact.text,
                          @"jobTitle":self.JobTitle.text,
                          @"mobile":self.mobile.text,
                          @"telephone":self.Telephone.text,
                          @"email":self.Email.text,
                          @"location":self.locationID,
                          @"industry":self.IndustryID,
                          @"companySize":self.CompanySizeID};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"company/CreateCorpMany"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}


//保存税率
-(void)saveShuiLvData {
    //company/SaveTax
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"company/SaveTax"] Parameters:@{@"EnableTax":self.shuilvStr,@"CompanyId":self.companyId} Delegate:self SerialNum:1 IfUserCache:NO];
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
        NSString * result = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];
        if ([NSString isEqualToNull:result]){
            self.companyId = result;
            [self saveShuiLvData];
        }else {
            return;
        }
    }
    
    
    if (serialNum == 1) {
        //        NSString * result = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];
        //        if ([NSString isEqualToNull:result]){
        //            self.shuilvStr = result;
        //            [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
        //        }
    }
    
    switch (serialNum) {
        case 0://
            
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
