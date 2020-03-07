//
//  ChooseCategoryCell.m
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ChooseCategoryCell.h"
#import "GPUtils.h"

@implementation ChooseCategoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)configViewWithModel:(ChooseCategoryModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 50)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];

    NSString *MarkId=[ChooseCategoryCell getModelSignWithModel:model WithType:type];
    
    if ([IdArray containsObject:MarkId]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 50) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if ([type isEqualToString:@"payWay"]) {
        _TypeLabel.text=[NSString stringWithFormat:@"%@",model.payMode];
    }else if ([type isEqualToString:@"purchaseType"]){
        _TypeLabel.text=model.purchaseType;
    }else if ([type isEqualToString:@"Department"]||[type isEqualToString:@"Branch"]){
        _TypeLabel.text = [NSString stringWithFormat:@"%@",model.groupName];
    }else if ([type isEqualToString:@"expensetype"]||[type isEqualToString:@"expensetypeSub"]){
        _TypeLabel.text = [NSString stringWithFormat:@"%@",model.typPurp];
    }else if ([type isEqualToString:@"ClaimType"]){
        _TypeLabel.text = [NSString stringWithFormat:@"%@",model.claimType];
    }else if ([type isEqualToString:@"CARNO"]){
        _TypeLabel.text = [GPUtils getSelectResultWithArray:@[model.carNo,model.carDesc] WithCompare:@"/"];
    }else if ([type isEqualToString:@"SupplierCat"]||[type isEqualToString:@"ProductCat"]||[type isEqualToString:@"NewPayWay"]||[type isEqualToString:@"VehicleTyp"]){
        _TypeLabel.text = model.name;
    }else if ([type isEqualToString:@"AttendanceRole"]){
        _TypeLabel.text = [NSString stringWithIdOnNO:model.roleName];
    }else if ([type isEqualToString:@"GetProvinces"]){
        _TypeLabel.text = model.provinceName;
    }else if ([type isEqualToString:@"GetCitys"]){
        _TypeLabel.text = model.cityName;
    }
    [self.mainView addSubview:_TypeLabel];
}

+(NSString *)getModelSignWithModel:(ChooseCategoryModel *)model WithType:(NSString *)type{
    NSString *MarkId=@"";
    if ([type isEqualToString:@"purchaseType"]) {
        MarkId=[NSString stringWithFormat:@"%@",model.purchaseCode];
    }else if ([type isEqualToString:@"payWay"]){
        MarkId=[NSString stringWithFormat:@"%@",model.payCode];
    }else if ([type isEqualToString:@"ClaimType"]||[type isEqualToString:@"ProductCat"]||[type isEqualToString:@"NewPayWay"]||[type isEqualToString:@"VehicleTyp"]||[type isEqualToString:@"SupplierCat"]){
        MarkId=[NSString stringWithFormat:@"%@",model.Id];
    }else if ([type isEqualToString:@"Department"]){
        MarkId=[NSString stringWithFormat:@"%@",model.groupId];
    }else if ([type isEqualToString:@"HotelStand"]){
        MarkId=[NSString stringWithFormat:@"%@",model.addCostCode];
    }else if ([type isEqualToString:@"CARNO"]){
        MarkId=[NSString stringWithFormat:@"%@",model.carNo];
    }else if ([type isEqualToString:@"AttendanceRole"]){
        MarkId=[NSString stringWithFormat:@"%@",model.roleId];
    }
    return MarkId;
}

