//
//  contactsVController.m
//  galaxy
//
//  Created by 赵碚 on 15/7/30.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "contactsVController.h"
#import "TViewCell.h"
#import "buildCellInfo.h"

#import "UIView+MLInputDodger.h"



@interface contactsVController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ByvalDelegate,GPClientDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UISearchBar * searchbar;

@property (nonatomic, strong)NSDictionary *resultDict;
@property (nonatomic, strong)NSDictionary *resultOftenDict;


@property (nonatomic, strong)NSMutableArray * oftenItemArray;//常用
@property (nonatomic, strong)NSMutableArray * userItemArray;//正常联系人
@property (nonatomic, strong)NSMutableArray * arrshowinfo;//要显示的内容
@property (nonatomic, strong)NSMutableArray * arrClick;//点击存储内容
@property (nonatomic, strong)NSMutableArray * showarray;//显示选中项目

@end

@implementation contactsVController

#pragma mark ---加载

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showarray = [[NSMutableArray alloc]init];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    _oftenItemArray = [NSMutableArray array];
    _userItemArray = [NSMutableArray array];
    _arrClick = [NSMutableArray array];
    if (![NSString isEqualToNull:_Radio]) {
        _Radio = @"1";
    }
    if (![NSString isEqualToNull:_isclean])
    {
        _isclean = @"2";
    }
    if([_Radio isEqualToString:@"2"])
    {
        [self createSaveBarItem:@selector(addMineContent)];
    }
        
    if (self.userdatas.local05&&self.userdatas.cache05) {
        if (self.userdatas.local05!=self.userdatas.cache05)
        {
            [self userrequest];
        }
        else
        {
            _resultDict = self.userdatas.localFile05;
            if (!_resultDict) {
                [self userrequest];
            }
            else
            {
                [self requestUserOver];
            }
        }
    }
    else
    {
        [self userrequest];
    }
    
    //添加搜索框
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    self.searchbar.placeholder = Custing(@"搜索姓名/部门/工号", nil);
    self.searchbar.delegate = self;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchbar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, Main_Screen_Width, Main_Screen_Height - NavigationbarHeight-44)];
    self.tableView.allowsMultipleSelection = YES;//设置可以多选高亮
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
}

//用户列表数据获取
-(void)userrequest
{
    [self requestCompanyData_User];
}

