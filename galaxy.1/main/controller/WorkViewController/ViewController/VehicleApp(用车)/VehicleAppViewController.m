//
//  VehicleAppViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VehicleAppViewController.h"
#import "ChooseCateFreshController.h"
#import "VehicleAppModel.h"
#import "ArticleConsuming_operatorUser_Model.h"

@interface VehicleAppViewController ()<GPClientDelegate,UITextViewDelegate>

//请求数据
@property (nonatomic, strong) NSDictionary *dic_request;//请求后保存的数据
@property (nonatomic, strong) NSMutableArray *muarr_MainView;
@property (nonatomic, strong) NSDictionary *dic_Submit;
@property (nonatomic, strong) VehicleAppModel *Model_Submit;
@property (nonatomic, strong) ArticleConsuming_operatorUser_Model *Model_User;
@property (nonatomic, strong) MyProcurementModel *ApprovelPeoModel;

//框架用view
@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView
@property (nonatomic, strong) UIView *DockBottomView;//底部视图
@property (nonatomic, strong) DoneBtnView * dockView; //底部按钮视图
@property (nonatomic, strong) UIButton *Btn_save;//保存按钮
@property (nonatomic, strong) UIButton *Btn_submit;//提交按钮
@property (nonatomic, strong) UIButton *Btn_backSub;//退单提交按钮
@property (nonatomic, strong) UIButton *Btn_Direct;//直送按钮

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;
@property (nonatomic, strong) FormBaseModel *FormData;
//用车事由
@property (nonatomic, strong) UIView *View_Reason;
@property (nonatomic, strong) UITextView *Txv_Reason;
//出发地
@property (nonatomic, strong) UIView *View_DepartCity;
@property (nonatomic, strong) UITextField *Txf_DepartCity;
//返回地点
@property (nonatomic, strong) UIView *View_BackCity;
@property (nonatomic, strong) UITextField *Txf_BackCity;
//用车时间
@property (nonatomic, strong) UIView *View_VehicleDate;
@property (nonatomic, strong) UITextField *Txf_VehicleDate;
//返回时间
@property (nonatomic, strong) UIView *View_BackDate;
@property (nonatomic, strong) UITextField *Txf_BackDate;
//同车人员
@property (nonatomic, strong) UIView *View_VehicleStaffId;
@property (nonatomic, strong) UITextField *Txf_VehicleStaffId;
@property (nonatomic, strong) NSString *Str_VehicleStaffId;
@property (nonatomic, strong) NSMutableArray *muarr_VehicleStaffId;
//项目名称
@property (nonatomic, strong) UIView *View_ProjId;
@property (nonatomic, strong) UITextField *Txf_ProjId;
@property (nonatomic, strong) NSString *Str_ProjId;
@property (nonatomic, copy) NSString *Str_ProjMgrId;
@property (nonatomic, copy) NSString *Str_ProjMgrName;
//客户
@property (nonatomic, strong) UIView *View_ClientId;
@property (nonatomic, strong) UITextField *Txf_ClientId;
@property (nonatomic, strong) NSString *Str_ClientId;
//供应商
@property (nonatomic, strong) UIView *View_SupplierId;
@property (nonatomic, strong) UITextField *Txf_SupplierId;
@property (nonatomic, strong) NSString *Str_SupplierId;
//车辆
@property (nonatomic, strong) UIView *View_CarNo;
@property (nonatomic, strong) UITextField *Txf_CarNo;
//司机
@property (nonatomic, strong) UIView *View_Driver;
@property (nonatomic, strong) UITextField *Txf_Driver;
//司机电话
@property (nonatomic, strong) UIView *View_DriverTel;
@property (nonatomic, strong) UITextField *Txf_DriverTel;
//备注
@property (nonatomic, strong) UIView *View_Remark;
@property (nonatomic, strong) UITextView *txv_Remark;
//行驶里程(KM)
@property (nonatomic, strong) UIView *View_Mileage;
@property (nonatomic, strong) UITextField *Txf_Mileage;
//附件
@property (nonatomic, strong) UIView *View_Attachments;
@property (nonatomic, strong) UITextField *Txf_Attachments;
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSString *imageDataString;//上传服务器图片
@property (nonatomic, strong) NSMutableArray *imagesArray;//图片数组
@property (nonatomic, strong) NSMutableArray *imageTypeArray;

