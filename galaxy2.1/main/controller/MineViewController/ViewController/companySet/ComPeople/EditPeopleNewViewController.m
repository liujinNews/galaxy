//
//  EditPeopleNewViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/6/23.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "StatisticalView.h"

#import "EditPeopleNewViewController.h"
#import "EditPeople.h"
#import "JKAlertDialog.h"
#import "BottomView.h"
#import "SexEditTableViewCell.h"
#import "SelectViewController.h"
#import "ComPeopleViewController.h"

@interface EditPeopleNewViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectViewControllerDelegate,ComPeopleViewControllerDelegate,StatisticalViewDelegate,UITextFieldDelegate,chooseTravelDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) EditPeople *model;
@property (nonatomic, strong) NSDictionary *request;
@property (nonatomic, strong) NSMutableArray *arr_usergroup;//用户数组

//修改性别的弹窗。。。
@property (nonatomic, strong) JKAlertDialog *alert;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) NSInteger nowClick;

//长按手势
@property (nonatomic, strong) UITapGestureRecognizer * longPress;

@property (nonatomic, strong) UIScrollView *scr_view;

@property (nonatomic, strong) UIView *view_one;
@property (nonatomic, strong) UITableView *tbv_two;
@property (nonatomic, strong) UIView *view_three;

@property (nonatomic, assign) NSInteger cellheight;

@property (nonatomic, strong) UITextField *txf_name;
@property (nonatomic, strong) UITextField *txf_firstName;
@property (nonatomic, strong) UITextField *txf_lastName;
@property (nonatomic, strong) UITextField *txf_sex;
@property (nonatomic, strong) UITextField *txf_phone;
@property (nonatomic, strong) UITextField *txf_Account;
@property (nonatomic, strong) UITextField *txf_email;
@property (nonatomic, strong) UITextField *txf_Language;
@property (nonatomic, strong) UITextField *txf_hrid;
@property (nonatomic, strong) UITextField *txf_level;
@property (nonatomic, strong) UITextField *txf_SelectLevel;
@property (nonatomic, strong) NSMutableArray *Muarr_SelectLevel;
@property (nonatomic, strong) NSString *str_SelectLevel;
@property (nonatomic, strong) NSString *str_SelectLevelCode;
@property (nonatomic, strong) NSString *str_levelid;
@property (nonatomic, strong) UITextField *txf_cost;
@property (nonatomic, strong) NSString *str_costid;
@property (nonatomic, strong) UITextField *txf_filiale;
@property (nonatomic, strong) NSString *str_filialeid;
@property (nonatomic, strong) UITextField *txf_BusDepartment;
@property (nonatomic, strong) NSString *str_BusDepartmentid;
@property (nonatomic, strong) NSString *str_ViewRptPer;
@property (nonatomic, strong) UITextField *txf_Area;
@property (nonatomic, strong) UITextField *txf_Location;
@property (nonatomic, strong) UITextField *txf_subAccount;

@property (nonatomic, strong) NSString *str_area;
@property (nonatomic, strong) NSString *str_location;
@property (nonatomic, strong) NSString *str_Language;

@property (nonatomic, strong) UIView *view_name;
@property (nonatomic, strong) UIView *view_firstName;
@property (nonatomic, strong) UIView *view_lastName;
@property (nonatomic, strong) UIView *view_sex;
@property (nonatomic, strong) UIView *view_Account;
@property (nonatomic, strong) UIView *view_phone;
@property (nonatomic, strong) UIView *view_email;
@property (nonatomic, strong) UIView *view_Language;
@property (nonatomic, strong) UIView *view_SelectLevel;
@property (nonatomic, strong) UIView *view_level;
@property (nonatomic, strong) UIView *view_cost;
@property (nonatomic, strong) UIView *view_filiale;
@property (nonatomic, strong) UIView *view_addBtn;
@property (nonatomic, strong) UIView *view_permission;
@property (nonatomic, strong) UIView *view_HRID;
@property (nonatomic, strong) UIView *view_BusDepartment;
@property (nonatomic, strong) UIView *view_Area;
@property (nonatomic, strong) UIView *view_Location;
@property (nonatomic, strong) UIView *view_SubAccount;

@property (nonatomic, strong) UIView *view_LineManager;
@property (nonatomic, strong) UIView *view_Approver1;
@property (nonatomic, strong) UIView *view_Approver2;
@property (nonatomic, strong) UIView *view_Approver3;
@property (nonatomic, strong) UIView *view_Approver4;
@property (nonatomic, strong) UIView *view_Approver5;
@property (nonatomic, strong) UITextField *txf_LineManager;
@property (nonatomic, strong) UITextField *txf_Approver1;
@property (nonatomic, strong) UITextField *txf_Approver2;
@property (nonatomic, strong) UITextField *txf_Approver3;
@property (nonatomic, strong) UITextField *txf_Approver4;
@property (nonatomic, strong) UITextField *txf_Approver5;
@property (nonatomic, strong) NSString *str_LineManagerId;
@property (nonatomic, strong) NSString *str_ApproverId1;
@property (nonatomic, strong) NSString *str_ApproverId2;
@property (nonatomic, strong) NSString *str_ApproverId3;
@property (nonatomic, strong) NSString *str_ApproverId4;
@property (nonatomic, strong) NSString *str_ApproverId5;


@property (nonatomic, strong) NSArray *arr_customs;
@property (nonatomic, strong) UIView *view_customs;
@property (nonatomic, strong) UITextField *txf_customs1;
@property (nonatomic, strong) UITextField *txf_customs2;
@property (nonatomic, strong) UITextField *txf_customs3;
@property (nonatomic, strong) UITextField *txf_customs4;
@property (nonatomic, strong) UITextField *txf_customs5;
@property (nonatomic, strong) UITextField *txf_customs6;
@property (nonatomic, strong) UITextField *txf_customs7;
@property (nonatomic, strong) UITextField *txf_customs8;
@property (nonatomic, strong) UITextField *txf_customs9;
@property (nonatomic, strong) UITextField *txf_customs10;

@property (nonatomic, strong) UIButton *btn_customs1;
@property (nonatomic, strong) UIButton *btn_customs2;
@property (nonatomic, strong) UIButton *btn_customs3;
@property (nonatomic, strong) UIButton *btn_customs4;
@property (nonatomic, strong) UIButton *btn_customs5;
@property (nonatomic, strong) UIButton *btn_customs6;
@property (nonatomic, strong) UIButton *btn_customs7;
@property (nonatomic, strong) UIButton *btn_customs8;
@property (nonatomic, strong) UIButton *btn_customs9;
@property (nonatomic, strong) UIButton *btn_customs10;

@property (nonatomic, strong) UIDatePicker *dap_Date;
@property (nonatomic, strong) chooseTravelDateView * cho_Date;//采购日期选择弹出框
@property (nonatomic, strong) UIPickerView *pic_IsLDSpv;
@property (nonatomic, strong) NSMutableArray *Muarr_IsLDSpv;
@property (nonatomic, strong) NSString *str_IsLDSpv;

@property (nonatomic, strong) UIPickerView *pic_SelectLevel;
@property (nonatomic, strong) UIPickerView *pic_Language;
@property (nonatomic, strong) NSMutableArray *Muarr_Language;

@property (nonatomic, strong) BottomView *contentView;
@property (nonatomic, strong) StatisticalView * dateView;

@property (nonatomic, strong) UIButton * resetBtn;


@end

