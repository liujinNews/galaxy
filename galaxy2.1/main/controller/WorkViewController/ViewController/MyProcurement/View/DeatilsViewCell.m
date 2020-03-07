//
//  DeatilsViewCell.m
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "DeatilsViewCell.h"
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@implementation DeatilsViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
//采购
-(void)configCellWithModel:(MyProcurementModel *)model withDetailsModel:(DeatilsModel *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"Name"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:deModel.Name]) {
            _NameTextField.text=deModel.Name;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        _NameTextField .keyboardType = UIKeyboardTypeDefault;
        _NameTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_NameTextField ];
        
        if ([model.ctrlTyp isEqualToString:@"dialog"]) {
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
                }else{
                    _NameTextField .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _NameTextField .placeholder=Custing(@"(必选)", nil);
                }
            }
            _NameTextField.userInteractionEnabled=NO;
            
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
            image.image=[UIImage imageNamed:@"skipImage"];
            [self.mainView addSubview:image ];
            
            _NameBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(NameBtn:) delegate:self];
            [self.mainView addSubview:_NameBtn];
        }else{
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)];
                }else{
                    _NameTextField .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _NameTextField .placeholder=Custing(@"(必填)", nil);
                }
            }
            _NameTextField.userInteractionEnabled=YES;
        }
        
    }else if ([model.fieldName isEqualToString:@"Brand"]) {
        _BrandTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _BrandTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _BrandTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _BrandTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Brand]) {
            _BrandTextField.text=deModel.Brand;
        }
        _BrandTextField .textAlignment = NSTextAlignmentLeft;
        _BrandTextField .keyboardType = UIKeyboardTypeDefault;
        _BrandTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_BrandTextField ];
    }else if ([model.fieldName isEqualToString:@"Size"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SizeTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Size]) {
            _SizeTextField.text=deModel.Size;
        }
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        _SizeTextField .keyboardType = UIKeyboardTypeDefault;
        _SizeTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"Qty"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Qty]) {
            _QtyTextField.text=deModel.Qty;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        _QtyTextField .keyboardType = UIKeyboardTypeDecimalPad;
        _QtyTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_QtyTextField];
    }else if ([model.fieldName isEqualToString:@"Unit"]){
        _UnitTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _UnitTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _UnitTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _UnitTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Unit]) {
            _UnitTextField.text=deModel.Unit;
        }
        _UnitTextField .textAlignment = NSTextAlignmentLeft;
        _UnitTextField .keyboardType = UIKeyboardTypeDefault;
        _UnitTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_UnitTextField];
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF.placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Amount]) {
            _AmountTF.text=deModel.Amount;
        }
        _AmountTF.textAlignment = NSTextAlignmentLeft;
        _AmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        _AmountTF.returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_AmountTF];
    }else if ([model.fieldName isEqualToString:@"Price"]){
        _PriceTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _PriceTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _PriceTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _PriceTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Price]) {
            _PriceTextField.text=deModel.Price;
        }
        _PriceTextField .textAlignment = NSTextAlignmentLeft;
        _PriceTextField .keyboardType = UIKeyboardTypeDecimalPad;
        _PriceTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_PriceTextField];
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        //        _NameTextField.backgroundColor=[UIColor redColor];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Remark]) {
            _RemarkTextField.text=deModel.Remark;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
        _SupplierTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _SupplierTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _SupplierTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.SupplierName]) {
            _SupplierTextField.text=deModel.SupplierName;
        }
        _SupplierTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SupplierTextField ];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _SupplierBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(SupplierBtn:) delegate:self];
        [self.mainView addSubview:_SupplierBtn];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)SupplierBtn:(UIButton *)btn{
    if (self.CellClickedBlock) {
        self.CellClickedBlock(self.IndexPath ,self.SupplierTextField);
    }
}
-(void)NameBtn:(UIButton *)btn{
    if (self.NameCellClickedBlock) {
        self.NameCellClickedBlock(self.IndexPath ,self.NameTextField);
    }
}
//物品领用
-(void)configItemCellWithModel:(MyProcurementModel *)model withDetailsModel:(ItemRequestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"Name"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        //        _NameTextField.backgroundColor=[UIColor redColor];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Name]) {
            _NameTextField.text=deModel.Name;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        _NameTextField .keyboardType = UIKeyboardTypeDefault;
        _NameTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_NameTextField ];
    }else if ([model.fieldName isEqualToString:@"Qty"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Qty]) {
            _QtyTextField.text=deModel.Qty;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        _QtyTextField .keyboardType = UIKeyboardTypeNumberPad;
        _QtyTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_QtyTextField];
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        //        _NameTextField.backgroundColor=[UIColor redColor];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Remark]) {
            _RemarkTextField.text=deModel.Remark;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

