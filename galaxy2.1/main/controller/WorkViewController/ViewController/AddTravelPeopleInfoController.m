//
//  AddTravelPeopleInfoController.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddTravelPeopleInfoController.h"
#import "BottomView.h"
#import "NewAddressViewController.h"

@interface AddTravelPeopleInfoController ()<UIScrollViewDelegate>
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
 *  身份证视图
 */
@property(nonatomic,strong)UIView *View_IdNum;
@property(nonatomic,strong)UITextField *txf_IdNum;
/**
 *  部门视图
 */
@property(nonatomic,strong)UIView *View_Dept;
@property(nonatomic,strong)UITextField *txf_Dept;
/**
 *  职位视图
 */
@property(nonatomic,strong)UIView *View_JobTitle;
@property(nonatomic,strong)UITextField *txf_JobTitle;
/**
 *  级别视图
 */
@property(nonatomic,strong)UIView *View_UserLev;
@property(nonatomic,strong)UITextField *txf_UserLev;
/**
 *  出差目的
 */
@property(nonatomic,strong)UIView *View_Purpose;
@property(nonatomic,strong)UITextField *txf_Purpose;
/**
 *  出差地点
 */
@property(nonatomic,strong)UIView *View_Addr;
@property(nonatomic,strong)UITextField *txf_Addr;
/**
 *  出差时间
 */
@property(nonatomic,strong)UIView *View_Time;
@property(nonatomic,strong)UITextField *txf_Time;

@end

@implementation AddTravelPeopleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"出差人员信息", nil) backButton:YES];
    if (!self.model) {
        self.model = [[TravelPeopleInfoModel alloc]init];
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
    
    _View_IdNum=[[UIView alloc]init];
    _View_IdNum.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_IdNum];
    [_View_IdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_People.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Dept=[[UIView alloc]init];
    _View_Dept.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Dept];
    [_View_Dept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IdNum.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_JobTitle=[[UIView alloc]init];
    _View_JobTitle.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_JobTitle];
    [_View_JobTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Dept.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_UserLev=[[UIView alloc]init];
    _View_UserLev.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_UserLev];
    [_View_UserLev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_JobTitle.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Purpose=[[UIView alloc]init];
    _View_Purpose.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Purpose];
    [_View_Purpose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_UserLev.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Addr=[[UIView alloc]init];
    _View_Addr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Addr];
    [_View_Addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Purpose.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Time=[[UIView alloc]init];
    _View_Time.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Time];
    [_View_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Addr.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
}
//MARK:视图更新
-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1) {
                [self updatePeople:model];
        }else if ([model.fieldName isEqualToString:@"IdNumber"]&&[model.isShow floatValue]==1) {
            [self updateIdNum:model];
        }else if ([model.fieldName isEqualToString:@"UserDept"]&&[model.isShow floatValue]==1) {
            [self updateDept:model];
        }else if ([model.fieldName isEqualToString:@"JobTitle"]&&[model.isShow floatValue]==1) {
            [self updateJobTitle:model];
        }else if ([model.fieldName isEqualToString:@"UserLevel"]&&[model.isShow floatValue]==1) {
            [self updateUserLev:model];
        }else if ([model.fieldName isEqualToString:@"TravelPurpose"]&&[model.isShow floatValue]==1) {
            [self updatePurpose:model];
        }else if ([model.fieldName isEqualToString:@"TravelAddr"]&&[model.isShow floatValue]==1) {
            [self updateAddr:model];
        }else if ([model.fieldName isEqualToString:@"TravelTime"]&&[model.isShow floatValue]==1) {
            [self updateTime:model];
        }
    }
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Time.bottom);
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
            weakSelf.model.UserDept = [NSString stringWithIdOnNO:bul.requestorDept];
            weakSelf.txf_Dept.text = weakSelf.model.UserDept;
            weakSelf.model.UserDeptId = [NSString stringWithIdOnNO:bul.requestorDeptId];
            weakSelf.model.JobTitle = [NSString stringWithIdOnNO:bul.jobTitle];
            weakSelf.txf_JobTitle.text = weakSelf.model.JobTitle;
            weakSelf.model.JobTitleCode = [NSString stringWithIdOnNO:bul.jobTitleCode];
            weakSelf.model.UserLevel = [NSString stringWithIdOnNO:bul.userLevel];
            weakSelf.txf_UserLev.text = weakSelf.model.UserLevel;
            weakSelf.model.UserLevelId = [NSString stringWithIdOnNO:bul.userLevelId];
        }];
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    [_View_People addSubview:view];
}
-(void)updateIdNum:(MyProcurementModel *)model{
    _txf_IdNum=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IdNum WithContent:_txf_IdNum WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.IdNumber}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.IdNumber = text;
    }];
    [_View_IdNum addSubview:view];
}
-(void)updateDept:(MyProcurementModel *)model{
    _txf_Dept=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Dept WithContent:_txf_Dept WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.UserDept}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.UserDept = text;
    }];
    [_View_Dept addSubview:view];
}
-(void)updateJobTitle:(MyProcurementModel *)model{
    _txf_JobTitle=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_JobTitle WithContent:_txf_JobTitle WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.JobTitle}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.JobTitle = text;
    }];
    [_View_JobTitle addSubview:view];
    
}
-(void)updateUserLev:(MyProcurementModel *)model{
    _txf_UserLev=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_UserLev WithContent:_txf_UserLev WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.UserLevel}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.UserLevel = text;
    }];
    [_View_UserLev addSubview:view];
}
-(void)updatePurpose:(MyProcurementModel *)model{
    _txf_Purpose=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Purpose WithContent:_txf_Purpose WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TravelPurpose}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.TravelPurpose = text;
    }];
    [_View_Purpose addSubview:view];
}
-(void)updateAddr:(MyProcurementModel *)model{
    _txf_Addr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Addr WithContent:_txf_Addr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TravelAddr}];
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        weakSelf.model.TravelAddr=text;
    }];
//    [view setFormClickedBlock:^(MyProcurementModel *model) {
//        NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
//        addVc.Type=1;
//        addVc.isGocity = @"1";
//        addVc.status = @"21";
//        [addVc setSelectAddressBlock:^(NSArray *array, NSString *start) {
//            NSDictionary *dic = array[0];
//            weakSelf.model.TravelAddr = [self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dic[@"cityName"]]:[NSString stringWithIdOnNO:dic[@"cityNameEn"]];
//            weakSelf.txf_Addr.text = weakSelf.model.TravelAddr;
//            //            dic[@"cityCode"];
//        }];
//        [weakSelf.navigationController pushViewController:addVc animated:YES];
//    }];
    [_View_Addr addSubview:view];
}
-(void)updateTime:(MyProcurementModel *)model{
    _txf_Time=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Time WithContent:_txf_Time WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.model.TravelTime}];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.model.TravelTime = selectTime;
    }];
    [_View_Time addSubview:view];

}
-(void)Save:(id)obj{
    for (MyProcurementModel *model in self.arr_Main) {
        if ([model.fieldName isEqualToString:@"UserName"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.UserId]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"IdNumber"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.IdNumber]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"TravelPurpose"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.TravelPurpose]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"TravelAddr"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.TravelAddr]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithIdOnNO:model.tips] duration:1.0];
            return;
        }else if ([model.fieldName isEqualToString:@"TravelTime"]&&[model.isShow floatValue]==1&&[model.isRequired floatValue]==1&&![NSString isEqualToNull:self.model.TravelTime]) {
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
