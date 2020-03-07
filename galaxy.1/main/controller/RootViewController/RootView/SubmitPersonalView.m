//
//  SubmitPersonalView.m
//  galaxy
//
//  Created by hfk on 2017/12/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "SubmitPersonalView.h"

@implementation SubmitPersonalView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView];
    }
    return self;
}
//MARK:创建视图
-(void)createMainView{
    
    _View_RequestorImg=[[UIView alloc]init];
    _View_RequestorImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_RequestorImg];
    [_View_RequestorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    _OperatorView=[[UIView alloc]init];
    _OperatorView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_OperatorView];
    [_OperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RequestorImg.bottom);
        make.left.right.equalTo(self);
    }];
   
    _OperatorDeptView=[[UIView alloc]init];
    _OperatorDeptView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_OperatorDeptView];
    [_OperatorDeptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.OperatorView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _RequestorView=[[UIView alloc]init];
    _RequestorView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_RequestorView];
    [_RequestorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.OperatorDeptView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _ContectView=[[UIView alloc]init];
    _ContectView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_ContectView];
    [_ContectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RequestorView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _DepartmentView=[[UIView alloc]init];
    _DepartmentView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_DepartmentView];
    [_DepartmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ContectView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _PositionView=[[UIView alloc]init];
    _PositionView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_PositionView];
    [_PositionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.DepartmentView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_UserLevel=[[UIView alloc]init];
    _View_UserLevel.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_UserLevel];
    [_View_UserLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PositionView.bottom);
        make.left.right.equalTo(self);
    }];
    
    
    _View_EmployeeNo=[[UIView alloc]init];
    _View_EmployeeNo.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_EmployeeNo];
    [_View_EmployeeNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_UserLevel.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_BranchCompany=[[UIView alloc]init];
    _View_BranchCompany.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_BranchCompany];
    [_View_BranchCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EmployeeNo.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_CostCenter=[[UIView alloc]init];
    _View_CostCenter.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_CostCenter];
    [_View_CostCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BranchCompany.bottom);
        make.left.right.equalTo(self);
    }];
    

    _View_BDivision=[[UIView alloc]init];
    _View_BDivision.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_BDivision];
    [_View_BDivision mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostCenter.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Area=[[UIView alloc]init];
    _View_Area.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Area];
    [_View_Area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BDivision.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Location=[[UIView alloc]init];
    _View_Location.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Location];
    [_View_Location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Area.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Fir=[[UIView alloc]init];
    _View_Personal_Fir.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Fir];
    [_View_Personal_Fir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Location.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Sec=[[UIView alloc]init];
    _View_Personal_Sec.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Sec];
    [_View_Personal_Sec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Fir.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Thir=[[UIView alloc]init];
    _View_Personal_Thir.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Thir];
    [_View_Personal_Thir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Sec.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Four=[[UIView alloc]init];
    _View_Personal_Four.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Four];
    [_View_Personal_Four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Thir.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Fif=[[UIView alloc]init];
    _View_Personal_Fif.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Fif];
    [_View_Personal_Fif mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Four.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Six=[[UIView alloc]init];
    _View_Personal_Six.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Six];
    [_View_Personal_Six mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Fif.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Sev=[[UIView alloc]init];
    _View_Personal_Sev.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Sev];
    [_View_Personal_Sev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Six.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Eig=[[UIView alloc]init];
    _View_Personal_Eig.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Eig];
    [_View_Personal_Eig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Sev.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Nin=[[UIView alloc]init];
    _View_Personal_Nin.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Nin];
    [_View_Personal_Nin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Eig.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Personal_Ten=[[UIView alloc]init];
    _View_Personal_Ten.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_View_Personal_Ten];
    [_View_Personal_Ten mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Nin.bottom);
        make.left.right.equalTo(self);
    }];
    
    _ApplyDataView=[[UIView alloc]init];
    _ApplyDataView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_ApplyDataView];
    [_ApplyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Personal_Ten.bottom);
        make.left.right.equalTo(self);
    }];
}