//费用申请
-(void)configFeeCellWithModel:(MyProcurementModel *)model withDetailsModel:(FeeAppDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    _titleLabel.numberOfLines=2;
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
        
        _ExpenseTypeTF=[GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12-20-10-32, 42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _ExpenseTypeTF.userInteractionEnabled=NO;
        [self.mainView addSubview:_ExpenseTypeTF];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _ExpenseTypeTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _ExpenseTypeTF.placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _ExpenseTypeTF.placeholder=Custing(@"(必选)", nil);
            }
        }
        
        _ExpenseTypeImg=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20-32, 5, 32, 32) imageName:nil];
        [self.mainView addSubview:_ExpenseTypeImg];
        
        UIImageView *image=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20) imageName:@"skipImage"];
        [self.mainView addSubview:image];
        
        _ExpenseTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 42)];
        [self.mainView addSubview:_ExpenseTypeBtn];
        
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",deModel.ExpenseCode]]&&![[NSString stringWithFormat:@"%@",deModel.ExpenseCode] isEqualToString:@"0"]) {
            _ExpenseTypeTF.text=[GPUtils getSelectResultWithArray:@[deModel.ExpenseCat,deModel.ExpenseType]];
            _ExpenseTypeImg.image =[UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",deModel.ExpenseIcon]]?[NSString stringWithFormat:@"%@",deModel.ExpenseIcon]:@"15"];
        }
    }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
        _ExpenseDescTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _ExpenseDescTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _ExpenseDescTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _ExpenseDescTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.ExpenseDesc]) {
            _ExpenseDescTF.text=deModel.ExpenseDesc;
        }
        _ExpenseDescTF .textAlignment = NSTextAlignmentLeft;
        _ExpenseDescTF .keyboardType = UIKeyboardTypeDefault;
        _ExpenseDescTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_ExpenseDescTF];
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Amount]) {
            _AmountTF.text=deModel.Amount;
        }
        _AmountTF .textAlignment = NSTextAlignmentLeft;
        _AmountTF .keyboardType = UIKeyboardTypeDecimalPad;
        _AmountTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_AmountTF];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
    
}

//用印
-(void)configChopCellWithModel:(MyProcurementModel *)model withDetailsModel:(MyChopDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"SealTypeId"]) {
        _SupplierTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _SupplierTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _SupplierTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.SealType]) {
            _SupplierTextField.text=deModel.SealType;
        }
        _SupplierTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SupplierTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _SupplierBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(SupplierBtn:) delegate:self];
        [self.mainView addSubview:_SupplierBtn];
    }else if ([model.fieldName isEqualToString:@"Qty"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Qty]) {
            _QtyTextField.text=deModel.Qty;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        _QtyTextField .keyboardType = UIKeyboardTypeNumberPad;
        _QtyTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_QtyTextField];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
    
}