@property (nonatomic, strong) ReserverdMainModel *model_rs;
//自定义字段1
@property (nonatomic, strong) UIView *View_Reserved1;
//@property (nonatomic, strong) UITextField *Txf_Reserved1;
////自定义字段2
//@property (nonatomic, strong) UIView *View_Reserved2;
//@property (nonatomic, strong) UITextField *Txf_Reserved2;
////自定义字段3
//@property (nonatomic, strong) UIView *View_Reserved3;
//@property (nonatomic, strong) UITextField *Txf_Reserved3;
////自定义字段4
//@property (nonatomic, strong) UIView *View_Reserved4;
//@property (nonatomic, strong) UITextField *Txf_Reserved4;
////自定义字段5
//@property (nonatomic, strong) UIView *View_Reserved5;
//@property (nonatomic, strong) UITextField *Txf_Reserved5;
////自定义字段6
//@property (nonatomic, strong) UIView *View_Reserved6;
//@property (nonatomic, strong) UITextField *Txf_Reserved6;
////自定义字段7
//@property (nonatomic, strong) UIView *View_Reserved7;
//@property (nonatomic, strong) UITextField *Txf_Reserved7;
////自定义字段8
//@property (nonatomic, strong) UIView *View_Reserved8;
//@property (nonatomic, strong) UITextField *Txf_Reserved8;
////自定义字段9
//@property (nonatomic, strong) UIView *View_Reserved9;
//@property (nonatomic, strong) UITextField *Txf_Reserved9;
////自定义字段10
//@property (nonatomic, strong) UIView *View_Reserved10;
//@property (nonatomic, strong) UITextField *Txf_Reserved10;
@property (nonatomic,strong)UIView *NoteView;//审批记录
@property (nonatomic,strong)NSMutableArray *noteDateArray;//审批记录数据
@property(nonatomic,assign)NSInteger NotesTableHeight;//审批记录tableView高度

@property (nonatomic, strong) UIView *view_FirstHandlerUserName;//审批人view
@property (nonatomic, strong) UIImageView *ApproveImgView;//审批人头像
@property (nonatomic, strong) UITextField *txf_Approver;//审批人Label
@property (nonatomic, strong) NSString *firstHanderId;//第一审批人Id
@property (nonatomic, strong) NSString *firstHanderName;//第一审批人姓名
@property (nonatomic, assign) int firstHanderHeadView;//第一审批人头像
@property (nonatomic, strong) NSString *firstHandlerGender;//第一审批人性别
@property (nonatomic, strong) buildCellInfo *firstinfo;//代理人

@property (nonatomic, assign) NSInteger int_Sub_State;

@property (nonatomic, assign) BOOL isAdminStaff;
@property (nonatomic, strong) NSString *str_directType;

@end

static NSString *const CellIdentifier = @"VehicleCell";

@implementation VehicleAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeData];
    NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowCode];
    [self setTitle:dict[@"Title"] backButton:YES];
    [self requestVehicleAppGetVehicleAppData];
}

#pragma mark - function
#pragma mark 视图
-(void)creationRootView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    
    self.view_ContentView =[[BottomView alloc]init];
    self.view_ContentView.userInteractionEnabled=YES;
    self.view_ContentView.backgroundColor=Color_White_Same_20;
    [_scr_RootScrollView addSubview:self.view_ContentView];
    
    
    [self.view_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_RootScrollView);
        make.width.equalTo(self.scr_RootScrollView);
    }];
}

-(void)creationDockView{
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    UIButton *btn = [UIButton new];
    if (_comeStatus==1||_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 5;
                [weakSelf btn_Click:btn];
            }else{
                btn.tag = 6;
                [weakSelf btn_Click:btn];
            }
        };
    }else if (_comeStatus==3&&![_str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 4;
                [weakSelf btn_Click:btn];
            }else{
                btn.tag = 3;
                [weakSelf btn_Click:btn];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 3;
                [weakSelf btn_Click:btn];
            }
        };
    }
}

-(void)creationMainView{
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.view_ContentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ContentView.top);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_DepartCity = [[UIView alloc]init];
    _View_DepartCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_DepartCity];
    [_View_DepartCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_BackCity = [[UIView alloc]init];
    _View_BackCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_BackCity];
    [_View_BackCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DepartCity.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_VehicleDate = [[UIView alloc]init];
    _View_VehicleDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_VehicleDate];
    [_View_VehicleDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackCity.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_BackDate = [[UIView alloc]init];
    _View_BackDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_BackDate];
    [_View_BackDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleDate.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_VehicleStaffId = [[UIView alloc]init];
    _View_VehicleStaffId.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_VehicleStaffId];
    [_View_VehicleStaffId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackDate.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_ProjId = [[UIView alloc]init];
    _View_ProjId.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_ProjId];
    [_View_ProjId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleStaffId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_ClientId = [[UIView alloc]init];
    _View_ClientId.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_ClientId];
    [_View_ClientId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ProjId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_SupplierId = [[UIView alloc]init];
    _View_SupplierId.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_SupplierId];
    [_View_SupplierId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClientId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_CarNo = [[UIView alloc]init];
    _View_CarNo.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_CarNo];
    [_View_CarNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SupplierId.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_Driver = [[UIView alloc]init];
    _View_Driver.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Driver];
    [_View_Driver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CarNo.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _View_DriverTel = [[UIView alloc]init];
    _View_DriverTel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_DriverTel];
    [_View_DriverTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Driver.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Reserved1 = [[UIView alloc]init];
    _View_Reserved1.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Reserved1];
    [_View_Reserved1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DriverTel.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved1.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Mileage = [[UIView alloc]init];
    _View_Mileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Mileage];
    [_View_Mileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    _View_Attachments = [[UIView alloc]init];
    _View_Attachments.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Attachments];
    [_View_Attachments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Mileage.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
   
    _NoteView = [[UIView alloc]init];
    _NoteView.layer.cornerRadius = 10.0f;
    _NoteView.backgroundColor=[UIColor whiteColor];
    _NoteView.layer.shadowOffset = CGSizeMake(0, 1);
    _NoteView.layer.shadowOpacity = 0.25;
    _NoteView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    _NoteView.layer.shadowOffset = CGSizeMake(2, 2);
    [self.view_ContentView addSubview:_NoteView];
    [_NoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Attachments.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    
    //审批人
    _view_FirstHandlerUserName=[[UIView alloc]init];
    _view_FirstHandlerUserName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview: _view_FirstHandlerUserName];
    [_view_FirstHandlerUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NoteView.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
    _DockBottomView=[[UIView alloc]init];
    _DockBottomView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_DockBottomView];
    [_DockBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_FirstHandlerUserName.bottom);
        make.left.equalTo(self.view_ContentView.left);
        make.right.equalTo(self.view_ContentView.right);
    }];
}