@implementation EditPeopleNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    [self.resetBtn addTarget:self action:@selector(toResetYourPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetBtn setTitle:Custing(@"重置密码", nil) forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:Normal_NavBar_TitleBlue_20 forState:UIControlStateNormal];
    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.resetBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    if (self.userdatas.SystemType == 1) {
        [self.resetBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    }
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.resetBtn];
    
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroup:) name:@"edit_group" object:nil];
    
    //初始化参数
    if (![NSString isEqualToNull:_userId]) {
        _userId = @"";
    }
    _arr_usergroup = [[NSMutableArray alloc]init];
    _Muarr_SelectLevel = [NSMutableArray array];
    _str_levelid = @"";
    _str_costid = @"";
    _str_ViewRptPer = @"";
    _str_filialeid = @"";
    _str_BusDepartmentid = @"";
    _str_SelectLevel = @"";
    _str_area = @"";
    _str_SelectLevelCode = @"";
    _str_location = @"";
    _str_Language = @"";
    _str_IsLDSpv = @"";
    _arr_customs = [NSArray array];
    _btn_close_width.constant = Main_Screen_Width/2;
    [_btn_close setTitle:Custing(@"禁用", nil) forState:UIControlStateNormal];
    [_btn_OK setTitle:Custing(@"保存", nil) forState:UIControlStateNormal];
    
    if (_isNowPeople==1) {
        _btn_close.userInteractionEnabled = NO;
        _btn_close.backgroundColor = Color_GrayDark_Same_20;
        [self setTitle:Custing(@"修改成员", nil) backButton:YES ];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }else if(_isNowPeople==2){
        _btn_close.userInteractionEnabled = NO;
        _btn_close.backgroundColor = Color_GrayDark_Same_20;
        _btn_close.hidden = YES;
        _btn_close_width.constant = 0;
        _img_close.hidden = YES;
        [self setTitle:Custing(@"新增成员", nil) backButton:YES ];
    }else{
        _isNowPeople=0;
        [self setTitle:Custing(@"修改成员", nil) backButton:YES ];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    if (_isNowPeople==2) {
        NSString *json = [NSString stringWithFormat:@"{\"success\":true,\"result\":{\"credentialType\":null,\"isMobileHide\":0,\"birthday\":null,\"userGroup\":[{\"groupId\":%@,\"jobTitleCode\":\"\",\"groupName\":\"%@\",\"parentId\":null,\"jobTitle\":\"\"}],\"userLevels\":null,\"userLevelId\":\"\",\"photoGraph\":\"\",\"companyId\":0,\"isExp\":false,\"hrid\":null,\"identityCardId\":null,\"userLevel\":\"\",\"costCenterId\":\"\",\"bankAccountInfo\":null,\"costCenters\":null,\"userAccount\":\"\",\"userDspName\":\"\",\"firstName\":\"\",\"lastName\":\"\",\"gender\":0,\"email\":\"\",\"isMobileVerified\":1,\"mobile\":\"\",\"costCenter\":\"\",\"companyName\":null,\"viewRptPer\":0,\"photoUrl\":null,\"isEmailVerified\":0,\"subAccountName\":null,\"userId\":0},\"msg\":null,\"unAuthorizedRequest\":false,\"error\":null}",[NSString isEqualToNull:_DeparId]?_DeparId:self.userdatas.companyId,[NSString isEqualToNull:_DeparTitle]?_DeparTitle:self.userdatas.company];
        _request = [NSString dictionaryWithJsonString:json];
        [self getPeopleInfoData];
    }else{
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [self getGroupgetuser];
    }
    _longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - function
-(void)getGroupgetuser
{
    NSString *url=[NSString stringWithFormat:@"%@",groupgetuser_V2];
    NSDictionary *parameters = @{@"UserId":_userId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//请求基本数据
-(void)requestCredentials
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:4 IfUserCache:NO];
}

-(void)getPeopleInfoData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_request[@"result"]];
    NSArray *usergroup = dic[@"userGroup"];
    [dic removeObjectForKey:@"userGroup"];
    _arr_customs = [dic objectForKey:@"customs"];
    if (![_arr_customs isKindOfClass:[NSArray class]]) {
        _arr_customs = [NSArray array];
    }
    
    _model = [[EditPeople alloc]initWithBydic:dic];
    _str_costid = _model.costCenterId;
    _str_levelid = _model.userLevelId;
    _str_filialeid = _model.branch;
    userGroup *group = [[userGroup alloc]init];
    if (usergroup.count>0) {
        for (int i =0; i<usergroup.count; i++) {
            group = [[userGroup alloc]initWithBydic:usergroup[i]];
            [_arr_usergroup addObject:group];
        }
    }else{
        [_arr_usergroup addObject:group];
    }
    [self createMainView];
    
    if ([[NSString stringWithFormat:@"%@",dic[@"userId"]]isEqualToString:self.userdatas.userId]) {
        _btn_close.userInteractionEnabled = NO;
        _btn_close.backgroundColor = Color_GrayDark_Same_20;
    }
 
    
}

-(void)createMainView
{
    self.scr_view = [[UIScrollView alloc]init];
    self.scr_view.backgroundColor = Color_White_Same_20;
    [self.view_RootView addSubview:self.scr_view];
    [self.scr_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view_RootView);
    }];
    
    _contentView =[[BottomView alloc]init];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [self.scr_view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_view);
        make.width.equalTo(self.scr_view);
    }];
    
    NSDictionary *dic = [NSObject getObjectData:_model];
    _cellheight = 0;
    
    self.view_one = [[UIView alloc]init];
    self.view_one.backgroundColor = Color_White_Same_20;
    [self.scr_view addSubview:self.view_one];
    [self.view_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scr_view);
        make.height.equalTo(@(54*6));
    }];
    
    
    self.tbv_two = [[UITableView alloc]init];
    self.tbv_two.delegate = self;
    self.tbv_two.dataSource = self;
    self.tbv_two.backgroundColor = Color_White_Same_20;
    [self.tbv_two setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.scr_view addSubview:self.tbv_two];
    [self.tbv_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_one.bottom);
        make.left.right.equalTo(self.scr_view);
        make.height.equalTo(@314);
    }];
    
    self.view_three = [[UIView alloc]init];
    self.view_three.backgroundColor = Color_White_Same_20;
    [self.scr_view addSubview:self.view_three];
    int row_hiegit = ceil(_arr_customs.count*54) + 516+360;
    [self.view_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tbv_two.bottom);
        make.left.right.equalTo(self.scr_view);
        make.height.equalTo(row_hiegit);
    }];
    if (_isNowPeople==2) {
        [self.view_three mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(550+60*6));
        }];
    }
    [self createMainOne:dic];
    [self updateContentView];
}