//常用联系人数据获取
-(void)reviewalloc
{
    if ([_status isEqualToString:@"2"]) {
        [self setTitle:Custing(@"选择申请人", nil) backButton:YES ];
        if (_isAll!=1) {
            [self requestCompanyData:[NSString stringWithFormat:@"1"]];
        }else{
            [self oftenrequest];
        }
    }else if ([_status isEqualToString:@"3"]){
        [self setTitle:Custing(@"选择出差人员",nil) backButton:YES ];
        if (_isAll!=1) {
            [self requestCompanyData:[NSString stringWithFormat:@"2"]];
        }else{
            [self oftenrequest];
        }
    }else if ([_status isEqualToString:@"4"]){
        [self setTitle:Custing(@"选择代理人", nil) backButton:YES ];
        if (_isAll!=1) {
            [self requestCompanyData:[NSString stringWithFormat:@"4"]];
        }else{
            [self oftenrequest];
        }
    }else if ([_status isEqualToString:@"6"]) {
        [self setTitle:Custing(@"选择负责人", nil) backButton:YES ];
        if (_isAll!=1) {
            [self requestCompanyData:[NSString stringWithFormat:@"1"]];
        }else{
            [self oftenrequest];
        }
    }
    else{
        if ([_status isEqualToString:@"5"]){
            [self setTitle:Custing(@"添加成员", nil) backButton:YES  ];
        }else if([_status isEqualToString:@"7"]){
            [self setTitle:Custing(@"选择联系人",nil) backButton:YES ];
        }else if([_status isEqualToString:@"8"]){
            [self setTitle:Custing(@"选择参会人员",nil) backButton:YES ];
        }else if([_status isEqualToString:@"9"]){
            [self setTitle:Custing(@"知会",nil) backButton:YES ];
        }else if([_status isEqualToString:@"10"]){
            [self setTitle:Custing(@"选择申请人",nil) backButton:YES ];
        }else if([_status isEqualToString:@"11"]){
            [self setTitle:Custing(@"选择受益人",nil) backButton:YES ];
        }else if([_status isEqualToString:@"12"]){
            [self setTitle:Custing(@"选择抄送人",nil) backButton:YES ];
        }else if([_status isEqualToString:@"13"]){
            [self setTitle:Custing(@"选择参训人员",nil) backButton:YES ];
        }else if([_status isEqualToString:@"14"]){
            [self setTitle:Custing(@"选择证明人",nil) backButton:YES ];
        }else if([_status isEqualToString:@"15"]){
            [self setTitle:Custing(@"选择业务经理",nil) backButton:YES ];
        }else if([_status isEqualToString:@"16"]){
            [self setTitle:Custing(@"选择业务负责人",nil) backButton:YES ];
        }else{
            [self setTitle:Custing(@"选择审批人",nil) backButton:YES ];
        }
        if (_isAll!=1) {
            [self requestCompanyData:[NSString stringWithFormat:@"3"]];
        }else{
            [self oftenrequest];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    //////之所以在viewDidAppear中来设置某个cell被初始选中，目的是要在uitableview加载出来以后再做
    [super viewDidAppear:animated];
    
    //////这里假设你初始要选中的是第一行
    if (_showarray) {
        if (_showarray.count>0) {
            for (int i = 0; i < _showarray.count; i++) {
                NSDictionary *dic = _showarray[i];
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:[[dic objectForKey:@"row"]integerValue ] inSection:[[dic objectForKey:@"section"]integerValue ]];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}


- (void)back:(UIButton *)btn
{
    [self Navback];
}

- (void) createSaveBarItem:(SEL)saveAction
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:saveAction];
}
//返回事件
- (void)addMineContent
{
//    NSLog(@"%d",arrClick.count);
//    [self.delegate contactsVCClickedLoadBtn:_arrClick type:_status];
    
    if ([self.status isEqualToString:@"10"]) {
        buildCellInfo *bul = _arrClick.lastObject;
        NSString *url=[NSString stringWithFormat:@"%@",GETREQUESTORUSERINFO];;
//        if ([self.flowCode isEqualToString:@"F0022"]) {
//            url=[NSString stringWithFormat:@"%@",GETPERFORMANCEREQ];
//        }else if ([self.flowCode isEqualToString:@"F0023"]){
//            url=[NSString stringWithFormat:@"%@",ENTERTAINMENTUserInfo];
//        }else if ([self.flowCode isEqualToString:@"F0024"]){
//            url=[NSString stringWithFormat:@"%@",VEHICLEREPAIRUserInfo];
//        }
        NSDictionary *Parameters=@{@"userId":[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId],@"flowCode":self.flowCode};
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:4 IfUserCache:NO];
    }else{
        if (self.Block) {
            self.Block(_arrClick);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ---私有方法
-(void)requestCompanyData:(NSString * )type{
    //type :1://常用申请人 2://常用同行人员 3://常用一级审批人 4://常用二级审批人
    //参数化查询 '(@OperatorUserId int,@CompanyId nvarchar(4000))select top 5 b.* ' 需要参数 '@CompanyId'，但未提供该参数。
    
    //menutype :1://常用申请人 2://常用同行人员 3://常用一级审批人 4://常用二级审批人
    //itemType 1.出差、2.差旅、3.请假、4.采购、5.预支、6.物品领用、7.通用审批表单 8日常报销
    // status 1 选择审批人  2选择申请人  3出差人员选择   4代理人选择   5添加成员
    if (_itemType!=99) {
        if (!_menutype) {
            _menutype = 1;
        }
        if (!_status) {
            _status = @"1";
        }
        if (!_itemType) {
            _itemType = 1;
        }
        NSDictionary *parameters;
        
        if (_itemType == 1) {
            if ([_status isEqualToString:@"3"]) {
                parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
                [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",travelappallusers_v1] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
            }
            else
            {
                parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
                [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",travelappallusers_v1] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
            }
        }
        else if (_itemType == 2) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",travelexpallusers_v1] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 3) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",dailyexpallusers_v1] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 4) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",leaveallusers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 5) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",Purchaseallusers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 6) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",AdvanceAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 7) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",ItemAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 8) {
            parameters = @{@"OperatorUserId":@"0",@"CompanyId":@"",@"userId": self.userdatas.userId,@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",CommontAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 9) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",PaymentAppAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 11) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",RepaymentAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 12) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",FeeAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 13) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",ContractAppAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 14) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",VehicleAppAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 15) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SealAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 16) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",StaffOutAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 17) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",OvertimeAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 18) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",MeetingAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 19) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",InvoiceAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 20) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",CancellationAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 21) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",WorkCardAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 22) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",PerformanceAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 23) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",ENTERTAINMENTAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 24) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",VEHICLEREPAIRAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 25) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",RECEIPTAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 26) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SUPPLIERAPPLYAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 27) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SPECIALREQUESTAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 28) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",EMPLOYEETRAINAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 29) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",WAREHOUSEENTRYAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 30) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",InvoiceRegAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 31) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SettlementAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 32) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",RemittanceAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }else if (_itemType == 33) {
            parameters = @{@"type":[NSString stringWithFormat:@"%d",_menutype]};
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",MAKEINVOICEAllUsers] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
        }
    }
    else
    {
        [self oftenrequest];
    }
    
}