-(void)initSubmitPersonalViewWithDate:(NSMutableArray *)dateArray WithRequireDict:(NSMutableDictionary *)requireDict WithUnShowArray:(NSMutableArray *)unShowArray WithSumbitBaseModel:(FormBaseModel *)baseModel Withcontroller:(VoiceBaseController *)baseController{
    _dateArray=dateArray;
    _requireDict=requireDict;
    _unShowArray=unShowArray;
    _baseModel=baseModel;
    _baseController=baseController;
    
    [self updateViewSubmit];

    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ApplyDataView.bottom);
    }];
}
-(void)updateViewSubmit{
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"OperatorUserId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateOperatorViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"OperatorDeptId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateOperatorDepartmentViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RequestorUserId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateRequestorViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Contact"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateContectViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateDepartmentViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"JobTitleCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePositionViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserLevelId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateUserLevelViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"HRID"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateEmployeeNoViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BranchId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateBranchCompanyViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateCostCenterViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateBDivisionViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"AreaId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateAreaViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LocationId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateLocationViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserReserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePersonal_FirViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserReserved2"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePersonal_SecViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserReserved3"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePersonal_ThirViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserReserved4"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePersonal_FourViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UserReserved5"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updatePersonal_FifViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }
//        else if ([model.fieldName isEqualToString:@"UserReserved6"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [_requireDict setValue:model.isRequired forKey:model.fieldName];
//                [self updatePersonal_SixViewWithModel:model];
//                [_unShowArray removeObject:model.fieldName];
//            }
//        }else if ([model.fieldName isEqualToString:@"UserReserved7"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [_requireDict setValue:model.isRequired forKey:model.fieldName];
//                [self updatePersonal_SevViewWithModel:model];
//                [_unShowArray removeObject:model.fieldName];
//            }
//        }else if ([model.fieldName isEqualToString:@"UserReserved8"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [_requireDict setValue:model.isRequired forKey:model.fieldName];
//                [self updatePersonal_EigViewWithModel:model];
//                [_unShowArray removeObject:model.fieldName];
//            }
//        }else if ([model.fieldName isEqualToString:@"UserReserved9"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [_requireDict setValue:model.isRequired forKey:model.fieldName];
//                [self updatePersonal_NinViewWithModel:model];
//                [_unShowArray removeObject:model.fieldName];
//            }
//        }else if ([model.fieldName isEqualToString:@"UserReserved10"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [_requireDict setValue:model.isRequired forKey:model.fieldName];
//                [self updatePersonal_TenViewWithModel:model];
//                [_unShowArray removeObject:model.fieldName];
//            }
//        }
        else if ([model.fieldName isEqualToString:@"RequestorDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateApplyDataWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }
        
    }
}
//MARK:更新操作人人视图
-(void)updateOperatorViewWithModel:(MyProcurementModel *)model{
    _txf_Operator=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_OperatorView WithContent:_txf_Operator WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Operator}];
    [_OperatorView addSubview:view];
}
//MARK:更新操作人部门视图
-(void)updateOperatorDepartmentViewWithModel:(MyProcurementModel *)model{
    _txf_OperatorDept=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_OperatorDeptView WithContent:_txf_OperatorDept WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.OperatorDept}];
    [_OperatorDeptView addSubview:view];
}
//MARK:更新申请人视图
-(void)updateRequestorViewWithModel:(MyProcurementModel *)model{
    if ([self.baseModel.str_flowCode isEqualToString:@"F0022"]) {
        PerformanceFormData *Performancemodel=(PerformanceFormData *)self.baseModel;
        if (Performancemodel.int_performanceMode==1) {
            _txf_Requestor=[[UITextField alloc]init];
            SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RequestorView WithContent:_txf_Requestor WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Requestor}];
            __weak typeof(self) weakSelf = self;
            [view setFormClickedBlock:^(MyProcurementModel *model){
                [weakSelf ChangeRequestor];
            }];
            [_RequestorView addSubview:view];
        }else{
            _txf_Requestor=[[UITextField alloc]init];
            SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RequestorView WithContent:_txf_Requestor WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Requestor}];
            [_RequestorView addSubview:view];
        }
    }else{
        _txf_Requestor=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RequestorView WithContent:_txf_Requestor WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Requestor}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeRequestor];
        }];
        [_RequestorView addSubview:view];
    }
}
//MARK:更新联系方式视图
-(void)updateContectViewWithModel:(MyProcurementModel *)model{
    _txf_Contect=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ContectView WithContent:_txf_Contect WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangePhone];
    }];
    [_ContectView addSubview:view];
}
//MARK:更新部门视图
-(void)updateDepartmentViewWithModel:(MyProcurementModel *)model{
//    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
        _txf_Department=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_DepartmentView WithContent:_txf_Department WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorDept}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeDepartment];
        }];
        [_DepartmentView addSubview:view];
//    }else{
//        _txf_Department=[[UITextField alloc]init];
//        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_DepartmentView WithContent:_txf_Department WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorDept}];
//        [_DepartmentView addSubview:view];
//    }
}
//MARK:更新职位视图
-(void)updatePositionViewWithModel:(MyProcurementModel *)model{
    _txf_Position=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_PositionView WithContent:_txf_Position WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.JobTitle}];
    [_PositionView addSubview:view];
}
//MARK:更新员工级别视图
-(void)updateUserLevelViewWithModel:(MyProcurementModel *)model{
    _txf_UserLevel=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_UserLevel WithContent:_txf_UserLevel WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.UserLevel}];