-(void)createMainOne:(NSDictionary *)dic
{
    //创建姓名
    self.view_name = [[UIView alloc]init];
    self.view_name.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:self.view_name];
    [self.view_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_one.top).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_name = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"姓名", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [self.view_name addSubview:lab_name];
    _txf_name = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入姓名", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    [self.view_name addSubview:_txf_name];
    if ([NSString isEqualToNull:dic[@"userDspName"]]) {
        _txf_name.text = dic[@"userDspName"];
    }
    //创建firstname
    self.view_firstName = [[UIView alloc] init];
    self.view_firstName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:self.view_firstName];
    [self.view_firstName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_name.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_firstName = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"firstName", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.view_firstName addSubview:lab_firstName];
    _txf_firstName = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入firstName", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    [self.view_firstName addSubview:_txf_firstName];
    if ([NSString isEqualToNull:dic[@"firstName"]]) {
        _txf_firstName.text = dic[@"firstName"];
    }
    //创建lastname
    self.view_lastName = [[UIView alloc] init];
    self.view_lastName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:self.view_lastName];
    [self.view_lastName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_firstName.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_lastName = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"lastName", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.view_lastName addSubview:lab_lastName];
    _txf_lastName = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入lastName", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    [self.view_lastName addSubview:_txf_lastName];
    if ([NSString isEqualToNull:dic[@"lastName"]]) {
        _txf_lastName.text = dic[@"lastName"];
    }
    //创建性别
    _view_sex = [[UIView alloc]init];
    _view_sex.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:_view_sex];
    [_view_sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_lastName.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_sex = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"性别", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [_view_sex addSubview:lab_sex];
    _txf_sex = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"选择性别", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_sex.userInteractionEnabled = NO;
    _txf_sex.textAlignment = NSTextAlignmentRight;
//    [_txf_sex setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_sex = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_sex.tag = 1;
    [btn_sex addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_sex = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_sex addSubview:_txf_sex];
    [_view_sex addSubview:img_sex];
    [_view_sex addSubview:btn_sex];
    if ([NSString isEqualToNull:dic[@"gender"]]) {
        _txf_sex.text = [dic[@"gender"] intValue]==0?Custing(@"男", nil):Custing(@"女",nil);
    }
    
    
    //创建账号
    _view_Account = [[UIView alloc]init];
    _view_Account.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:_view_Account];
    [_view_Account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_sex.bottom).offset(0);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(0);
    }];
    UILabel *lab_account = [GPUtils createLable:CGRectZero text:Custing(@"用户账号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];//CGRectMake(20, 13, 80, 18)
    [_view_Account addSubview:lab_account];
    _txf_Account= [GPUtils createTextField:CGRectZero placeholder:Custing(@"请输入用户账号", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];//CGRectMake(108, 13, Main_Screen_Width-148, 18)
    [_view_Account addSubview:_txf_Account];
    if ([NSString isEqualToNull:dic[@"userAccount"]]) {
        _txf_Account.text = dic[@"userAccount"];
    }
    
    //创建手机
    _view_phone = [[UIView alloc]init];
    _view_phone.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:_view_phone];
    [_view_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_sex.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_phone = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"手机", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [_view_phone addSubview:lab_phone];
    _txf_phone = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入手机号", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_phone.keyboardType =UIKeyboardTypeNumberPad;
    if (_isNowPeople!=2) {
        _txf_phone.userInteractionEnabled = NO;
    }
    [_view_phone addSubview:_txf_phone];
    if ([NSString isEqualToNull:dic[@"mobile"]]) {
        _txf_phone.text = dic[@"mobile"];
    }
    
    //创建邮箱
    _view_email = [[UIView alloc]init];
    _view_email.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:_view_email];
    [_view_email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_phone.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_email = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"邮箱", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [_view_email addSubview:lab_email];
    _txf_email= [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入邮箱", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_email.keyboardType =UIKeyboardTypeASCIICapable;
    [_view_email addSubview:_txf_email];
    if ([NSString isEqualToNull:dic[@"email"]]) {
        _txf_email.text = dic[@"email"];
    }
    
    //创建语言
    self.view_Language = [[UIView alloc]init];
    self.view_Language.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:self.view_Language];
    [self.view_Language mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_email.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Language = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"语言", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [self.view_Language addSubview:lab_Language];
    _txf_Language= [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择语言", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Language.userInteractionEnabled = NO;
//    [_txf_Language setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Language = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Language.tag = 8;
    [btn_Language addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Language = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [self.view_Language addSubview:img_Language];
    [self.view_Language addSubview:btn_Language];
    [self.view_Language addSubview:_txf_Language];
    if ([NSString isEqualToNull:dic[@"language"]]) {
        if ([dic[@"language"] isEqualToString:@"ch"]) {
            _txf_Language.text = @"简体中文";
        }
        if ([dic[@"language"] isEqualToString:@"en"]) {
            _txf_Language.text = @"English";
        }
    }
    
//    创建员工工号
    _view_HRID = [[UIView alloc]init];
    _view_HRID.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_one addSubview:_view_HRID];
    [_view_HRID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Language.bottom).offset(10);
        make.left.right.equalTo(self.view_one);
        make.height.equalTo(@44);
    }];
    UILabel *lab_HRID = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"工号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    [_view_HRID addSubview:lab_HRID];
    _txf_hrid= [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入工号", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_hrid.keyboardType =UIKeyboardTypeASCIICapable;
    [_view_HRID addSubview:_txf_hrid];
    if ([NSString isEqualToNull:dic[@"hrid"]]) {
        _txf_hrid.text = dic[@"hrid"];
    }
    
    //创建添加按钮
    self.view_addBtn = [[UIView alloc]init];
//    self.view_addBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:self.view_addBtn];
    [self.view_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:self.view_addBtn withTitle:Custing(@"增加部门职位", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];

    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf AddDetailsClick:nil];
    }];
    [self.view_addBtn addSubview:view];


    
    //创建选择默认职位
    self.view_SelectLevel = [[UIView alloc]init];
    self.view_SelectLevel.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:self.view_SelectLevel];
    [self.view_SelectLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_addBtn.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_SelectLevel = [GPUtils createLable:CGRectMake(20, 0, 80, 44) text:Custing(@"首要职位", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    lab_SelectLevel.numberOfLines = 0;
    _txf_SelectLevel = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择首要职位", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_SelectLevel.userInteractionEnabled = NO;
    _txf_SelectLevel.textAlignment = NSTextAlignmentRight;
//    [_txf_SelectLevel setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_SelectLevel = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_SelectLevel.tag = 6;
    [btn_SelectLevel addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_SelectLevel = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [self.view_SelectLevel addSubview:lab_SelectLevel];
    [self.view_SelectLevel addSubview:_txf_SelectLevel];
    [self.view_SelectLevel addSubview:img_SelectLevel];
    [self.view_SelectLevel addSubview:btn_SelectLevel];
    
    
    //创建级别
    self.view_level = [[UIView alloc]init];
    self.view_level.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:self.view_level];
    [self.view_level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_SelectLevel.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_level = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"级别", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_level = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择级别", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_level.userInteractionEnabled = NO;
    _txf_level.textAlignment = NSTextAlignmentRight;
//    [_txf_level setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_level = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_level.tag = 2;
    [btn_level addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_level = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [self.view_level addSubview:lab_level];
    [self.view_level addSubview:_txf_level];
    [self.view_level addSubview:img_level];
    [self.view_level addSubview:btn_level];
    if ([NSString isEqualToNull:dic[@"userLevel"]]) {
        _txf_level.text = dic[@"userLevel"];
    }
    
    //创建成本中心
    self.view_cost = [[UIView alloc]init];
    self.view_cost.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:self.view_cost];
    [self.view_cost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_level.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_cost = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"成本中心", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_cost = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择成本中心", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_cost.userInteractionEnabled = NO;
    _txf_cost.textAlignment = NSTextAlignmentRight;
//    [_txf_cost setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_cost = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_cost.tag = 3;
    [btn_cost addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_cost = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [self.view_cost addSubview:lab_cost];
    [self.view_cost addSubview:_txf_cost];
    [self.view_cost addSubview:img_cost];
    [self.view_cost addSubview:btn_cost];
    if ([NSString isEqualToNull:dic[@"costCenter"]]) {
        _txf_cost.text = dic[@"costCenter"];
    }
    
    //创建公司
    self.view_filiale = [[UIView alloc]init];
    self.view_filiale.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:self.view_filiale];
    [self.view_filiale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_cost.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_filiale = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"公司", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_filiale = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择公司", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_filiale.userInteractionEnabled = NO;
    _txf_filiale.textAlignment = NSTextAlignmentRight;
//    [_txf_filiale setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_filiale = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_filiale.tag = 4;
    [btn_filiale addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_filiale = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [self.view_filiale addSubview:lab_filiale];
    [self.view_filiale addSubview:_txf_filiale];
    [self.view_filiale addSubview:img_filiale];
    [self.view_filiale addSubview:btn_filiale];
    if ([NSString isEqualToNull:dic[@"branchName"]]) {
        _txf_filiale.text = dic[@"branchName"];
    }
    
    //创建业务部门
    _view_BusDepartment = [[UIView alloc]init];
    _view_BusDepartment.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_BusDepartment];
    [_view_BusDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_filiale.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_BusDepartment = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"业务部门", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_BusDepartment = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择业务部门", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_BusDepartment.userInteractionEnabled = NO;
    _txf_BusDepartment.textAlignment = NSTextAlignmentRight;
//    [_txf_BusDepartment setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_BusDepartment = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_BusDepartment.tag = 5;
    [btn_BusDepartment addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_BusDepartment = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_BusDepartment addSubview:lab_BusDepartment];
    [_view_BusDepartment addSubview:_txf_BusDepartment];
    [_view_BusDepartment addSubview:img_BusDepartment];
    [_view_BusDepartment addSubview:btn_BusDepartment];
    if ([NSString isEqualToNull:dic[@"busDepartmentName"]]) {
        _txf_BusDepartment.text = dic[@"busDepartmentName"];
    }
    
    //创建地区
    _view_Area = [[UIView alloc]init];
    _view_Area.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Area];
    [_view_Area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_BusDepartment.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Area = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"地区", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Area = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择地区", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Area.userInteractionEnabled = NO;
    _txf_Area.textAlignment = NSTextAlignmentRight;
//    [_txf_Area setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Area = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Area.tag = 9;
    [btn_Area addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Area = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Area addSubview:lab_Area];
    [_view_Area addSubview:_txf_Area];
    [_view_Area addSubview:img_Area];
    [_view_Area addSubview:btn_Area];
    if ([NSString isEqualToNull:dic[@"areaName"]]) {
        _txf_Area.text = dic[@"areaName"];
    }
    if ([NSString isEqualToNull:dic[@"area"]]) {
        _str_area = dic[@"area"];
    }
    
    //创建办事处
    _view_Location = [[UIView alloc]init];
    _view_Location.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Location];
    [_view_Location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Area.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Location = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"办事处", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Location = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择办事处", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Location.userInteractionEnabled = NO;
    _txf_Location.textAlignment = NSTextAlignmentRight;
//    [_txf_Location setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Location = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Location.tag = 10;
    [btn_Location addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Location = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Location addSubview:lab_Location];
    [_view_Location addSubview:_txf_Location];
    [_view_Location addSubview:img_Location];
    [_view_Location addSubview:btn_Location];
    if ([NSString isEqualToNull:dic[@"locationName"]]) {
        _txf_Location.text = dic[@"locationName"];
    }
    if ([NSString isEqualToNull:dic[@"location"]]) {
        _str_location = dic[@"location"];
    }
    
    
    
    //创建直线领导
    _view_LineManager = [[UIView alloc]init];
    _view_LineManager.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_LineManager];
    [_view_LineManager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Location.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_LineManager = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"直线领导", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_LineManager = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择直线领导", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_LineManager.userInteractionEnabled = NO;
    _txf_LineManager.textAlignment = NSTextAlignmentRight;
//    [_txf_LineManager setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_LineManager = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_LineManager.tag = 15;
    [btn_LineManager addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_LineManager = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_LineManager addSubview:lab_LineManager];
    [_view_LineManager addSubview:_txf_LineManager];
    [_view_LineManager addSubview:img_LineManager];
    [_view_LineManager addSubview:btn_LineManager];
    if ([NSString isEqualToNull:dic[@"lineManager"]]) {
        _txf_LineManager.text = dic[@"lineManager"];
    }
    if ([NSString isEqualToNull:dic[@"lineManagerId"]]) {
        _str_LineManagerId = [NSString stringWithFormat:@"%@",dic[@"lineManagerId"]];
    }
    
    //创建审批人1
    _view_Approver1 = [[UIView alloc]init];
    _view_Approver1.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Approver1];
    [_view_Approver1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_LineManager.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Approver1 = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"审批人1", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Approver1 = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择审批人1", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Approver1.userInteractionEnabled = NO;
    _txf_Approver1.textAlignment = NSTextAlignmentRight;
//    [_txf_Approver1 setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Approver1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Approver1.tag = 16;
    [btn_Approver1 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Approver1 = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Approver1 addSubview:lab_Approver1];
    [_view_Approver1 addSubview:_txf_Approver1];
    [_view_Approver1 addSubview:img_Approver1];
    [_view_Approver1 addSubview:btn_Approver1];
    if ([NSString isEqualToNull:dic[@"approver1"]]) {
        _txf_Approver1.text = dic[@"approver1"];
    }
    if ([NSString isEqualToNull:dic[@"approverId1"]]) {
        _str_ApproverId1 = [NSString stringWithFormat:@"%@",dic[@"approverId1"]];

    }
    
    
    //创建审批人2
    _view_Approver2 = [[UIView alloc]init];
    _view_Approver2.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Approver2];
    [_view_Approver2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Approver1.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Approver2 = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"审批人2", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Approver2 = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择审批人2", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Approver2.userInteractionEnabled = NO;
    _txf_Approver2.textAlignment = NSTextAlignmentRight;
//    [_txf_Approver2 setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Approver2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Approver2.tag = 17;
    [btn_Approver2 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Approver2 = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Approver2 addSubview:lab_Approver2];
    [_view_Approver2 addSubview:_txf_Approver2];
    [_view_Approver2 addSubview:img_Approver2];
    [_view_Approver2 addSubview:btn_Approver2];
    if ([NSString isEqualToNull:dic[@"approver2"]]) {
        _txf_Approver2.text = dic[@"approver2"];
    }
    if ([NSString isEqualToNull:dic[@"approverId2"]]) {
        _str_ApproverId2 = [NSString stringWithFormat:@"%@",dic[@"approverId2"]];
    }
    
    //创建审批人3
    _view_Approver3 = [[UIView alloc]init];
    _view_Approver3.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Approver3];
    [_view_Approver3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Approver2.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Approver3 = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"审批人3", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Approver3 = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择审批人3", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Approver3.userInteractionEnabled = NO;
    _txf_Approver3.textAlignment = NSTextAlignmentRight;
//    [_txf_Approver3 setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Approver3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Approver3.tag = 18;
    [btn_Approver3 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Approver3 = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Approver3 addSubview:lab_Approver3];
    [_view_Approver3 addSubview:_txf_Approver3];
    [_view_Approver3 addSubview:img_Approver3];
    [_view_Approver3 addSubview:btn_Approver3];
    if ([NSString isEqualToNull:dic[@"approver3"]]) {
        _txf_Approver3.text = dic[@"approver3"];
    }
    if ([NSString isEqualToNull:dic[@"approverId3"]]) {
        _str_ApproverId3 = [NSString stringWithFormat:@"%@",dic[@"approverId3"]];
    }
    
    //创建审批人4
    _view_Approver4 = [[UIView alloc]init];
    _view_Approver4.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Approver4];
    [_view_Approver4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Approver3.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Approver4 = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"审批人4", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Approver4 = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择审批人4", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Approver4.userInteractionEnabled = NO;
    _txf_Approver4.textAlignment = NSTextAlignmentRight;
//    [_txf_Approver4 setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Approver4 = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Approver4.tag = 19;
    [btn_Approver4 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Approver4 = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Approver4 addSubview:lab_Approver4];
    [_view_Approver4 addSubview:_txf_Approver4];
    [_view_Approver4 addSubview:img_Approver4];
    [_view_Approver4 addSubview:btn_Approver4];
    if ([NSString isEqualToNull:dic[@"approver4"]]) {
        _txf_Approver4.text = dic[@"approver4"];
    }
    if ([NSString isEqualToNull:dic[@"approverId4"]]) {
        _str_ApproverId4 = [NSString stringWithFormat:@"%@",dic[@"approverId4"]];
    }
    
    //创建审批人5
    _view_Approver5 = [[UIView alloc]init];
    _view_Approver5.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_Approver5];
    [_view_Approver5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Approver4.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@44);
    }];
    UILabel *lab_Approver5 = [GPUtils createLable:CGRectMake(20, 13, 90, 18) text:Custing(@"审批人5", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    _txf_Approver5 = [GPUtils createTextField:CGRectMake(118, 13, Main_Screen_Width-158, 18) placeholder:Custing(@"请选择审批人5", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_Approver5.userInteractionEnabled = NO;
    _txf_Approver5.textAlignment = NSTextAlignmentRight;
//    [_txf_Approver5 setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_Approver5 = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
    btn_Approver5.tag = 20;
    [btn_Approver5 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_Approver5 = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 15, 10, 14) imageName:@"People_arrow"];
    [_view_Approver5 addSubview:lab_Approver5];
    [_view_Approver5 addSubview:_txf_Approver5];
    [_view_Approver5 addSubview:img_Approver5];
    [_view_Approver5 addSubview:btn_Approver5];
    if ([NSString isEqualToNull:dic[@"approver5"]]) {
        _txf_Approver5.text = dic[@"approver5"];
    }
    if ([NSString isEqualToNull:dic[@"approverId5"]]) {
        _str_ApproverId5 = [NSString stringWithFormat:@"%@",dic[@"approverId5"]];
    }
    
    
    //创建查看视图
    _view_permission = [[UIView alloc]init];
    _view_permission.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_permission];
    [_view_permission mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Approver5.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(@74);
    }];
    UILabel *lab_title = [GPUtils createLable:CGRectMake(20, 8, Main_Screen_Width - 91, 31) text:Custing(@"查看报表权限", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    UISwitch *switc = [[UISwitch alloc]initWithFrame:CGRectMake(Main_Screen_Width-71, 8, 51, 31)];
    [switc addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
    UILabel *lab_content = [GPUtils createLable:CGRectMake(20, 40, Main_Screen_Width-40, 30) text:Custing(@"开启后有权限查看本部门、以及下级部门员工提交的报销，生成的部门费用统计表。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab_content.numberOfLines = 0;
    if ([NSString isEqualToNull:dic[@"viewRptPer"]]) {
        _str_ViewRptPer = [NSString stringWithFormat:@"%@",dic[@"viewRptPer"]];
        switc.on = [dic[@"viewRptPer"] intValue];
    }
    [_view_permission addSubview:lab_title];
    [_view_permission addSubview:switc];
    [_view_permission addSubview:lab_content];
    
    //子账户
    _view_SubAccount = [[UIView alloc] init];
    _view_SubAccount.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view_three addSubview:_view_SubAccount];
    [_view_SubAccount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_permission.bottom).offset(10);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(44);
    }];
    UILabel *lab_SubAccount = [GPUtils createLable:CGRectMake(20, 13, 80, 18) text:Custing(@"子账户", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.view_SubAccount addSubview:lab_SubAccount];
    _txf_subAccount = [GPUtils createTextField:CGRectMake(108, 13, Main_Screen_Width-148, 18) placeholder:Custing(@"请输入子账户", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    [self.view_SubAccount addSubview:_txf_subAccount];
    if ([NSString isEqualToNull:dic[@"subAccountName"]]) {
        _txf_subAccount.text = dic[@"subAccountName"];
    }
    
    _view_customs = [[UIView alloc]init];
    [self.view_three addSubview:_view_customs];
    [_view_customs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_SubAccount.bottom);
        make.left.right.equalTo(self.view_three);
        make.height.equalTo(self.arr_customs.count*54);
    }];
    
    for (int i = 0 ; i<_arr_customs.count; i++) {
        NSDictionary *dic = _arr_customs[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*54, Main_Screen_Width, 54)];
        view.backgroundColor = Color_form_TextFieldBackgroundColor;
        [view addSubview:[self createLineView]];
        [_view_customs addSubview:view];
        UILabel *lab_name = [GPUtils createLable:CGRectMake(12, 10, 80, 44) text:dic[@"description"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
        lab_name.numberOfLines = 0;
        [view addSubview:lab_name];
        
        UITextField *txf = [GPUtils createTextField:CGRectMake(108, 10, Main_Screen_Width-148, 44) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        txf.text = [NSString isEqualToNull:dic[@"fieldValue"]]?dic[@"fieldValue"]:@"";
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 44)];
        if (![dic[@"ctrlTyp"]isEqualToString:@"text"]) {
            btn.tag = [dic[@"ctrlTyp"]isEqualToString:@"dialog"]?10001:10002;
            [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 25, 10, 14) imageName:@"People_arrow"];
            txf.textAlignment = NSTextAlignmentRight;
            txf.userInteractionEnabled = NO;
            [view addSubview:btn];
            [view addSubview:img];
            txf.placeholder = Custing(@"请选择", nil);
        }else{
            txf.placeholder = Custing(@"请输入", nil);
        }
        [view addSubview:txf];
        switch (i) {
            case 0:
                _txf_customs1 = txf;
                _btn_customs1 = btn;
                break;
            case 1:
                _txf_customs2 = txf;
                _btn_customs2 = btn;
                break;
            case 2:
                _txf_customs3 = txf;
                _btn_customs3 = btn;
                break;
            case 3:
                _txf_customs4 = txf;
                _btn_customs4 = btn;
                break;
            case 4:
                _txf_customs5 = txf;
                _btn_customs5 = btn;
                break;
            case 5:
                _txf_customs6 = txf;
                _btn_customs6 = btn;
                break;
            case 6:
                _txf_customs7 = txf;
                _btn_customs7 = btn;
                break;
            case 7:
                _txf_customs8 = txf;
                _btn_customs8 = btn;
                break;
            case 8:
                _txf_customs9 = txf;
                _btn_customs9 = btn;
                break;
            case 9:
                _txf_customs10 = txf;
                _btn_customs10 = btn;
                break;
            default:
                break;
        }
    }

    if (_isNowPeople==2) {
        UILabel *lab = [GPUtils createLable:CGRectMake(20, 82, Main_Screen_Width-40, 30) text:Custing(@"新增员工后，将免费向新加入员工发送邀请短信。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [_view_permission addSubview:lab];
    }
    
    
    
    
}

-(void)updateContentView{
    [self.tbv_two updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.arr_usergroup.count*172);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_three.bottom).offset(@10);
    }];
}

#pragma mark - action
-(void)back:(UIButton *)btn
{
    self.userdatas.PeoplePage = 0;
    [self Navback];
}

- (IBAction)btn_OK_click:(UIButton *)sender {
    _btn_OK.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    
    if (![NSString isEqualToNull:_txf_name.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"姓名为必填内容", nil) duration:1.0];
        _btn_OK.userInteractionEnabled = YES;
        return;
    }
    
    
    if (![NSString isEqualToNull:_txf_phone.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请确认手机内容是否填写正确",nil) duration:1.0];
        _btn_OK.userInteractionEnabled = YES;
        return;
    }
    NSString *i =_txf_phone.text;
    if (i.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号",nil) duration:1.5];
        _btn_OK.userInteractionEnabled = YES;
        return;
    }
    
    NSString *email = _txf_email.text;
    if ([NSString isEqualToNull:email]) {
        if (email.length >40) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"邮箱不能超过40位", nil) duration:1.5];
            _btn_OK.userInteractionEnabled = YES;
            return;
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:email]) {//邮箱地址不正确吧？
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"输入邮箱信息不正确，请重新输入。", nil)];
            _btn_OK.userInteractionEnabled = YES;
            return;
        }
    }
    if (![NSString isEqualToNull:_txf_SelectLevel.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请选择首要职务",nil) duration:1.5];
        _btn_OK.userInteractionEnabled = YES;
        return;
    }
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    [Dic setObject:_txf_name.text forKey:@"userdspname"];
    [Dic setObject:[NSString isEqualToNull:_txf_Account.text]?_txf_Account.text:[NSNull null] forKey:@"userAccount"];
    [Dic setObject:[NSString isEqualToNull:_txf_firstName.text]?_txf_firstName.text:[NSNull null] forKey:@"FirstName"];
    [Dic setObject:[NSString isEqualToNull:_txf_lastName.text]?_txf_lastName.text:[NSNull null] forKey:@"LastName"];
    [Dic setObject:[NSString isEqualToNull:_txf_phone.text]?_txf_phone.text:[NSNull null] forKey:@"mobile"];
    [Dic setObject:[NSString isEqualToNull:_txf_email.text]?_txf_email.text:[NSNull null] forKey:@"email"];
    [Dic setObject:[NSString isEqualToNull:_str_levelid]?_str_levelid:[NSNull null] forKey:@"userlevel"];
    [Dic setObject:[NSString isEqualToNull:_str_costid]?_str_costid:[NSNull null] forKey:@"costcenter"];
    [Dic setObject:[_txf_sex.text isEqualToString:Custing(@"女", nil)]?@"1":@"0" forKey:@"gender"];
    [Dic setObject:_str_ViewRptPer forKey:@"viewRptPer"];
    [Dic setObject:[NSString isEqualToNull:_str_filialeid]?_str_filialeid:@"" forKey:@"Branch"];
    [Dic setObject:[NSString isEqualToNull:_txf_hrid.text]?_txf_hrid.text:@"" forKey:@"hrid"];
    [Dic setObject:[NSString isEqualToNull:_txf_BusDepartment.text]?_txf_BusDepartment.text:@"" forKey:@"busDepartmentName"];
    [Dic setObject:[NSString isEqualToNull:_str_BusDepartmentid]?_str_BusDepartmentid:@"" forKey:@"busDepartment"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs1.text]?_txf_customs1.text:@"" forKey:@"Reserved1"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs2.text]?_txf_customs2.text:@"" forKey:@"Reserved2"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs3.text]?_txf_customs3.text:@"" forKey:@"Reserved3"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs4.text]?_txf_customs4.text:@"" forKey:@"Reserved4"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs5.text]?_txf_customs5.text:@"" forKey:@"Reserved5"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs6.text]?_txf_customs6.text:@"" forKey:@"Reserved6"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs7.text]?_txf_customs7.text:@"" forKey:@"Reserved7"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs8.text]?_txf_customs8.text:@"" forKey:@"Reserved8"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs9.text]?_txf_customs9.text:@"" forKey:@"Reserved9"];
    [Dic setObject:[NSString isEqualToNull:_txf_customs10.text]?_txf_customs10.text:@"" forKey:@"Reserved10"];
    [Dic setObject:[NSString isEqualToNull:_txf_subAccount.text]?_txf_subAccount.text:@"" forKey:@"SubAccountName"];

    
    [Dic setObject:[NSString isEqualToNull:_txf_Approver1.text]?_txf_Approver1.text:@"" forKey:@"Approver1"];
    [Dic setObject:[NSString isEqualToNull:_txf_Approver2.text]?_txf_Approver2.text:@"" forKey:@"Approver2"];
    [Dic setObject:[NSString isEqualToNull:_txf_Approver3.text]?_txf_Approver3.text:@"" forKey:@"Approver3"];
    [Dic setObject:[NSString isEqualToNull:_txf_Approver4.text]?_txf_Approver4.text:@"" forKey:@"Approver4"];
    [Dic setObject:[NSString isEqualToNull:_txf_Approver5.text]?_txf_Approver5.text:@"" forKey:@"Approver5"];
    
    [Dic setObject:[NSString isEqualToNull:_str_ApproverId1]?_str_ApproverId1:@"0" forKey:@"ApproverId1"];
    [Dic setObject:[NSString isEqualToNull:_str_ApproverId2]?_str_ApproverId2:@"0" forKey:@"ApproverId2"];
    [Dic setObject:[NSString isEqualToNull:_str_ApproverId3]?_str_ApproverId3:@"0" forKey:@"ApproverId3"];
    [Dic setObject:[NSString isEqualToNull:_str_ApproverId4]?_str_ApproverId4:@"0" forKey:@"ApproverId4"];
    [Dic setObject:[NSString isEqualToNull:_str_ApproverId5]?_str_ApproverId5:@"0" forKey:@"ApproverId5"];
    
    [Dic setObject:[NSString isEqualToNull:_txf_LineManager.text]?_txf_LineManager.text:@"" forKey:@"LineManager"];
    [Dic setObject:[NSString isEqualToNull:_str_LineManagerId]?_str_LineManagerId:@"0" forKey:@"LineManagerId"];
    
    [Dic setObject:_str_area forKey:@"area"];
    [Dic setObject:_str_location forKey:@"location"];
    if ([_txf_Language.text isEqualToString:@"简体中文"]) {
        [Dic setObject:@"ch" forKey:@"Language"];
    }else{
        [Dic setObject:@"en" forKey:@"Language"];
    }
    
    
    NSMutableDictionary *mbdic ;
    NSMutableArray *mbarr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_arr_usergroup.count; i++) {
        userGroup *group = _arr_usergroup[i];
        if (![NSString isEqualToNull:group.groupId]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"请选择第%d个部门",i+1] duration:1.5];
            _btn_OK.userInteractionEnabled = YES;
            return;
        }
        if (![NSString isEqualToNull:group.jobTitleCode]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"请选择第%d个职位",i+1] duration:1.5];
            _btn_OK.userInteractionEnabled = YES;
            return;
        }
        mbdic= [[NSMutableDictionary alloc]init];
        [mbdic setObject:[NSString isEqualToNull:group.groupId]?group.groupId:[NSNull null] forKey:@"groupid"];
        [mbdic setObject:[NSString isEqualToNull:group.jobTitleCode]?group.jobTitleCode:[NSNull null] forKey:@"jobtitlecode"];
        [mbdic setObject:[NSString isEqualToNull:group.jobTitle]?group.jobTitle:[NSNull null] forKey:@"jobtitle"];
        [mbdic setObject:[NSString isEqualToNull:group.isldSpv]?[[NSString stringWithFormat:@"%@",group.isldSpv] isEqualToString:@"1"]?@"1":@"0":@"0" forKey:@"isldSpv"];
        if ([NSString isEqualToNull:group.jobTitleCode]||[NSString isEqualToNull:group.groupId]||[NSString isEqualToNull:group.jobTitle]) {
            if ([group.jobTitle isEqualToString:_txf_SelectLevel.text]) {
                [mbdic setObject:@1 forKey:@"IsPrimTerm"];
            }else{
                [mbdic setObject:@0 forKey:@"IsPrimTerm"];
            }
            [mbarr addObject:mbdic];
        }
    }
    [Dic setObject:mbarr forKey:@"groupmbrs"];
    [Dic setObject:_model.userId forKey:@"UserId"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
//    NSLog(stri);
    NSDictionary *adddic = @{@"Mbrs":stri};
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (_isNowPeople==2) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",addmbr] Parameters:adddic Delegate:self SerialNum:1 IfUserCache:NO];
    }else{
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updatembr] Parameters:adddic Delegate:self SerialNum:1 IfUserCache:NO];
    }
}