//会议
-(void)configConferenceCellWithModel:(MyProcurementModel *)model withDetailsModel:(ConferenceDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"Subject"]){
        _SubjectTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SubjectTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SubjectTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SubjectTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Subject]) {
            _SubjectTF.text=deModel.Subject;
        }
        _SubjectTF .textAlignment = NSTextAlignmentLeft;
        _SubjectTF .keyboardType = UIKeyboardTypeDefault;
        _SubjectTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_SubjectTF];
    }else if ([model.fieldName isEqualToString:@"Spokesman"]) {
        _SpokesmanTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SpokesmanTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SpokesmanTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SpokesmanTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Spokesman]) {
            _SpokesmanTF.text=deModel.Spokesman;
        }
        _SpokesmanTF .textAlignment = NSTextAlignmentLeft;
        _SpokesmanTF .keyboardType = UIKeyboardTypeDefault;
        _SpokesmanTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_SpokesmanTF ];
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        //        _NameTextField.backgroundColor=[UIColor redColor];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Remark]) {
            _RemarkTextField.text=deModel.Remark;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}
//业务招待
-(void)configEntertainmentDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(id)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    _titleLabel.numberOfLines=2;
    [self.mainView addSubview:_titleLabel];
    
    
    if ([deModel isKindOfClass:[EntertainmentDeatil class]]) {
        EntertainmentDeatil *ContentModel=(EntertainmentDeatil *)deModel;
        if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
            _ExpenseTypeTF=[GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12-20-10-32, 42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            _ExpenseTypeTF.userInteractionEnabled=NO;
            [self.mainView addSubview:_ExpenseTypeTF];
            
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _ExpenseTypeTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
                }else{
                    _ExpenseTypeTF.placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _ExpenseTypeTF.placeholder=Custing(@"(必选)", nil);
                }
            }
            
            _ExpenseTypeImg=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20-32, 5, 32, 32) imageName:nil];
            [self.mainView addSubview:_ExpenseTypeImg];
            
            UIImageView *image=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20) imageName:@"skipImage"];
            [self.mainView addSubview:image];
            
            _ExpenseTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 42)];
            [self.mainView addSubview:_ExpenseTypeBtn];
            
            if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",ContentModel.ExpenseCode]]&&![[NSString stringWithFormat:@"%@",ContentModel.ExpenseCode] isEqualToString:@"0"]) {
                _ExpenseTypeTF.text=[GPUtils getSelectResultWithArray:@[ContentModel.ExpenseCat,ContentModel.ExpenseType]];
                _ExpenseTypeImg.image =[UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",ContentModel.ExpenseIcon]]?[NSString stringWithFormat:@"%@",ContentModel.ExpenseIcon]:@"15"];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
            _ExpenseDescTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _ExpenseDescTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
                }else{
                    _ExpenseDescTF .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _ExpenseDescTF .placeholder=Custing(@"(必填)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.ExpenseDesc]) {
                _ExpenseDescTF.text=ContentModel.ExpenseDesc;
            }
            _ExpenseDescTF .textAlignment = NSTextAlignmentLeft;
            _ExpenseDescTF .keyboardType = UIKeyboardTypeDefault;
            _ExpenseDescTF .returnKeyType = UIReturnKeyDefault;
            [self.mainView addSubview:_ExpenseDescTF];
        }else if ([model.fieldName isEqualToString:@"Amount"]){
            _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _AmountTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
                }else{
                    _AmountTF .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _AmountTF .placeholder=Custing(@"(必填)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.Amount]) {
                _AmountTF.text=ContentModel.Amount;
            }
            _AmountTF .textAlignment = NSTextAlignmentLeft;
            _AmountTF .keyboardType = UIKeyboardTypeDecimalPad;
            _AmountTF .returnKeyType = UIReturnKeyDefault;
            [self.mainView addSubview:_AmountTF];
        }else if ([model.fieldName isEqualToString:@"Remark"]) {
            _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
                }else{
                    _RemarkTextField .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _RemarkTextField .placeholder=Custing(@"(必填)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.Remark]) {
                _RemarkTextField.text=ContentModel.Remark;
            }
            _RemarkTextField .textAlignment = NSTextAlignmentLeft;
            _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
            _RemarkTextField .returnKeyType = UIReturnKeyDefault;
            [self.mainView addSubview:_RemarkTextField ];
        }
    }else if ([deModel isKindOfClass:[EntertainmentSchDeatil class]]){
        
        EntertainmentSchDeatil *ContentModel=(EntertainmentSchDeatil *)deModel;
        if ([model.fieldName isEqualToString:@"EntertainDate"]) {
            _DateTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            _DateTextField.userInteractionEnabled=NO;
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _DateTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
                }else{
                    _DateTextField .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _DateTextField .placeholder=Custing(@"(必选)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.EntertainDate]) {
                _DateTextField.text=ContentModel.EntertainDate;
            }
            _DateTextField .textAlignment = NSTextAlignmentLeft;
            [self.mainView addSubview:_DateTextField ];
            
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
            image.image=[UIImage imageNamed:@"skipImage"];
            [self.mainView addSubview:image ];
            
            _DateBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(DateBtn:) delegate:self];
            [self.mainView addSubview:_DateBtn];
            
        }else if ([model.fieldName isEqualToString:@"EntertainAddr"]) {
            _AddressTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _AddressTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
                }else{
                    _AddressTF .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _AddressTF .placeholder=Custing(@"(必填)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.EntertainAddr]) {
                _AddressTF.text=ContentModel.EntertainAddr;
            }
            _AddressTF .textAlignment = NSTextAlignmentLeft;
            _AddressTF .keyboardType = UIKeyboardTypeDefault;
            _AddressTF .returnKeyType = UIReturnKeyDefault;
            [self.mainView addSubview:_AddressTF ];
        }else if ([model.fieldName isEqualToString:@"EntertainContent"]) {
            _ContentTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
            
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    _ContentTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
                }else{
                    _ContentTF .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    _ContentTF .placeholder=Custing(@"(必填)", nil);
                }
            }
            
            if ([NSString isEqualToNull:ContentModel.EntertainContent]) {
                _ContentTF.text=ContentModel.EntertainContent;
            }
            _ContentTF .textAlignment = NSTextAlignmentLeft;
            _ContentTF .keyboardType = UIKeyboardTypeDefault;
            _ContentTF .returnKeyType = UIReturnKeyDefault;
            [self.mainView addSubview:_ContentTF ];
        }
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)DateBtn:(UIButton *)obj{
    UIViewController *vc=[GPUtils getCurrentVC];
    [vc.view endEditing:YES];
    _datePicker = [[UIDatePicker alloc]init];
    NSString *dateStr;
    if ([NSString isEqualToNull:_DateTextField.text]) {
        dateStr=_DateTextField.text;
        _selectDataString=_DateTextField.text;
    }else{
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        dateStr=currStr;
        _selectDataString=currStr;
    }
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *fromdate=[format dateFromString:dateStr];
    _datePicker.date=fromdate;
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"日期", nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btnClick:) delegate:self title:Custing(@"确定", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    sureDataBtn.tag=12;
    [view addSubview:sureDataBtn];
    
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btnClick:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    cancelDataBtn.tag = 14;
    [view addSubview:cancelDataBtn];
    
    if (!_DateChooseView) {
        _DateChooseView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _DateChooseView.delegate = self;
    }
    
    [_DateChooseView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    
}
-(void)DateChanged:(UIDatePicker *)sender{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    _selectDataString=str;
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==12){//确定选择日期
        if (_selectDataString) {
            _DateTextField.text =_selectDataString;
            if (self.CellClickedBlock) {
                self.CellClickedBlock(self.IndexPath ,self.DateTextField);
            }
            if (self.CellClickedWithModelBlock) {
                self.CellClickedWithModelBlock(self.IndexPath, self.DateTextField, self.model);
            }
        }
        [_DateChooseView remove];
    }else if (btn.tag == 14){
        [_DateChooseView remove];
        _DateChooseView = nil;
        _datePicker = nil;
    }
}
#pragma mark - delegate
-(void)dimsissPDActionView{
    _DateChooseView = nil;
}