-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:_muarr_MainView WithRequireDict:[NSMutableDictionary dictionary] WithUnShowArray:[NSMutableArray array] WithSumbitBaseModel:self.FormData Withcontroller:self];

    for (MyProcurementModel *model in _muarr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]) {
                [self updateReasonViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"DepartCity"]) {
                [self updateDepartCityViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"BackCity"]) {
                [self updateBackCityViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"VehicleDate"]) {
                [self updateVehicleDateViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"BackDate"]) {
                [self update_BackDateViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"VehicleStaffId"]) {
                [self update_VehicleStaffIdViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"ProjId"]) {
                [self update_ProjIdViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"ClientId"]) {
                [self update_ClientIdViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"SupplierId"]) {
                [self update_SupplierIdViewWithModel:model];
            }
            if (_isAdminStaff) {
                if ([model.fieldName isEqualToString:@"CarNo"]) {
                    [self update_CarNoViewWithModel:model];
                }
                if ([model.fieldName isEqualToString:@"Driver"]) {
                    [self update_DriverViewWithModel:model];
                }
                if ([model.fieldName isEqualToString:@"DriverTel"]) {
                    [self update_DriverTelViewWithModel:model];
                }
                if ([model.fieldName isEqualToString:@"Mileage"]) {
                    [self update_MileageViewWithModel:model];
                }
                if ([model.fieldName isEqualToString:@"Remark"]) {
                    [self updateRemarkViewWithModel:model];
                }
                if ([model.fieldName isEqualToString:@"Attachments"]) {
                    [self update_AttachmentsViewWithModel:model];
                }
            }
            if ([model.fieldName isEqualToString:@"Reserved1"])
            {
                [self update_Reserved1ViewWithModel:model];
            }
            if ([model.fieldName isEqualToString:@"ApprovalMode"]){
                [self updateFirstHandlerUserNameViewWithModel:_ApprovelPeoModel];
            }
        }
        if (([model.fieldName isEqualToString:@"ProjName"])) {
            _Txf_ProjId.text = model.fieldValue;
        }
        if ([model.fieldName isEqualToString:@"ClientName"]) {
            _Txf_ClientId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"SupplierName"])) {
            _Txf_SupplierId.text = model.fieldValue;
        }
        if (([model.fieldName isEqualToString:@"VehicleStaff"])) {
            _Txf_VehicleStaffId.text = model.fieldValue;
        }
    }
}

//更新用车事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _Txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_Txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Reason addSubview:view];
}

//更新出发地视图
-(void)updateDepartCityViewWithModel:(MyProcurementModel *)model{
    _Txf_DepartCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DepartCity WithContent:_Txf_DepartCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DepartCity addSubview:view];
}

//更新返回地点视图
-(void)updateBackCityViewWithModel:(MyProcurementModel *)model{
    _Txf_BackCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackCity WithContent:_Txf_BackCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BackCity addSubview:view];
}

//更新用车时间视图
-(void)updateVehicleDateViewWithModel:(MyProcurementModel *)model{
    _Txf_VehicleDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_VehicleDate WithContent:_Txf_VehicleDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_VehicleDate addSubview:view];
}

//更新返回时间视图
-(void)update_BackDateViewWithModel:(MyProcurementModel *)model{
    _Txf_BackDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackDate WithContent:_Txf_BackDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BackDate addSubview:view];
}