- (IBAction)btn_Close_click:(id)sender {
    NSDictionary *adddic = @{@"UserId":_model.userId,@"UserAccount":_model.mobile};
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",upstatus] Parameters:adddic Delegate:self SerialNum:2 IfUserCache:NO];
}


//tag 1 性别 2级别 3成本中心
-(void)btn_click:(UIButton *)btn
{
    [self keyClose];
//    NSLog([NSString stringWithFormat:@"%ld",(long)btn.tag]);
    if (btn.tag>=1000&&btn.tag<=10000) {
        NSInteger i = btn.tag-1000;
        if (_Muarr_SelectLevel.count!=0&&[_txf_SelectLevel.text isEqualToString:_Muarr_SelectLevel[i][@"jobtitle"]]) {
            _txf_SelectLevel.text = @"";
        }
        [_arr_usergroup removeObjectAtIndex:i];
        [self.tbv_two reloadData];
        [self updateContentView];
    }
    if (btn.tag==1) {
        self.alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"选择性别", nil) message:@"" canDismis:YES];
        self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 120) style:UITableViewStylePlain];
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        self.tableview.tableFooterView = [[UIView alloc]init];
        self.tableview.tag = 88;
        self.alert.contentView =  self.tableview;
        [self.alert show];
    }
    if (btn.tag==2) {
        NSLog(@"level_click");
        SelectViewController *select = [[SelectViewController alloc]init];
        select.type = 0;
        select.selectId = [NSString stringWithFormat:@"%@",_str_levelid];
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
    if (btn.tag == 3) {
        SelectViewController *select = [[SelectViewController alloc]init];
        select.type = 2;
        select.selectId = [NSString stringWithFormat:@"%@",_str_costid];
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
    if (btn.tag == 4) {
        SelectViewController *select = [[SelectViewController alloc]init];
        select.type = 3;
        select.selectId = [NSString stringWithFormat:@"%@",_str_filialeid];
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
    if (btn.tag == 5) {        
        __weak typeof(self) weakSelf = self;
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BDivision"];
        vc.ChooseCategoryId = _str_BusDepartmentid;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_BusDepartmentid = model.Id;
            weakSelf.txf_BusDepartment.text=model.name;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 6) {
        if (_arr_usergroup.count>0) {
            _Muarr_SelectLevel = [NSMutableArray array];
            for (int i = 0; i<_arr_usergroup.count; i++) {
                userGroup *group = _arr_usergroup[i];
                if ([NSString isEqualToNull:group.jobTitleCode]||[NSString isEqualToNull:group.jobTitle]) {
                    NSMutableDictionary *mudic= [[NSMutableDictionary alloc]init];
                    [mudic setObject:[NSString isEqualToNull:group.jobTitleCode]?group.jobTitleCode:[NSNull null] forKey:@"jobtitlecode"];
                    [mudic setObject:[NSString isEqualToNull:group.jobTitle]?group.jobTitle:[NSNull null] forKey:@"jobtitle"];
                    [_Muarr_SelectLevel addObject:mudic];
                }
            }
        }
        if (_Muarr_SelectLevel.count>0) {
            if (_pic_SelectLevel == nil) {
                _pic_SelectLevel = [[UIPickerView alloc]init];
                _pic_SelectLevel.dataSource = self;
                _pic_SelectLevel.delegate = self;
            }
            if (_cho_Date == nil) {
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
                UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
                lbl.text=Custing(@"首要职位", nil);
                lbl.font=Font_cellContent_16;
                lbl.textColor=Color_cellTitle;
                lbl.textAlignment=NSTextAlignmentCenter;
                lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
                [view addSubview:lbl];
                UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_click:) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
                sureDataBtn.tag = 7;
                [view addSubview:sureDataBtn];
                UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
                cancelDataBtn.tag = 12;
                [view addSubview:cancelDataBtn];
                if (!_cho_Date) {
                    _cho_Date=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _pic_SelectLevel.frame.size.height+40) pickerView:_pic_SelectLevel titleView:view];
                    _cho_Date.delegate = self;
                }
                if (![NSString isEqualToNull:_txf_SelectLevel.text]) {
                    _txf_SelectLevel.text = _Muarr_SelectLevel[0][@"jobtitle"];
                }
                for (int i = 0; i<_Muarr_SelectLevel.count; i++) {
                    if ([_txf_SelectLevel.text isEqualToString:_Muarr_SelectLevel[i][@"jobtitle"]]) {
                        [_pic_SelectLevel selectRow:i inComponent:0 animated:YES];
                    }
                }
                [_cho_Date showUpView:_pic_SelectLevel];
                [_cho_Date show];
            }
            [_cho_Date show];
        }
    }
    if (btn.tag == 7) {
        if ([NSString isEqualToNull:_str_SelectLevel]) {
            _txf_SelectLevel.text = _str_SelectLevel;
        }
        _pic_SelectLevel = nil;
        [_cho_Date remove];
        _cho_Date = nil;
        _str_SelectLevel = @"";
    }
    //语言
    if (btn.tag == 8) {
        _Muarr_Language = [NSMutableArray arrayWithArray:@[Custing(@"简体中文", nil),Custing(@"English", nil)]];
        if (_Muarr_Language.count>0) {
            if (_pic_Language == nil) {
                _pic_Language = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 220)];
                _pic_Language.dataSource = self;
                _pic_Language.delegate = self;
            }
            if (_cho_Date == nil) {
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
                UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
                lbl.text=Custing(@"语言", nil);
                lbl.font=Font_cellContent_16;
                lbl.textColor=Color_cellTitle;
                lbl.textAlignment=NSTextAlignmentCenter;
                lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
                [view addSubview:lbl];
                UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_click:) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
                sureDataBtn.tag = 11;
                [view addSubview:sureDataBtn];
                UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
                cancelDataBtn.tag = 13;
                [view addSubview:cancelDataBtn];
                if (!_cho_Date) {
                    _cho_Date=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _pic_Language.frame.size.height+40) pickerView:_pic_SelectLevel titleView:view];
                    _cho_Date.delegate = self;
                }
                if (![NSString isEqualToNull:_txf_Language.text]) {
                    _txf_Language.text = _Muarr_Language[0];
                }
                for (int i = 0; i<_Muarr_Language.count; i++) {
                    if ([_txf_Language.text isEqualToString:_Muarr_Language[i]]) {
                        [_pic_Language selectRow:i inComponent:0 animated:YES];
                    }
                }
                [_cho_Date showUpView:_pic_Language];
                [_cho_Date show];
            }
            [_cho_Date show];
        }
    }
    //地区
    if (btn.tag == 9) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"area"];
        vc.ChooseCategoryId=_str_area;
        __weak typeof(self) weakSelf = self;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_area=model.Id;
            weakSelf.txf_Area.text=model.name;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    //办事处
    if (btn.tag == 10) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"location"];
        vc.ChooseCategoryId=_str_location;
        __weak typeof(self) weakSelf = self;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_location=model.Id;
            weakSelf.txf_Location.text=model.name;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 11) {
        if ([NSString isEqualToNull:_str_Language]) {
            _txf_Language.text = _str_Language;
        }
        _pic_Language = nil;
        [_cho_Date remove];
        _cho_Date = nil;
        _str_Language = @"";
    }
    if (btn.tag == 12) {
        _pic_SelectLevel = nil;
        [_cho_Date remove];
        _cho_Date = nil;
    }
    if (btn.tag == 13) {
        _pic_Language = nil;
        [_cho_Date remove];
        _cho_Date = nil;
    }
    
    if (btn.tag>=15&&btn.tag<=20) {
        contactsVController *contactVC=[[contactsVController alloc]init];
        NSMutableArray *array = [NSMutableArray array];
//        NSString *ChooseId;
//        if (btn.tag==15) {
//            ChooseId=_str_LineManagerId;
//        }else if (btn.tag==16){
//            ChooseId=_str_ApproverId1;
//        }else if (btn.tag==17){
//            ChooseId=_str_ApproverId2;
//        }else if (btn.tag==18){
//            ChooseId=_str_ApproverId3;
//        }else if (btn.tag==19){
//            ChooseId=_str_ApproverId4;
//        }else if (btn.tag==20){
//            ChooseId=_str_ApproverId5;
//        }
//        ChooseId=[NSString stringWithFormat:@"%@",ChooseId];
        NSArray *idarr =@[self.userdatas.userId];
        for (int i = 0 ; i<idarr.count ; i++) {
            NSDictionary *dic = @{@"requestorUserId":idarr[i]};
            [array addObject:dic];
        }
        contactVC.arrClickPeople =array;
        contactVC.status = @"5";
        contactVC.menutype=3;
        contactVC.Radio = @"1";
        contactVC.isclean = @"1";
        contactVC.itemType = 99;
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            if (array.count==1) {
                buildCellInfo *info=array[0];
                switch (btn.tag) {
                    case 15:
                        weakSelf.txf_LineManager.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_LineManagerId=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];
                        break;
                    case 16:
                        weakSelf.txf_Approver1.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_ApproverId1=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];

                        break;
                    case 17:
                        weakSelf.txf_Approver2.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_ApproverId2=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];

                        break;
                    case 18:
                        weakSelf.txf_Approver3.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_ApproverId3=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];

                        break;
                    case 19:
                        weakSelf.txf_Approver4.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_ApproverId4=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];

                        break;
                    case 20:
                        weakSelf.txf_Approver5.text=[NSString stringWithIdOnNO:info.requestor];
                        weakSelf.str_ApproverId5=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];

                        break;
                    default:
                        break;
                }
            }
        }];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    
    if (btn.tag>=100&&btn.tag<500) {
        _nowClick = btn.tag-100;
        [self requestCredentials];
    }
    if (btn.tag>=500&&btn.tag<1000) {
        _nowClick = btn.tag-500;
        SelectViewController *select = [[SelectViewController alloc]init];
        userGroup *user = _arr_usergroup[_nowClick];
        select.selectId = [NSString stringWithFormat:@"%@",user.ids];
        select.type = 1;
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
    if (btn.tag == 10001) {
        UITextField *txf ;
        int i = 1;
        if (btn == _btn_customs1) {
            txf = _txf_customs1;
            i=1;
        }else if (btn == _btn_customs2) {
            txf = _txf_customs2;
            i=2;
        }else if (btn == _btn_customs3) {
            txf = _txf_customs3;
            i=3;
        }else if (btn == _btn_customs4) {
            txf = _txf_customs4;
            i=4;
        }else if (btn == _btn_customs5) {
            txf = _txf_customs5;
            i=5;
        }else if (btn == _btn_customs6) {
            txf = _txf_customs6;
            i=6;
        }else if (btn == _btn_customs7) {
            txf = _txf_customs7;
            i=7;
        }else if (btn == _btn_customs8) {
            txf = _txf_customs8;
            i=8;
        }else if (btn == _btn_customs9) {
            txf = _txf_customs9;
            i=9;
        }else if (btn == _btn_customs10) {
            txf = _txf_customs10;
            i=10;
        }
        MyProcurementModel *model = [MyProcurementModel new];
        [model setValuesForKeysWithDictionary:_arr_customs[i-1]];
        //列表选择
        MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
        vc.model = model;
        vc.aimTextField=txf;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 10002) {
        //时间选择
        int i = 0;
        UITextField *txf ;
        if (btn == _btn_customs1) {
            txf = _txf_customs1;
            i=1;
        }else if (btn == _btn_customs2) {
            txf = _txf_customs2;
            i=2;
        }else if(btn == _btn_customs3) {
            txf = _txf_customs3;
            i=3;
        }else if(btn == _btn_customs4) {
            txf = _txf_customs4;
            i=4;
        }else if(btn == _btn_customs5) {
            txf = _txf_customs5;
            i=5;
        }else if(btn == _btn_customs6) {
            txf = _txf_customs6;
            i=6;
        }else if(btn == _btn_customs7) {
            txf = _txf_customs7;
            i=7;
        }else if(btn == _btn_customs8) {
            txf = _txf_customs8;
            i=8;
        }else if(btn == _btn_customs9) {
            txf = _txf_customs9;
            i=9;
        }else if(btn == _btn_customs10) {
            txf = _txf_customs10;
            i=10;
        }
    
        if (![NSString isEqualToNull:txf.text]) {
            txf.text = [NSString stringWithDate:[NSDate date]];
        }
        txf.text = [txf.text substringToIndex:10];
        _dap_Date = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd"];
        NSDate *fromdate=[format dateFromString:txf.text];
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
        NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
        _dap_Date.date=fromDate;
        _dap_Date.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        _dap_Date.datePickerMode = UIDatePickerModeDate;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"时间",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = i;
        [view addSubview:sureDataBtn];
        __weak typeof(self) weakSelf = self;
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        [cancelDataBtn bk_whenTapped:^{
            [weakSelf.cho_Date remove];
            weakSelf.dap_Date = nil;
            weakSelf.cho_Date = nil;
        }];
        if (!_cho_Date) {
            _cho_Date=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_Date.frame.size.height+40) pickerView:_dap_Date titleView:view];
            _cho_Date.delegate = self;
        }
        
        [_cho_Date showUpView:_dap_Date];
        [_dap_Date addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
        [_cho_Date show];
    }
}