//    __weak typeof(self) weakSelf = self;
//    [view setFormClickedBlock:^(MyProcurementModel *model){
//        [weakSelf ChangeUserLevel];
//    }];
    [_View_UserLevel addSubview:view];
}
//MARK:更新员工工号视图
-(void)updateEmployeeNoViewWithModel:(MyProcurementModel *)model{
    _txf_EmployeeNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EmployeeNo WithContent:_txf_EmployeeNo WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_EmployeeNo addSubview:view];
    
}
//MARK:更新公司视图
-(void)updateBranchCompanyViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
        _txf_BranchCompany=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BranchCompany WithContent:_txf_BranchCompany WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Branch}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeBranchCompany];
        }];
        [_View_BranchCompany addSubview:view];
    }else{
        _txf_BranchCompany=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BranchCompany WithContent:_txf_BranchCompany WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Branch}];
        [_View_BranchCompany addSubview:view];
    }
}
//MARK:更新成本中心视图
-(void)updateCostCenterViewWithModel:(MyProcurementModel *)model{
    _txf_CostCenter=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CostCenter WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.CostCenter}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeCostCenter];
    }];
    [_View_CostCenter addSubview:view];
}
//MARK:更新业务部门视图
-(void)updateBDivisionViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.isNotSelect]isEqualToString:@"0"]) {
        _txf_BDivision=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BDivision WithContent:_txf_BDivision WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorBusDept}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf ChangeBDivision];
        }];
        [_View_BDivision addSubview:view];
    }else{
        _txf_BDivision=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BDivision WithContent:_txf_BDivision WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorBusDept}];
        [_View_BDivision addSubview:view];
    }
}
//MARK:更新地区视图
-(void)updateAreaViewWithModel:(MyProcurementModel *)model{
    _txf_Area=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Area WithContent:_txf_Area WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Area}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeArea];
    }];
    [_View_Area addSubview:view];
}
//MARK:更新办事处视图
-(void)updateLocationViewWithModel:(MyProcurementModel *)model{
    _txf_Location=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Location WithContent:_txf_Location WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Location}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeLocation];
    }];
    [_View_Location addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_FirViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Fir=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Fir WithContent:_txf_Personal_Fir WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Fir addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_SecViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Sec=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Sec WithContent:_txf_Personal_Sec WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Sec addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_ThirViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Thir=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Thir WithContent:_txf_Personal_Thir WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Thir addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_FourViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Four=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Four WithContent:_txf_Personal_Four WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Four addSubview:view];}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_FifViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Fif=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Fif WithContent:_txf_Personal_Fif WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Fif addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_SixViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Six=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Six WithContent:_txf_Personal_Six WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Six addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_SevViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Sev=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Sev WithContent:_txf_Personal_Sev WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Sev addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_EigViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Eig=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Eig WithContent:_txf_Personal_Eig WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Eig addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_NinViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Nin=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Nin WithContent:_txf_Personal_Nin WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Nin addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updatePersonal_TenViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Ten=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Ten WithContent:_txf_Personal_Ten WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Ten addSubview:view];
}
//MARK:更新申请日期
-(void)updateApplyDataWithModel:(MyProcurementModel *)model{
    UITextField *txf=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ApplyDataView WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_ApplyDataView addSubview:view];
}
//MARK:修改申请人
-(void)ChangeRequestor{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.baseModel.personalData.RequestorUserId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople = array;
    contactVC.status = @"10";
    contactVC.menutype=1;
    contactVC.itemType = 99;
    contactVC.Radio = @"1";
    contactVC.flowCode = self.baseModel.str_flowCode;
    __weak typeof(self) weakSelf = self;
    [contactVC setPerfSelectBlock:^(NSDictionary *SelectDict) {
        if ([SelectDict[@"operatorUser"]isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict=SelectDict[@"operatorUser"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                weakSelf.baseModel.personalData.RequestorUserId = [NSString stringWithIdOnNO:dict[@"requestorUserId"]];
                weakSelf.baseModel.personalData.RequestorAccount = [NSString stringWithIdOnNO:dict[@"requestorAccount"]];
                weakSelf.baseModel.personalData.Requestor = [NSString stringWithIdOnNO:dict[@"requestor"]];
                weakSelf.txf_Requestor.text = weakSelf.baseModel.personalData.Requestor;
                weakSelf.txf_Contect.text = weakSelf.baseModel.personalData.RequestorAccount;
                
                weakSelf.baseModel.personalData.RequestorDeptId = [NSString stringWithIdOnNO:dict[@"requestorDeptId"]];
                weakSelf.baseModel.personalData.RequestorDept = [NSString stringWithIdOnNO:dict[@"requestorDept"]];
                weakSelf.txf_Department.text = weakSelf.baseModel.personalData.RequestorDept;
                
                weakSelf.baseModel.personalData.JobTitleCode = [NSString stringWithIdOnNO:dict[@"jobTitleCode"]];
                weakSelf.baseModel.personalData.JobTitle = [NSString stringWithIdOnNO:dict[@"jobTitle"]];
                weakSelf.baseModel.personalData.JobTitleLvl = [NSString stringWithIdOnNO:dict[@"jobTitleLvl"]];
                weakSelf.txf_Position.text = weakSelf.baseModel.personalData.JobTitle;

                weakSelf.baseModel.personalData.Hrid = [NSString stringWithIdOnNO:dict[@"requestorHRID"]];
                weakSelf.txf_EmployeeNo.text = weakSelf.baseModel.personalData.Hrid;
                
                weakSelf.baseModel.personalData.BranchId = [NSString stringWithIdOnNO:dict[@"branchId"]];
                weakSelf.baseModel.personalData.Branch = [NSString stringWithIdOnNO:dict[@"branch"]];
                weakSelf.txf_BranchCompany .text = weakSelf.baseModel.personalData.Branch;

                weakSelf.baseModel.personalData.CostCenterId = [NSString stringWithIdOnNO:dict[@"costCenter"]];
                weakSelf.baseModel.personalData.CostCenter = [NSString stringWithIdOnNO:dict[@"costCenterName"]];
                weakSelf.baseModel.personalData.CostCenterMgrUserId = [NSString stringWithIdOnNO:dict[@"costCenterMgrUserId"]];
                weakSelf.baseModel.personalData.CostCenterMgr = [NSString stringWithIdOnNO:dict[@"costCenterMgr"]];
                weakSelf.txf_CostCenter .text = weakSelf.baseModel.personalData.CostCenter;

                weakSelf.baseModel.personalData.RequestorBusDept = [NSString stringWithIdOnNO:dict[@"requestorBusDept"]];
                weakSelf.baseModel.personalData.RequestorBusDeptId = [NSString stringWithIdOnNO:dict[@"requestorBusDeptId"]];
                weakSelf.txf_BDivision .text = weakSelf.baseModel.personalData.RequestorBusDept;

                weakSelf.baseModel.personalData.UserLevelId = [NSString stringWithIdOnNO:dict[@"userLevel"]];
                weakSelf.baseModel.personalData.UserLevel = [NSString stringWithIdOnNO:dict[@"userLevelName"]];
                weakSelf.txf_UserLevel.text = weakSelf.baseModel.personalData.UserLevel;

                weakSelf.baseModel.personalData.AreaId = [NSString stringWithIdOnNO:dict[@"area"]];
                weakSelf.baseModel.personalData.Area = [NSString stringWithIdOnNO:dict[@"areaName"]];
                weakSelf.txf_Area.text = weakSelf.baseModel.personalData.Area;
                
                weakSelf.baseModel.personalData.LocationId = [NSString stringWithIdOnNO:dict[@"location"]];
                weakSelf.baseModel.personalData.Location = [NSString stringWithIdOnNO:dict[@"locationName"]];
                weakSelf.txf_Location.text = weakSelf.baseModel.personalData.Location;

            
                weakSelf.baseModel.personalData.UserReserved1 = [NSString stringWithIdOnNO:dict[@"reserved1"]];
                weakSelf.txf_Personal_Fir.text = weakSelf.baseModel.personalData.UserReserved1;

                weakSelf.baseModel.personalData.UserReserved2 = [NSString stringWithIdOnNO:dict[@"reserved2"]];
                weakSelf.txf_Personal_Sec.text = weakSelf.baseModel.personalData.UserReserved2;

                weakSelf.baseModel.personalData.UserReserved3 = [NSString stringWithIdOnNO:dict[@"reserved3"]];
                weakSelf.txf_Personal_Thir.text = weakSelf.baseModel.personalData.UserReserved3;

                weakSelf.baseModel.personalData.UserReserved4 = [NSString stringWithIdOnNO:dict[@"reserved4"]];
                weakSelf.txf_Personal_Four.text = weakSelf.baseModel.personalData.UserReserved4;

                weakSelf.baseModel.personalData.UserReserved5 = [NSString stringWithIdOnNO:dict[@"reserved5"]];
                weakSelf.txf_Personal_Fif.text = weakSelf.baseModel.personalData.UserReserved5;
                
//                weakSelf.baseModel.personalData.UserReserved6=[NSString stringWithIdOnNO:dict[@"reserved6"]];
//                weakSelf.txf_Personal_Six.text=weakSelf.baseModel.personalData.UserReserved6;
//
//                weakSelf.baseModel.personalData.UserReserved7=[NSString stringWithIdOnNO:dict[@"reserved7"]];
//                weakSelf.txf_Personal_Sev.text=weakSelf.baseModel.personalData.UserReserved7;
//
//                weakSelf.baseModel.personalData.UserReserved8=[NSString stringWithIdOnNO:dict[@"reserved8"]];
//                weakSelf.txf_Personal_Eig.text=weakSelf.baseModel.personalData.UserReserved8;
//
//                weakSelf.baseModel.personalData.UserReserved9=[NSString stringWithIdOnNO:dict[@"reserved9"]];
//                weakSelf.txf_Personal_Nin.text=weakSelf.baseModel.personalData.UserReserved9;
//
//                weakSelf.baseModel.personalData.UserReserved10=[NSString stringWithIdOnNO:dict[@"reserved10"]];
//                weakSelf.txf_Personal_Ten.text=weakSelf.baseModel.personalData.UserReserved10;

                weakSelf.baseModel.personalData.ApproverId1 = [NSString stringWithIdOnNO:dict[@"approverId1"]];
                weakSelf.baseModel.personalData.ApproverId2 = [NSString stringWithIdOnNO:dict[@"approverId2"]];
                weakSelf.baseModel.personalData.ApproverId3 = [NSString stringWithIdOnNO:dict[@"approverId3"]];
                weakSelf.baseModel.personalData.ApproverId4 = [NSString stringWithIdOnNO:dict[@"approverId4"]];
                weakSelf.baseModel.personalData.ApproverId5 = [NSString stringWithIdOnNO:dict[@"approverId5"]];
                weakSelf.baseModel.personalData.UserLevelNo = [NSString stringWithIdOnNO:dict[@"userLevelNo"]];

            }
        }
        if (weakSelf.SubmitPersonalViewBackBlock) {
            weakSelf.SubmitPersonalViewBackBlock(SelectDict);
        }
    }];
    [_baseController.navigationController pushViewController:contactVC animated:YES];
}
//MARK:修改电话号码
-(void)ChangePhone{
    ChangePhoneNumController *change = [[ChangePhoneNumController alloc]init];
    change.type = 1;
    change.str_content = self.baseModel.personalData.Contact;
    __weak typeof(self) weakSelf = self;
    change.numDataChangeBlock = ^(NSString *numData, NSInteger type) {
        weakSelf.baseModel.personalData.Contact = numData;
        weakSelf.txf_Contect.text = numData;
    };
    [_baseController.navigationController pushViewController:change animated:YES];
}
//MARK:修改部门
-(void)ChangeDepartment{
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"Department"];
    choose.ChooseCategoryArray=nil;
    choose.dict_Parameter = @{@"userId":self.baseModel.personalData.RequestorUserId};
    choose.ChooseCategoryId=self.baseModel.personalData.RequestorDeptId;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.baseModel.personalData.RequestorDeptId=[NSString stringWithFormat:@"%@",model.groupId];
        weakSelf.baseModel.personalData.RequestorDept = model.groupName;
        weakSelf.txf_Department.text = model.groupName;
        weakSelf.txf_Position.text = model.jobTitle;
        weakSelf.baseModel.personalData.JobTitle = model.jobTitle;
        weakSelf.baseModel.personalData.JobTitleCode = model.jobTitleCode;
        weakSelf.baseModel.personalData.JobTitleLvl = model.jobTitleLvl;
    };
    [_baseController.navigationController pushViewController:choose animated:YES];
}
//MARK:修改员工级别
-(void)ChangeUserLevel{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"UserLevel"];
    vc.ChooseCategoryId=self.baseModel.personalData.UserLevelId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.UserLevelId=model.Id;
        weakSelf.baseModel.personalData.UserLevel=model.userLevel;
        weakSelf.txf_UserLevel.text=model.userLevel;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];

}
//MARK:修改公司
-(void)ChangeBranchCompany{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BranchCompany"];
    vc.ChooseCategoryId=self.baseModel.personalData.BranchId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.BranchId=model.groupId;
        weakSelf.baseModel.personalData.Branch=model.groupName;
        weakSelf.txf_BranchCompany.text=model.groupName;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改成本中心
-(void)ChangeCostCenter{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"costCenter"];
    vc.ChooseCategoryId = self.baseModel.personalData.CostCenterId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.CostCenterId=model.Id;
        weakSelf.baseModel.personalData.CostCenter=model.costCenter;
        weakSelf.baseModel.personalData.CostCenterMgrUserId = model.costCenterMgrUserId;
        weakSelf.baseModel.personalData.CostCenterMgr = model.costCenterMgr;
        weakSelf.txf_CostCenter.text=model.costCenter;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改业务部门
-(void)ChangeBDivision{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BDivision"];
    vc.ChooseCategoryId=self.baseModel.personalData.RequestorBusDeptId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.RequestorBusDeptId=model.Id;
        weakSelf.baseModel.personalData.RequestorBusDept=model.name;
        weakSelf.txf_BDivision.text=model.name;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改地区
-(void)ChangeArea{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"area"];
    vc.ChooseCategoryId=self.baseModel.personalData.AreaId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.AreaId=model.Id;
        weakSelf.baseModel.personalData.Area=model.name;
        weakSelf.txf_Area.text=model.name;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改办事处
-(void)ChangeLocation{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"location"];
    vc.ChooseCategoryId=self.baseModel.personalData.LocationId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.LocationId=model.Id;
        weakSelf.baseModel.personalData.Location=model.name;
        weakSelf.txf_Location.text=model.name;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//==============================================我是快乐的分割线================================================================//


-(void)initOnlyApprovePersonalViewWithDate:(NSMutableArray *)dateArray WithApproveModel:(FormBaseModel *)baseModel withType:(NSInteger)type{
    _dateArray=dateArray;
    _baseModel=baseModel;
    [self updateViewOnlyApproveWithType:type];
    if (_int_RequestorLine==1&&type==2) {
        [_View_RequestorImg addSubview:[self createLineViewOfHeight_ByTitle:79.5]];
    }
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ApplyDataView.bottom);
    }];
}

