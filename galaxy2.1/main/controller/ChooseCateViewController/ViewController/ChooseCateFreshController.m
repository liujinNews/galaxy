//
//  ChooseCateFreshController.m
//  galaxy
//
//  Created by hfk on 2017/6/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ChooseCateFreshController.h"
#import "ContractIsTableViewCell.h"
#import "PayCompanyViewController.h"
#import "AddPayCompanyViewController.h"
#import "AddClientViewController.h"
#import "ClientViewController.h"
#import "projectManagementViewController.h"
#import "ZFProjectMangViewController.h"
#import "ProductEditController.h"
#import "ProductMangerListController.h"
#import "PayeesEditViewController.h"
#import "PayeesManagerViewController.h"

@interface ChooseCateFreshController ()

@property (nonatomic, strong) NSMutableArray *ChoosedIdArray;
@property (nonatomic, strong) NSMutableArray *ChoosedNameArray;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) UISearchBar * searchbar;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) ChooseCategoryCell *cell;
@property (nonatomic, strong)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong)NSString *searchAim;
@property (nonatomic, assign)NSInteger offsetHight;
@property (nonatomic, strong)UIImageView *selectedImg;
@property (nonatomic, assign) NSInteger paramValue;
@property (nonatomic, assign) NSInteger codeIsSystem;//编号是否由系统生成(0系统 1自己输入)
@property (nonatomic, strong) DoneBtnView *dockView;
@property (nonatomic, copy) NSString *str_SearchTips;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;
/**
 采购选择的模板model
 */
@property (nonatomic, copy) ChooseCateFreModel *model_ItemTpl;


@end

@implementation ChooseCateFreshController