//更新同车人员视图
-(void)update_VehicleStaffIdViewWithModel:(MyProcurementModel *)model{
    _Txf_VehicleStaffId=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_VehicleStaffId WithContent:_Txf_VehicleStaffId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_VehicleStaffId addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        contactVC.arrClickPeople = weakSelf.muarr_VehicleStaffId;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio = @"2";
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            weakSelf.muarr_VehicleStaffId = [[NSMutableArray alloc]init];
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
                weakSelf.Str_VehicleStaffId = nameid;
                [weakSelf.muarr_VehicleStaffId addObject:dic];
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
                weakSelf.Txf_VehicleStaffId.text = @"";
            }else{
                weakSelf.Txf_VehicleStaffId.text = name;
            }
        }];
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _Str_VehicleStaffId = model.fieldValue;
    }
}

//更新项目名称视图
-(void)update_ProjIdViewWithModel:(MyProcurementModel *)model{
    _Txf_ProjId=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ProjId WithContent:_Txf_ProjId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ProjId addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
        vc.ChooseCategoryId = weakSelf.Str_ProjId;
        vc.ChooseCateFreBlock = ^(ChooseCateFreModel *model, NSString *type) {
            weakSelf.Str_ProjId=model.Id;
            weakSelf.Txf_ProjId.text = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
            weakSelf.Str_ProjMgrId = model.projMgrUserId;
            weakSelf.Str_ProjMgrName = model.projMgr;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _Str_ProjId = model.fieldValue;
    }
}

//更新客户视图
-(void)update_ClientIdViewWithModel:(MyProcurementModel *)model{
    _Txf_ClientId=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ClientId WithContent:_Txf_ClientId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ClientId addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
        vc.ChooseCategoryId=weakSelf.Str_ClientId;
        vc.ChooseCateFreBlock = ^(ChooseCateFreModel *model, NSString *type) {
            weakSelf.Str_ClientId = model.Id;
            weakSelf.Txf_ClientId.text =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _Str_ClientId = model.fieldValue;
    }
}

//更新供应商视图
-(void)update_SupplierIdViewWithModel:(MyProcurementModel *)model{
    _Txf_SupplierId=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SupplierId WithContent:_Txf_SupplierId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_SupplierId addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
        vc.ChooseCategoryId = weakSelf.Str_SupplierId;
        vc.ChooseCateFreBlock = ^(ChooseCateFreModel *model, NSString *type) {
            weakSelf.Str_SupplierId = model.Id;
            weakSelf.Txf_SupplierId.text =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _Str_SupplierId = model.fieldValue;
    }
}

//更新车辆视图
-(void)update_CarNoViewWithModel:(MyProcurementModel *)model{
    _Txf_CarNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CarNo WithContent:_Txf_CarNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CarNo addSubview:view];
}

//更新司机视图
-(void)update_DriverViewWithModel:(MyProcurementModel *)model{
    _Txf_Driver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Driver WithContent:_Txf_Driver WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Driver addSubview:view];
}

//更新司机电话视图
-(void)update_DriverTelViewWithModel:(MyProcurementModel *)model{
    _Txf_DriverTel=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DriverTel WithContent:_Txf_DriverTel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DriverTel addSubview:view];
}

//更新行驶里程(KM)视图
-(void)update_MileageViewWithModel:(MyProcurementModel *)model{
    _Txf_Mileage=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Mileage WithContent:_Txf_Mileage WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Mileage addSubview:view];
}

//更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}

//更新附件视图
-(void)update_AttachmentsViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_Attachments withEditStatus:1 withModel:model];
    view.maxCont=5;
    [_View_Attachments addSubview:view];
    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
}

//更新自定义字段视图
-(void)update_Reserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved1 addSubview:[[ReserverdMainView alloc]initArr:_muarr_MainView isRequiredmsdic:[NSMutableDictionary dictionary] reservedDic:[NSMutableDictionary dictionary] UnShowmsArray:[NSMutableArray array] view:_View_Reserved1 model:_model_rs block:^(NSInteger height) {
        [weakSelf.View_Reserved1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}


//更新采购审批人
-(void)updateFirstHandlerUserNameViewWithModel:(MyProcurementModel *)model{
    _txf_Approver = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_FirstHandlerUserName WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.ApproveImgView=image;
        UIButton *btn = [UIButton new];
        btn.tag = 7;
        [weakSelf btn_Click:btn];
    }];
    [_view_FirstHandlerUserName addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _txf_Approver.text=model.fieldValue;
    }
}

//更新滚动视图 基本方法
-(void)updateContentView{
    [_DockBottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
    }];
    [_DockBottomView addSubview:[self createUpLineView]];
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.DockBottomView.bottom);
    }];
}