-(void)requestCompanyData_User{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getusers] Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
//    临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 0:
            if (![_status isEqualToString:@"PowerMembers"]){
                _resultOftenDict = responceDic;
            }
            
            [self oftenrequest];
            break;
        case 3:
            if (!self.userdatas.cache05) {
                self.userdatas.cache05 = [NSString GetstringFromDate];
            }
            self.userdatas.local05 = self.userdatas.cache05;
            self.userdatas.localFile05 = responceDic;
            
            [userData savelocalFile:responceDic type:5];
            
            _resultDict = responceDic;
            
            [self requestUserOver];
            break;
        case 4:
        {
            if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
                if (self.PerfSelectBlock) {
                    self.PerfSelectBlock(responceDic[@"result"]);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
    [self viewDidAppear:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return [textField resignFirstResponder];
}


-(void)requestUserOver
{
    [_oftenItemArray removeAllObjects];
    [_userItemArray removeAllObjects];
    NSMutableArray * lastarr = [[NSMutableArray alloc]init];
    if (![_status isEqualToString:@"PowerMembers"]) {
        [buildCellInfo GetcompanyBookDictionary:_resultDict Array:lastarr Array:_userItemArray cleanSelf:self.isCleanSelf];
        if (self.arrClickPeople.count>0) {
            for (int a=0; a<self.arrClickPeople.count; a++) {
                for (int i =0; i<_userItemArray.count; i++) {
                    buildCellInfo *info = _userItemArray[i];
                    buildCellInfo *info1 = self.arrClickPeople[a];
                    if ([[info1 class] isEqual:[buildCellInfo class]]) {
                        if (info1 != nil) {
                            if (info1.requestorUserId == info.requestorUserId) {
                                info.isClick = @"1";
                                if ([_isclean isEqualToString:@"1"]) {
                                    [_userItemArray removeObjectAtIndex:i];
                                }
                                else
                                {
                                    [_arrClick addObject:info];
                                    _userItemArray[i] = info;
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        if ([self.arrClickPeople[a][@"requestorUserId"] intValue]==info.requestorUserId) {
                            info.isClick = @"1";
                            if ([_isclean isEqualToString:@"1"]) {
                                [_userItemArray removeObjectAtIndex:i];
                            }
                            else
                            {
                                [_arrClick addObject:info];
                                _userItemArray[i] = info;
                            }
                        }
                    }
                }
            }
        }
        [self reviewalloc];
    }else if ([_status isEqualToString:@"PowerMembers"]){
        [buildCellInfo GetcompanyBookDictionary:_resultDict Array:lastarr Array:_userItemArray cleanSelf:self.isCleanSelf];
        [lastarr removeAllObjects];
        if (self.arrClickPeople.count>0) {
            for (int i=0; i<_arrClickPeople.count; i++) {
                for (int j=0; j<_userItemArray.count; j++) {
                    buildCellInfo *info=_userItemArray[j];
                    if ([_arrClickPeople[i][@"requestorUserId"]integerValue]==info.requestorUserId) {
                        [_userItemArray removeObjectAtIndex:j];
                    }
                }
            }
        }
        if (_isAll!=1) {
            [self reviewalloc];
        }else{
            [self oftenrequest];
        }
    }
}

-(void)oftenrequest
{
    [YXSpritesLoadingView dismiss];
    [_oftenItemArray removeAllObjects];
    NSMutableArray *lostarr = [[NSMutableArray alloc]init];
    [buildCellInfo GetcompanyBookDictionary:_resultOftenDict Array:_oftenItemArray Array:lostarr cleanSelf:self.isCleanSelf];
    
    if (self.arrClickPeople.count>0) {
        for (int a=0; a<self.arrClickPeople.count; a++) {
            for (int i =0; i<_oftenItemArray.count; i++) {
                buildCellInfo *info = _oftenItemArray[i];
                if ([self.arrClickPeople[a][@"requestorUserId"] integerValue] == info.requestorUserId) {
                    if ([_isclean isEqualToString:@"1"]) {
                        [_oftenItemArray removeObjectAtIndex:i];
                    }
                    else
                    {
                        info.isClick = @"1";
                        _oftenItemArray[i] = info;
                    }
                    
                }
            }
        }
    }
    [self ProvinceByCity:_oftenItemArray array:_userItemArray];
    if (_isAll == 1) {
        if (_arrshowinfo) {
            
            NSString *Stre = [NSString stringWithFormat:@"{\"contact\":\"0\",\"costCenter\":null,\"requestorAccount\":\"0\",\"photoGraph\":null,\"jobTitleCode\":null,\"requestor\":\"%@\",\"requestorDept\":\"\",\"isActivated\":0,\"email\":null,\"requestorDeptId\":0,\"jobTitle\":null,\"requestorUserId\":0,\"gender\":0,\"requestorHRID\":null,\"companyId\":0,\"userDspName\":null}",Custing(@"全部", nil)];
            NSDictionary *dic = [NSString dictionaryWithJsonString:Stre];
            
            buildCellInfo *info = [buildCellInfo retrunByDic:dic];
            
            NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
            [mds setObject:@"" forKey:@"title"];
            [mds setObject:@[info] forKey:@"array"];
            [_arrshowinfo insertObject:mds atIndex:0];
        }
    }
    [self.tableView reloadData];
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//原始数据转换为显示数据
-(void) ProvinceByCity:(NSMutableArray *)array1 array:(NSMutableArray *)array2
{
//    array = [NSMutableArray arrayWithArray:array1];
    [array2 sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        buildCellInfo *dic1 = obj1;
        buildCellInfo *dic2 = obj2;
        NSString *str1=dic1.guihua;
        NSString *str2=dic2.guihua;
        return [str1 compare:str2];
    }];
    
    NSMutableArray *Temporary = [[NSMutableArray alloc]init];
    
    NSMutableArray *ma = [[NSMutableArray alloc]init];
    NSMutableDictionary *md = [[NSMutableDictionary alloc]init];
    NSString *oneguihua = @"";
    //常规用户
    for (int i = 0; i<array2.count; i++) {
        buildCellInfo *travel = array2[i];
        if ([oneguihua isEqualToString:travel.guihua]) {
            [ma addObject:travel];
        }
        else
        {
            if (i>0) {
                [md setObject:ma forKey:@"array"];
                [Temporary addObject:md];
            }
            oneguihua = travel.guihua;
            ma =[[NSMutableArray alloc]init];
            md =[[NSMutableDictionary alloc]init];
            [ma addObject:travel];
            [md setObject:travel.guihua forKey:@"title"];
        }
        if (i==array2.count-1) {
            [md setObject:ma forKey:@"array"];
            [Temporary addObject:md];
        }
    }
    
    [Temporary sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)[obj1 objectForKey:@"title"];
        NSString *str2=(NSString *)[obj2 objectForKey:@"title"];
        return [str1 compare:str2];
    }];
    
    if (array1.count>0) {
        //常用联系人
        NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
        [mds setObject:@"☆" forKey:@"title"];
        [mds setObject:array1 forKey:@"array"];
        [Temporary insertObject:mds atIndex:0];
    }
    _arrshowinfo = Temporary;
}

//搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (![searchText isEqualToString:@""]) {
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        
        for (buildCellInfo *dic in _userItemArray) {
            if (([dic.requestor rangeOfString:searchText].location != NSNotFound)||([dic.requestorDept rangeOfString:searchText].location != NSNotFound)||([dic.requestorHRID rangeOfString:searchText].location != NSNotFound))
            {
                [toRemove addObject:dic];
            }
        }
        
        [self ProvinceByCity:[[NSMutableArray alloc]init] array:toRemove];
        [self.tableView reloadData];
    }
    else if ([searchText isEqualToString:@""])
    {
        [self ProvinceByCity:_oftenItemArray array:_userItemArray];
        [self.tableView reloadData];
    }
}


#pragma mark   ---tableview加载
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"%lu",(unsigned long)arrshowinfo.count);
    return _arrshowinfo.count;
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _arrshowinfo[section][@"array"];
//    NSLog(@"%lu~~~~%ld",(unsigned long)arr.count,(long)section);
    return arr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