-(void)configVehicleRepairDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(VehicleRepairDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    _titleLabel.numberOfLines=2;
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
        _ExpenseTypeTF=[GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12-20-10-32, 42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _ExpenseTypeTF.userInteractionEnabled=NO;
        [self.mainView addSubview:_ExpenseTypeTF];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _ExpenseTypeTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _ExpenseTypeTF.placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _ExpenseTypeTF.placeholder=Custing(@"(必选)", nil);
            }
        }
        
        _ExpenseTypeImg=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20-32, 5, 32, 32) imageName:nil];
        [self.mainView addSubview:_ExpenseTypeImg];
        
        UIImageView *image=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20) imageName:@"skipImage"];
        [self.mainView addSubview:image];
        
        _ExpenseTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 42)];
        [self.mainView addSubview:_ExpenseTypeBtn];
        
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",deModel.ExpenseCode]]&&![[NSString stringWithFormat:@"%@",deModel.ExpenseCode] isEqualToString:@"0"]) {
            _ExpenseTypeTF.text=[GPUtils getSelectResultWithArray:@[deModel.ExpenseCat,deModel.ExpenseType]];
            _ExpenseTypeImg.image =[UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",deModel.ExpenseIcon]]?[NSString stringWithFormat:@"%@",deModel.ExpenseIcon]:@"15"];
        }
    }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
        _ExpenseDescTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _ExpenseDescTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _ExpenseDescTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _ExpenseDescTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.ExpenseDesc]) {
            _ExpenseDescTF.text=deModel.ExpenseDesc;
        }
        _ExpenseDescTF .textAlignment = NSTextAlignmentLeft;
        _ExpenseDescTF .keyboardType = UIKeyboardTypeDefault;
        _ExpenseDescTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_ExpenseDescTF];
        
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Amount]) {
            _AmountTF.text=deModel.Amount;
        }
        _AmountTF .textAlignment = NSTextAlignmentLeft;
        _AmountTF .keyboardType = UIKeyboardTypeDecimalPad;
        _AmountTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_AmountTF];
        
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Remark]) {
            _RemarkTextField.text=deModel.Remark;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)configSupplierApplyDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(SupplierDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    if ([model.fieldName isEqualToString:@"Name"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:deModel.Name]) {
            _NameTextField.text=deModel.Name;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        _NameTextField .keyboardType = UIKeyboardTypeDefault;
        _NameTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_NameTextField ];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)];
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
    }else if ([model.fieldName isEqualToString:@"Sex"]) {
        _SupplierTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _SupplierTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _SupplierTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Sex]) {
            if ([deModel.Sex floatValue] == 1) {
                _SupplierTextField.text = Custing(@"男", nil);
            }else if ([deModel.Sex floatValue] == 2){
                _SupplierTextField.text = Custing(@"女", nil);
            }
        }
        _SupplierTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SupplierTextField ];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _SupplierBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(SupplierBtn:) delegate:self];
        [self.mainView addSubview:_SupplierBtn];
    }else if ([model.fieldName isEqualToString:@"Dept"]) {
        _BrandTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _BrandTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _BrandTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _BrandTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Dept]) {
            _BrandTextField.text=deModel.Dept;
        }
        _BrandTextField .textAlignment = NSTextAlignmentLeft;
        _BrandTextField .keyboardType = UIKeyboardTypeDefault;
        _BrandTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_BrandTextField ];
    }else if ([model.fieldName isEqualToString:@"JobTitle"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SizeTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.JobTitle]) {
            _SizeTextField.text=deModel.JobTitle;
        }
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        _SizeTextField .keyboardType = UIKeyboardTypeDefault;
        _SizeTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"Tel"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Tel]) {
            _QtyTextField.text=deModel.Tel;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        _QtyTextField .keyboardType = UIKeyboardTypeDefault;
        _QtyTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_QtyTextField];
    }else if ([model.fieldName isEqualToString:@"Email"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        //        _NameTextField.backgroundColor=[UIColor redColor];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Email]) {
            _RemarkTextField.text=deModel.Email;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)configEntertainVistorDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(EntertainmentVisitorDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{

    _model = model;

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    _titleLabel.numberOfLines=2;
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"Name"]){
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Name]) {
            _NameTextField.text=deModel.Name;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        _NameTextField .keyboardType = UIKeyboardTypeDefault;
        _NameTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_NameTextField];
        
    }else if ([model.fieldName isEqualToString:@"JobTitle"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SizeTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=Custing(@"(必填)", nil);
            }
        }

        if ([NSString isEqualToNull:deModel.JobTitle]) {
            _SizeTextField.text=deModel.JobTitle;
        }
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        _SizeTextField .keyboardType = UIKeyboardTypeDefault;
        _SizeTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"Department"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Department]) {
            _QtyTextField.text=deModel.Department;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        _QtyTextField .keyboardType = UIKeyboardTypeDefault;
        _QtyTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_QtyTextField];
        
    }else if ([model.fieldName isEqualToString:@"VisitDate"]) {
        _DateTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _DateTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _DateTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _DateTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _DateTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.VisitDate]) {
            _DateTextField.text=deModel.VisitDate;
        }
        _DateTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_DateTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _DateBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(DateBtn:) delegate:self];
        [self.mainView addSubview:_DateBtn];
        
    }else if ([model.fieldName isEqualToString:@"LeaveDate"]) {
        _DateTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _DateTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _DateTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _DateTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _DateTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.LeaveDate]) {
            _DateTextField.text=deModel.LeaveDate;
        }
        _DateTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_DateTextField ];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _DateBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(DateBtn:) delegate:self];
        [self.mainView addSubview:_DateBtn];
        
    }else if ([model.fieldName isEqualToString:@"CostCenter"]) {
        _SupplierTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _SupplierTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _SupplierTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.CostCenter]) {
            _SupplierTextField.text=deModel.CostCenter;
        }
        _SupplierTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SupplierTextField ];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _SupplierBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(SupplierBtn:) delegate:self];
        [self.mainView addSubview:_SupplierBtn];
    }else if ([model.fieldName isEqualToString:@"BudgetAmt"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF.placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.BudgetAmt]) {
            _AmountTF.text=deModel.BudgetAmt;
        }
        _AmountTF.textAlignment = NSTextAlignmentLeft;
        _AmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        _AmountTF.returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_AmountTF];
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        _RemarkTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _RemarkTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _RemarkTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Remark]) {
            _RemarkTextField.text=deModel.Remark;
        }
        _RemarkTextField .textAlignment = NSTextAlignmentLeft;
        _RemarkTextField .keyboardType = UIKeyboardTypeDefault;
        _RemarkTextField .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_RemarkTextField ];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)configPmtMethodDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(pmtMethodDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"Amount"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Amount]) {
            _AmountTF.text=deModel.Amount;
        }
        _AmountTF .textAlignment = NSTextAlignmentLeft;
        _AmountTF .keyboardType = UIKeyboardTypeDecimalPad;
        _AmountTF .returnKeyType = UIReturnKeyDefault;
        [self.mainView addSubview:_AmountTF];
        
    }else if ([model.fieldName isEqualToString:@"Currency"]) {
        _SupplierTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _SupplierTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _SupplierTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SupplierTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Currency]) {
            _SupplierTextField.text=deModel.Currency;
        }
        _SupplierTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SupplierTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _SupplierBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(SupplierBtn:) delegate:self];
        [self.mainView addSubview:_SupplierBtn];
    }else if ([model.fieldName isEqualToString:@"PmtMethod"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _NameTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.PmtMethod]) {
            _NameTextField.text=deModel.PmtMethod;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_NameTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _NameBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(NameBtn:) delegate:self];
        [self.mainView addSubview:_NameBtn];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
    
}