#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _procId = self.pushProcId;
        _comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    if (_taskId == nil) {
        _taskId = @"";
    }
    if (_procId == nil) {
        _procId = @"";
    }
    _Str_ProjId = @"";
    _Str_ProjMgrId = @"";
    _Str_ProjMgrName = @"";
    _Str_SupplierId = @"";
    _Str_ClientId = @"";
    _str_directType = @"";
    _firstHanderName = @"";
    _firstHanderId = @"";
    _muarr_VehicleStaffId = [NSMutableArray array];
    _imagesArray = [NSMutableArray array];
    _imageTypeArray = [NSMutableArray array];
    _isAdminStaff = NO;
    _dic_Submit = [NSDictionary dictionary];
    _imagesArray = [NSMutableArray array];
    _totalArray = [NSMutableArray array];
    self.FormData=[[FormBaseModel alloc]initBaseWithStatus:1];
    self.FormData.str_flowCode=@"F0014";
    _model_rs = [[ReserverdMainModel alloc]init];
}

//处理请求后数据
-(void)analysisRequestData{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dic_request[@"result"][@"formFields"][@"mainFld"]];
    _muarr_MainView = [NSMutableArray array];
    _str_directType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"directType"]]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"directType"]]:@"0";
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [_muarr_MainView addObject:model];
            if ([model.fieldName isEqualToString:@"RequestorDept"]) {
                self.FormData.personalData.RequestorDept = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"RequestorDeptId"]) {
                self.FormData.personalData.RequestorDeptId = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Requestor"]) {
                self.FormData.personalData.Requestor = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"JobTitle"]) {
                self.FormData.personalData.JobTitle = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"JobTitleCode"]) {
                self.FormData.personalData.JobTitleCode = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Branch"]) {
                self.FormData.personalData.Branch = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"RequestorBusDept"]) {
                self.FormData.personalData.RequestorBusDept = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"RequestorDate"]) {
                self.FormData.personalData.RequestorDate = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Requestor"]) {
                self.FormData.personalData.Requestor = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"UserLevelId"]&&[NSString isEqualToNull:model.fieldValue]) {
                self.FormData.personalData.UserLevelId = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"UserLevel"]&&[NSString isEqualToNull:model.fieldValue]) {
                self.FormData.personalData.UserLevel = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Area"]&&[NSString isEqualToNull:model.fieldValue]) {
                self.FormData.personalData.Area = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"AreaId"]&&[NSString isEqualToNull:model.fieldValue]) {
                self.FormData.personalData.AreaId = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"FirstHandlerUserName"]) {
                _ApprovelPeoModel = model;
                _firstHanderName = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FirstHandlerUserId"]) {
                _firstHanderId = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"Attachments"]) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = [self transformToNSArrayFromString:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_totalArray addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_totalArray WithImageArray:_imagesArray WithMaxConut:5];
                }
            }
        }
    }
    if ([NSString isEqualToNull:_dic_request[@"result"][@"operatorUser"]]) {
        _Model_User = [[ArticleConsuming_operatorUser_Model alloc]initWithDict:_dic_request[@"result"][@"operatorUser"] ];
    }
    
    [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:_dic_request[@"result"] WithFormArray:_muarr_MainView];

}

