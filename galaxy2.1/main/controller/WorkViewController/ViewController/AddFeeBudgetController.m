//
//  AddFeeBudgetController.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddFeeBudgetController.h"
#import "BottomView.h"

@interface AddFeeBudgetController ()<UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  出差人视图
 */
@property(nonatomic,strong)UIView *View_People;
@property(nonatomic,strong)UITextField *txf_People;
/**
 *  城际往返交通
 */
@property(nonatomic,strong)UIView *View_InterTransFee;
@property(nonatomic,strong)UITextField *txf_InterTransFee;
/**
 *  城际往返交通天数
 */
@property(nonatomic,strong)UIView *View_InterTransDay;
@property(nonatomic,strong)UITextField *txf_InterTransDay;
/**
 *  市内交通
 */
@property(nonatomic,strong)UIView *View_CityTransFee;
@property(nonatomic,strong)UITextField *txf_CityTransFee;
/**
 *  市内交通天数
 */
@property(nonatomic,strong)UIView *View_CityTransDay;
@property(nonatomic,strong)UITextField *txf_CityTransDay;
/**
 *  住宿
 */
@property(nonatomic,strong)UIView *View_HotelFee;
@property(nonatomic,strong)UITextField *txf_HotelFee;
/**
 *  住宿天数
 */
@property(nonatomic,strong)UIView *View_HotelDay;
@property(nonatomic,strong)UITextField *txf_HotelDay;
/**
 *  业务招待
 */
@property(nonatomic,strong)UIView *View_EntertainmentFee;
@property(nonatomic,strong)UITextField *txf_EntertainmentFee;
/**
 *  业务招待天数
 */
@property(nonatomic,strong)UIView *View_EntertainmentDay;
@property(nonatomic,strong)UITextField *txf_EntertainmentDay;
/**
 *  伙食
 */
@property(nonatomic,strong)UIView *View_MealFee;
@property(nonatomic,strong)UITextField *txf_MealFee;
/**
 *  伙食天数
 */
@property(nonatomic,strong)UIView *View_MealDay;
@property(nonatomic,strong)UITextField *txf_MealDay;
/**
 *  通讯费
 */
@property(nonatomic,strong)UIView *View_CommunicationFee;
@property(nonatomic,strong)UITextField *txf_CommunicationFee;
/**
 *  通讯费天数
 */
@property(nonatomic,strong)UIView *View_CommunicationDay;
@property(nonatomic,strong)UITextField *txf_CommunicationDay;
/**
 *  出差补助
 */
@property(nonatomic,strong)UIView *View_TravelAllowance;
@property(nonatomic,strong)UITextField *txf_TravelAllowance;
/**
 *  出差补助天数
 */
@property(nonatomic,strong)UIView *View_TravelAllowanceDay;
@property(nonatomic,strong)UITextField *txf_TravelAllowanceDay;
/**
 *  驻外津贴
 */
@property(nonatomic,strong)UIView *View_OverseasAllowance;
@property(nonatomic,strong)UITextField *txf_OverseasAllowance;
/**
 *  驻外津贴天数
 */
@property(nonatomic,strong)UIView *View_OverseasAllowanceDay;
@property(nonatomic,strong)UITextField *txf_OverseasAllowanceDay;
/**
 *  其他
 */
@property(nonatomic,strong)UIView *View_OtherFee;
@property(nonatomic,strong)UITextField *txf_OtherFee;
/**
 *  其他
 */
@property(nonatomic,strong)UIView *View_OtherDay;
@property(nonatomic,strong)UITextField *txf_OtherDay;
/**
 *  合计
 */