-(void)updateViewOnlyApproveWithType:(NSInteger)type{
    if (type==2) {
        [self updateOnlyApproveRequestor];
    }
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"OperatorUserId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveOperatorWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OperatorDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveOperatorDepartmentViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Contact"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveContectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveDepartmentViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"JobTitleCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePositionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserLevelId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveUserLevelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"HRID"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveEmployeeNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BranchId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveBranchCompanyViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveCostCenterViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveBDivisionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AreaId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveAreaViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LocationId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveLocationViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePersonal_FirViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved2"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePersonal_SecViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved3"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePersonal_ThirViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved4"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePersonal_FourViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved5"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApprovePersonal_FifViewWithModel:model];
        }
//        else if ([model.fieldName isEqualToString:@"UserReserved6"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            _int_RequestorLine=1;
//            [self updateOnlyApprovePersonal_SixViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved7"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            _int_RequestorLine=1;
//            [self updateOnlyApprovePersonal_SevViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved8"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            _int_RequestorLine=1;
//            [self updateOnlyApprovePersonal_EigViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved9"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            _int_RequestorLine=1;
//            [self updateOnlyApprovePersonal_NinViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved10"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            _int_RequestorLine=1;
//            [self updateOnlyApprovePersonal_TenViewWithModel:model];
//        }
        else if ([model.fieldName isEqualToString:@"RequestorDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateOnlyApproveApplyDataWithModel:model];
        }
    }
}
//MARK:更新申请人视图
-(void)updateOnlyApproveRequestor{
    [_View_RequestorImg updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
    }];
    
    UIImageView *requestorImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 11, 58, 58)];
    if ([NSString isEqualToNull:self.baseModel.personalData.RequestorPhotoGraph]) {
        [requestorImage sd_setImageWithURL:[NSURL URLWithString:self.baseModel.personalData.RequestorPhotoGraph]];
    }else{
        if (![NSString isEqualToNull:self.baseModel.personalData.RequestorGender]||[[NSString stringWithFormat:@"%@",self.baseModel.personalData.RequestorGender]isEqualToString:@"0"]) {
            requestorImage.image=[UIImage imageNamed:@"Message_Man"];
        }else{
            requestorImage.image=[UIImage imageNamed:@"Message_Woman"];
        }
    }
    requestorImage.backgroundColor=Color_form_TextFieldBackgroundColor;
    requestorImage.layer.masksToBounds=YES;
    requestorImage.layer.cornerRadius = 29.0f;
    [_View_RequestorImg addSubview:requestorImage];
    
    UILabel *nameLabel = [GPUtils createLable:CGRectMake(88, 10, 150, 60) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLabel.numberOfLines=0;
    [_View_RequestorImg addSubview:nameLabel];
    
    if ([NSString isEqualToNull:self.baseModel.personalData.Requestor]) {
        nameLabel.text=self.baseModel.personalData.Requestor;
    }
    
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@%@",Custing(@"   单号:", nil),self.baseModel.str_SerialNo] font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *numberTitle=[GPUtils createLable:CGRectMake(Main_Screen_Width-size.width-10,25,size.width+20, 25) text:Custing(@"   单号:", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    if ([NSString isEqualToNull:self.baseModel.str_SerialNo]) {
        numberTitle.text=[NSString stringWithFormat:@"%@%@",Custing(@"   单号:", nil),self.baseModel.str_SerialNo];
    }
    numberTitle.layer.cornerRadius = 12.5;
    numberTitle.layer.masksToBounds = YES;
    numberTitle.layer.borderWidth = 0.5;
    numberTitle.layer.borderColor = Color_GrayDark_Same_20.CGColor;
    [_View_RequestorImg addSubview:numberTitle];
    [_View_RequestorImg addSubview:[XBHepler creation_State_Lab:self.baseModel.str_noteStatus]];
}

