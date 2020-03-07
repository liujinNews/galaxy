//
//  AddTravelInfoController.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddTravelInfoController.h"
#import "BottomView.h"
#import "NewAddressViewController.h"


@interface AddTravelInfoController ()<UIScrollViewDelegate>
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
 *  去程地点视图
 */
@property(nonatomic,strong)UIView *View_FromCity;
@property(nonatomic,strong)UITextField *txf_FromCity;
/**
 *  去程价格视图
 */
@property(nonatomic,strong)UIView *View_FromAmt;
@property(nonatomic,strong)UITextField *txf_FromAmt;
/**
 *  返程地点视图
 */
@property(nonatomic,strong)UIView *View_BackCity;
@property(nonatomic,strong)UITextField *txf_BackCity;
/**
 *  返程价格视图
 */
@property(nonatomic,strong)UIView *View_BackAmt;
@property(nonatomic,strong)UITextField *txf_BackAmt;
/**
 *  合计视图
 */
@property(nonatomic,strong)UIView *View_TolAmt;
@property(nonatomic,strong)UITextField *txf_TolAmt;

@end

@implementation AddTravelInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"出行信息", nil) backButton:YES];
    if (!self.model) {
        self.model = [[TravelInfoModel alloc]init];
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
    _View_People=[[UIView alloc]init];
    _View_People.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_People];
    [_View_People mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_FromCity=[[UIView alloc]init];
    _View_FromCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_FromCity];
    [_View_FromCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_People.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_FromAmt=[[UIView alloc]init];
    _View_FromAmt.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_FromAmt];
    [_View_FromAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_BackCity=[[UIView alloc]init];
    _View_BackCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackCity];
    [_View_BackCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromAmt.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_BackAmt=[[UIView alloc]init];
    _View_BackAmt.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackAmt];
    [_View_BackAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackCity.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_TolAmt=[[UIView alloc]init];
    _View_TolAmt.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TolAmt];
    [_View_TolAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackAmt.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
}
//MARK:视图更新
-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1) {
            [self updatePeople:model];
        }else if ([model.fieldName isEqualToString:@"Departure"]&&[model.isShow floatValue]==1) {
            [self updateFromCity:model];
        }else if ([model.fieldName isEqualToString:@"DepartureAmt"]&&[model.isShow floatValue]==1) {
            [self updateFromAmt:model];
        }else if ([model.fieldName isEqualToString:@"ReturnAddr"]&&[model.isShow floatValue]==1) {
            [self updateBackCity:model];
        }else if ([model.fieldName isEqualToString:@"ReturnAmt"]&&[model.isShow floatValue]==1) {
            [self updateBackAmt:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[model.isShow floatValue]==1) {
            [self updateTotalAmount:model];
        }
    }
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_TolAmt.bottom);
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
-(void)updateFromCity:(MyProcurementModel *)model{
    _txf_FromCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.Departure}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.Departure=text;
    }];
//    [view setFormClickedBlock:^(MyProcurementModel *model) {
//        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
//        addVc.Type=1;
//        addVc.isGocity = @"1";
//        addVc.status = @"21";
//        [addVc setSelectAddressBlock:^(NSArray *array, NSString *start) {
//            NSDictionary *dic = array[0];
//            weakSelf.model.Departure = [self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dic[@"cityName"]]:[NSString stringWithIdOnNO:dic[@"cityNameEn"]];
//            weakSelf.txf_FromCity.text = weakSelf.model.Departure;
//            //            dic[@"cityCode"];
//        }];
//        [weakSelf.navigationController pushViewController:addVc animated:YES];
//    }];
    [_View_FromCity addSubview:view];
    
//    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(12, 5, 30, 13) imageName:Custing(@"AddTravelInfo_go", nil)];
//    [_View_FromCity addSubview:img];
    
}

-(void)updateFromAmt:(MyProcurementModel *)model{
    _txf_FromAmt=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromAmt WithContent:_txf_FromAmt WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.DepartureAmt}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.DepartureAmt = amount;
        weakSelf.model.TotalAmount = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberAddWithString:amount with:weakSelf.model.ReturnAmt]) afterPoint:2];
        weakSelf.txf_TolAmt.text = weakSelf.model.TotalAmount;
    }];
    [_View_FromAmt addSubview:view];
}
-(void)updateBackCity:(MyProcurementModel *)model{
    _txf_BackCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackCity WithContent:_txf_BackCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.ReturnAddr}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.ReturnAddr=text;
    }];
//    [view setFormClickedBlock:^(MyProcurementModel *model) {
//        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
//        addVc.Type=1;
//        addVc.isGocity = @"1";
//        addVc.status = @"21";
//        [addVc setSelectAddressBlock:^(NSArray *array, NSString *start) {
//            NSDictionary *dic = array[0];
//            weakSelf.model.ReturnAddr = [self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dic[@"cityName"]]:[NSString stringWithIdOnNO:dic[@"cityNameEn"]];
//            weakSelf.txf_BackCity.text = weakSelf.model.ReturnAddr;
//            //            dic[@"cityCode"];
//        }];
//        [weakSelf.navigationController pushViewController:addVc animated:YES];
//    }];
    [_View_BackCity addSubview:view];
    
//    UIImageView *img = [GPUtils createImageViewFrame:CGRectMake(12, 5, 30, 13) imageName:Custing(@"AddTravelInfo_back", nil)];
//    [_View_BackCity addSubview:img];

}

-(void)updateBackAmt:(MyProcurementModel *)model{
    _txf_BackAmt=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackAmt WithContent:_txf_BackAmt WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.ReturnAmt}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.ReturnAmt = amount;
        weakSelf.model.TotalAmount = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberAddWithString:amount with:weakSelf.model.DepartureAmt]) afterPoint:2];
        weakSelf.txf_TolAmt.text = weakSelf.model.TotalAmount;
    }];
    [_View_BackAmt addSubview:view];
}
-(void)updateTotalAmount:(MyProcurementModel *)model{
    _txf_TolAmt=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TolAmt WithContent:_txf_TolAmt WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TotalAmount}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.model.TotalAmount = amount;
    }];
    [_View_TolAmt addSubview:view];
}

-(void)Save:(id)obj{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.UserId]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"Departure"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.Departure]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"DepartureAmt"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.DepartureAmt]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"ReturnAddr"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.ReturnAddr]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"ReturnAmt"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.ReturnAmt]) {
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