@property(nonatomic,strong)UIView *View_TotalAmount;
@property(nonatomic,strong)UITextField *txf_TotalAmount;
/**
 *  合计
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;


@end

@implementation AddFeeBudgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"费用预算", nil) backButton:YES];
    if (!self.model) {
        self.model = [[FeeBudgetInfoModel alloc]init];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(Save:)];
    [self createScrollView];
    [self createMainView];
    [self updateMainView];
}
//MARK:创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    _View_People = [[UIView alloc]init];
    _View_People.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_People];
    [_View_People mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_InterTransFee = [[UIView alloc]init];
    _View_InterTransFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_InterTransFee];
    [_View_InterTransFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_People.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_InterTransDay = [[UIView alloc]init];
    _View_InterTransDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_InterTransDay];
    [_View_InterTransDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InterTransFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_CityTransFee = [[UIView alloc]init];
    _View_CityTransFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CityTransFee];
    [_View_CityTransFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InterTransDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_CityTransDay = [[UIView alloc]init];
    _View_CityTransDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CityTransDay];
    [_View_CityTransDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CityTransFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_HotelFee = [[UIView alloc]init];
    _View_HotelFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_HotelFee];
    [_View_HotelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CityTransDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_HotelDay = [[UIView alloc]init];
    _View_HotelDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_HotelDay];
    [_View_HotelDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HotelFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_EntertainmentFee = [[UIView alloc]init];
    _View_EntertainmentFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_EntertainmentFee];
    [_View_EntertainmentFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HotelDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_EntertainmentDay = [[UIView alloc]init];
    _View_EntertainmentDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_EntertainmentDay];
    [_View_EntertainmentDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EntertainmentFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_MealFee = [[UIView alloc]init];
    _View_MealFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_MealFee];
    [_View_MealFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EntertainmentDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_MealDay = [[UIView alloc]init];
    _View_MealDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_MealDay];
    [_View_MealDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MealFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];

    
    _View_CommunicationFee = [[UIView alloc]init];
    _View_CommunicationFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CommunicationFee];
    [_View_CommunicationFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MealDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_CommunicationDay = [[UIView alloc]init];
    _View_CommunicationDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CommunicationDay];
    [_View_CommunicationDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CommunicationFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_TravelAllowance = [[UIView alloc]init];
    _View_TravelAllowance.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelAllowance];
    [_View_TravelAllowance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CommunicationDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_TravelAllowanceDay = [[UIView alloc]init];
    _View_TravelAllowanceDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelAllowanceDay];
    [_View_TravelAllowanceDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelAllowance.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];

    
    _View_OverseasAllowance = [[UIView alloc]init];
    _View_OverseasAllowance.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OverseasAllowance];
    [_View_OverseasAllowance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelAllowanceDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_OverseasAllowanceDay = [[UIView alloc]init];
    _View_OverseasAllowanceDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OverseasAllowanceDay];
    [_View_OverseasAllowanceDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverseasAllowance.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_OtherFee = [[UIView alloc]init];
    _View_OtherFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OtherFee];
    [_View_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverseasAllowanceDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_OtherDay = [[UIView alloc]init];
    _View_OtherDay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OtherDay];
    [_View_OtherDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherFee.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_TotalAmount=[[UIView alloc]init];
    _View_TotalAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TotalAmount];
    [_View_TotalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherDay.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalAmount.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];

}
//MARK:视图更新
-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1) {
            [self updatePeople:model];
        }else if ([model.fieldName isEqualToString:@"InterTransFee"]&&[model.isShow floatValue]==1) {
            [self updateInterTransFee:model];
        }else if ([model.fieldName isEqualToString:@"InterTransDay"]&&[model.isShow floatValue]==1) {
            [self updateInterTransDay:model];
        }else if ([model.fieldName isEqualToString:@"CityTransFee"]&&[model.isShow floatValue]==1) {
            [self updateCityTransFee:model];
        }else if ([model.fieldName isEqualToString:@"CityTransDay"]&&[model.isShow floatValue]==1) {
            [self updateCityTransDay:model];
        }else if ([model.fieldName isEqualToString:@"HotelFee"]&&[model.isShow floatValue]==1) {
            [self updateHotelFee:model];
        }else if ([model.fieldName isEqualToString:@"HotelDay"]&&[model.isShow floatValue]==1) {
            [self updateHotelDay:model];
        }else if ([model.fieldName isEqualToString:@"EntertainmentFee"]&&[model.isShow floatValue]==1) {
            [self updateEntertainmentFee:model];
        }else if ([model.fieldName isEqualToString:@"EntertainmentDay"]&&[model.isShow floatValue]==1) {
            [self updateEntertainmentDay:model];
        }else if ([model.fieldName isEqualToString:@"MealFee"]&&[model.isShow floatValue]==1) {
            [self updateMealFee:model];
        }else if ([model.fieldName isEqualToString:@"MealDay"]&&[model.isShow floatValue]==1) {
            [self updateMealDay:model];
        }else if ([model.fieldName isEqualToString:@"CommunicationFee"]&&[model.isShow floatValue]==1) {
            [self updateCommunicationFee:model];
        }else if ([model.fieldName isEqualToString:@"CommunicationDay"]&&[model.isShow floatValue]==1) {
            [self updateCommunicationDay:model];
        }else if ([model.fieldName isEqualToString:@"TravelAllowance"]&&[model.isShow floatValue]==1) {
            [self updateTravelAllowance:model];
        }else if ([model.fieldName isEqualToString:@"TravelAllowanceDay"]&&[model.isShow floatValue]==1) {
            [self updateTravelAllowanceDay:model];
        }else if ([model.fieldName isEqualToString:@"OverseasAllowance"]&&[model.isShow floatValue]==1) {
            [self updateOverseasAllowance:model];
        }else if ([model.fieldName isEqualToString:@"OverseasAllowanceDay"]&&[model.isShow floatValue]==1) {
            [self updateOverseasAllowanceDay:model];
        }else if ([model.fieldName isEqualToString:@"OtherFee"]&&[model.isShow floatValue]==1) {
            [self updateOtherFee:model];
        }else if ([model.fieldName isEqualToString:@"OtherDay"]&&[model.isShow floatValue]==1) {
            [self updateOtherDay:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[model.isShow floatValue]==1) {
            [self updateTotalAmount:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[model.isShow floatValue]==1) {
            [self updateRemark:model];
        }
    }
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Remark.bottom);
    }];
}

-(void)updatePeople:(MyProcurementModel *)model{
    _txf_People=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_People WithContent:_txf_People WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.UserName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        NSMutableArray *array = [NSMutableArray array];
        NSArray *idarr = [[NSString stringWithIdOnNO:weakSelf.model.UserId] componentsSeparatedByString:@","];
        for (int i = 0 ; i<idarr.count ; i++) {
            NSDictionary *dic = @{@"requestorUserId":idarr[i]};
            [array addObject:dic];
        }
        contactVC.arrClickPeople = array;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio = @"1";
        [contactVC setBlock:^(NSMutableArray *array) {
            buildCellInfo *bul = array.lastObject;
            weakSelf.model.UserName = [NSString stringWithIdOnNO:bul.requestor];
            weakSelf.txf_People.text = weakSelf.model.UserName;
            weakSelf.model.UserId = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
        }];
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    [_View_People addSubview:view];
}

-(void)updateInterTransFee:(MyProcurementModel *)model{
    _txf_InterTransFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InterTransFee WithContent:_txf_InterTransFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.InterTransFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.InterTransFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_InterTransFee addSubview:view];
}
-(void)updateInterTransDay:(MyProcurementModel *)model{
    _txf_InterTransDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InterTransDay WithContent:_txf_InterTransDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.InterTransDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.InterTransDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_InterTransDay addSubview:view];
}
-(void)updateCityTransFee:(MyProcurementModel *)model{
    _txf_CityTransFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CityTransFee WithContent:_txf_CityTransFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.CityTransFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.CityTransFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_CityTransFee addSubview:view];
}
-(void)updateCityTransDay:(MyProcurementModel *)model{
    _txf_CityTransDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CityTransDay WithContent:_txf_CityTransDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.CityTransDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.CityTransDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_CityTransDay addSubview:view];
}
-(void)updateHotelFee:(MyProcurementModel *)model{
    _txf_HotelFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_HotelFee WithContent:_txf_HotelFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.HotelFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.HotelFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_HotelFee addSubview:view];
}
-(void)updateHotelDay:(MyProcurementModel *)model{
    _txf_HotelDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_HotelDay WithContent:_txf_HotelDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.HotelDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.HotelDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_HotelDay addSubview:view];
}
-(void)updateEntertainmentFee:(MyProcurementModel *)model{
    _txf_EntertainmentFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EntertainmentFee WithContent:_txf_EntertainmentFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.EntertainmentFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.EntertainmentFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_EntertainmentFee addSubview:view];
}
-(void)updateEntertainmentDay:(MyProcurementModel *)model{
    _txf_EntertainmentDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_EntertainmentDay WithContent:_txf_EntertainmentDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.EntertainmentDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.EntertainmentDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_EntertainmentDay addSubview:view];
}
-(void)updateMealFee:(MyProcurementModel *)model{
    _txf_MealFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_MealFee WithContent:_txf_MealFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.MealFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.MealFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_MealFee addSubview:view];
}
-(void)updateMealDay:(MyProcurementModel *)model{
    _txf_MealDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_MealDay WithContent:_txf_MealDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.MealDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.MealDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_MealDay addSubview:view];
}
-(void)updateCommunicationFee:(MyProcurementModel *)model{
    _txf_CommunicationFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CommunicationFee WithContent:_txf_CommunicationFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.CommunicationFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.CommunicationFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_CommunicationFee addSubview:view];
}
-(void)updateCommunicationDay:(MyProcurementModel *)model{
    _txf_CommunicationDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CommunicationDay WithContent:_txf_CommunicationDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.CommunicationDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.CommunicationDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_CommunicationDay addSubview:view];
}
-(void)updateTravelAllowance:(MyProcurementModel *)model{
    _txf_TravelAllowance=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelAllowance WithContent:_txf_TravelAllowance WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TravelAllowance}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.TravelAllowance = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_TravelAllowance addSubview:view];
}
-(void)updateTravelAllowanceDay:(MyProcurementModel *)model{
    _txf_TravelAllowanceDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TravelAllowanceDay WithContent:_txf_TravelAllowanceDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TravelAllowanceDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.TravelAllowanceDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_TravelAllowanceDay addSubview:view];
}
-(void)updateOverseasAllowance:(MyProcurementModel *)model{
    _txf_OverseasAllowance=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OverseasAllowance WithContent:_txf_OverseasAllowance WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.OverseasAllowance}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.OverseasAllowance = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_OverseasAllowance addSubview:view];
}
-(void)updateOverseasAllowanceDay:(MyProcurementModel *)model{
    _txf_OverseasAllowanceDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_OverseasAllowanceDay WithContent:_txf_OverseasAllowanceDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.OverseasAllowanceDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.OverseasAllowanceDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_OverseasAllowanceDay addSubview:view];
}
-(void)updateOtherFee:(MyProcurementModel *)model{
    _txf_OtherFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OtherFee WithContent:_txf_OtherFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.OtherFee}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.OtherFee = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_OtherFee addSubview:view];
}
-(void)updateOtherDay:(MyProcurementModel *)model{
    _txf_OtherDay = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_OtherDay WithContent:_txf_OtherDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.OtherDay}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.OtherDay = amount;
        [weakSelf getTotalAmount];
    }];
    [_View_OtherDay addSubview:view];
}
-(void)updateTotalAmount:(MyProcurementModel *)model{
    _txf_TotalAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalAmount WithContent:_txf_TotalAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TotalAmount}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.TotalAmount = amount;
    }];
    [_View_TotalAmount addSubview:view];
}

-(void)updateRemark:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.Remark}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.Remark=text;
    }];
    [_View_Remark addSubview:view];
}

-(void)getTotalAmount{
    NSString *total=@"";
    ;
    total = [GPUtils decimalNumberMultipWithString:_txf_InterTransFee.text with:(_txf_InterTransDay.text.length > 0 ? _txf_InterTransDay.text:@"1")];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_CityTransFee.text with:(_txf_CityTransDay.text.length > 0 ? _txf_CityTransDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_HotelFee.text with:(_txf_HotelDay.text.length > 0 ? _txf_HotelDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_EntertainmentFee.text with:(_txf_EntertainmentDay.text.length > 0 ? _txf_EntertainmentDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_MealFee.text with:(_txf_MealDay.text.length > 0 ? _txf_MealDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_CommunicationFee.text with:(_txf_CommunicationDay.text.length > 0 ? _txf_CommunicationDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_TravelAllowance.text with:(_txf_TravelAllowanceDay.text.length > 0 ? _txf_TravelAllowanceDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_OverseasAllowance.text with:(_txf_OverseasAllowanceDay.text.length > 0 ? _txf_OverseasAllowanceDay.text:@"1")]];
    total = [GPUtils decimalNumberAddWithString:total with:[GPUtils decimalNumberMultipWithString:_txf_OtherFee.text with:(_txf_OtherDay.text.length > 0 ? _txf_OtherDay.text:@"1")]];
    total = [GPUtils getRoundingOffNumber:total afterPoint:2];
    self.txf_TotalAmount.text = total;
    self.model.TotalAmount =total;
}

-(void)Save:(id)obj{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.UserId]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"InterTransFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.InterTransFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"InterTransDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.InterTransDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"CityTransFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.CityTransFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"CityTransDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.CityTransDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"HotelFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.HotelFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"HotelDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.HotelDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"EntertainmentFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.EntertainmentFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"EntertainmentDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.EntertainmentDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"MealFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.MealFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"MealDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.MealDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"CommunicationFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.CommunicationFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"CommunicationDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.CommunicationDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"TravelAllowance"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.TravelAllowance]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"TravelAllowanceDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.TravelAllowanceDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"OverseasAllowance"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.OverseasAllowance]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"OverseasAllowanceDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.OverseasAllowanceDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"OtherFee"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.OtherFee]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"OtherDay"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.OtherDay]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.Remark]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }
    }
    
    if (self.SaveBackBlock) {
        self.SaveBackBlock(self.model, self.type);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
