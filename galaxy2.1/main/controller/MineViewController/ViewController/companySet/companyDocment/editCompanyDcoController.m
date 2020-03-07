//
//  editCompanyDcoController.m
//  galaxy
//
//  Created by 赵碚 on 15/12/22.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#define EMAIL @"1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm@._%\\+-"

#import "InitializationDataViewController.h"
#import "IndustryOnController.h"
#import "UIView+MLInputDodger.h"
#import "editCompanyDcoController.h"
//#import "analyzeData.h"

@interface editCompanyDcoController ()<GPClientDelegate,companyIndustryDelegate,UITextFieldDelegate,UIScrollViewDelegate,chooseTravelDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSArray * comDocArray;

@property (nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * userStr;
@property(nonatomic,strong)UIButton * editBtn;

@property (nonatomic,strong)UIView * mainView;

@property (nonatomic,strong)UITextField * companyName;
@property (nonatomic,strong)UITextField * companyContact;
@property (nonatomic,strong)UITextField * JobTitle;
@property (nonatomic,strong)UITextField * mobile;
@property (nonatomic,strong)UITextField * Telephone;
@property (nonatomic,strong)UITextField * Email;

@property (nonatomic, copy)NSArray * fromcityarray;//去城市
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

@property (nonatomic,strong)NSString * canClearData;
@property (nonatomic,strong)UIButton * canClearBtn;

@property (nonatomic,strong)NSString * contactAccountStr;

@property (nonatomic,strong)NSString * locationID;
@property (nonatomic,strong)NSString * IndustryID;
@property (nonatomic,strong)NSString * CompanySizeID;

@property (nonatomic,strong)UISwitch * shuilvSw;
@property (nonatomic,strong)NSString * shuilvStr;

@property (nonatomic,strong)NSString * companyId;

@property (nonatomic, strong) UIButton *btn_date;
@property (nonatomic, strong) chooseTravelDateView * datelView;//采购日期选择弹出框
@property (nonatomic, strong) UIPickerView *pic_date;
@property (nonatomic, strong) NSArray *arr_date;
@property (nonatomic, strong) NSString *str_date;

@end

@implementation editCompanyDcoController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
//        self.status = type;
        
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
    if ([self.status isEqualToString:@"upon"]) {
        [self.scrollView removeFromSuperview];
        [self RequestCompanyDocument];
    }
    
      
    self.mainView.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.mainView registerAsDodgeViewForMLInputDodger];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   [self RequestShuiLvData];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.editBtn = [[UIButton alloc]init];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:self.editBtn title:Custing(@"编辑", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(editCompany:)];

    [self setTitle:Custing(@"企业信息", nil) backButton:YES ];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self RequestCompanyDocument];
    
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
    [self.LocationBtn resignFirstResponder];
    [self.IndustryBtn resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.CompanySizeBtn resignFirstResponder];
    [self.companyContact resignFirstResponder];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        [self.editBtn setTitle:Custing(@"保存", nil) forState:UIControlStateNormal];
        [self.scrollView removeFromSuperview];
        [self createCompanyView];
        self.Email.userInteractionEnabled = YES;
        self.mobile.userInteractionEnabled = YES;
        self.JobTitle.userInteractionEnabled = YES;
        self.Telephone.userInteractionEnabled = YES;
        self.LocationBtn.userInteractionEnabled = YES;
        self.IndustryBtn.userInteractionEnabled = YES;
        self.companyName.userInteractionEnabled = YES;
        self.CompanySizeBtn.userInteractionEnabled = YES;
        self.companyContact.userInteractionEnabled = YES;
        self.shuilvSw.userInteractionEnabled = YES;
    }else{
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
        self.canClearBtn.hidden = NO;
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        
        [self RequestIndustryInfo];
    }
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Email resignFirstResponder];
    [self.mobile resignFirstResponder];
    [self.JobTitle resignFirstResponder];
    [self.Telephone resignFirstResponder];
    [self.LocationBtn resignFirstResponder];
    [self.IndustryBtn resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.CompanySizeBtn resignFirstResponder];
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
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if ([self.canClearData isEqualToString:@"0"]) {
            self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
            self.canClearBtn.hidden = YES;
            
        }else{
            if ([NSString isEqualToNull:self.EmailStr]) {
                self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49)];
                self.canClearBtn = [GPUtils createButton:CGRectMake(0, ScreenRect.size.height - 49 - NavigationbarHeight, Main_Screen_Width, 49) action:@selector(InitializationData:) delegate:self title:Custing(@"初始化数据", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
                self.canClearBtn.backgroundColor = Color_Blue_Important_20;
                [self.view addSubview:self.canClearBtn];
            }else{
                self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
                self.canClearBtn.hidden = YES;
            }
            
        }
    }else{
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
        self.canClearBtn.hidden = YES;
    }
    
    
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if ([NSString isEqualToNull:self.EmailStr]) {
            self.comDocArray = @[
                                 @{@"image":@"",@"name":Custing(@"公司名称", nil),@"height":@"10"},
                                 @{@"image":@"",@"name":Custing(@"联系人", nil),@"height":@"10"},
                                 @{@"image":@"",@"name":Custing(@"职位", nil),@"height":@"0"},
                                 @{@"image":@"",@"name":Custing(@"手机", nil),@"height":@"0"},
                                 @{@"image":@"",@"name":Custing(@"电话", nil),@"height":@"-10"},
                                 @{@"image":@"",@"name":Custing(@"邮箱", nil),@"height":@"-20"},
                                 @{@"image":@"",@"name":Custing(@"所属地区", nil),@"height":@"-20"},
                                 @{@"image":@"",@"name":Custing(@"所属行业", nil),@"height":@"-30"},
                                 @{@"image":@"",@"name":Custing(@"公司规模", nil),@"height":@"-40"}
//                                 @{@"image":@"",@"name":Custing(@"税额", nil),@"height":@"-40"},
//                                 @{@"image":@"",@"name":Custing(@"报销日期", nil),@"height":@"-40"}
                                 ];
            self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*1.9);

        }else{
            self.comDocArray = @[
                                 @{@"image":@"",@"name":Custing(@"获取更多权限，请完善企业信息", nil),@"height":@"10"},
                                 @{@"image":@"",@"name":Custing(@"公司名称", nil),@"height":@"10"},
                                 @{@"image":@"",@"name":Custing(@"联系人", nil),@"height":@"10"},
                                 @{@"image":@"",@"name":Custing(@"职位", nil),@"height":@"0"},
                                 @{@"image":@"",@"name":Custing(@"手机", nil),@"height":@"0"},
                                 @{@"image":@"",@"name":Custing(@"电话", nil),@"height":@"-10"},
                                 @{@"image":@"",@"name":Custing(@"邮箱", nil),@"height":@"-20"},
                                 @{@"image":@"",@"name":Custing(@"所属地区", nil),@"height":@"-20"},
                                 @{@"image":@"",@"name":Custing(@"所属行业", nil),@"height":@"-30"},
                                 @{@"image":@"",@"name":Custing(@"公司规模", nil),@"height":@"-40"}
//                                 @{@"image":@"",@"name":Custing(@"税额", nil),@"height":@"-40"},
//                                 @{@"image":@"",@"name":Custing(@"报销日期", nil),@"height":@"-40"}
                                 ];
            self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*2.1);

        }
        
        
    }else{
        self.comDocArray = @[
                             @{@"image":@"",@"name":Custing(@"公司名称", nil),@"height":@"10"},
                             @{@"image":@"",@"name":Custing(@"联系人", nil),@"height":@"10"},
                             @{@"image":@"",@"name":Custing(@"职位", nil),@"height":@"0"},
                             @{@"image":@"",@"name":Custing(@"手机", nil),@"height":@"0"},
                             @{@"image":@"",@"name":Custing(@"电话", nil),@"height":@"-10"},
                             @{@"image":@"",@"name":Custing(@"邮箱", nil),@"height":@"-20"},
                             @{@"image":@"skipImage",@"name":Custing(@"所属地区", nil),@"height":@"-20"},
                             @{@"image":@"skipImage",@"name":Custing(@"所属行业", nil),@"height":@"-30"},
                             @{@"image":@"skipImage",@"name":Custing(@"公司规模", nil),@"height":@"-40"}
//                             @{@"image":@"",@"name":Custing(@"税额", nil),@"height":@"-40"},
//                             @{@"image":@"",@"name":Custing(@"报销日期", nil),@"height":@"-40"}
                             ];
        self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Width*1.9);

        
    }
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    
    for (int j = 0 ; j < [self.comDocArray count] ; j ++ ) {
        NSInteger heightCell = [[[self.comDocArray objectAtIndex:j] objectForKey:@"height"] integerValue];
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, j*58+heightCell, Main_Screen_Width,48)];
//        self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
        self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.scrollView addSubview:self.mainView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 47.5, Main_Screen_Width - 30,0.5)];
        lineView .backgroundColor = Color_GrayLight_Same_20;
        [self.mainView addSubview:lineView];
        
        
        UILabel * titleLa = [GPUtils createLable:CGRectMake(15, j*58+heightCell, 75, 48) text:[[self.comDocArray objectAtIndex:j] objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLa.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:titleLa];
        titleLa.numberOfLines = 0;
        
        if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
            if (![NSString isEqualToNull:self.EmailStr]) {
                if (j == 0) {
                    self.mainView.frame = CGRectMake(0, 0, Main_Screen_Width, 58);
                    titleLa.frame = CGRectMake(15, 0, Main_Screen_Width-30, 58);
                    titleLa.textColor = Color_Orange_Weak_20;
                    titleLa.font = Font_Same_14_20;
                    lineView.frame = CGRectMake(15, 57.5, Main_Screen_Width - 30, 0.5);
                }
            }
        }
