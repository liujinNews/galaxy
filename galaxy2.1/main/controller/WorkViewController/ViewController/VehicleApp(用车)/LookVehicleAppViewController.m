//
//  LookVehicleAppViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "LookVehicleAppViewController.h"
#import "VehicleAppViewController.h"
#import "SelectViewController.h"

@interface LookVehicleAppViewController ()<GPClientDelegate,UIScrollViewDelegate,SelectViewControllerDelegate>
//view视图底层
@property (nonatomic, strong) UIScrollView * scr_RootScrollView;//滚动视图
@property (nonatomic, strong) UIView *view_ContentView;//滚动视图contentView
@property (nonatomic, strong) DoneBtnView *dockView;//下部按钮底层视图
@property (nonatomic, strong) UIButton *backBtn;//退单按钮
@property (nonatomic, strong) UIButton *recallBtn;//撤回按钮
@property (nonatomic, strong) UIButton *refuseBtn;//拒绝按钮
@property (nonatomic, strong) UIButton *agreeBtn;//同意按钮

@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) NSDictionary *dic_approve;//审批数据
@property (nonatomic, strong) NSDictionary *dic_operatorUser;
@property (nonatomic, strong) NSString *canEndorsel;//是否显示加签
@property (nonatomic, strong) NSMutableArray *arr_MainView;
@property (nonatomic, strong) NSMutableArray *arr_Approve;

@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;//网格规则
@property (nonatomic, strong) NSString *imageDataString;//上传服务器图片
@property (nonatomic, strong) NSMutableArray *imagesArray;//图片数组
@property (nonatomic, strong) NSMutableArray *imageTypeArray;
@property (nonatomic, assign) NSInteger NotesTableHeight;//审批记录tableView高度
@property (nonatomic, strong) NSMutableArray *totalArray;

@property (nonatomic, strong) NSString *twoHandeId;//第二审批人Id
@property (nonatomic, strong) NSString *twoApprovalName;//第二审批人名字
@property (nonatomic, strong) NSString *commentIdea;//提交退单拒绝意见
@property (nonatomic, strong) NSDictionary *parametersDict;//提交和保存的提交字典

//@property (nonatomic, strong) UIView *View_OneView;//内容1视图
//@property (nonatomic, strong) UIView *View_Requestor;//申请人相关视图
//@property (nonatomic, strong) UIImageView *Imgv_requestor;//申请人头像
//@property (nonatomic, assign) int Int_firstHandlerGender;// 第一审批人性别
//@property (nonatomic, strong) UIView *View_RequestorUserId;//申请人
//@property (nonatomic, strong) UILabel *Lab_RequestorUserId;
//@property (nonatomic, strong) UIView *View_RequestorDeptId;//部门
//@property (nonatomic, strong) UILabel *Lab_RequestorDeptId;
//@property (nonatomic, strong) UIView *View_HRID;//员工工号
//@property (nonatomic, strong) UIView *View_BranchId;//分公司
//@property (nonatomic, strong) UILabel *Lab_BranchId;
//@property (nonatomic, strong) UIView *View_RequestorBusDeptId;//业务部门
//@property (nonatomic, strong) UILabel *Lab_RequestorBusDeptId;
//@property (nonatomic, strong) UIView *View_Personal_Fir;// 员工自定义字段
//@property (nonatomic, strong) UIView *View_Personal_Sec;
//@property (nonatomic, strong) UIView *View_Personal_Thir;
//@property (nonatomic, strong) UIView *View_Personal_Four;
//@property (nonatomic, strong) UIView *View_Personal_Fif;
//@property (nonatomic, strong) UIView *View_RequestorDate;//申请日期

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;
@property (nonatomic, strong) FormBaseModel *FormData;