//拼接上传数据
-(void)jointResponse{
    _Model_Submit = [[VehicleAppModel alloc]init];
    _Model_Submit.HRID = self.FormData.personalData.Hrid;
    if ([NSString isEqualToNull:self.FormData.personalData.BranchId]) {
        _Model_Submit.BranchId = [self.FormData.personalData.BranchId integerValue];
    }
    _Model_Submit.Branch = self.FormData.personalData.Branch;
    if ([NSString isEqualToNull:self.FormData.personalData.RequestorDeptId]) {
        _Model_Submit.RequestorDept = self.FormData.personalData.RequestorDept;
        _Model_Submit.RequestorDeptId = self.FormData.personalData.RequestorDeptId;
    }
    _Model_Submit.JobTitle = self.FormData.personalData.JobTitle;
    _Model_Submit.JobTitleCode = self.FormData.personalData.JobTitleCode;
    
    if ([NSString isEqualToNull:self.FormData.personalData.RequestorBusDeptId]) {
        _Model_Submit.RequestorBusDeptId = [self.FormData.personalData.RequestorBusDeptId integerValue];
    }
    _Model_Submit.UserLevel = self.FormData.personalData.UserLevel;
    _Model_Submit.UserLevelId = self.FormData.personalData.UserLevelId;
    _Model_Submit.Area = self.FormData.personalData.Area;
    _Model_Submit.AreaId = self.FormData.personalData.AreaId;
    _Model_Submit.Requestor = self.FormData.personalData.Requestor;
    _Model_Submit.RequestorBusDept = self.FormData.personalData.RequestorBusDept;
    _Model_Submit.RequestorDate = self.FormData.personalData.RequestorDate;
    _Model_Submit.UserReserved1 = self.FormData.personalData.UserReserved1;
    _Model_Submit.UserReserved2 = self.FormData.personalData.UserReserved2;
    _Model_Submit.UserReserved3 = self.FormData.personalData.UserReserved3;
    _Model_Submit.UserReserved4 = self.FormData.personalData.UserReserved4;
    _Model_Submit.UserReserved5 = self.FormData.personalData.UserReserved5;
    
//    _Model_Submit.ApproverId1=self.FormData.personalData.ApproverId1;
//    _Model_Submit.ApproverId2=self.FormData.personalData.ApproverId2;
//    _Model_Submit.ApproverId3=self.FormData.personalData.ApproverId3;
//    _Model_Submit.ApproverId4=self.FormData.personalData.ApproverId4;
//    _Model_Submit.ApproverId5=self.FormData.personalData.ApproverId5;
    _Model_Submit.UserLevelNo=self.FormData.personalData.UserLevelNo;
    
    
    
    _Model_Submit.Reason = _Txv_Reason.text;
    _Model_Submit.DepartCity = _Txf_DepartCity.text;
    if ([NSString isEqualToNull:_Str_VehicleStaffId]) {
        _Model_Submit.VehicleStaff = _Txf_VehicleStaffId.text;
        _Model_Submit.VehicleStaffId = [_Str_VehicleStaffId integerValue];
    }
    _Model_Submit.BackCity = _Txf_BackCity.text;
    if ([NSString isEqualToNull:_Str_ProjId]) {
        _Model_Submit.ProjName = _Txf_ProjId.text;
        _Model_Submit.ProjId = _Str_ProjId;
    }
    if ([NSString isEqualToNull:_Str_ClientId]) {
        _Model_Submit.ClientName = _Txf_ClientId.text;
        _Model_Submit.ClientId = [_Str_ClientId integerValue];
    }
    if ([NSString isEqualToNull:_Str_SupplierId]) {
        _Model_Submit.SupplierName = _Txf_SupplierId.text;
        _Model_Submit.SupplierId = [_Str_SupplierId integerValue];
    }
    if ([NSString isEqualToNull:_Txf_VehicleDate.text]) {
        _Model_Submit.VehicleDate = _Txf_VehicleDate.text;
    }
    if ([NSString isEqualToNull:_Txf_BackDate.text]) {
        _Model_Submit.BackDate = _Txf_BackDate.text;
    }
    _Model_Submit.FirstHandlerUserId = _firstHanderId;
    _Model_Submit.FirstHandlerUserName = _firstHanderName;
    _Model_Submit.RequestorUserId = _Model_User.requestorUserId;
    _Model_Submit.RequestorAccount = _Model_User.requestorAccount;
    _Model_Submit.CompanyId = _Model_User.companyId;
    _Model_Submit.TwohandlerUserId = nil;
    _Model_Submit.TwohandlerUserName = nil;
    
    _Model_Submit.Reserved1 = _model_rs.Reserverd1;
    _Model_Submit.Reserved2 = _model_rs.Reserverd2;
    _Model_Submit.Reserved3 = _model_rs.Reserverd3;
    _Model_Submit.Reserved4 = _model_rs.Reserverd4;
    _Model_Submit.Reserved5 = _model_rs.Reserverd5;
    _Model_Submit.Reserved6 = _model_rs.Reserverd6;
    _Model_Submit.Reserved7 = _model_rs.Reserverd7;
    _Model_Submit.Reserved8 = _model_rs.Reserverd8;
    _Model_Submit.Reserved9 = _model_rs.Reserverd9;
    _Model_Submit.Reserved10 = _model_rs.Reserverd10;
}

//拼接数据
-(void)mainDataList{
    NSMutableDictionary *dic_detailedDataList = [[NSMutableDictionary alloc]init];
    if ([NSString isEqualToNull:_Txf_VehicleStaffId.text]) {
        //拼接合同条款
        NSMutableArray *arr_Term_name = [NSMutableArray arrayWithArray:@[@"UserId",@"UserDspName",@"RequestorUserId"]];
        NSMutableArray *arr_term_value3 = [NSMutableArray array];
        NSMutableDictionary *dic_Term = [[NSMutableDictionary alloc]init];
        [dic_Term setObject:@"Sa_VehicleStaffDetail" forKey:@"tableName"];
        
        NSMutableArray *arr_term_value1 = [NSMutableArray arrayWithArray:[_Txf_VehicleStaffId.text componentsSeparatedByString:@","]];
        NSMutableArray *arr_term_value2 = [NSMutableArray arrayWithArray:[_Str_VehicleStaffId componentsSeparatedByString:@","]];
        
        for (int i = 0; i<arr_term_value1.count; i++) {
            [arr_term_value3 addObject:_Model_User.requestorUserId];
        }
        [dic_Term setObject:arr_Term_name forKey:@"fieldNames"];
        [dic_Term setObject:@[arr_term_value2,arr_term_value1,arr_term_value3] forKey:@"fieldBigValues"];
        
        [dic_detailedDataList addArray:@[dic_Term] forKey:@"detailedDataList"];
    }
    
    NSDictionary *dic = [NSObject getObjectData:_Model_Submit];
    NSMutableArray *arr_key = [NSMutableArray arrayWithArray:[dic allKeys]];
    NSMutableArray *arr_value = [NSMutableArray arrayWithArray:[dic allValues]];
    NSMutableArray *arr_mainDataList = [NSMutableArray arrayWithArray:@[@{@"fieldNames":arr_key,@"fieldValues":arr_value,@"tableName":@"Sa_VehicleApp"}]];
    [dic_detailedDataList setObject:arr_mainDataList forKey:@"mainDataList"];
    _dic_Submit = dic_detailedDataList;
}