//组头加载
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25)];
    view.backgroundColor = Color_White_Same_20;
    UILabel *titleLabel= [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-15, 25) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *travel = _arrshowinfo[section];
    
    NSString *title = @"";
    if ([_status isEqualToString:@"2"]) {
        title = Custing(@"常用申请人_", nil);
    }else if ([_status isEqualToString:@"3"]){
        title = Custing(@"常用同行人员_",nil);
    }else if ([_status isEqualToString:@"4"]){
        title = Custing(@"常用代理人", nil);
    }else if ([_status isEqualToString:@"6"]) {
        title = Custing(@"常用负责人", nil);
    }else if ([_status isEqualToString:@"12"]) {
        title = Custing(@"常用抄送人", nil);
    }else{
        if ([_status isEqualToString:@"5"]){
            title = Custing(@"常用成员", nil);
        }else if([_status isEqualToString:@"7"]){
            title = Custing(@"常用联系人_",nil);
        }else{
            title = Custing(@"常用审批人_",nil);
        }
    }
    
    
    titleLabel.text = [travel[@"title"]isEqualToString:@"☆"]?title:travel[@"title"];
    titleLabel.text = [titleLabel.text isEqualToString:@""]?Custing(@"全部", nil):titleLabel.text;
    [view addSubview:titleLabel];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    
    
    return view;
}