@property (nonatomic, strong) UIView *View_TwoView;//内容2视图
@property (nonatomic, strong) UIView *View_Reason;//用车事由
@property (nonatomic, strong) UIView *View_DepartCity;//出发地
@property (nonatomic, strong) UIView *View_BackCity;//返回地点
@property (nonatomic, strong) UIView *View_VehicleDate;//用车时间
@property (nonatomic, strong) UIView *View_BackDate;//返回时间
@property (nonatomic, strong) UIView *View_VehicleStaffId;//同车人员
@property (nonatomic, strong) UILabel *Lab_VehicleStaffId;
@property (nonatomic, strong) NSString *str_VehicleStaffId;
@property (nonatomic, strong) NSString *str_VehicleStaff;
@property (nonatomic, strong) UIView *View_ProjId;//项目名称
@property (nonatomic, strong) UILabel *Lab_ProjId;
@property (nonatomic, strong) UIView *View_ClientId;//客户
@property (nonatomic, strong) UILabel *Lab_ClientId;
@property (nonatomic, strong) UIView *View_SupplierId;//供应商
@property (nonatomic, strong) UILabel *Lab_SupplierId;
@property (nonatomic, strong) UIView *View_CarNo;//车辆
@property (nonatomic, strong) UITextField *Txf_CarNo;
@property (nonatomic, strong) SelectDataModel *Model_CarNo;
@property (nonatomic, strong) UIView *View_Driver;//司机
@property (nonatomic, strong) UITextField *Txf_Driver;
@property (nonatomic, strong) UIView *View_DriverTel;//司机电话
@property (nonatomic, strong) UITextField *Txf_DriverTel;
@property (nonatomic, strong) UIView *View_Entourage;//同行人
@property (nonatomic, strong) UITextField *Txf_Entourage;
@property (nonatomic, strong) UIView *View_VehicleType;//同行人员
@property (nonatomic, strong) UITextField *Txf_VehicleType;
@property (nonatomic, strong) NSString *str_Entourage;
@property (nonatomic, strong) NSMutableArray *muarr_Entourage;
@property (nonatomic, strong) UIView *View_Remark;//备注
@property (nonatomic, strong) UITextField *Txf_Remark;
@property (nonatomic, strong) UIView *View_Mileage;//行驶里程(KM)
@property (nonatomic, strong) UITextField *Txf_Mileage;
@property (nonatomic, strong) UIView *View_Attachments;//附件
@property (nonatomic, strong) UITextField *Txf_Attachments;
@property (nonatomic, strong) UIView *View_Reserved1;//自定义字段1

@property (nonatomic, strong) UIView *View_Approve;//内容审批人视图
@property (nonatomic, strong) UIImageView *Img_Approve;//审批人头像
@property (nonatomic, strong) UITextField *txf_Approver;//审批人Label

@property (nonatomic, strong) UIView *View_FiveView;//内容5视图
//@property (nonatomic, strong) UITableView *Tbv_Notes;//流程视图

//是否是行政
@property (nonatomic, assign) BOOL isAdminStaff;
//司机Id
@property (nonatomic, strong)NSString *DriverUserId;
//是否是司机
@property (nonatomic, assign) BOOL IsDriver;

@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;

@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;

@property (nonatomic, strong) NSMutableArray *arr_More;//更多按钮显示数组


@end

static NSString *const CellIdentifier = @"MyCell";

@implementation LookVehicleAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _procId = self.pushProcId;
        _flowGuid = self.pushFlowGuid;
        _comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    [self initializeData];
    NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowCode];
    [self setTitle:dict[@"Title"] backButton:YES];
    [self requestGetContractVehicleData];
}

#pragma mark - function
#pragma mark view
-(void)creationRootView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    self.view_ContentView =[[BottomView alloc]init];
    self.view_ContentView.userInteractionEnabled=YES;
    self.view_ContentView.backgroundColor=Color_White_Same_20;
    [_scr_RootScrollView addSubview:self.view_ContentView];
    
    [self.view_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_RootScrollView);
        make.width.equalTo(self.scr_RootScrollView);
    }];
    
    if (_comeStatus==2||_comeStatus==3||_comeStatus==4||_comeStatus==7) {
        [self.scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(@-50);
        }];
        
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }else{
        [self.scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self createDealBtns];
    [self createMainView];
    
    [self createMoreBtnWithArray:self.arr_More WithDict:@{@"ProcId":_procId,@"TaskId":_taskId,@"FlowCode":@"F0014"}];

}

-(void)createDealBtns{
    if (_comeStatus==2||_comeStatus==7) {
        [self createReCallBtn];
    }else if (_comeStatus==3){
        [self saveAndSubmitBtn];
    }
}

//创建撤回按钮
-(void)createReCallBtn{
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf reCallBack:nil];
        }
    };
}

//创建待审批按钮
-(void)saveAndSubmitBtn{
    if ([_canEndorsel isEqualToString:@"1"]) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf refuseclick:nil];
            }else if (index==1){
                [weakSelf backclick:nil];
            }else if (index==2){
                [weakSelf agreeclick:nil];
            }
        };
    }else{
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf backclick:nil];
            }else if (index==1){
                [weakSelf agreeclick:nil];
            }
        };
    }
}