-(void)configSpecialReqestDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(SpecialReqestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"StdType"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _NameTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.StdType]) {
            _NameTextField.text=deModel.StdType;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_NameTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _NameBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(NameBtn:) delegate:self];
        [self.mainView addSubview:_NameBtn];
    }else if ([model.fieldName isEqualToString:@"Standard"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Standard]) {
            _AmountTF.text=deModel.Standard;
        }
        _AmountTF .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_AmountTF];
        
    }else if ([model.fieldName isEqualToString:@"ActualExecution"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SizeTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.ActualExecution]) {
            _SizeTextField.text=deModel.ActualExecution;
        }
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"Reason"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Reason]) {
            _QtyTextField.text=deModel.Reason;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_QtyTextField];
    }
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}


-(void)configEmployeeTrainDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(EmployeeTrainDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"UserName"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _NameTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.UserName]) {
            _NameTextField.text=deModel.UserName;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_NameTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        
        _NameBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(NameBtn:) delegate:self];
        [self.mainView addSubview:_NameBtn];
    }else if ([model.fieldName isEqualToString:@"UserDept"]){
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0, Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:deModel.UserDept]) {
            _AmountTF.text=deModel.UserDept;
        }
        _AmountTF.userInteractionEnabled = NO;
        _AmountTF .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_AmountTF];
        
    }else if ([model.fieldName isEqualToString:@"JobTitle"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:deModel.JobTitle]) {
            _SizeTextField.text=deModel.JobTitle;
        }
        _SizeTextField.userInteractionEnabled = NO;
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"UserLevel"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:deModel.UserLevel]) {
            _QtyTextField.text=deModel.UserLevel;
        }
        _QtyTextField.userInteractionEnabled = NO;
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_QtyTextField];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }
}