//        j == self.comDocArray.count-2 ||
//        if ( j == self.comDocArray.count-1) {
//            self.mainView.frame = CGRectMake(0, j*58+heightCell, Main_Screen_Width, 68);
//            titleLa.frame = CGRectMake(15, j*58+heightCell, 75, 28);
//            titleLa.textColor = Color_Black_Important_20;
//            titleLa.font = Font_Important_15_20;
//            lineView.frame = CGRectMake(15, 67.5, Main_Screen_Width - 30, 0.5);
//        }
        
        UIImageView * viewImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-35,j*58+heightCell+15 , 18, 18)];
        viewImage.image = GPImage([[self.comDocArray objectAtIndex:j] objectForKey:@"image"]);
        viewImage.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:viewImage];
    
     }
    
    NSInteger height;
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if (![NSString isEqualToNull:self.EmailStr]) {
          height = 58;
        }else{
            height = 0;
        }
    }else{
        height = 0;
    }
    
    self.companyName = [GPUtils createTextField:CGRectMake(90, 10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司名称", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.companyName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.companyName setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.companyName.tag = 0;
    self.companyName.delegate=self;
    self.companyName.userInteractionEnabled = NO;
    self.companyName.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.companyName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editCompanyTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.companyName];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.companyName.textAlignment = NSTextAlignmentRight;
        self.companyName.text = [NSString isEqualToNull:self.companyNameStr]?self.companyNameStr:@" ";
    }else{
        if ([NSString isEqualToNull:self.companyNameStr]) {
            self.companyName.text = self.companyNameStr;
        }
    }
    
    self.companyContact = [GPUtils createTextField:CGRectMake(90, 58+10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司联系人", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.companyContact.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.companyContact setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.companyContact.tag = 1;
    self.companyContact.delegate=self;
    self.companyContact.userInteractionEnabled = NO;
    self.companyContact.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.companyContact];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editNameTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.companyContact];
    
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.companyContact.textAlignment = NSTextAlignmentRight;
        self.companyContact.text = [NSString isEqualToNull:self.companyContactStr]?self.companyContactStr:@" ";
    }else{
        if ([NSString isEqualToNull:self.companyContactStr]) {
            self.companyContact.text = self.companyContactStr;
        }
    }
    
    self.JobTitle = [GPUtils createTextField:CGRectMake(90, 58*2+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入职位", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.JobTitle.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.JobTitle setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.JobTitle.tag = 2;
    self.JobTitle.delegate=self;
    self.JobTitle.userInteractionEnabled = NO;
    self.JobTitle.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.JobTitle];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editJobTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.JobTitle];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.JobTitle.textAlignment = NSTextAlignmentRight;
        self.JobTitle.text = [NSString isEqualToNull:self.JobTitleStr]?self.JobTitleStr:@" ";
    }else{
        if ([NSString isEqualToNull:self.JobTitleStr]) {
            self.JobTitle.text = self.JobTitleStr;
        }
    }
    
    self.mobile = [GPUtils createTextField:CGRectMake(90, 58*3+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司手机", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.mobile.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.mobile setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.mobile.tag = 3;
    self.mobile.delegate=self;
    self.mobile.userInteractionEnabled = NO;
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.mobile];
    
    if ([NSString isEqualToNull:self.mobileStr]) {
        self.mobile.text = self.mobileStr;
    }
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.mobile.textAlignment = NSTextAlignmentRight;
    }
    self.Telephone = [GPUtils createTextField:CGRectMake(90, 58*4-10+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司电话", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.Telephone.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.Telephone setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.Telephone.tag = 4;
    self.Telephone.delegate=self;
    self.Telephone.userInteractionEnabled = NO;
    self.Telephone.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.Telephone];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.Telephone.textAlignment = NSTextAlignmentRight;
        self.Telephone.text = [NSString isEqualToNull:self.TelephoneStr]?self.TelephoneStr:@" ";
    }else{
        if ([NSString isEqualToNull:self.TelephoneStr]) {
            self.Telephone.text = self.TelephoneStr;
        }
    }
    
    
    self.Email = [GPUtils createTextField:CGRectMake(90, 58*5-20+height, WIDTH(self.mainView)-105, 48) placeholder:Custing(@"请输入公司邮箱", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.Email.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.Email setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.Email.tag = 5;
    self.Email.delegate=self;
    self.Email.userInteractionEnabled = NO;
    self.Email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.scrollView addSubview:self.Email];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        self.Email.textAlignment = NSTextAlignmentRight;
        self.Email.text = [NSString isEqualToNull:self.EmailStr]?self.EmailStr:@" ";
    }else{
        if ([NSString isEqualToNull:self.EmailStr]) {
            self.Email.text = self.EmailStr;
        }
    }
    
    
    self.LocationBtn = [GPUtils createButton:CGRectMake(0, 58*6-20+height, WIDTH(self.mainView), 48) action:@selector(pushAdress:) delegate:self normalImage:nil highlightedImage:nil];
    self.LocationBtn.backgroundColor = [UIColor clearColor];
    self.LocationBtn.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.LocationBtn];
    
    
    self.locationLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.locationLa.backgroundColor = [UIColor clearColor];
    [self.LocationBtn addSubview:self.locationLa];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if ([NSString isEqualToNull:self.locationStr]) {
            self.locationLa.text = self.locationStr;
            self.locationLa.frame = CGRectMake(90, 0, WIDTH(self.mainView)-105, 48);
        }else{
            self.locationLa.text = @"";
        }
    }else{
        if ([NSString isEqualToNull:self.locationStr]) {
            self.locationLa.text = self.locationStr;
        }else{
            self.locationLa.text = Custing(@"请选择公司所属地区", nil);
            self.locationLa.textColor = Color_cellPlace;
        }
    }
    
    self.IndustryBtn = [GPUtils createButton:CGRectMake(0, 58*7-30+height, WIDTH(self.mainView), 48) action:@selector(SubordinateToIndustry:) delegate:self normalImage:nil highlightedImage:nil];
    self.IndustryBtn.backgroundColor = [UIColor clearColor];
    self.IndustryBtn.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.IndustryBtn];
    
    
    self.IndustryLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.IndustryLa.backgroundColor = [UIColor clearColor];
    [self.IndustryBtn addSubview:self.IndustryLa];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if ([NSString isEqualToNull:self.IndustryStr]) {
            self.IndustryLa.text = self.IndustryStr;
            self.IndustryLa.frame = CGRectMake(90, 0, WIDTH(self.mainView)-105, 48);
        }else{
            self.IndustryLa.text = @"";
        }
    }else{
        if ([NSString isEqualToNull:self.IndustryStr]) {
            self.IndustryLa.text = self.IndustryStr;
        }else{
            self.IndustryLa.text = Custing(@"请选择公司所属行业", nil);
            self.IndustryLa.textColor = Color_cellPlace;
        }
    }
    

    self.CompanySizeBtn = [GPUtils createButton:CGRectMake(0, 58*8-40+height, WIDTH(self.mainView), 48) action:@selector(pushCompanySize:) delegate:self normalImage:nil highlightedImage:nil];
    self.CompanySizeBtn.backgroundColor = [UIColor clearColor];
    self.CompanySizeBtn.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.CompanySizeBtn];
    
    
    self.CompanySizeLa = [GPUtils createLable:CGRectMake(90, 0, WIDTH(self.mainView)-125, 48) text:@"" font:Font_cellContent_16 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.CompanySizeLa.backgroundColor = [UIColor clearColor];
    [self.CompanySizeBtn addSubview:self.CompanySizeLa];
    
    if ([self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if ([NSString isEqualToNull:self.CompanySizeStr]) {
            self.CompanySizeLa.text = self.CompanySizeStr;
            self.CompanySizeLa.frame = CGRectMake(90, 0, WIDTH(self.mainView)-105, 48);
        }else{
            self.CompanySizeLa.text = @"";
        }
    }else{
        if ([NSString isEqualToNull:self.CompanySizeStr]) {
            self.CompanySizeLa.text = self.CompanySizeStr;
        }else{
            self.CompanySizeLa.text = Custing(@"请选择公司规模", nil);
            self.CompanySizeLa.textColor = Color_cellPlace;
        }
    }
    
//    UILabel * shuilv = [GPUtils createLable:CGRectMake(15, 58*9-22+height, WIDTH(self.mainView)-80, 40) text:Custing(@"开启后,在记一笔中填写“增值税专用发票税额”", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    shuilv.backgroundColor = [UIColor clearColor];
//    shuilv.numberOfLines = 0;
//    [self.scrollView addSubview:shuilv];
    
//    self.shuilvSw = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-70, 58*9-28+height, 40, 25)];
//    self.shuilvSw.backgroundColor = [UIColor clearColor];
//    if ([self.shuilvStr isEqualToString:@"0"]) {
//        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
//    }else{
//        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
//    }
//    [self.shuilvSw addTarget:self action:@selector(isOpenShuiLv:) forControlEvents:UIControlEventValueChanged];
//    self.shuilvSw.userInteractionEnabled = NO;
//    self.shuilvSw.onTintColor = Color_Blue_Important_20;
//    [self.scrollView addSubview:self.shuilvSw];
    
//    UILabel * baoxiaodate = [GPUtils createLable:CGRectMake(15, 58*9-7+height, WIDTH(self.mainView)-30, 40) text:[NSString stringWithFormat:@"%@                %@",Custing(@"只能报销", nil),Custing(@"个月内的发票，过期的发票不能报销", nil)] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    baoxiaodate.backgroundColor = [UIColor clearColor];
//    baoxiaodate.numberOfLines = 0;
//    [baoxiaodate sizeToFit];
//    [self.scrollView addSubview:baoxiaodate];
//    CGSize bxsize = [NSString sizeWithText:Custing(@"只能报销", nil) font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    CGSize btnsize = [NSString sizeWithText:@"                " font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    
//    if (![NSString isEqualToNull:_str_date]) {
//        _str_date = @"0";
//    }
//    
//    _btn_date = [GPUtils createButton:CGRectMake(20+ceil(bxsize.width), Y(baoxiaodate), ceil(btnsize.width-10), 17) action:@selector(date_click:) delegate:self title:_str_date font:Font_Same_14_20 titleColor:Color_Black_Important_20];
//    [_btn_date setBackgroundImage:[UIImage imageNamed:@"my_dateBtn"] forState:UIControlStateNormal];
//    [self.scrollView addSubview:_btn_date];
}

#pragma mark - action
-(void)date_click:(UIButton *)btn{
    if (![self.editBtn.titleLabel.text isEqualToString:Custing(@"编辑", nil)]) {
        if (_pic_date == nil) {
            _pic_date = [[UIPickerView alloc]init];
            _pic_date.dataSource = self;
            _pic_date.delegate = self;
        }
        if (_arr_date == nil) {
            _arr_date = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        }
        if (_datelView == nil) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"报销日期", nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [view addSubview:cancelDataBtn];
            _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _pic_date.frame.size.height+40) pickerView:_pic_date titleView:view];
            _datelView.delegate = self;
            [_datelView showUpView:_pic_date];
        }
        for (int i = 0; i<_arr_date.count; i++) {
            if ([_str_date isEqualToString:_arr_date[i]]) {
                [_pic_date selectRow:i inComponent:0 animated:YES];
            }
        }
        [_datelView show];
    }
}