//MARK:更新操作人视图
-(void)updateOnlyApproveOperatorWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.Operator]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.Operator]:@"";
    __weak typeof(self) weakSelf = self;
    [_OperatorView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.OperatorView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新操作人部门视图
-(void)updateOnlyApproveOperatorDepartmentViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.OperatorDept]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.OperatorDept]:@"";
    __weak typeof(self) weakSelf = self;
    [_OperatorDeptView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.OperatorDeptView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新联系方式视图
-(void)updateOnlyApproveContectViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_ContectView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.ContectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新部门视图
-(void)updateOnlyApproveDepartmentViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.RequestorDept]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.RequestorDept]:@"";
    __weak typeof(self) weakSelf = self;
    [_DepartmentView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.DepartmentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新职位视图
-(void)updateOnlyApprovePositionViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.JobTitle]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.JobTitle]:@"";
    __weak typeof(self) weakSelf = self;
    [_PositionView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.PositionView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新级别视图
-(void)updateOnlyApproveUserLevelViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.UserLevel]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.UserLevel]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_UserLevel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_UserLevel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新员工工号视图
-(void)updateOnlyApproveEmployeeNoViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_EmployeeNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_EmployeeNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新公司视图
-(void)updateOnlyApproveBranchCompanyViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.Branch]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.Branch]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_BranchCompany addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BranchCompany updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新成本中心
-(void)updateOnlyApproveCostCenterViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.CostCenter]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.CostCenter]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_CostCenter addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CostCenter updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新业务部门视图
-(void)updateOnlyApproveBDivisionViewWithModel:(MyProcurementModel *)model{

    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.RequestorBusDept]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.RequestorBusDept]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_BDivision addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BDivision updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新地区视图
-(void)updateOnlyApproveAreaViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.Area]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.Area]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Area addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Area updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新办事处视图
-(void)updateOnlyApproveLocationViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.baseModel.personalData.Location]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.Location]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Location addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Location updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_FirViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Fir addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Fir updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_SecViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Sec addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Sec updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_ThirViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Thir addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Thir updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_FourViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Four addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Four updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_FifViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Fif addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Fif updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_SixViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Six addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Six updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_SevViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Sev addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Sev updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_EigViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Eig addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Eig updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_NinViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Nin addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Nin updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新员工自定义字段视图
-(void)updateOnlyApprovePersonal_TenViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Personal_Ten addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Personal_Ten updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新申请日期
-(void)updateOnlyApproveApplyDataWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_ApplyDataView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.ApplyDataView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//==============================================我是快乐的分割线================================================================//
-(void)initApprovePersonalViewWithDate:(NSMutableArray *)dateArray WithSumbitBaseModel:(FormBaseModel *)baseModel{

    _dateArray=dateArray;
    _baseModel=baseModel;
    [self updateViewApprove];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ApplyDataView.bottom);
    }];
}
-(void)updateViewApprove{
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"OperatorUserId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveOperatorRequestorViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OperatorDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveOperatorDeptViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RequestorUserId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveRequestorViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Contact"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveContectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveDepartmentViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"JobTitleCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePositionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserLevelId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveUserLevelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"HRID"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveEmployeeNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BranchId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveBranchCompanyViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveCostCenterViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveBDivisionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AreaId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveAreaViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LocationId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveLocationViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePersonal_FirViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved2"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePersonal_SecViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved3"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePersonal_ThirViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved4"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePersonal_FourViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UserReserved5"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovePersonal_FifViewWithModel:model];
        }
