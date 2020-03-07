//
//  FormRelatedView.m
//  galaxy
//
//  Created by hfk on 2018/11/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormRelatedView.h"

@implementation FormRelatedView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView];
    }
    return self;
}
//MARK:创建视图
-(void)createMainView{
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self);
    }];
    
}

-(void)initFormRelatedViewWithDate:(NSMutableArray *)dateArray WithRequireDict:(NSMutableDictionary *)requireDict WithUnShowArray:(NSMutableArray *)unShowArray WithBaseModel:(FormBaseModel *)baseModel Withcontroller:(VoiceBaseController *)baseController{
    _dateArray=dateArray;
    _requireDict=requireDict;
    _unShowArray=unShowArray;
    _baseModel=baseModel;
    _baseController=baseController;
    
    [self updateViewSubmit];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Supplier.bottom);
    }];
}
-(void)updateViewSubmit{
    
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClientId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateClientViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [_requireDict setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierViewWithModel:model];
                [_unShowArray removeObject:model.fieldName];
            }
        }
    }
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}
//MARK:更新客户视图
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.ClientName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ClientClick];
    }];
    [_View_Client addSubview:view];
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}

//MARK:修改项目名称
-(void)ProjectClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId = self.baseModel.personalData.ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.ProjId = model.Id;
        weakSelf.baseModel.personalData.ProjName = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text = weakSelf.baseModel.personalData.ProjName;
        weakSelf.baseModel.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.baseModel.personalData.ProjMgr = model.projMgr;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改客户
-(void)ClientClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId = self.baseModel.personalData.ClientId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.ClientId = model.Id;
        weakSelf.baseModel.personalData.ClientName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Client.text = weakSelf.baseModel.personalData.ClientName;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}
//MARK:修改供应商
-(void)SupplierClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId = self.baseModel.personalData.SupplierId;
    vc.dict_otherPars = @{@"DateType":self.baseModel.str_SupplierParam};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.baseModel.personalData.SupplierId = model.Id;
        weakSelf.baseModel.personalData.SupplierName =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text = weakSelf.baseModel.personalData.SupplierName;
    };
    [_baseController.navigationController pushViewController:vc animated:YES];
}

//==============================================我是快乐的分割线================================================================//


-(void)initOnlyApproveFormRelatedViewWithDate:(NSMutableArray *)dateArray WithBaseModel:(FormBaseModel *)baseModel{
    
    _dateArray=dateArray;
    _baseModel=baseModel;
    
    [self updateViewOnlyApprove];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Supplier.bottom);
    }];
}

-(void)updateViewOnlyApprove{
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateOnlyApproveProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateOnlyApproveClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateOnlyApproveSupplierViewWithModel:model];
        }
    }
}

//MARK:更新项目名称
-(void)updateOnlyApproveProjectViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.baseModel.personalData.ProjName]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.ProjName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新客户名称
-(void)updateOnlyApproveClientViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.baseModel.personalData.ClientName]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.ClientName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商名称
-(void)updateOnlyApproveSupplierViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.baseModel.personalData.SupplierName]?[NSString stringWithFormat:@"%@",self.baseModel.personalData.SupplierName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//==============================================我是快乐的分割线================================================================//
-(void)initApproveFormRelatedViewWithDate:(NSMutableArray *)dateArray WithBaseModel:(FormBaseModel *)baseModel{

    _dateArray=dateArray;
    _baseModel=baseModel;
    
    [self updateViewApprove];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Supplier.bottom);
    }];
}
-(void)updateViewApprove{
    for (MyProcurementModel *model in _dateArray) {
        if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApproveSupplierViewWithModel:model];
        }
    }
}

//MARK:更新项目视图
-(void)updateApproveProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.ProjName}];
    [_View_Project addSubview:view];
}

//MARK:更新客户视图
-(void)updateApproveClientViewWithModel:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.ClientName}];
    [_View_Client addSubview:view];
}

//MARK:更新供应商视图
-(void)updateApproveSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.baseModel.personalData.SupplierName}];
    [_View_Supplier addSubview:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