//测试数据
-(BOOL)testData{
    BOOL bo = YES;
    NSString * str = @"";
    for (MyProcurementModel *model  in _muarr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.isRequired] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]&&![NSString isEqualToNull:_Txv_Reason.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"RequestorDeptId"]&&![NSString isEqualToNull:self.FormData.personalData.RequestorDept]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"BranchId"]&&![NSString isEqualToNull:self.FormData.personalData.BranchId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"AreaId"]&&![NSString isEqualToNull:self.FormData.personalData.AreaId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"UserLevelId"]&&![NSString isEqualToNull:self.FormData.personalData.UserLevelId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"JobTitleCode"]&&![NSString isEqualToNull:self.FormData.personalData.JobTitleCode]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]&&![NSString isEqualToNull:self.FormData.personalData.RequestorBusDeptId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"DepartCity"]&&![NSString isEqualToNull:_Txf_DepartCity.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"BackCity"]&&![NSString isEqualToNull:_Txf_BackCity.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"VehicleDate"]&&![NSString isEqualToNull:_Txf_VehicleDate.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"BackDate"]&&![NSString isEqualToNull:_Txf_BackDate.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"VehicleStaffId"]&&![NSString isEqualToNull:_Txf_VehicleStaffId.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"ProjId"]&&![NSString isEqualToNull:_Txf_ProjId.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"ClientId"]&&![NSString isEqualToNull:_Txf_ClientId.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                break;
            }
            if ([model.fieldName isEqualToString:@"SupplierId"]&&![NSString isEqualToNull:_Txf_SupplierId.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                break;
            }
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
                if ([model.fieldName isEqualToString:@"Remark"]&&![NSString isEqualToNull:_txv_Remark.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"Mileage"]&&![NSString isEqualToNull:_Txf_Mileage.text]) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
                    break;
                }
                if ([model.fieldName isEqualToString:@"Attachments"]&&_imagesArray.count>0) {
                    bo = NO;
                    str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved1"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd1]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved2"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd2]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved3"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd3]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved4"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd4]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved5"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd5]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved6"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd6]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved7"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd7]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved8"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd8]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved9"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd9]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
            if([model.fieldName isEqualToString:@"Reserved10"]) {
                if (![NSString isEqualToNull:_model_rs.Reserverd10]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[model.ctrlTyp isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                    break;
                }
            }
        }
        if([model.fieldName isEqualToString:@"ApprovalMode"]&&[[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"])
        {
            if (![NSString isEqualToNull:_firstHanderName] ) {
                bo = NO;
                str = Custing(@"请选择审批人",nil);
                break;
            }
        }
    }
    if (!bo) {
        _dockView.userInteractionEnabled = YES;
        [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:1.0];
    }
    return bo;
}

//处理图片请求
-(void)requestUploadImage{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:_totalArray WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.imageDataString=data;
            [weakSelf readyRequest];
        }
    }];
}