#pragma mark - delegate
-(void)dimsissPDActionView{
    _datelView = nil;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arr_date.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arr_date[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _str_date = _arr_date[row];
}

-(void)sureData{
    NSInteger value = [_str_date integerValue];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",UpdateCliamDate] Parameters:@{@"CliamDate":[NSNumber numberWithInteger:value]} Delegate:self SerialNum:6 IfUserCache:NO];
    [_btn_date setTitle:_str_date forState:UIControlStateNormal];
    [_datelView remove];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)btn_Cancel_Click{
    [_datelView remove];
}

-(void)isOpenShuiLv:(UISwitch *)open {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    if ([self.shuilvStr isEqualToString:@"0"]) {
        self.shuilvStr = @"1";
        [self saveShuiLvData];
        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:YES];
    }
    else
    {
        self.shuilvStr = @"0";
        [self saveShuiLvData];
        [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
    }
    
}

-(void)InitializationData:(UIButton *)btn{
    self.status = @"upon";
    InitializationDataViewController * initialization = [[InitializationDataViewController alloc]initWithType:self.contactAccountStr];
    [self.navigationController pushViewController:initialization animated:YES];
    
}

-(void)pushAdress:(UIButton *)btn{
    self.status = @"upno";
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"location"];
    industry.dataStr =[NSString stringWithFormat:@"%@", self.locationLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
    
}

-(void)SubordinateToIndustry:(UIButton *)btn{
    self.status = @"upno";
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"industry"];
    industry.dataStr = [NSString stringWithFormat:@"%@", self.IndustryLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
}

-(void)pushCompanySize:(UIButton *)btn{
    self.status = @"upno";
    IndustryOnController * industry = [[IndustryOnController alloc]initWithType:@"companySize"];
    industry.dataStr = [NSString stringWithFormat:@"%@", self.CompanySizeLa.text];
    industry.delegate = self;
    [self.navigationController pushViewController:industry animated:YES];
    
}

-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array
{
    NSDictionary *dic = array[0];
    
    _fromcityarray = array;
    self.locationLa.textColor = Color_Unsel_TitleColor;
    self.locationLa.text = dic[@"cityName"];
//    _hotel.checkincity = dic[@"cityName"];
//    _hotel.checkincitycode = dic[@"cityCode"];
}

-(void)companyIndustryClickedLoadBtn:(NSDictionary *)dic type:(NSString *)type{
    if ([type isEqualToString:@"industry"]) {
//        self.IndustryID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.IndustryLa.text = dic[@"industry"];
        self.IndustryLa.textColor = Color_form_TextField_20;
    }else if ([type isEqualToString:@"location"]){
//        self.locationID = [NSString stringWithFormat:@"%@",dic[@"location"]];
        self.locationLa.text = dic[@"location"];
        self.locationLa.textColor = Color_form_TextField_20;
    }
    else{
//        self.CompanySizeID = [NSString stringWithFormat:@"%@",dic[@"id"]];
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


//获取我的企业表单数据
-(void)RequestIndustryInfo{
    
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",getcompanyget] Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
    
}


//获取我的企业表单数据
-(void)RequestCompanyDocument{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetCoInfo] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
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
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcompanyput] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//获取税率
-(void)RequestShuiLvData {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"company/GetTax"] Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}


//保存税率
-(void)saveShuiLvData {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"company/SaveTax"] Parameters:@{@"EnableTax":self.shuilvStr,@"CompanyId": self.companyId} Delegate:self SerialNum:5 IfUserCache:NO];
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
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else{
            NSDictionary * company = [result objectForKey:@"company"];
            if ([company isKindOfClass:[NSNull class]] || company == nil|| company.count == 0||!company){
                return;
            }
            //[NSString stringWithFormat:@"%@",[result objectForKey:@"canClearData"]];
            self.companyId = [NSString stringWithFormat:@"%@",[company objectForKey:@"companyId"]];
            self.canClearData = [NSString stringWithFormat:@"%@",[result objectForKey:@"canClearData"]];
            self.companyNameStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"companyName"]];
            self.companyContactStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"companyContact"]];
            self.JobTitleStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"jobTitle"]];
            self.contactAccountStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"contactAccount"]];
            self.mobileStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"mobile"]];
            self.TelephoneStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"telephone"]];
            self.EmailStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"email"]];
            self.locationStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"location"]];
            self.IndustryStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"industryDsp"]];
            self.CompanySizeStr = [NSString stringWithFormat:@"%@",[company objectForKey:@"companySizeDsp"]];
            self.userdatas.companyId = [NSString stringWithIdOnNO:self.companyId];
            self.userdatas.company = _companyNameStr;
            self.str_date = [NSString stringWithFormat:@"%@",[company objectForKey:@"cliamDate"]];
            [self.userdatas storeUserInfo];
        }
    }
    if (serialNum ==1) {
        if ([success isEqualToString:@"1"]) {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //[self popSettingViewControl];
            });
        }
    }
    
    if (serialNum == 2) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        
        NSArray * province = [result objectForKey:@"province"];
        if ([province isKindOfClass:[NSNull class]] || province == nil|| province.count == 0||!province){
            
        }else{
            for (NSDictionary * listDic in province) {
                if ([self.locationLa.text isEqualToString:[NSString stringWithFormat:@"%@",listDic[@"provinceName"]]]) {
                    self.locationID = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"provinceName"]];
                }
            }
        }
        
        NSArray * industry = [result objectForKey:@"industry"];
        if ([industry isKindOfClass:[NSNull class]] || industry == nil|| industry.count == 0||!industry){
            
        }else{
            for (NSDictionary * listDic in industry) {
                if ([self.IndustryLa.text isEqualToString:[NSString stringWithFormat:@"%@",listDic[@"industry"]]]) {
                    self.IndustryID = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
                }
                
            }
        }
        
        NSArray * coscale = [result objectForKey:@"coScale"];
        if ([coscale isKindOfClass:[NSNull class]] || coscale == nil|| coscale.count == 0||!coscale){
            
        }else{
            for (NSDictionary * listDic in coscale) {
                if ([self.CompanySizeLa.text isEqualToString:[NSString stringWithFormat:@"%@",listDic[@"scale"]]]) {
                    self.CompanySizeID = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
                }
            }
        }
        [self RequestAddCompanyDocument];
        
    }
    
    if (serialNum == 3) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else {
            NSString * enableTax = [NSString stringWithFormat:@"%@",[result objectForKey:@"enableTax"]];
            self.shuilvStr = enableTax;
            [self.shuilvSw setOn:[self.shuilvStr boolValue] animated:NO];
        }
    }
    
    if (serialNum == 5) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:2.0];
    }
    if (serialNum == 6) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:2.0];
    }
    
    switch (serialNum) {
        case 0://
            [self createCompanyView];
            if ([self.userStr isEqualToString:@"121"]) {
                self.userdatas.RefreshStr = @"YES";
                 [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"企业信息保存成功", nil) duration:2.0];
            }
            self.userStr = @"212";
            break;
        case 1:
            [self.editBtn setTitle:Custing(@"编辑", nil) forState:UIControlStateNormal];
            [self.scrollView removeFromSuperview];
            [self RequestCompanyDocument];
            self.userStr = @"121";
            self.Email.userInteractionEnabled = NO;
            self.mobile.userInteractionEnabled = NO;
            self.JobTitle.userInteractionEnabled = NO;
            self.Telephone.userInteractionEnabled = NO;
            self.LocationBtn.userInteractionEnabled = NO;
            self.IndustryBtn.userInteractionEnabled = NO;
            self.companyName.userInteractionEnabled = NO;
            self.CompanySizeBtn.userInteractionEnabled = NO;
            self.companyContact.userInteractionEnabled = NO;
            self.shuilvSw.userInteractionEnabled = NO;
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