-(void)btn_IsLDSpvclick:(UIButton *)btn{
    _Muarr_IsLDSpv = [NSMutableArray arrayWithArray:@[Custing(@"否", nil),Custing(@"是", nil)]];
    
    if (_pic_IsLDSpv == nil) {
        _pic_IsLDSpv = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 220)];
        _pic_IsLDSpv.dataSource = self;
        _pic_IsLDSpv.delegate = self;
    }
    if (_cho_Date == nil) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"是否领导", nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_IsLDSpvclick_sure:) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = btn.tag;
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        if (!_cho_Date) {
            _cho_Date=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _pic_IsLDSpv.frame.size.height+40) pickerView:_pic_IsLDSpv titleView:view];
            _cho_Date.delegate = self;
        }
        _str_IsLDSpv = Custing(@"否", nil);
        [_cho_Date showUpView:_pic_IsLDSpv];
        [_cho_Date show];
    }
    [_cho_Date show];
}

-(void)btn_IsLDSpvclick_sure:(UIButton *)btn{
    userGroup *group = _arr_usergroup[btn.tag];
    if ([_str_IsLDSpv isEqualToString:Custing(@"是", nil)]) {
        group.isldSpv = @"1";
    }else{
        group.isldSpv = @"0";
    }
    _arr_usergroup[btn.tag] = group;
    [self.tbv_two reloadData];
    _pic_IsLDSpv = nil;
    [_cho_Date remove];
    _cho_Date = nil;
    _str_IsLDSpv = @"";
}