-(void)readyRequest
{
    NSUInteger index=[_dic_Submit[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Attachments"];
    [_dic_Submit[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:_imageDataString];
    //3退单 4直送 5保存 6提交
    if (_int_Sub_State == 3) {
        [self requestVehicleAppApprovalAppData];
    }else if(_int_Sub_State == 4){
        [self requestVehicleAppDirectAppData];
    }else if (_int_Sub_State == 5){
        [self requestVehicleAppSaveAppData];
    }else{
        [self requestVehicleAppSubmitAppData];
    }
}


#pragma mark  请求
//获取表单数据
-(void)requestVehicleAppGetVehicleAppData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetVehicleAppData];
    NSDictionary *parameters = @{@"TaskId": _taskId,@"ProcId":_procId?_procId:@"",@"FlowCode":@"F0014"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//保存表单数据
-(void)requestVehicleAppSaveAppData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = [self SaveFormDateUserId:[NSString stringWithFormat:@"%@",self.userdatas.userId] WithFlowGuid:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]] WithFlowCode:@"F0014" WithTaskId:_taskId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
    NSString *url =[NSString stringWithFormat:@"%@",SAVE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

//提交
-(void)requestVehicleAppSubmitAppData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",SUBMIT];
    //临时解析用的数据
    NSDictionary *parameters=[self SubmitFormDateUserId:[NSString stringWithFormat:@"%@",self.userdatas.userId] WithFlowGuid:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]] WithFlowCode:@"F0014" WithTaskId:_taskId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}

//撤回提交
-(void)requestVehicleAppApprovalAppData{
    if (_comeStatus==4) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",APPROVAL];
        NSDictionary *parameters=[self SubmitFormAgainTaskId:_taskId WithProcId:_procId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    }else{
        FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
        FormDatas.str_flowCode=@"F0014";
        FormDatas.str_taskId=_taskId;
        FormDatas.str_procId=_procId;
        FormDatas.dict_parametersDict=_dic_Submit;
        self.dockView.userInteractionEnabled=YES;
        BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
        vc.FormDatas=FormDatas;
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//直送提交
-(void)requestVehicleAppDirectAppData{
    FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
    FormDatas.str_flowGuid=[NSString isEqualToNull:_dic_request[@"result"][@"flowGuid"]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]]:@"";
    FormDatas.str_flowCode=@"F0014";
    FormDatas.str_taskId=_taskId;
    FormDatas.str_procId=_procId;
    FormDatas.dict_parametersDict=_dic_Submit;
    
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
-(void)btn_Click:(UIButton *)btn{
    [self keyClose];
    switch (btn.tag) {
            //退单提交提交
        case 3:
        {
            _int_Sub_State = 3;
            [self jointResponse];
            [self mainDataList];
            if ([self testData]) {
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //直送
        case 4:
        {
            _int_Sub_State = 4;
            [self jointResponse];
            [self mainDataList];
            if ([self testData]) {
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //保存
        case 5:
        {
            _int_Sub_State = 5;
            _dockView.userInteractionEnabled = NO;
            [self jointResponse];
            [self mainDataList];
            [self requestUploadImage];
            break;
        }
            //提交
        case 6:
        {
            _int_Sub_State = 6;
            [self jointResponse];
            [self mainDataList];
            if ([self testData]) {
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //选择审批人
        case 7:
        {
            [self keyClose];
            NSMutableArray *array = [NSMutableArray array];
            NSArray *idarr = [_firstHanderId componentsSeparatedByString:@","];
            for (int i = 0 ; i<idarr.count ; i++) {
                NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                [array addObject:dic];
            }
            
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"1";
            contactVC.arrClickPeople = array;
            contactVC.menutype=3;
            contactVC.itemType = 14;
            __weak typeof(self) weakSelf = self;
            [contactVC setBlock:^(NSMutableArray *array) {
                weakSelf.firstinfo = array.lastObject;
                weakSelf.txf_Approver.text=weakSelf.firstinfo.requestor;
                weakSelf.firstHanderName=weakSelf.firstinfo.requestor;
                weakSelf.firstHanderId=[NSString stringWithFormat:@"%ld",(long)weakSelf.firstinfo.requestorUserId];
                
                if ([NSString isEqualToNull:weakSelf.firstinfo.photoGraph]) {
                    NSDictionary * dic = [GPUtils transformToDictionaryFromString:weakSelf.firstinfo.photoGraph];
                    NSString *str =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                    if ([NSString isEqualToNull:str]) {
                        [weakSelf.ApproveImgView sd_setImageWithURL:[NSURL URLWithString:str]];
                    }else{
                        weakSelf.ApproveImgView.image=weakSelf.firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
                    }
                }
                else{
                    weakSelf.ApproveImgView.image=weakSelf.firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
                }
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
            break;
        }
        default:
            break;
    }
}


-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}

#pragma mark--自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dockView.userInteractionEnabled = YES;
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self creationRootView];
        [self creationMainView];
        [self creationDockView];
        [self updateMainView];
        [self updateContentView];
    }
    if (serialNum == 1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }
    if (serialNum == 2||serialNum == 3) {
        [YXSpritesLoadingView dismiss];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            LookVehicleAppViewController *look = [[LookVehicleAppViewController alloc]init];
            look.comeStatus=1;
            if (self.comeStatus==1) {
                look.backIndex=@"0";
            }else{
                look.backIndex=@"1";
            }
            look.taskId = [responceDic objectForKey:@"result"];
            [self.navigationController pushViewController:look animated:YES];
        } afterDelay:1.5];
    }
    if (serialNum == 4) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }
    
    if (serialNum == 6) {
        NSArray *array=[self transformToNSArrayFromString:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]]];
        for (int i=0; i<array.count; i++) {
            [_imagesArray replaceObjectAtIndex:[_imageTypeArray[i] integerValue] withObject:array[i]];
        }
        _imageDataString=[NSString transformToDictionaryFromJson:_imagesArray];
        
        [self readyRequest];
    }
    if (serialNum == 10) {
        boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@",ip_web,[responceDic objectForKey:@"result"]]];
        bo.str_title = Custing(@"流程图", nil);
        [self.navigationController pushViewController:bo animated:YES];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark 3class


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