- (void)configFreViewWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 50)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSString *MarkId=[ChooseCategoryCell getFreModelSignWithModel:model WithType:type];
   
    if ([IdArray containsObject:MarkId]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    if ([type isEqualToString:@"ConfigurationItem"]&&IdArray.count==0&&_ChooseNamesArray&&[_ChooseNamesArray containsObject:model.name]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 50) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if ([type isEqualToString:@"projectName"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.projTyp,model.no,model.projName]];
    }else if ([type isEqualToString:@"costCenter"]){
        _TypeLabel.text=model.costCenter;
    }else if ([type isEqualToString:@"Client"]||[type isEqualToString:@"Supplier"]||[type isEqualToString:@"PurchaseItemTpls"]||[type isEqualToString:@"InventoryStorage"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.code,model.name]];
    }else if ([type isEqualToString:@"PurchaseItems"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];;
    }else if ([type isEqualToString:@"projectChooseType"]){
        _TypeLabel.text=model.projTyp;
    }else if ([type isEqualToString:@"BranchCompany"]){
        _TypeLabel.text=model.groupName;
    }else if ([type isEqualToString:@"FormReason"]){
        _TypeLabel.text=[NSString stringWithFormat:@"%@/%@",model.serialNo,model.taskName];
    }else if ([type isEqualToString:@"BDivision"]||[type isEqualToString:@"ConfigurationItem"]||[type isEqualToString:@"location"]||[type isEqualToString:@"area"]){
        _TypeLabel.text=model.name;
    }else if ([type isEqualToString:@"travelForm"]){
        
        _TypeLabel.frame = CGRectMake(50, 8, Main_Screen_Width-65, 19);
        _TypeLabel.text = [GPUtils getSelectResultWithArray:@[model.serialNo,model.reason]];

        UILabel *sub1 = [GPUtils createLable:CGRectMake(50, 29+2, Main_Screen_Width-65, 15) text:[GPUtils getSelectResultWithArray:@[model.requestor,model.requestorDept] WithCompare:@"/"] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:sub1];
        
    }else if ([type isEqualToString:@"travelForm"]||[type isEqualToString:@"FeeAppForms"]||[type isEqualToString:@"EntertainApp"]||[type isEqualToString:@"VehicleSvcApp"]||[type isEqualToString:@"ReceiveBill"]||[type isEqualToString:@"InvoiceForms"]||[type isEqualToString:@"StaffOut"]||[type isEqualToString:@"SpecialReqest"]||[type isEqualToString:@"EmployeeTrain"]||[type isEqualToString:@"VehicleForm"]||[type isEqualToString:@"PaymentApp"]||[type isEqualToString:@"StoreApp"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.serialNo,model.reason]];
    }else if ([type isEqualToString:@"Contracts"]||[type isEqualToString:@"RelateContAndApply"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName]];
        _TypeLabel.frame = CGRectMake(X(_TypeLabel), Y(_TypeLabel), WIDTH(_TypeLabel), 30);
        UILabel *lab = [GPUtils createLable:CGRectMake(50, 25, Main_Screen_Width-65, 20) text:[NSString stringWithFormat:@"%@%@",Custing(@"合同金额：", nil),[GPUtils transformNsNumber:model.totalAmount]] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        UILabel *lab1 = [GPUtils createLable:CGRectMake((Main_Screen_Width-65)/2+50, 25, (Main_Screen_Width-65)/2, 20) text:[NSString stringWithFormat:@"%@%@",Custing(@"已付金额：", nil),[GPUtils transformNsNumber:model.paidAmount]] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:lab];
        [self.mainView addSubview:lab1];
    }else if ([type isEqualToString:@"ContractsV3"]||[type isEqualToString:@"RelaContract"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.contractNo,model.contractName]];
    } else if ([type isEqualToString:@"PurchaseNumber"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.serialNo,model.reason]];
        _TypeLabel.frame = CGRectMake(X(_TypeLabel), Y(_TypeLabel), WIDTH(_TypeLabel), 30);
        UILabel *lab = [GPUtils createLable:CGRectMake(X(_TypeLabel), 25, WIDTH(_TypeLabel)/2, 20) text:[NSString stringWithFormat:@"%@:%@",Custing(@"采购金额", nil), [GPUtils transformNsNumber:model.totalAmount]] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:lab];
        UILabel *lab1 = [GPUtils createLable:CGRectMake(X(_TypeLabel)+(WIDTH(_TypeLabel)/2), 25, WIDTH(_TypeLabel)/2, 20) text:[NSString stringWithFormat:@"%@:%@",Custing(@"已付金额", nil),[GPUtils transformNsNumber:model.paidAmount]] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:lab1];
    }else if ([type isEqualToString:@"AdvanceType"]){
        _TypeLabel.text=model.type;
    }else if ([type isEqualToString:@"LeaveType"]){
        _TypeLabel.text=model.leaveType;
    }else if ([type isEqualToString:@"UserLevel"]){
        _TypeLabel.text=model.userLevel;
    }else if ([type isEqualToString:@"ContractType"]){
        _TypeLabel.text=model.contractTyp;
    }else if ([type isEqualToString:@"BusinessType"]){
        _TypeLabel.text=model.travelType;
    }else if ([type isEqualToString:@"Inventorys"]){
        _TypeLabel.text = [NSString stringWithFormat:@"%@/%@  (%@/%@)",model.code,model.name,model.pendingQty,model.qty];
    }else if ([type isEqualToString:@"AccountItem"]){
        _TypeLabel.text=  [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem]];
    }else if ([type isEqualToString:@"ProjActivitys"]){
        _TypeLabel.text=  [GPUtils getSelectResultWithArray:@[model.name_Lv1,model.name]];
    }else if ([type isEqualToString:@"ClearingBank"]){
        _TypeLabel.text=  model.clearingBank;
    }else if ([type isEqualToString:@"BankOutlets"]){
        _TypeLabel.text=  model.bankName;
    }
    [self.mainView addSubview:_TypeLabel];
}

- (void)configFreViewHasSubInfoWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 70)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSString *MarkId=[ChooseCategoryCell getFreModelSignWithModel:model WithType:type];
    
    if ([IdArray containsObject:MarkId]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 35);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 35);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    if ([type isEqualToString:@"ConfigurationItem"]&&IdArray.count==0&&_ChooseNamesArray&&[_ChooseNamesArray containsObject:model.name]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 35);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 10, Main_Screen_Width-65, 19) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_TypeLabel];
    
    UILabel *sub1 = [GPUtils createLable:CGRectMake(50, 29+2, Main_Screen_Width-65, 15) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:sub1];

    UILabel *sub2 = [GPUtils createLable:CGRectMake(50, 29+2+15+2, Main_Screen_Width-65, 15) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:sub2];
    
    if ([type isEqualToString:@"PayBankName"]) {
        _TypeLabel.text = model.accountName;
        sub1.text = model.bankName;
        sub2.text = model.bankAccount;
    }else if ([type isEqualToString:@"Supplier"]){
        _TypeLabel.text=[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        sub1.text = model.depositBank;
        sub2.text = model.bankAccount;
    }
}

+(NSString *)getFreModelSignWithModel:(ChooseCateFreModel *)model WithType:(NSString *)type{
    NSString *MarkId=@"";
    if ([type isEqualToString:@"projectName"]||[type isEqualToString:@"costCenter"]||[type isEqualToString:@"Client"]||[type isEqualToString:@"Supplier"]||[type isEqualToString:@"area"]||[type isEqualToString:@"location"]||[type isEqualToString:@"BDivision"]||[type isEqualToString:@"AdvanceType"]||[type isEqualToString:@"ConfigurationItem"]||[type isEqualToString:@"UserLevel"]||[type isEqualToString:@"LeaveType"]||[type isEqualToString:@"PurchaseItemTpls"]||[type isEqualToString:@"projectChooseType"]||[type isEqualToString:@"ContractType"]||[type isEqualToString:@"BusinessType"]||[type isEqualToString:@"Inventorys"]||[type isEqualToString:@"InventoryStorage"]) {
        MarkId=[NSString stringWithFormat:@"%@",model.Id];
    }else if ([type isEqualToString:@"BranchCompany"]){
        MarkId=[NSString stringWithFormat:@"%@",model.groupId];
    }else if ([type isEqualToString:@"travelForm"]||[type isEqualToString:@"FeeAppForms"]||[type isEqualToString:@"Contracts"]||[type isEqualToString:@"ContractsV3"]||[type isEqualToString:@"RelaContract"]||[type isEqualToString:@"EntertainApp"]||[type isEqualToString:@"VehicleSvcApp"]||[type isEqualToString:@"ReceiveBill"]||[type isEqualToString:@"InvoiceForms"]||[type isEqualToString:@"PurchaseNumber"]||[type isEqualToString:@"StaffOut"]||[type isEqualToString:@"SpecialReqest"]||[type isEqualToString:@"EmployeeTrain"]||[type isEqualToString:@"VehicleForm"]||[type isEqualToString:@"PaymentApp"]||[type isEqualToString:@"StoreApp"]||[type isEqualToString:@"RelateContAndApply"]){
        MarkId=[NSString stringWithFormat:@"%@",model.taskId];
    }else if ([type isEqualToString:@"PurchaseItems"]){
        MarkId=[NSString stringWithFormat:@"%@",model.purId];
    }else if ([type isEqualToString:@"AccountItem"]){
        MarkId=[NSString stringWithFormat:@"%@",model.accountItemCode];
    }else if ([type isEqualToString:@"ProjActivitys"]){
        MarkId = [NSString stringWithFormat:@"%@",model.Id];
    }
    return MarkId;
}

- (void)configFreViewWithString:(NSString *)str withIdStr:(NSString *)IdStr{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 45)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    if (![IdStr isEqualToString:@""]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 22.5);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 22.5);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    
    _TypeLabel.text=str;
    [self.mainView addSubview:_TypeLabel];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            subview.backgroundColor=Color_Sideslip_TableView;
        }
    }
}

-(void)configCateShowTypeWith:(NSMutableArray *)showTitle index:(NSIndexPath *)index showType:(NSInteger)showType showDes:(NSInteger )showDes{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 45)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    self.selectImageView.center=CGPointMake(25, 22.5);
    self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    [self.mainView addSubview:self.selectImageView];
    
    if (index.section==0) {
        if (index.row+1==showType) {
            self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        }
    }else{
        if (index.row==0&&showDes==1) {
            self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        }else if (index.row==1&&showDes==0){
            self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        }
    }
    
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _TypeLabel.text=showTitle[index.section][index.row];
    [self.mainView addSubview:_TypeLabel];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