-(void)btn_Cancel_Click{
    _pic_IsLDSpv = nil;
    [_cho_Date remove];
    _cho_Date = nil;
}

//时间选择确定按钮
-(void)sureData:(UIButton *)btn{
    NSDate * pickerDate = [_dap_Date date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    
    if (btn.tag == 1) {
        _txf_customs1.text = str;
    }else if (btn.tag == 2) {
        _txf_customs2.text = str;
    }else if (btn.tag == 3) {
        _txf_customs3.text = str;
    }else if (btn.tag == 4) {
        _txf_customs4.text = str;
    }else if (btn.tag == 5) {
        _txf_customs5.text = str;
    }else if (btn.tag == 6) {
        _txf_customs6.text = str;
    }else if (btn.tag == 7) {
        _txf_customs7.text = str;
    }else if (btn.tag == 8) {
        _txf_customs8.text = str;
    }else if (btn.tag == 9) {
        _txf_customs9.text = str;
    }else if (btn.tag == 10) {
        _txf_customs10.text = str;
    }
    [self.cho_Date remove];
}

//添加职位
-(void)AddDetailsClick:(UIButton *)btn
{
    userGroup *group = [[userGroup alloc]init];
    [_arr_usergroup addObject:group];
    [self.tbv_two reloadData];
    [self updateContentView];
}

//报表权限开关
-(void)switchOn:(UISwitch *)swi
{
    _str_ViewRptPer = swi.on?@"1":@"0";
//    NSLog(_str_ViewRptPer);
//    [NSLog([NSString stringWithFormat:@"%b",swi])];
}

//点击键盘收回
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    [self keyClose];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            _btn_OK.userInteractionEnabled = YES;
            if (_isNowPeople!=1&&_isNowPeople!=2) {
                _btn_close.userInteractionEnabled = YES;
            }
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (![success isEqualToString:@"1"]) {
        _btn_OK.userInteractionEnabled = YES;
        if (_isNowPeople!=1&&_isNowPeople!=2) {
            _btn_close.userInteractionEnabled = YES;
        }
        if (serialNum == 1) {
            NSString * result = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];
            if ([result isEqualToString:@"-1"]) {
                //用户数用完
                if (self.userdatas.checkExpiryDic != nil) {
                    NSString * isAdmin = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"isAdmin"]];
                    if ([isAdmin isEqualToString:@"1"]) {
                        [self createXueFeiLogin];
                        [YXSpritesLoadingView dismiss];
                        return;
                    }
                }
            }
        }
        return;
    }
    _request = responceDic ;
    if (serialNum == 0 ) {
        [self getPeopleInfoData];
    }
    if (serialNum == 1) {
        if (_isNowPeople==1) {
            NSString *url=[NSString stringWithFormat:@"%@",updateuserisa];
            NSDictionary *parameters = @{@"UserId":_model.userId,@"UserDspName":_model.userDspName};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
        }else if(_isNowPeople==2){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
            [self performBlock:^{
                [self Navback];
            } afterDelay:1.0f];
        }else{
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:1.0];
            [self performBlock:^{
                [self Navback];
            } afterDelay:1.0f];
        }
        
    }
    if (serialNum == 2) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"禁用成功", nil) duration:1.0];
        [self performBlock:^{
            [self Navback];
        } afterDelay:1.0f];
    }
    if (serialNum == 3) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
        [self performBlock:^{
            [self Navback];
        } afterDelay:1.0f];
    }
    if (serialNum == 4) {
        [YXSpritesLoadingView dismiss];
        
        NSDictionary * result = [responceDic objectForKey:@"result"];
        self.userdatas.groupid = [result objectForKey:@"groupId"];
        self.userdatas.PeoplePage = self.navigationController.viewControllers.count;
        [self.userdatas storeUserInfo];
        ComPeopleViewController *cp = [[ComPeopleViewController alloc]init];
        cp.nowGroupname = self.userdatas.company;
        cp.nowGroup = [NSString isEqualToNull:self.userdatas.groupid]?self.userdatas.groupid:self.userdatas.companyId;
        cp.delegate = self;
        [self.navigationController pushViewController:cp animated:YES];
    }
    if (serialNum == 5) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"确认成功", nil) duration:1.0];
        self.userdatas.PeoplePage = 0;
        [self performBlock:^{
            [self Navback];
        }afterDelay:1.0f];
    }
    
    if (serialNum == 6) {
        [YXSpritesLoadingView dismiss];
        
        NSString * result = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];
        if ([NSString isEqualToNull:result]) {
            
            [self CreateRestPasswordView:result];
        }
        
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==88) {
        return 2;
    }
    return _arr_usergroup.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==88) {
        return 44;
    }
    return 172;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 88) {
        SexEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SexEditTableViewCell" owner:nil options:nil];
            cell = [nib lastObject];
        }
        if (indexPath.row == 0) {
            cell.lbl_label.text = Custing(@"男", nil);
            if ([_txf_sex.text isEqualToString:Custing(@"男", nil) ]) {
                cell.img_image.highlighted = YES;
            }
        }
        if (indexPath.row == 1) {
            cell.lbl_label.text = Custing(@"女", nil);
            if ([_txf_sex.text isEqualToString:Custing(@"女", nil) ]) {
                cell.img_image.highlighted = YES;
            }
        }
        
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 162)];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UIImageView *image_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 20)];
    image_line.backgroundColor = Color_White_Same_20;
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    UIButton *btn_delete = [GPUtils createButton:CGRectMake(Main_Screen_Width-((lan)?50:70), 0, ((lan)?30:50), 20) action:@selector(btn_click:) delegate:self title:Custing(@"删除", nil) font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
    btn_delete.tag = 1000+indexPath.row;
    UILabel *lab_depa = [GPUtils createLable:CGRectMake(20, 33, ((lan)?80:90), 18) text:Custing(@"部门", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    UITextField *_txf_depa = [GPUtils createTextField:CGRectMake(108, 33, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择部门", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_depa.userInteractionEnabled = NO;
    _txf_depa.textAlignment = NSTextAlignmentRight;
//    [_txf_depa setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_depa = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, Main_Screen_Width, 44)];
    btn_depa.tag = 100+indexPath.row;
    [btn_depa addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_depa = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 35, 10, 14) imageName:@"People_arrow"];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 10)];
    image.backgroundColor = Color_White_Same_20;
    
    UILabel *lab_cost = [GPUtils createLable:CGRectMake(20, 87, 80, 18) text:Custing(@"职位", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    UITextField *txf_cost = [GPUtils createTextField:CGRectMake(108, 87, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择职位", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    txf_cost.userInteractionEnabled = NO;
    txf_cost.textAlignment = NSTextAlignmentRight;
//    [txf_cost setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_cost = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 44)];
    btn_cost.tag = 500+indexPath.row;
    [btn_cost addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_cost = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 89, 10, 14) imageName:@"People_arrow"];
    
    [cell addSubview:image_line];
    if (_arr_usergroup.count!=1) {
        [cell addSubview:btn_delete];
    }
    [cell addSubview:lab_depa];
    [cell addSubview:_txf_depa];
    [cell addSubview:btn_depa];
    [cell addSubview:img_depa];
    [cell addSubview:image];
    [cell addSubview:txf_cost];
    [cell addSubview:btn_cost];
    [cell addSubview:img_cost];
    [cell addSubview:lab_cost];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *image_IsLDSpv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 118, Main_Screen_Width, 10)];
    image_IsLDSpv.backgroundColor = Color_White_Same_20;
    UILabel *lab_IsLDSpv = [GPUtils createLable:CGRectMake(20, 141, 80, 18) text:Custing(@"是否领导", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft ];
    UITextField *txf_IsLDSpv = [GPUtils createTextField:CGRectMake(108, 141, Main_Screen_Width-148, 18) placeholder:Custing(@"请选择是否领导", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    txf_IsLDSpv.userInteractionEnabled = NO;
    txf_IsLDSpv.textAlignment = NSTextAlignmentRight;
//    [txf_IsLDSpv setValue:Color_form_TextField_20 forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *btn_IsLDSpv = [[UIButton alloc]initWithFrame:CGRectMake(0, 118, Main_Screen_Width, 44)];
    btn_IsLDSpv.tag = indexPath.row;
    [btn_IsLDSpv addTarget:self action:@selector(btn_IsLDSpvclick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_IsLDSpv = [GPUtils createImageViewFrame:CGRectMake(108+(Main_Screen_Width-138), 143, 10, 14) imageName:@"People_arrow"];
    [cell addSubview:image_IsLDSpv];
    [cell addSubview:lab_IsLDSpv];
    [cell addSubview:txf_IsLDSpv];
    [cell addSubview:btn_IsLDSpv];
    [cell addSubview:img_IsLDSpv];
    
    userGroup *user = _arr_usergroup[indexPath.row];
    
    if ([NSString isEqualToNull:user.groupName]) {
        _txf_depa.text = user.groupName;
    }
    if ([NSString isEqualToNull:user.jobTitle]) {
        txf_cost.text = user.jobTitle;
    }
    if ([user.isPrimTerm integerValue] == 1) {
        _txf_SelectLevel.text = user.jobTitle;
    }
    if ([NSString isEqualToNull:user.isldSpv]) {
        if ([user.isldSpv integerValue]==0) {
            txf_IsLDSpv.text = Custing(@"否", nil);
        }else if ([user.isldSpv integerValue]==1){
            txf_IsLDSpv.text = Custing(@"是", nil);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _nowClick = indexPath.row;
    [self.alert dismiss];
    if (tableView.tag == 88) {
        _txf_sex.text = indexPath.row==1?Custing(@"女", nil):Custing(@"男",nil);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    
    if (textField ==_txf_phone ) {
        if (textField.text.length > 10) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号码不能超过11位", nil) duration:1.5];
            return NO;
        }
        if (![string isEqualToString:@"0"]&&![string isEqualToString:@"1"]&&![string isEqualToString:@"2"]&&![string isEqualToString:@"3"]&&![string isEqualToString:@"4"]&&![string isEqualToString:@"5"]&&![string isEqualToString:@"6"]&&![string isEqualToString:@"7"]&&![string isEqualToString:@"8"]&&![string isEqualToString:@"9"]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark picker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _pic_Language) {
        return _Muarr_Language.count;
    }else if (pickerView == _pic_IsLDSpv) {
        return _Muarr_IsLDSpv.count;
    }else if (pickerView==_pic_SelectLevel){
        return _Muarr_SelectLevel.count;
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _pic_Language) {
        return _Muarr_Language[row];
    }else if (pickerView == _pic_IsLDSpv) {
        return _Muarr_IsLDSpv[row];
    }else if (pickerView==_pic_SelectLevel){
        NSDictionary *dic = _Muarr_SelectLevel[row];
        return dic[@"jobtitle"];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _pic_Language) {
        _str_Language = _Muarr_Language[row];
    }else if (pickerView == _pic_IsLDSpv) {
        _str_IsLDSpv = _Muarr_IsLDSpv[row];
    }else if (pickerView==_pic_SelectLevel){
        NSDictionary *dic = _Muarr_SelectLevel[row];
        _str_SelectLevel = dic[@"jobtitle"];
        _str_SelectLevelCode = dic[@"jobtitlecode"];
    }
}


//部门回调
- (void)editGroup:(NSNotification *)note
{
    NSLog(@"23333%@",note.userInfo);
    userGroup *group = _arr_usergroup[_nowClick];
    group.groupName = note.userInfo[@"name"];
    group.groupId = note.userInfo[@"id"];
    _arr_usergroup[_nowClick] = group;
    [self.tbv_two reloadData];
}

-(void)SelectViewControllerClickedLoadBtn:(SelectDataModel *)selectmodel
{
    //职位
    if ([NSString isEqualToNull:selectmodel.groupName]&&[NSString isEqualToNull:selectmodel.groupId]) {
        _txf_filiale.text = selectmodel.groupName;
        _str_filialeid = selectmodel.groupId;
    }else if ([NSString isEqualToNull:selectmodel.jobTitle]){
        userGroup *user = _arr_usergroup[_nowClick];
        if ([_txf_SelectLevel.text isEqualToString:user.jobTitle]) {
            _txf_SelectLevel.text = @"";
        }
        user.jobTitle = selectmodel.jobTitle;
        user.jobTitleCode = selectmodel.jobTitleCode;
        user.ids = selectmodel.ids;
        _arr_usergroup[_nowClick] = user;
        [self.tbv_two reloadData];
    }else if ([NSString isEqualToNull:selectmodel.userLevel]) {
        _txf_level.text = selectmodel.userLevel;
        _str_levelid = selectmodel.ids;
    }else if ([NSString isEqualToNull:selectmodel.costCenter]) {
        _txf_cost.text = selectmodel.costCenter;
        _str_costid = selectmodel.ids;
    }else if ([NSString isEqualToNull:selectmodel.name]){
        _txf_BusDepartment.text = selectmodel.name;
        _str_BusDepartmentid = selectmodel.ids;
    }
}

//部门选择代理
-(void)ComPeopleViewController_BtnClick:(NSDictionary *)dic
{
    NSLog(@"122121");
    userGroup *group = _arr_usergroup[_nowClick];
    group.groupName = dic[@"name"];
    group.groupId = dic[@"id"];
    _arr_usergroup[_nowClick] = group;
    [self.tbv_two reloadData];
}

//续费登录
-(void)createXueFeiLogin {
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-135, 0,270, 345)];
    View.backgroundColor = Color_form_TextFieldBackgroundColor;
    View.layer.cornerRadius = 15.0f;
    View.userInteractionEnabled = YES;
    
    UIImageView * alertView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,270, 372/2)];
    alertView.image = GPImage(@"ArrearsNotification");
    alertView.backgroundColor = [UIColor clearColor];
    [View addSubview:alertView];
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 372/2+5, 270, 50) text:Custing(@"您的公司购买的用户数已经用完", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(0, 372/2+45, 270, 50) text:Custing(@"请前往网页端购买用户数", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [View addSubview:twoLa];
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(67.5, 285, 135, 35) action:@selector(wozhdiaole:) delegate:self title:Custing(@"我知道了", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    chooseBtn.backgroundColor = Color_Blue_Important_20;
    chooseBtn.layer.cornerRadius = 10.0f;
    [View addSubview:chooseBtn];
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    
}

//重置密码
-(void)toResetYourPassword:(UIButton *)btn {
    
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"是否要重置密码？", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
    [alert show];
    
    
}

//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:Custing(@"确定", nil)]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"User/ResetPassword"] Parameters:@{@"UserId":[NSString stringWithFormat:@"%@",_model.userId]} Delegate:self SerialNum:6 IfUserCache:NO];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }else if ([btnTitle isEqualToString:Custing(@"取消", nil)] ) {
//        [self CreateRestPasswordView:@"222222"  ];
    }
    
    
}

-(void)CreateRestPasswordView:(NSString *)string {

    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-135, 30,270, 115)];
    View.backgroundColor = Color_form_TextFieldBackgroundColor;
    View.layer.cornerRadius = 13.0f;
    View.userInteractionEnabled = YES;
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(0, 70, 270, 50) action:@selector(wozhdiaole:) delegate:self title:Custing(@"确定", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    chooseBtn.backgroundColor = Color_Blue_Important_20;
    chooseBtn.layer.cornerRadius = 13.0f;
    chooseBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [View addSubview:chooseBtn];
    
    UIView * View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20,270, 65)];
    View1.backgroundColor = Color_form_TextFieldBackgroundColor;
    [View addSubview:View1];
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 10, 270, 30) text:Custing(@"系统随机生成临时密码", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(35, 40, 200, 30) text:string font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    twoLa.backgroundColor = Color_ClearBlue_Same_20;
    [View addSubview:twoLa];
    
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
}

//日期选择底层视图代理
-(void)dimsissPDActionView{
    _cho_Date = nil;
}


//键盘取消
- (void)dimsissStatisticalPDActionView{
    self.dateView = nil;
}
//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (_dateView) {
        [_dateView removeStatistical];
    }
}

//数值变化的时候代理
-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
}

- (void)wozhdiaole:(UIButton *)btn {
    [self.dateView removeStatistical];
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