//        else if ([model.fieldName isEqualToString:@"UserReserved6"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            [self updateApprovePersonal_SixViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved7"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            [self updateApprovePersonal_SevViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved8"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            [self updateApprovePersonal_EigViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved9"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            [self updateApprovePersonal_NinViewWithModel:model];
//        }else if ([model.fieldName isEqualToString:@"UserReserved10"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
//            [self updateApprovePersonal_TenViewWithModel:model];
//        }
        else if ([model.fieldName isEqualToString:@"RequestorDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveApplyDataWithModel:model];
        }
    }
}

//MARK:更新操作人人视图
-(void)updateApproveOperatorRequestorViewWithModel:(MyProcurementModel *)model{
    _txf_Operator=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_OperatorView WithContent:_txf_Operator WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Operator}];
    [_OperatorView addSubview:view];
}
//MARK:更新操作人部门视图
-(void)updateApproveOperatorDeptViewWithModel:(MyProcurementModel *)model{
    _txf_OperatorDept=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_OperatorDeptView WithContent:_txf_OperatorDept WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.OperatorDept}];
    [_OperatorDeptView addSubview:view];
}
//MARK:更新申请人视图
-(void)updateApproveRequestorViewWithModel:(MyProcurementModel *)model{
    UITextField *tx=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RequestorView WithContent:tx WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Requestor}];
    [_RequestorView addSubview:view];
}
//MARK:更新联系方式视图
-(void)updateApproveContectViewWithModel:(MyProcurementModel *)model{
    _txf_Contect=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ContectView WithContent:_txf_Contect WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_ContectView addSubview:view];
}
//MARK:更新部门视图
-(void)updateApproveDepartmentViewWithModel:(MyProcurementModel *)model{
    _txf_Department=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_DepartmentView WithContent:_txf_Department WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorDept}];
    [_DepartmentView addSubview:view];
}
//MARK:更新职位视图
-(void)updateApprovePositionViewWithModel:(MyProcurementModel *)model{
    _txf_Position=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_PositionView WithContent:_txf_Position WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.JobTitle}];
    [_PositionView addSubview:view];
}