-(void)configPayeeDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(PayeeDetails *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 42)];
    [self.contentView addSubview:self.mainView];
    
    _titleLabel=[GPUtils createLable:CGRectMake(0,0,XBHelper_Title_Width, 42) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines=2;
    _titleLabel.center=CGPointMake(12+XBHelper_Title_Width/2, 21);
    //    _titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:_titleLabel];
    
    if ([model.fieldName isEqualToString:@"Payee"]) {
        _NameTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12-20,42) placeholder:Custing(@"请选择", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _NameTextField.userInteractionEnabled=NO;
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _NameTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _NameTextField .placeholder=Custing(@"(必选)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Payee]) {
            _NameTextField.text=deModel.Payee;
        }
        _NameTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_NameTextField];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-20, 11, 20, 20)];
        image.image=[UIImage imageNamed:@"skipImage"];
        [self.mainView addSubview:image ];
        _NameBtn=[GPUtils createButton:CGRectMake(40, 0, Main_Screen_Width-40, 42) action:@selector(NameBtn:) delegate:self];
        [self.mainView addSubview:_NameBtn];
    }else if ([model.fieldName isEqualToString:@"DepositBank"]){
        _SizeTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _SizeTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _SizeTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.DepositBank]) {
            _SizeTextField.text=deModel.DepositBank;
        }
        _SizeTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_SizeTextField];
    }else if ([model.fieldName isEqualToString:@"BankAccount"]){
        _QtyTextField = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _QtyTextField .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _QtyTextField .placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.BankAccount]) {
            _QtyTextField.text=deModel.BankAccount;
        }
        _QtyTextField .textAlignment = NSTextAlignmentLeft;
        [self.mainView addSubview:_QtyTextField];
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        
        _AmountTF = [GPUtils createTextField:CGRectMake(12+15+XBHelper_Title_Width, 0,Main_Screen_Width-12-15-XBHelper_Title_Width-12,42) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _AmountTF.placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _AmountTF.placeholder=Custing(@"(必填)", nil);
            }
        }
        
        if ([NSString isEqualToNull:deModel.Amount]) {
            _AmountTF.text=deModel.Amount;
        }
        _AmountTF.textAlignment = NSTextAlignmentLeft;
        _AmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        [self.mainView addSubview:_AmountTF];
    }
    
    if (index!=count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(X(_titleLabel), 41, Main_Screen_Width-X(_titleLabel), 1)];
        lineView.backgroundColor=Color_White_Same_20;
        [self.mainView addSubview:lineView];
    }

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