-(void)createMainView{
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    _SubmitPersonalView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ContentView.top);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _view_line1 = [[UIView alloc]init];
    [self.view_ContentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    //第二视图
    _View_TwoView=[[UIView alloc]init];
    _View_TwoView.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_TwoView];
    [_View_TwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Reason = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_Reason];
    [_View_Reason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TwoView.top);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_DepartCity = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_DepartCity];
    [_View_DepartCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_BackCity = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_BackCity];
    [_View_BackCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DepartCity.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_VehicleDate = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_VehicleDate];
    [_View_VehicleDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackCity.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_BackDate = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_BackDate];
    [_View_BackDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleDate.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_VehicleStaffId = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_VehicleStaffId];
    [_View_VehicleStaffId makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackDate.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_ProjId = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_ProjId];
    [_View_ProjId makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleStaffId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_ClientId = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_ClientId];
    [_View_ClientId makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ProjId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_SupplierId = [[UIView alloc]init];
    [_View_TwoView addSubview:_View_SupplierId];
    [_View_SupplierId makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClientId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _view_line2 = [[UIView alloc]init];
    [self.view_ContentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TwoView.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_CarNo = [[UIView alloc]init];
    _View_CarNo.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_CarNo];
    [_View_CarNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Driver = [[UIView alloc]init];
    _View_Driver.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Driver];
    [_View_Driver makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CarNo.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_DriverTel = [[UIView alloc]init];
    _View_DriverTel.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_DriverTel];
    [_View_DriverTel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Driver.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Entourage = [[UIView alloc]init];
    _View_Entourage.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Entourage];
    [_View_Entourage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DriverTel.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_VehicleType = [[UIView alloc]init];
    _View_VehicleType.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_VehicleType];
    [_View_VehicleType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Entourage.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _view_line3 = [[UIView alloc]init];
    [self.view_ContentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleType.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Mileage = [[UIView alloc]init];
    _View_Mileage.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Mileage];
    [_View_Mileage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Reserved1 = [[UIView alloc]init];
    _View_Reserved1.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Reserved1];
    [_View_Reserved1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Mileage.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved1.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Attachments = [[UIView alloc]init];
    _View_Attachments.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Attachments];
    [_View_Attachments makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Attachments.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    //第五视图
    _View_FiveView = [[UIView alloc]init];
    _View_FiveView.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_View_FiveView];
    [_View_FiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
}

-(void)updateMainView{;
    _int_line1 = 1;
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:_arr_MainView WithApproveModel:self.FormData withType:2];
    for (MyProcurementModel *model in _arr_MainView) {
        if ([[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateLineState:model];
            if ([model.fieldName isEqualToString:@"Reason"]) {
                [self update_Reason_View:model];
            }
            if ([model.fieldName isEqualToString:@"DepartCity"]) {
                [self update_DepartCity_View:model];
            }
            if ([model.fieldName isEqualToString:@"BackCity"]) {
                [self update_BackCity_View:model];
            }
            if ([model.fieldName isEqualToString:@"VehicleDate"]) {
                [self update_VehicleDate_View:model];
            }
            if ([model.fieldName isEqualToString:@"BackDate"]) {
                [self update_BackDate_View:model];
            }
            if ([model.fieldName isEqualToString:@"VehicleStaffId"]) {
                [self update_VehicleStaffId_View:model];
            }
            if ([model.fieldName isEqualToString:@"ProjId"]) {
                [self update_ProjId_View:model];
            }
            if ([model.fieldName isEqualToString:@"ClientId"]) {
                [self update_ClientId_View:model];
            }
            if ([model.fieldName isEqualToString:@"SupplierId"]) {
                [self update_SupplierId_View:model];
            }
            if ([model.fieldName isEqualToString:@"CarNo"]) {
                [self update_CarNo_View:model];
            }
            if ([model.fieldName isEqualToString:@"Attachments"]) {
                [self update_AttachtsView_View:model];
            }
            if ([model.fieldName isEqualToString:@"Driver"]) {
                [self update_Driver_View:model];
            }
            if ([model.fieldName isEqualToString:@"DriverTel"]) {
                [self update_DriverTel_View:model];
            }
            if ([model.fieldName isEqualToString:@"Entourage"]) {
                [self update_Entourage_View:model];
            }
            if ([model.fieldName isEqualToString:@"VehicleType"]) {
                [self update_VehicleType_View:model];
            }
            if ([model.fieldName isEqualToString:@"Remark"]) {
                [self update_Remark_View:model];
            }
            if ([model.fieldName isEqualToString:@"Mileage"]) {
                [self update_Mileage_View:model];
            }
            if ([model.fieldName isEqualToString:@"Reserved1"]) {
                [self update_Reserved1_View:model];
            }
            if ([model.fieldName isEqualToString:@"ApprovalMode"]) {
                if (_comeStatus==3||_comeStatus==4) {
                    [self update_Approve_View:model];
                }
            }
        }
        if ([model.fieldName isEqualToString:@"VehicleStaff"]) {
            _Lab_VehicleStaffId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"ClientName"])) {
            _Lab_ClientId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"ProjName"])) {
            _Lab_ProjId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"SupplierName"])) {
            _Lab_SupplierId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"EntourageId"])) {
            if (![NSString isEqualToNull:model.fieldValue]) {
                _str_Entourage = _str_VehicleStaffId;
                _Txf_Entourage.text = _str_VehicleStaff;
            }
        }
    }
    if (_arr_Approve.count!=0) {
        [self updateNotesTableView_ap];
    }
    
    [self updateBottomView_ap];
}