//MARK:更新级别视图
-(void)updateApproveUserLevelViewWithModel:(MyProcurementModel *)model{
    _txf_UserLevel=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_UserLevel WithContent:_txf_UserLevel WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.UserLevel}];
    [_View_UserLevel addSubview:view];
}

//MARK:更新员工工号视图
-(void)updateApproveEmployeeNoViewWithModel:(MyProcurementModel *)model{
    _txf_EmployeeNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EmployeeNo WithContent:_txf_EmployeeNo WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_EmployeeNo addSubview:view];
    
}
//MARK:更新公司视图
-(void)updateApproveBranchCompanyViewWithModel:(MyProcurementModel *)model{
    _txf_BranchCompany=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BranchCompany WithContent:_txf_BranchCompany WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Branch}];
    [_View_BranchCompany addSubview:view];
}
//MARK:更新成本中心视图
-(void)updateApproveCostCenterViewWithModel:(MyProcurementModel *)model{
    _txf_CostCenter=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CostCenter WithContent:_txf_CostCenter WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.CostCenter}];
    [_View_CostCenter addSubview:view];
}
//MARK:更新业务部门视图
-(void)updateApproveBDivisionViewWithModel:(MyProcurementModel *)model{
    _txf_BDivision=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BDivision WithContent:_txf_BDivision WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.RequestorBusDept}];
    [_View_BDivision addSubview:view];
}
//MARK:更新地区视图
-(void)updateApproveAreaViewWithModel:(MyProcurementModel *)model{
    _txf_Area=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Area WithContent:_txf_Area WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Area}];
    [_View_Area addSubview:view];
}
//MARK:更新办事处视图
-(void)updateApproveLocationViewWithModel:(MyProcurementModel *)model{
    _txf_Location=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Location WithContent:_txf_Location WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.Location}];
    [_View_Location addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_FirViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Fir=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Fir WithContent:_txf_Personal_Fir WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Fir addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_SecViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Sec=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Sec WithContent:_txf_Personal_Sec WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Sec addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_ThirViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Thir=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Thir WithContent:_txf_Personal_Thir WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Thir addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_FourViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Four=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Four WithContent:_txf_Personal_Four WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Four addSubview:view];}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_FifViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Fif=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Fif WithContent:_txf_Personal_Fif WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Fif addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_SixViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Six=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Six WithContent:_txf_Personal_Six WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Six addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_SevViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Sev=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Sev WithContent:_txf_Personal_Sev WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Sev addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_EigViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Eig=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Eig WithContent:_txf_Personal_Eig WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Eig addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_NinViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Nin=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Nin WithContent:_txf_Personal_Nin WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Nin addSubview:view];
}
//MARK:更新员工自定义字段视图
-(void)updateApprovePersonal_TenViewWithModel:(MyProcurementModel *)model{
    _txf_Personal_Ten=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Personal_Ten WithContent:_txf_Personal_Ten WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Personal_Ten addSubview:view];
}
//MARK:更新申请日期
-(void)updateApproveApplyDataWithModel:(MyProcurementModel *)model{
    UITextField *txf=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ApplyDataView WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_ApplyDataView addSubview:view];
}

-(UIView *)createLineViewOfHeight_ByTitle:(CGFloat)height{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(12,height, Main_Screen_Width,0.5)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