-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _offsetHight=0;
    _paramValue = 0;
    _codeIsSystem = 0;
    _requestType=NO;
    _ChoosedIdArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryId]?[[NSString stringWithFormat:@"%@",_ChooseCategoryId] componentsSeparatedByString:@","]:@[]];
    
    if (_isMultiSelect) {
        _ChoosedNameArray=[NSMutableArray array];
    }else{
        _ChoosedNameArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryName]?@[_ChooseCategoryName]:@[]];
    }
    if ([_type isEqualToString:@"projectName"]){
        [self setTitle:Custing(@"选择项目", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"项目", nil);
    }else if ([_type isEqualToString:@"costCenter"]){
        [self setTitle:Custing(@"选择成本中心", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"成本中心", nil);
    }else if ([_type isEqualToString:@"Client"]){
        [self setTitle:Custing(@"选择客户", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"客户", nil);
    }else if ([_type isEqualToString:@"Supplier"]){
        [self setTitle:Custing(@"选择供应商", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"供应商", nil);
    }else if ([_type isEqualToString:@"area"]){
        [self setTitle:Custing(@"选择地区", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"地区", nil);
    }else if ([_type isEqualToString:@"location"]){
        [self setTitle:Custing(@"选择办事处", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"办事处", nil);
    }else if ([_type isEqualToString:@"BranchCompany"]){
        [self setTitle:Custing(@"选择公司", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"公司", nil);
    }else if ([_type isEqualToString:@"BDivision"]){
        [self setTitle:Custing(@"选择业务部门", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"业务部门", nil);
    }else if ([_type isEqualToString:@"travelForm"]){
        [self setTitle:Custing(@"选择出差申请单", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"FeeAppForms"]){
        [self setTitle:Custing(@"选择费用申请单", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"Contracts"]){
        [self setTitle:Custing(@"选择合同", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"ContractsIs"]){
        [self setTitle:Custing(@"选择合同", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"ContractsV3"]){
        [self setTitle:Custing(@"选择合同", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"RelaContract"]){
        [self setTitle:Custing(@"选择合同", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"合同", nil);
    }else if ([_type isEqualToString:@"FormReason"]){
        [self setTitle:Custing(@"选择撤销申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"撤销申请单", nil);
    }else if ([_type isEqualToString:@"PurchaseNumber"]){
        [self setTitle:Custing(@"选择采购申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"采购申请单", nil);
    }else if ([_type isEqualToString:@"AdvanceType"]){
        [self setTitle:Custing(@"选择借款类型", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"LeaveType"]){
        [self setTitle:Custing(@"选择请假类型", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"UserLevel"]){
        [self setTitle:Custing(@"选择员工级别", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"PurchaseItems"]){
        [self setTitle:Custing(@"选择产品", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"产品", nil);
    }else if ([_type isEqualToString:@"PurchaseItemTpls"]){
        [self setTitle:Custing(@"选择采购申请模板", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"采购申请模板", nil);
    }else if ([_type isEqualToString:@"EntertainApp"]){
        [self setTitle:Custing(@"选择业务招待申请单", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"VehicleSvcApp"]){
        [self setTitle:Custing(@"选择车辆维修申请单", nil) backButton:YES ];
    }else if ([_type isEqualToString:@"ContractType"]){
        [self setTitle:Custing(@"选择合同类型", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"合同类型", nil);
    }else if ([_type isEqualToString:@"ReceiveBill"]){
        [self setTitle:Custing(@"选择收款单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"收款单", nil);
    }else if ([_type isEqualToString:@"InvoiceForms"]){
        [self setTitle:Custing(@"选择开票申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"开票申请单", nil);
    }else if ([_type isEqualToString:@"PayBankName"]){
        [self setTitle:Custing(@"选择付款银行", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"付款银行", nil);
    }else if ([_type isEqualToString:@"StaffOut"]){
        [self setTitle:Custing(@"选择外出申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"外出申请单", nil);
    }else if ([_type isEqualToString:@"SpecialReqest"]){
        [self setTitle:Custing(@"选择特殊事项申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"特殊事项申请单", nil);
    }else if ([_type isEqualToString:@"EmployeeTrain"]){
        [self setTitle:Custing(@"选择外出培训申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"外出培训申请单", nil);
    }else if ([_type isEqualToString:@"VehicleForm"]){
        [self setTitle:Custing(@"选择用车申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"用车申请单", nil);
    }else if ([_type isEqualToString:@"BusinessType"]){
        [self setTitle:Custing(@"选择出差类型", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"出差类型", nil);
    }else if ([_type isEqualToString:@"Inventorys"]){
        [self setTitle:Custing(@"选择库存", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"库存", nil);
    }else if ([_type isEqualToString:@"PaymentApp"]){
        [self setTitle:Custing(@"选择付款单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"付款单", nil);
    }else if ([_type isEqualToString:@"AccountItem"]){
        [self setTitle:Custing(@"选择辅助核算项目", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"辅助核算项目", nil);
    }else if ([_type isEqualToString:@"InventoryStorage"]){
        [self setTitle:Custing(@"选择仓库", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"仓库", nil);
    }else if ([_type isEqualToString:@"StoreApp"]){
        [self setTitle:Custing(@"选择入库单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"入库单", nil);
    }else if ([_type isEqualToString:@"ProjActivitys"]){
        [self setTitle:Custing(@"选择项目活动", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"项目活动", nil);
    }else if ([_type isEqualToString:@"ClearingBank"]){
        [self setTitle:Custing(@"选择开户行", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"开户行", nil);
    }else if ([_type isEqualToString:@"BankOutlets"]){
        [self setTitle:Custing(@"选择开户网点", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"开户网点", nil);
    }else if ([_type isEqualToString:@"RelateContAndApply"]){
        [self setTitle:Custing(@"选择合同/申请单", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips = Custing(@"合同/申请单", nil);
    }else if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel){
        [self setTitle:[self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithFormat:@"%@%@",Custing(@"选择", nil),_ChooseModel.Description]:[NSString stringWithFormat:@"%@ %@",Custing(@"选择", nil),_ChooseModel.Description] backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=_ChooseModel.Description;
    }
    if (self.searchbar&&[NSString isEqualToNull:self.str_SearchTips]) {
        self.searchbar.placeholder =[self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),self.str_SearchTips]:[NSString stringWithFormat:@"%@ %@",Custing(@"搜索", nil),self.str_SearchTips];
    }
    [self updateTable];
    
    if (_isMultiSelect) {
        [self createNavMutilSelectSure];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_requestType) {
        [self loadData];
    }
    _requestType=YES;
}
//MARK:创建多选确定按钮
-(void)createNavMutilSelectSure{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(sureSelect:)];
}

-(void)createSeachBar{
    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    //    判断iOS的版本是否大于13.0
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    }
    self.searchbar.delegate = self;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    _offsetHight=_offsetHight+49;
}

-(void)createManageView{
    __weak typeof(self) weakSelf = self;
    if ([_type isEqualToString:@"Supplier"]||[_type isEqualToString:@"Client"]||[_type isEqualToString:@"projectName"]||[_type isEqualToString:@"PurchaseItems"]) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"管理", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(ManageClick:)];

        [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-50);
        }];
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.equalTo(@50);
        }];
        
        NSArray *titles;
        if ([_type isEqualToString:@"Supplier"]) {
            titles=@[Custing(@"新增供应商", nil)];
        }else if ([_type isEqualToString:@"projectName"]){
            titles=@[Custing(@"新增项目", nil)];
        }else if ([_type isEqualToString:@"Client"]){
            if (_isMultiSelect) {
                titles=@[Custing(@"新增客户", nil),Custing(@"确定", nil)];
            }else{
                titles=@[Custing(@"新增客户", nil)];
            }
        }else if ([_type isEqualToString:@"PurchaseItems"]){
            titles=@[Custing(@"新增产品", nil)];
        }
        [self.dockView updateLookFormViewWithTitleArray:titles];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if ([weakSelf.type isEqualToString:@"Supplier"]) {
                if (index==0){
                    AddPayCompanyViewController *add = [[AddPayCompanyViewController alloc]init];
                    add.codeIsSystem = weakSelf.codeIsSystem;
//                    if (weakSelf.ChooseCateFreBlock) {
//                        add.ChooseCateFreBlock = weakSelf.ChooseCateFreBlock;
//                    }
//                    add.type = @"Supplier";
//                    add.ChooseCateFreBlock = ^(ChooseCateFreModel *model, NSString *type) {
//                        weakSelf.ChooseCateFreBlock(model, type);
//                    };
//                    add.returnNumber = 3;
                    [weakSelf.navigationController pushViewController:add animated:YES];
                }
            }else if ([weakSelf.type isEqualToString:@"Client"]){
                if (index == 0) {
                    AddClientViewController *add = [[AddClientViewController alloc]init];
                    add.codeIsSystem = weakSelf.codeIsSystem;
                    [weakSelf.navigationController pushViewController:add animated:YES];
                }else{
                    [weakSelf sureSelect:nil];
                }
            }else if ([weakSelf.type isEqualToString:@"projectName"]) {
                if (index==0){
                    ZFProjectMangViewController * reimburs = [[ZFProjectMangViewController alloc]init];
                    reimburs.codeIsSystem = weakSelf.codeIsSystem;
                    [weakSelf.navigationController pushViewController:reimburs animated:YES];
                }
            }else if ([weakSelf.type isEqualToString:@"PurchaseItems"]) {
                if (index==0){
                    ProductEditController * vc = [[ProductEditController alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        };
    }
}

-(void)updateTable{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(self.offsetHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
//项目
-(void)requestProject{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary * dic =@{@"Requestor":@"",
                          @"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],
                          @"PageSize":@"20",
                          @"OrderBy":@"ProjName",
                          @"IsAsc":@"",
                          @"ProjName":_searchAim,
                          @"CostCenterId":self.dict_otherPars[@"CostCenterId"] ? self.dict_otherPars[@"CostCenterId"]:@"0"
                          };
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getProjs] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//成本中心
-(void)requestCostCenter{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],@"PageSize":@"20",@"OrderBy":@"id",@"IsAsc":@"",@"costCenterName":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcostcs] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    
}
//客户
-(void)requestClient{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],@"PageSize":@"20",@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetClientList] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//供应商
-(void)requestSupplier{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url;
    if (self.dict_otherPars && [self.dict_otherPars[@"DateType"]isEqualToString:@"2"]) {
        url = [NSString stringWithFormat:@"%@",BeneficiaryBeneficiaryListByUserId];
    }else{
        url = [NSString stringWithFormat:@"%@",BeneficiaryList_B];
    }
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//地区
-(void)requestArea{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetAreaList];
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//办事处
-(void)requestLocation{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetLocationList];
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//公司
-(void)requestBranchCompany{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetBRCompany];
    NSDictionary * dic =@{@"GroupName":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//业务部门
-(void)requestBDivision{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetBDivision];
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//出差申请单  type 0(审批完成1次) 1(审批中审批完成1次) 2(审批完成多次) 3(审批中审批完成多次)
-(void)requestTravelForm{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETTRAVELFORM];
    NSDictionary * dic =@{@"TaskId":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0",@"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//费用申请单
-(void)requestFeeForm{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETFEEFORM];
    NSDictionary * dic =@{@"TaskId":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//合同
-(void)requestContract{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPAYMENTCONTRACT];
    NSDictionary * dic =@{@"TaskId":@"",@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//合同分期
-(void)requestContractIs{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",PaymentAppGetContractFormsV2];
    NSDictionary * dic =@{@"TaskId":@"",@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//开票申请合同
-(void)requestContractV3{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",PaymentAppGetContractFormsV3];
    NSDictionary * dic =@{@"TaskId":@"",@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"flowCode":self.dict_otherPars ? self.dict_otherPars[@"flowCode"]:@"",@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//关联合同
-(void)requestRelaContract{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETRELACONTRACT];
    NSDictionary * dic =@{@"TaskId":@"",@"ContractName":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//撤销申请单
-(void)requestFormReason{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",CancellationGetReimbursement];
    NSDictionary * dic =@{@"TaskId":@"",@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@10,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//采购申请单
-(void)requestPurchaseNumber{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetPurchases];
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//借款类型
-(void)requestAdvanceType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetADVANCETYPE];
    NSDictionary * dic =@{@"Name":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//请假类型
-(void)requestLeaveType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetLEAVETYPE];
    NSDictionary * dic =@{@"Name":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//请求员工级别
-(void)requestUserLevel{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",getuserlevels];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"OrderBy":@"id",@"IsAsc":@"desc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//商品列表
-(void)requestPurchaseItem{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPURCHASEITEMS];
    NSDictionary * dic =@{@"Type":@"2",@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"OrderBy":@"",@"IsAsc":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//采购模板列表
-(void)requestPurchaseTpls{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPURCHASETPLS];
    NSDictionary * dic =@{@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"OrderBy":@"",@"IsAsc":@""};//
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//付款银行
-(void)requestPayBankName{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPAYBANKNAME];
    NSDictionary * dic =@{@"Branch":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//请求配置项
-(void)requestConfigurationItem{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetMasterData];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"MasterId":[NSString stringWithIdOnNO:_ChooseModel.masterId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取业务招待或车辆维修
-(void)requestEntertainVehicleSvc{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETENTERTAINVEHICLEFORMLIST];
    NSDictionary * dic =@{@"FlowCode":[_type isEqualToString:@"EntertainApp"]?@"F0023":@"F0024",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"OrderBy":@"",@"IsAsc":@"",@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取合同类型
-(void)requestContractType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETCONTRACTTYPE];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"ContractTyp":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//收款单列表
-(void)requestReceiveBill{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETRECEIVEBILLLIST];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Reason":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//开票申请单列表
-(void)requestInvoiceForms{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETINVOICEFORMSLIST];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Reason":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//外出申请单列表
-(void)requestStaffOut{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETSTAFFOUT];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//特殊事项申请单
-(void)requestSpecialRequest{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETSPECIALREQUEST];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//外出培训申请单列表
-(void)requestEmployeeTrain{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETEMPLOYEETRAIN];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//收款人列表
-(void)requestPayeeBank{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETALLPAYEE];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//用车申请单列表
-(void)requestVehicle{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETVEHICLEFORM];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//出差类型列表
-(void)requestBusinessType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETBUSINESSTYPE];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"OrderBy":@"No",@"IsAsc":@"",@"TravelType":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//库存列表
-(void)requestInventorys{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETINVENTORYS];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//付款单列表
-(void)requestPaymentApp{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPAYMENTFORMS];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":self.dict_otherPars ? self.dict_otherPars[@"Type"]:@"0",@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//辅助核算项目列表
-(void)requestAccountItem{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETACCOUNTITEM];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//仓库列表
-(void)requestInventoryStorage{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETINVENTORYSTORAGES];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//入库单列表
-(void)requestStoreApp{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETSTOREAPPLIST];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//项目活动列表
-(void)requestProjActivitys{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPROJECTACTIVITY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"PrjId":self.dict_otherPars ? self.dict_otherPars[@"PrjId"]:@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//获取开户行
-(void)requestClearingBanks{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETCLEARINGBANKS];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"OrderBy":@"ClearingBankCode",@"IsAsc":@"Asc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//获取开户行网点
-(void)requestBankOutlets{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETBANKOUTLETS];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"ClearingBankCode":self.dict_otherPars ? self.dict_otherPars[@"ClearingBankCode"]:@"",@"CityCode":self.dict_otherPars ? self.dict_otherPars[@"CityCode"]:@"",@"OrderBy":@"BankName",@"IsAsc":@"Asc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//关联合同/申请单列表
-(void)requestRelateContAndApply{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETRELATECONTANDAPPLY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);

    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            NSMutableArray *array=[NSMutableArray array];
            [ChooseCateFreModel GetPurchaseItemsTplListDictionary:responceDic Array:array WithTplModel:_model_ItemTpl];
            if (self.ChooseFreshCateBackBlock) {
                self.ChooseFreshCateBackBlock(array, _type);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPages=[result[@"totalPages"] integerValue];
    if ([_type isEqualToString:@"projectName"]){
        _paramValue = [result[@"paramValue"] integerValue];
        _codeIsSystem = [result[@"procCodeIsSyStem"]integerValue];
    }else if ([_type isEqualToString:@"Client"]){
        _paramValue = [result[@"paramValue"] integerValue];
        _codeIsSystem = [result[@"clientCodeIsSystem"]integerValue];
    }else if ([_type isEqualToString:@"Supplier"]){
        _codeIsSystem = [result[@"suppCodeIsSystem"]integerValue];
    }else if ([_type isEqualToString:@"PurchaseItems"]){
        _paramValue = [result[@"paramValue"] integerValue];
    }
    if (self.totalPages >= self.currPage) {
        if ([_type isEqualToString:@"projectName"]){
            [ChooseCateFreModel GetProjectManagerDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"costCenter"]){
            [ChooseCateFreModel GetCostCenterDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Client"]){
            [ChooseCateFreModel GetClientDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Supplier"]){
            [ChooseCateFreModel GetSupplierDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"area"]){
            [ChooseCateFreModel GetAreaDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"location"]){
            [ChooseCateFreModel GetLocationDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"BranchCompany"]){
            [ChooseCateFreModel GetBranchListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"BDivision"]){
            [ChooseCateFreModel GetBusDeptsListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"travelForm"]){
            [ChooseCateFreModel GetTravelFormListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"FeeAppForms"]||[_type isEqualToString:@"EntertainApp"]||[_type isEqualToString:@"VehicleSvcApp"]||[_type isEqualToString:@"StoreApp"]){
            [ChooseCateFreModel GetFeeEntertainVehicleSvcFormListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Contracts"]){
            [ChooseCateFreModel GetContractListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ContractsV3"]){
            [ChooseCateFreModel GetContractListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"RelaContract"]){
            [ChooseCateFreModel GetContractListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"FormReason"]){
            [ChooseCateFreModel GetFormReasonDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ContractsIs"]){
            [ChooseCateFreModel GetContractListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"PurchaseNumber"]){
            [ChooseCateFreModel GetPurchaseNumberListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"AdvanceType"]){
            [ChooseCateFreModel GetAdvanceTypeListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"LeaveType"]){
            [ChooseCateFreModel GetLeaveTypeListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"UserLevel"]){
            [ChooseCateFreModel GetUserLevelListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel){
            [ChooseCateFreModel GetConfigurationItemListDictionary: _resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"PurchaseItems"]){
            [ChooseCateFreModel GetPurchaseItemsListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"PurchaseItemTpls"]){
            [ChooseCateFreModel GetPurchaseTplsListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ContractType"]){
            [ChooseCateFreModel GetContractTypeListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ReceiveBill"]){
            [ChooseCateFreModel GetReceiveBillListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"InvoiceForms"]){
            [ChooseCateFreModel GetInvoiceFormsListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"PayBankName"]){
            [ChooseCateFreModel GetPayBankNameListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"StaffOut"]||[_type isEqualToString:@"SpecialReqest"]||[_type isEqualToString:@"EmployeeTrain"]||[_type isEqualToString:@"VehicleForm"]){
            [ChooseCateFreModel GetStaffOutListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"BusinessType"]){
            [ChooseCateFreModel GetBusinessTypeListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Inventorys"]){
            [ChooseCateFreModel GetInventorysListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"PaymentApp"]){
            [ChooseCateFreModel GetPaymentFormListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"AccountItem"]){
            [ChooseCateFreModel GetAccountItemListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"InventoryStorage"]){
            [ChooseCateFreModel GetInventoryStorageListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ProjActivitys"]){
            [ChooseCateFreModel GetProjActivityListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"ClearingBank"]){
            [ChooseCateFreModel GetClearingBankListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"BankOutlets"]){
            [ChooseCateFreModel GetBankOutletsListListDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"RelateContAndApply"]){
            [ChooseCateFreModel GetRelateContAndApplyListListDictionary:_resultDict Array:self.resultArray];
        }
    }
    
    if ([_type isEqualToString:@"Supplier"]){
        if (self.dict_otherPars && ![self.dict_otherPars[@"DateType"] isEqualToString:@"0"]) {
            [self createManageView];
        }
    }else if (_paramValue == 1){
        [self createManageView];
    }
}
//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =Color_form_TextFieldBackgroundColor;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 0.5)];
        lineview.backgroundColor =Color_GrayLight_Same_20;
        [view addSubview:lineview];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_type isEqualToString:@"ContractsIs"]){
        return 100;
    }else if ([_type isEqualToString:@"PayBankName"]||[_type isEqualToString:@"Supplier"]){
        return 70;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_type isEqualToString:@"ContractsIs"]){
        ContractIsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"ContractIsTableViewCell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ContractIsTableViewCell" owner:self options:nil]lastObject];
        }
        [cell setLable_Value:self.resultArray[indexPath.section]];
        return cell;
    }else if ([_type isEqualToString:@"PayBankName"]||[_type isEqualToString:@"Supplier"]){
        //cell创建
        _cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
        if (_cell==nil) {
            _cell=[[ChooseCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
        }
        
        ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
        _cell.ChooseNamesArray=self.ChoosedNameArray;
        [_cell configFreViewHasSubInfoWithModel:model withIdArray:_ChoosedIdArray withType:_type];
        
        return _cell;
    }
    //cell创建
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
    if (_cell==nil) {
        _cell=[[ChooseCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
    }
    
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    _cell.ChooseNamesArray=self.ChoosedNameArray;
    [_cell configFreViewWithModel:model withIdArray:_ChoosedIdArray withType:_type];
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMultiSelect) {
        ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
        if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel) {
            if ([_ChoosedNameArray containsObject:model.name]) {
                [_ChoosedNameArray removeObject:model.name];
            }else{
                [_ChoosedNameArray addObject:model.name];
            }
        }else{
            NSString *MarkId=[ChooseCategoryCell getFreModelSignWithModel:model WithType:_type];
            if ([_ChoosedIdArray containsObject:MarkId]) {
                [_ChoosedIdArray removeObject:MarkId];
            }else{
                [_ChoosedIdArray addObject:MarkId];
            }
        }
        [self.tableView reloadData];
    }else{
        if ([self.type isEqualToString:@"PurchaseItemTpls"]) {
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",GETPURCHASEITEMLIST];
            ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
            _model_ItemTpl=model;
            NSDictionary * dic =@{@"IdList":model.itemId};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
        }else{
            if ([_type isEqualToString:@"ClearingBank"]) {
                ChooseCateFreModel *model = self.resultArray[indexPath.section];
                ChooseCategoryController *choose = [[ChooseCategoryController alloc]initWithType:@"GetProvinces"];
                choose.dict_BankOutlets = @{@"ClearingBankCode":model.clearingBankCode};
                choose.ChooseBankOutletsBlock = self.ChooseBankOutletsBlock;
                [self.navigationController pushViewController:choose animated:YES];
            }else if ([_type isEqualToString:@"BankOutlets"]){
                NSMutableArray *arr=[NSMutableArray array];
                [arr addObject:self.resultArray[indexPath.section]];
                if (self.ChooseBankOutletsBlock) {
                    self.ChooseBankOutletsBlock(arr);
                }
                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-4]animated:YES];
            }else{
                NSMutableArray *arr=[NSMutableArray array];
                [arr addObject:self.resultArray[indexPath.section]];
                if (self.ChooseFreshCateBackBlock) {
                    self.ChooseFreshCateBackBlock(arr, _type);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
//MARK:确认选择
-(void)sureSelect:(id)obj{
    NSMutableArray *arr=[NSMutableArray array];
    for (ChooseCateFreModel *model in self.resultArray) {
        if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel) {
            if ([_ChoosedNameArray containsObject:model.name]) {
                [arr addObject:model];
            }
        }else{
            NSString *MarkId=[ChooseCategoryCell getFreModelSignWithModel:model WithType:_type];
            if ([_ChoosedIdArray containsObject:MarkId]) {
                [arr addObject:model];
            }
        }
    }
    if (self.ChooseFreshCateBackBlock) {
        self.ChooseFreshCateBackBlock(arr, _type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:管理选择
-(void)ManageClick:(id)obj{
    if ([self.type isEqualToString:@"Supplier"]) {
        PayCompanyViewController *sp = [[PayCompanyViewController alloc]init];
        sp.isUser = 1;
        [self.navigationController pushViewController:sp animated:YES];
    }else if ([self.type isEqualToString:@"Client"]){
        ClientViewController *sp = [[ClientViewController alloc]init];
        sp.isUser = 1;
        [self.navigationController pushViewController:sp animated:YES];
    }else if ([self.type isEqualToString:@"projectName"]){
        projectManagementViewController * project = [[projectManagementViewController alloc]init];
        project.isUser = 1;
        [self.navigationController pushViewController:project animated:YES];
    }else if ([self.type isEqualToString:@"PurchaseItems"]){
        ProductMangerListController * vc = [[ProductMangerListController alloc]init];
        vc.isUser = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)loadData{
    if ([_type isEqualToString:@"projectName"]){
        [self requestProject];
    }else if ([_type isEqualToString:@"costCenter"]){
        [self requestCostCenter];
    }else if ([_type isEqualToString:@"Client"]){
        [self requestClient];
    }else if ([_type isEqualToString:@"Supplier"]){
        [self requestSupplier];
    }else if ([_type isEqualToString:@"area"]){
        [self requestArea];
    }else if ([_type isEqualToString:@"location"]){
        [self requestLocation];
    }else if ([_type isEqualToString:@"BranchCompany"]){
        [self requestBranchCompany];
    }else if ([_type isEqualToString:@"BDivision"]){
        [self requestBDivision];
    }else if ([_type isEqualToString:@"travelForm"]){
        [self requestTravelForm];
    }else if ([_type isEqualToString:@"FeeAppForms"]){
        [self requestFeeForm];
    }else if ([_type isEqualToString:@"Contracts"]){
        [self requestContract];
    }else if ([_type isEqualToString:@"ContractsV3"]){
        [self requestContractV3];
    }else if ([_type isEqualToString:@"RelaContract"]){
        [self requestRelaContract];
    }else if ([_type isEqualToString:@"FormReason"]){
        [self requestFormReason];
    }else if ([_type isEqualToString:@"ContractsIs"]){
        [self requestContractIs];
    }else if ([_type isEqualToString:@"PurchaseNumber"]){
        [self requestPurchaseNumber];
    }else if ([_type isEqualToString:@"AdvanceType"]){
        [self requestAdvanceType];
    }else if ([_type isEqualToString:@"LeaveType"]){
        [self requestLeaveType];
    }else if ([_type isEqualToString:@"UserLevel"]){
        [self requestUserLevel];
    }else if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel){
        [self requestConfigurationItem];
    }else if ([_type isEqualToString:@"PurchaseItems"]){
        [self requestPurchaseItem];
    }else if ([_type isEqualToString:@"PurchaseItemTpls"]){
        [self requestPurchaseTpls];
    }else if ([_type isEqualToString:@"EntertainApp"]||[_type isEqualToString:@"VehicleSvcApp"]){
        [self requestEntertainVehicleSvc];
    }else if ([_type isEqualToString:@"ContractType"]){
        [self requestContractType];
    }else if ([_type isEqualToString:@"ReceiveBill"]){
        [self requestReceiveBill];
    }else if ([_type isEqualToString:@"InvoiceForms"]){
        [self requestInvoiceForms];
    }else if ([_type isEqualToString:@"PayBankName"]){
        [self requestPayBankName];
    }else if ([_type isEqualToString:@"StaffOut"]){
        [self requestStaffOut];
    }else if ([_type isEqualToString:@"SpecialReqest"]){
        [self requestSpecialRequest];
    }else if ([_type isEqualToString:@"EmployeeTrain"]){
        [self requestEmployeeTrain];
    }else if ([_type isEqualToString:@"VehicleForm"]){
        [self requestVehicle];
    }else if ([_type isEqualToString:@"BusinessType"]){
        [self requestBusinessType];
    }else if ([_type isEqualToString:@"Inventorys"]){
        [self requestInventorys];
    }else if ([_type isEqualToString:@"PaymentApp"]){
        [self requestPaymentApp];
    }else if ([_type isEqualToString:@"AccountItem"]){
        [self requestAccountItem];
    }else if ([_type isEqualToString:@"InventoryStorage"]){
        [self requestInventoryStorage];
    }else if ([_type isEqualToString:@"StoreApp"]){
        [self requestStoreApp];
    }else if ([_type isEqualToString:@"ProjActivitys"]){
        [self requestProjActivitys];
    }else if ([_type isEqualToString:@"ClearingBank"]){
        [self requestClearingBanks];
    }else if ([_type isEqualToString:@"BankOutlets"]){
        [self requestBankOutlets];
    }else if ([_type isEqualToString:@"RelateContAndApply"]){
        [self requestRelateContAndApply];
    }
    
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        self.currPage=1;
        [self loadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self loadData];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else if ([_type isEqualToString:@"projectName"]){
        tips=Custing(@"您还没有项目哦", nil);
    }else if ([_type isEqualToString:@"costCenter"]){
        tips=Custing(@"您还没有成本中心哦", nil);
    }else if ([_type isEqualToString:@"Client"]){
        tips=Custing(@"您还没有客户哦", nil);
    }else if ([_type isEqualToString:@"Supplier"]){
        tips=Custing(@"您还没有供应商哦", nil);
    }else if ([_type isEqualToString:@"area"]){
        tips=Custing(@"您还没有地区哦", nil);
    }else if ([_type isEqualToString:@"location"]){
        tips=Custing(@"您还没有办事处哦", nil);
    }else if ([_type isEqualToString:@"BranchCompany"]){
        tips=Custing(@"您还没有公司哦", nil);
    }else if ([_type isEqualToString:@"BDivision"]){
        tips=Custing(@"您还没有业务部门哦", nil);
    }else if ([_type isEqualToString:@"travelForm"]){
        tips=Custing(@"您还没有可用于报销的出差申请单,请先提交出差申请", nil);
    }else if ([_type isEqualToString:@"FeeAppForms"]){
        tips=Custing(@"您还没有费用申请单哦", nil);
    }else if ([_type isEqualToString:@"Contracts"]){
        tips=Custing(@"您还没有合同哦", nil);
    }else if ([_type isEqualToString:@"ContractsV3"]){
        tips=Custing(@"您还没有合同哦", nil);
    }else if ([_type isEqualToString:@"RelaContract"]){
        tips=Custing(@"您还没有合同哦", nil);
    }else if ([_type isEqualToString:@"PurchaseNumber"]){
        tips=Custing(@"您还没有采购申请单哦", nil);
    }else if ([_type isEqualToString:@"AdvanceType"]){
        tips=Custing(@"您还没有借款类型哦", nil);
    }else if ([_type isEqualToString:@"LeaveType"]){
        tips=Custing(@"您还没有请假类型哦", nil);
    }else if ([_type isEqualToString:@"UserLevel"]){
        tips=Custing(@"您还没有员工级别哦", nil);
    }else if ([_type isEqualToString:@"ConfigurationItem"]&&_ChooseModel){
        tips=Custing(@"您还没有配置哦", nil);
    }else if ([_type isEqualToString:@"PurchaseItems"]){
        tips=Custing(@"您还没有产品哦", nil);
    }else if ([_type isEqualToString:@"PurchaseItemTpls"]){
        tips=Custing(@"您还没有采购申请模板哦", nil);
    }else if ([_type isEqualToString:@"EntertainApp"]){
        tips=Custing(@"您还没有业务招待申请单哦", nil);
    }else if ([_type isEqualToString:@"EntertainApp"]){
        tips=Custing(@"您还没有车辆维修申请单哦", nil);
    }else if ([_type isEqualToString:@"ContractType"]){
        tips=Custing(@"您还没有设置合同类型哦", nil);
    }else if ([_type isEqualToString:@"ReceiveBill"]){
        tips=Custing(@"您还没有收款单哦", nil);
    }else if ([_type isEqualToString:@"InvoiceForms"]){
        tips=Custing(@"您还没有费用申请单哦", nil);
    }else if ([_type isEqualToString:@"PayBankName"]){
        tips=Custing(@"您还没有付款银行哦", nil);
    }else if ([_type isEqualToString:@"StaffOut"]){
        tips=Custing(@"您还没有外出申请单哦", nil);
    }else if ([_type isEqualToString:@"SpecialReqest"]){
        tips=Custing(@"您还没有特殊事项申请单哦", nil);
    }else if ([_type isEqualToString:@"EmployeeTrain"]){
        tips=Custing(@"您还没有外出培训申请单哦", nil);
    }else if ([_type isEqualToString:@"VehicleForm"]){
        tips=Custing(@"您还没有用车申请单哦", nil);
    }else if ([_type isEqualToString:@"BusinessType"]){
        tips=Custing(@"您还没有出差类型哦", nil);
    }else if ([_type isEqualToString:@"Inventorys"]){
        tips=Custing(@"您还没有库存哦", nil);
    }else if ([_type isEqualToString:@"PaymentApp"]){
        tips=Custing(@"您还没有付款单哦", nil);
    }else if ([_type isEqualToString:@"AccountItem"]){
        tips=Custing(@"您还没有辅助核算项目哦", nil);
    }else if ([_type isEqualToString:@"InventoryStorage"]){
        tips=Custing(@"您还没有仓库哦", nil);
    }else if ([_type isEqualToString:@"StoreApp"]){
        tips=Custing(@"您还没有入库单哦", nil);
    }else if ([_type isEqualToString:@"ProjActivitys"]){
        tips=Custing(@"您还没有项目活动哦", nil);
    }else if ([_type isEqualToString:@"ClearingBank"]){
        tips=Custing(@"您还没有开户行哦", nil);
    }else if ([_type isEqualToString:@"BankOutlets"]){
        tips=Custing(@"您还没有开户网点哦", nil);
    }else if ([_type isEqualToString:@"RelateContAndApply"]){
        tips=Custing(@"您还没有合同/申请单哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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