/**
 *  返回右边索引条显示的字符串数据
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [_arrshowinfo valueForKeyPath:@"title"];
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TViewCell"];
    if (cell==nil) {
        cell=[[TViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TViewCell"];
    }
    NSArray *arr = _arrshowinfo[indexPath.section][@"array"];
    
    buildCellInfo *cellInfo = arr[indexPath.row];
    [cell configViewWithCellInfo:cellInfo];
    if ([cellInfo.isClick isEqualToString:@"1"]&&![_status isEqualToString:@"10"]) {
        [cell setHighlighted:YES];
        NSDictionary *dic = @{@"row":[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"section":[NSString stringWithFormat:@"%ld",(long)indexPath.section]};
        [_showarray addObject:dic];
    }

    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view_bg;
    
    if (indexPath.row==arr.count-1) {
        cell.lineView.hidden=YES;
    }
    return cell;
}

//行单击取消事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSArray *array = _arrshowinfo[indexPath.section][@"array"];
    buildCellInfo *cellInfo = array[indexPath.row];
    cellInfo.isClick = @"0";
    
    for (int i = 0; i<_userItemArray.count; i++) {
        buildCellInfo *mesinfo = _userItemArray[i];
        if (cellInfo.requestorUserId == mesinfo.requestorUserId) {
            mesinfo.isClick = @"0";
            _userItemArray[i]=mesinfo;
        }
    }
    
    for (int i = 0; i<_arrClick.count; i++) {
        buildCellInfo *clickinfo = _arrClick[i];
        if (cellInfo.requestorUserId == clickinfo.requestorUserId) {
            [_arrClick removeObjectAtIndex:i];
        }
    }
    [self oftenByuser:_oftenItemArray array:_userItemArray];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    for (int i = 0; i<_arrshowinfo.count; i++) {
        NSMutableArray *array = _arrshowinfo[i][@"array"];
        for (int a = 0; a<array.count; a++) {
            buildCellInfo *build = array[a];
            if (i!=0) {
                if (cellInfo.requestorUserId == build.requestorUserId) {
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:a inSection:i];
                    
                    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
    
}

//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSArray *array = _arrshowinfo[indexPath.section][@"array"];
    buildCellInfo *cellInfo = array[indexPath.row];
    BOOL isadd = [cellInfo.isClick isEqualToString:@"0"];
    cellInfo.isClick = @"1";
    
    for (int i = 0; i<_userItemArray.count; i++) {
        buildCellInfo *mesinfo = _userItemArray[i];
        if (cellInfo.requestorUserId ==mesinfo.requestorUserId) {
            mesinfo.isClick = @"1";
            _userItemArray[i]=mesinfo;
        }
    }
    [self oftenByuser:_oftenItemArray array:_userItemArray];
    
    if (isadd&&![[NSString stringWithFormat:@"%@",cellInfo.requestor] isEqualToString:Custing(@"全部", nil)]) {
        [_arrClick addObject:cellInfo];
    }
    
    if ([[NSString stringWithFormat:@"%@",cellInfo.requestor] isEqualToString:Custing(@"全部", nil)]) {
        [_arrClick removeAllObjects] ;
    }
    
    if ([_Radio isEqualToString:@"1"]) {
        [self addMineContent];
    }
    
}

//两个表去重
-(void)oftenByuser:(NSMutableArray *)often array:(NSMutableArray *)user
{
    for (int i = 0; i<often.count; i++) {
        buildCellInfo *ofteninfo = [NSMutableArray arrayWithArray:often][i];
        for (int a = 0; a<user.count; a++) {
            buildCellInfo *userinfo = [NSMutableArray arrayWithArray:user][a];
            if ([[NSString stringWithFormat:@"%@",ofteninfo.requestor] isEqualToString:userinfo.requestor]) {
                if ([userinfo.isClick isEqualToString:@"1"]) {
                    ofteninfo.isClick = @"1";
                }
                if ([userinfo.isClick isEqualToString:@"0"]) {
                    ofteninfo.isClick = @"0";
                    [self.tableView reloadData];
                }
                if ([ofteninfo.isClick isEqualToString:@"1"]) {
                    userinfo.isClick = @"1";
                }
                if ([ofteninfo.isClick isEqualToString:@"0"]) {
                    userinfo.isClick = @"0";
                }
            }
            user[a] = userinfo;
        }
        often[i] = ofteninfo;
    }
    _userItemArray = user;
    _oftenItemArray = often;
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