-(void)updateLineState:(MyProcurementModel *)model{
    if ([model.isShow integerValue]==1) {
        if ([model.fieldName isEqualToString:@"Reason"]||[model.fieldName isEqualToString:@"DepartCity"]||[model.fieldName isEqualToString:@"BackCity"]||[model.fieldName isEqualToString:@"VehicleDate"]||[model.fieldName isEqualToString:@"BackDate"]||[model.fieldName isEqualToString:@"VehicleStaffId"]||[model.fieldName isEqualToString:@"ProjId"]||[model.fieldName isEqualToString:@"ClientId"]||[model.fieldName isEqualToString:@"SupplierId"]) {
            _int_line2 = 1;
        }
        if ([model.fieldName isEqualToString:@"CarNo"]||[model.fieldName isEqualToString:@"Driver"]||[model.fieldName isEqualToString:@"DriverTel"]) {
            _int_line3 = 1;
        }
    }
}



//更新物品领用审批人
-(void)update_Approve_View:(MyProcurementModel *)model{
    model.Description=Custing(@"审批人", nil);
    model.fieldValue=@"";
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.Img_Approve = image;
        [self SecondApproveClick:[UIButton new]];
    }];
    [_View_Approve addSubview:view];
}


//更新用车事由
-(void)update_Reason_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新出发地
-(void)update_DepartCity_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_DepartCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_DepartCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新返回地点
-(void)update_BackCity_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_BackCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BackCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新用车时间
-(void)update_VehicleDate_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_VehicleDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_VehicleDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新返回时间
-(void)update_BackDate_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_BackDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BackDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新同车人员
-(void)update_VehicleStaffId_View:(MyProcurementModel *)model{
    _Lab_VehicleStaffId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_VehicleStaffId addSubview:[XBHepler creation_Lable:_Lab_VehicleStaffId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_VehicleStaffId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _Lab_VehicleStaffId.text = @"";
}

//更新项目名称
-(void)update_ProjId_View:(MyProcurementModel *)model{
    _Lab_ProjId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_ProjId addSubview:[XBHepler creation_Lable:_Lab_ProjId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ProjId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _Lab_ProjId.text = @"";
}

//更新客户
-(void)update_ClientId_View:(MyProcurementModel *)model{
    _Lab_ClientId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_ClientId addSubview:[XBHepler creation_Lable:_Lab_ClientId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ClientId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _Lab_ClientId.text = @"";
}

//更新供应商
-(void)update_SupplierId_View:(MyProcurementModel *)model{
    _Lab_SupplierId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_SupplierId addSubview:[XBHepler creation_Lable:_Lab_SupplierId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_SupplierId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _Lab_SupplierId.text = @"";
}

//更新车辆
-(void)update_CarNo_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_CarNo = [UITextField new];
        [_View_CarNo addSubview:[XBHepler creation_Txf_Right:_Txf_CarNo model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_CarNo updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-30, 24)];
        [_View_CarNo addSubview:btn];
        [btn addTarget:self action:@selector(CarNO_Click:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_View_CarNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_CarNo updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新司机
-(void)update_Driver_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_Driver = [UITextField new];
        [_View_Driver addSubview:[XBHepler creation_Txf_Right:_Txf_Driver model:model Y:0 block:^(NSInteger height) {
            weakSelf.Txf_Driver.userInteractionEnabled = NO;
            [weakSelf.View_Driver updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-30, 32)];
        btn.tag=2;
        [_View_Driver addSubview:btn];
        [btn addTarget:self action:@selector(Entourage_Click:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_View_Driver addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Driver updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新司机电话
-(void)update_DriverTel_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_DriverTel = [UITextField new];
        [_View_DriverTel addSubview:[XBHepler creation_Txf:_Txf_DriverTel model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_DriverTel updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }else{
        [_View_DriverTel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_DriverTel updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新同行人
-(void)update_Entourage_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_Entourage = [UITextField new];
        [_View_Entourage addSubview:[XBHepler creation_Txf_Right:_Txf_Entourage model:model Y:0 block:^(NSInteger height) {
            weakSelf.Txf_Entourage.userInteractionEnabled = NO;
            [weakSelf.View_Entourage updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-30, 32)];
        [_View_Entourage addSubview:btn];
        btn.tag=1;
        [btn addTarget:self action:@selector(Entourage_Click:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_View_Entourage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Entourage updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新用车类型
-(void)update_VehicleType_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_VehicleType = [UITextField new];
        [_View_VehicleType addSubview:[XBHepler creation_Txf_Right:_Txf_VehicleType model:model Y:0 block:^(NSInteger height) {
            weakSelf.Txf_VehicleType.userInteractionEnabled = NO;
            [weakSelf.View_VehicleType updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-30, 32)];
        [_View_VehicleType addSubview:btn];
        [btn addTarget:self action:@selector(VehicleType_Click:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_View_VehicleType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_VehicleType updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新备注
-(void)update_Remark_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_isAdminStaff&&_comeStatus == 3) {
        _Txf_Remark = [UITextField new];
        [_View_Remark addSubview:[XBHepler creation_Txf:_Txf_Remark model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }else{
        [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新行驶里程(KM)
-(void)update_Mileage_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (_IsDriver&&_comeStatus == 3) {
        _Txf_Mileage = [UITextField new];
        [_View_Mileage addSubview:[XBHepler creation_Txf:_Txf_Mileage model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Mileage updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }else{
        [_View_Mileage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_Mileage updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}

//更新物品领用图片
-(void)update_AttachtsView_View:(MyProcurementModel *)model{
    if (_isAdminStaff &&_comeStatus == 3) {
        EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_Attachments withEditStatus:1 withModel:model];
        view.maxCont=5;
        [_View_Attachments addSubview:view];
        [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
    }else{
        if (_totalArray.count>0) {
            EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_Attachments withEditStatus:2 withModel:model];
            view.maxCont=5;
            [_View_Attachments addSubview:view];
            [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
        }
    }
}

//更新自定义字段
-(void)update_Reserved1_View:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved1 addSubview:[ReserverdLookMainView initArr:_arr_MainView view:_View_Reserved1 block:^(NSInteger height) {
        [weakSelf.View_Reserved1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//审批记录
-(void)updateNotesTableView_ap{
    __weak typeof(self) weakSelf = self;
    [_View_FiveView addSubview:[[FlowChartView alloc] init:_arr_Approve Y:0 HeightBlock:^(NSInteger height) {
        [weakSelf.View_FiveView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
            make.top.equalTo(weakSelf.View_Approve.bottom).offset(@10);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}

//更新底层视图
-(void)updateBottomView_ap{
    [_View_TwoView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_SupplierId.bottom);
    }];
    
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_FiveView.bottom).offset(@10);
    }];
    
    if (_int_line1 == 1) {
        [_view_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line2 == 1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line3 == 1) {
        [_view_line3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
}

#pragma mark data
-(void)initializeData{
    _dic_request = [NSDictionary dictionary];
    _dic_approve = [NSDictionary dictionary];
    _dic_operatorUser = [NSDictionary dictionary];
    _canEndorsel = @"";
    _str_Entourage = @"";
    _str_VehicleStaffId = @"";
    _str_VehicleStaff = @"";
    _arr_MainView = [NSMutableArray array];
    _arr_Approve = [NSMutableArray array];
    _muarr_Entourage = [NSMutableArray array];
    _isAdminStaff = NO;
    _DriverUserId=@"";
    _IsDriver=NO;
    _int_line1 = 0;
    _int_line2 = 0;
    _int_line3 = 0;
    _twoHandeId=@"";
    _twoApprovalName=@"";
    
    _imageDataString=@"";
    _imagesArray=[NSMutableArray array];
    _totalArray=[NSMutableArray array];
    _imageTypeArray=[NSMutableArray array];
    self.FormData = [[FormBaseModel alloc]initBaseWithStatus:2];
    self.FormData.str_flowCode=@"F0014";

}

-(void)analysisRequestData{
    NSDictionary *result=[_dic_request objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _canEndorsel=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"canEndorse"]]]?[NSString stringWithFormat:@"%@",result[@"canEndorse"]]:@"0";
        //默认申请人及相关数据
        _FormData.str_SerialNo = [NSString isEqualToNull:result[@"serialNo"]]?[NSString stringWithFormat:@"%@",result[@"serialNo"]]:@"";
        
        self.arr_More=[NSMutableArray arrayWithArray:@[@1,@2,@3]];
        //是否显示打印
        if (![[NSString stringWithFormat:@"%@",result[@"isPrint"]]isEqualToString:@"1"]) {
            [self.arr_More removeObject:@3];
        }
        if (self.comeStatus!=3) {
            [self.arr_More removeObject:@2];
        }
        
        
        _isAdminStaff = [[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"isAdminStaff"] ]integerValue]==0?NO:YES;
        _IsDriver = [[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"isDriver"]] integerValue]==0?NO:YES;
       
        _dic_operatorUser = [result objectForKey:@"operatorUser"];
        _flowGuid=[NSString stringWithFormat:@"%@",result[@"flowGuid"]];
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dic in mainFld) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_arr_MainView addObject:model];
                    [_FormData getMainFormShowAndData:dic WithAttachmentsMaxCont:5];
                    //解析图片
                    if ([dic[@"fieldName"] isEqualToString:@"Attachments"]) {
                        if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                            _imageDataString=model.fieldValue;
                            NSArray *array=(NSArray *)[self transformToTypeFromJsonString:[NSString stringWithFormat:@"%@",model.fieldValue]];
                            for (NSDictionary *dict in array) {
                                [_totalArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:_totalArray WithImageArray:_imagesArray WithMaxConut:5];
                        }else{
                            _imageDataString=@"";
                        }
                    }
                    if ([model.fieldName isEqualToString:@"EntourageId"]) {
                        _str_Entourage = model.fieldValue;
                    }
                    if ([model.fieldName isEqualToString:@"VehicleStaffId"]) {
                        _str_VehicleStaffId = model.fieldValue;
                    }
                    if ([model.fieldName isEqualToString:@"VehicleStaff"]) {
                        _str_VehicleStaff = model.fieldValue;
                    }
                }
            }
        }
        
        [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:_dic_request[@"result"] WithFormArray:_arr_MainView];
    }
}
-(void)analysisApproveData{
    NSDictionary *result=[_dic_approve objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _FormData.str_noteStatus = [NSString stringWithFormat:@"%@",result[@"statusCode"]];
        NSArray *array=result[@"taskProcList"];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model=[[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_arr_Approve addObject:model];
        }
    }
}

//同意数据处理
-(void)dealWithData{
    NSDictionary *travelDict;
    if (_isAdminStaff) {
        NSArray *travelFieldName=[NSArray arrayWithObjects:
                                  @"Attachments",
                                  @"FirstHandlerUserId",
                                  @"FirstHandlerUserName",
                                  @"CarNo",
                                  @"Driver",
                                  @"DriverTel",
                                  @"Remark",
                                  @"Mileage",
                                  @"Entourage",
                                  @"EntourageId",
                                  @"VehicleType",
                                  @"DriverUserId",nil];
        if (![NSString isEqualToNull:_twoHandeId]) {
            _twoHandeId=@"";
        }
        NSMutableArray *travelfieldValues=[NSMutableArray arrayWithArray:@[
                                    (_totalArray.count!=0)?@"1":@"",
                                    _twoHandeId,
                                    _twoApprovalName,
                                    [NSString isEqualToNull:_Model_CarNo.carNo]?[NSString stringWithFormat:@"%@/%@",_Model_CarNo.carDesc,_Model_CarNo.carNo]:@"",
                                    [NSString isEqualToNull:_Txf_Driver.text]?_Txf_Driver.text:@"",
                                    [NSString isEqualToNull:_Txf_DriverTel.text]?_Txf_DriverTel.text:@"",
                                    [NSString isEqualToNull:_Txf_Remark.text]?_Txf_Remark.text:@"",
                                    [NSString isEqualToNull:_Txf_Mileage.text]?_Txf_Mileage.text:(id)[NSNull null],
                                    [NSString isEqualToNull:_Txf_Entourage.text]?_Txf_Entourage.text:@"",
                                    [NSString isEqualToNull:_str_Entourage]?_str_Entourage:@"",
                                    [NSString isEqualToNull:_Txf_VehicleType.text]?_Txf_VehicleType.text:@"",
                                    _DriverUserId]];
        
        travelDict = @{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_VehicleApp"]};
    }else if (_IsDriver) {
        NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"Mileage",nil];
        if (![NSString isEqualToNull:_twoHandeId]) {
            _twoHandeId=@"";
        }
        NSArray *travelfieldValues=[NSArray arrayWithObjects:_twoHandeId,_twoApprovalName,[NSString isEqualToNull:_Txf_Mileage.text]?_Txf_Mileage.text:@"", nil];
        travelDict = @{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_VehicleApp"]};
    }else{
        NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",nil];
        if (![NSString isEqualToNull:_twoHandeId]) {
            _twoHandeId=@"";
        }
        NSArray *travelfieldValues=[NSArray arrayWithObjects:_twoHandeId,_twoApprovalName, nil];
        travelDict = @{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_VehicleApp"]};
    }
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    _parametersDict=@{@"mainDataList":mainArray};
}

-(BOOL)testData{
    BOOL bo = YES;
    NSString * str = @"";
    for (MyProcurementModel *model  in _arr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.isRequired] isEqualToString:@"1"] ) {
            if (_isAdminStaff) {
                if ([model.fieldName isEqualToString:@"CarNo"]&&![NSString isEqualToNull:_Txf_CarNo.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"Driver"]&&![NSString isEqualToNull:_Txf_Driver.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"DriverTel"]&&![NSString isEqualToNull:_Txf_DriverTel.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"Remark"]&&![NSString isEqualToNull:_Txf_Remark.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if (_IsDriver&&[model.fieldName isEqualToString:@"Mileage"]&&![NSString isEqualToNull:_Txf_Mileage.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"Entourage"]&&![NSString isEqualToNull:_Txf_Entourage.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"VehicleType"]&&![NSString isEqualToNull:_Txf_VehicleType.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if (_isAdminStaff&&[model.fieldName isEqualToString:@"Attachments"]&&_totalArray.count==0) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                    break;
                }
            }else{
                if (_IsDriver&&[model.fieldName isEqualToString:@"Mileage"]&&![NSString isEqualToNull:_Txf_Mileage.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
            }
          
        }
    }
    if (!bo) {
        _dockView.userInteractionEnabled = YES;
        [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:1.0];
    }
    return bo;
}

-(NSArray*)transformToNSArrayFromString:(NSString*)string{
    
    NSData* jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return (NSArray*)jsonObject;
}

#pragma mark network
-(void)requestGetContractVehicleData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",VehicleAppGetFormData];
    NSDictionary *parameters = @{@"TaskId": _taskId,@"ProcId":_procId?_procId:@"",@"FlowCode":@"F0014"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取审批记录
-(void)requestApproveNote{
    NSString *url=[NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}

#pragma mark - action
-(void)CarNO_Click:(UIButton *)btn{
    SelectViewController *selec = [[SelectViewController alloc]init];
    selec.type = 8;
    selec.delegate = self;
    [self.navigationController pushViewController:selec animated:YES];
}

-(void)Entourage_Click:(UIButton *)btn{
    NSMutableArray *array;
    if (btn.tag==2) {
        array= [NSMutableArray array];
        NSArray *idarr = [_DriverUserId componentsSeparatedByString:@","];
        for (int i = 0 ; i<idarr.count ; i++) {
            NSDictionary *dic = @{@"requestorUserId":idarr[i]};
            [array addObject:dic];
        }
    }
    if (btn.tag == 1) {
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        contactVC.arrClickPeople =_muarr_Entourage ;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio =@"2";
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            weakSelf.muarr_Entourage = [[NSMutableArray alloc]init];
            NSString *nameid = @"";
            for (int i = 0 ; i<array.count ; i++) {
                buildCellInfo *info = array[i];
                NSDictionary *dic = @{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]};
                if (i == 0) {
                    nameid = [NSString stringWithFormat:@"%ld",(long)info.requestorUserId];
                }
                else
                {
                    nameid = [NSString stringWithFormat:@"%@,%ld",nameid,(long)info.requestorUserId];
                }
                weakSelf.str_Entourage = nameid;
                [weakSelf.muarr_Entourage addObject:dic];
            }
            
            NSString *name = @"";
            for (int i = 0; i<array.count; i++) {
                buildCellInfo *info = array[i];
                if (i == 0) {
                    name = info.requestor;
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@,%@",name,info.requestor];
                }
            }
            if (![NSString isEqualToNull:name]) {
                weakSelf.Txf_Entourage.text = @"";
            }
            else
            {
                weakSelf.Txf_Entourage.text = name;
            }
        }];
        [self.navigationController pushViewController:contactVC animated:YES];
    }else{
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"2";
        contactVC.arrClickPeople =(btn.tag==1?_muarr_Entourage:array) ;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio =(btn.tag==1?@"2":@"1");
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            buildCellInfo *bul = array.lastObject;
            weakSelf.DriverUserId=[NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]?[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]:@"";
            weakSelf.Txf_Driver.text= bul.requestor;
        }];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    
}

-(void)VehicleType_Click:(UIButton *)btn{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
       weakSelf.Txf_VehicleType.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",Model.Type]]?[NSString stringWithFormat:@"%@",Model.Type]:@"";
    }];
    picker.typeTitle=Custing(@"用车类型", nil);
    NSMutableArray *arr=[NSMutableArray array];
    [STOnePickModel getVehicleType:arr];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:arr];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Type=[NSString isEqualToNull: _Txf_VehicleType.text]?_Txf_VehicleType.text:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker show];
}

//审批人点击
-(void)SecondApproveClick:(UIButton *)btn{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [_twoHandeId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"1";
    contactVC.Radio = @"1";
    contactVC.arrClickPeople = array;
    contactVC.menutype=4;
    contactVC.itemType = 14;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.twoApprovalName = bul.requestor;
        weakSelf.twoHandeId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.txf_Approver.text= bul.requestor;
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = [GPUtils transformToDictionaryFromString:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                [weakSelf.Img_Approve sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
            }else{
                weakSelf.Img_Approve.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
            }
        }else{
            weakSelf.Img_Approve.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//退单
-(void)backclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"0";
    exa.FlowCode = @"F0014";
    [self.navigationController pushViewController:exa animated:YES];
}

//撤回操作
-(void)reCallBack:(UIButton *)btn{
    _dockView.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"FlowCode":@"F0014",@"TaskId":_taskId};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",RecallList];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache :NO];
}

//拒绝 改为加签
-(void)refuseclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"1";
    exa.FlowCode = @"F0014";
    [self.navigationController pushViewController:exa animated:YES];
}

//同意
-(void)agreeclick:(UIButton *)btn
{
    [self dealWithData];
    if ([self testData]) {
        if (_isAdminStaff) {
            [self dealWithImagesArray];
        }else{
            examineViewController *exa = [[examineViewController alloc]init];
            exa.TaskId = _taskId;
            exa.ProcId = _procId;
            exa.Type = @"2";
            exa.FlowCode = @"F0014";
            exa.dic_APPROVAL = _parametersDict;
            [self.navigationController pushViewController:exa animated:YES];
        }
    }
}

#pragma mark  打印链接
-(void)GoToPush{
    self.PrintfBtn.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GETPrintLink];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:11 IfUserCache:NO];
}


#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"====%@",responceDic);

    _dockView.userInteractionEnabled = YES;
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self requestApproveNote];
        
    }
    if (serialNum == 1) {
        _dic_approve = responceDic;
        [self analysisApproveData];
        [self creationRootView];
        [self updateMainView];
    }
    if (serialNum == 4) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"撤回成功" duration:1.5];
        [self performBlock:^{
            if (self.comeStatus==2) {
                VehicleAppViewController *art=[[VehicleAppViewController alloc]init];
                art.taskId=self.taskId;
                art.comeStatus=4;
                art.backIndex=@"1";
                art.procId=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                [self.navigationController pushViewController:art animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        } afterDelay:1.0];
    }
    if (serialNum == 10) {
        boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@",ip_web,[responceDic objectForKey:@"result"]]];
        bo.str_title = Custing(@"流程图", nil);
        [self.navigationController pushViewController:bo animated:YES];
    }
    if (serialNum == 11) {
        self.PrintfBtn.userInteractionEnabled=YES;
        NSDictionary *dict = responceDic[@"result"];
        if (![dict isKindOfClass:[NSNull class]]) {
            [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                 @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                 @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                 @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                 @"flowCode":@"F0014",
                                                                 @"requestor":self.FormData.personalData.Requestor
                                                                 }]];
        }
    }
    if (serialNum == 6) {
        NSArray *array=(NSArray *)[self transformToTypeFromJsonString:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]]];
        for (int i=0; i<array.count; i++) {
            [_totalArray replaceObjectAtIndex:[_imageTypeArray[i] integerValue] withObject:array[i]];
        }
        _imageDataString=[self ImgAtttransformToJson:_totalArray];
        [self addImagesInfo];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dockView.userInteractionEnabled = YES;
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



-(void)SelectViewControllerClickedLoadBtn:(SelectDataModel *)selectmodel{
    _Txf_CarNo.text = [NSString stringWithFormat:@"%@/%@",selectmodel.carDesc,selectmodel.carNo];
    _Model_CarNo = selectmodel;
}


#pragma mark--处理图片数组
-(void)dealWithImagesArray{
    if (_totalArray.count!=0) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSMutableArray *loadImageArray=[NSMutableArray array];
        _imageTypeArray=[NSMutableArray array];
        for (int i=0; i<_totalArray.count; i++) {
            ZLPhotoAssets *asset = _totalArray[i];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
//                [loadImageArray addObject:UIImageJPEGRepresentation([asset originImage], 0.4)];
                [loadImageArray addObject:[[asset originImage]dataForXBUpload]];
                [_imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
//                [loadImageArray addObject:UIImageJPEGRepresentation([asset thumbImage], 0.4)];
                [loadImageArray addObject:[[asset thumbImage]dataForXBUpload]];
                [_imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        if (loadImageArray.count!=0) {
            //图片上传处理
            NSString *url=[NSString stringWithFormat:@"%@",travelImgLoad];
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *name= [pickerFormatter stringFromDate:pickerDate];
            name=[name stringByReplacingOccurrencesOfString:@" " withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@"-" withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSMutableArray *names=[[NSMutableArray alloc]init];
            for (int i=0; i<loadImageArray.count; i++) {
                [names addObject:[NSString stringWithFormat:@"%@%d",name,i]];
            }
            [[GPClient shareGPClient]RequestByPostOnImageWithPath:url Parameters:nil NSArray:loadImageArray name:names type:@"image/png" Delegate:self SerialNum:6 IfUserCache:NO];
        }else{
            _imageDataString=[self ImgAtttransformToJson:_totalArray];
            [self addImagesInfo];
        }
    }else{
        
        _imageDataString=@"";
        [self addImagesInfo];
    }
    
}
#pragma mark--图片信息添加
-(void)addImagesInfo{
    NSLog(@"%@",_parametersDict);
    NSUInteger index=[_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Attachments"];
    [_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:_imageDataString];
    
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"2";
    exa.FlowCode = @"F0014";
    exa.dic_APPROVAL = _parametersDict;
    [self.navigationController pushViewController:exa animated:YES];
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
