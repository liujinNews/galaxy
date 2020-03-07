//
//  AddEditCostCenterController.m
//  galaxy
//
//  Created by hfk on 2018/11/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddEditCostCenterController.h"

@interface AddEditCostCenterController ()<GPClientDelegate>

@property (nonatomic, strong) UITextField *txf_costCenter;
@property (nonatomic, strong) UITextField *txf_costCenterEn;

@property (nonatomic, strong) UITextField *txf_mgr;

@end

@implementation AddEditCostCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    NSString *title;
    if (self.costCenter) {
        title = Custing(@"修改成本中心", nil);
    }else{
        title = Custing(@"新增成本中心", nil);
        self.costCenter = [[costCenterData alloc]init];
    }
    [self setTitle:title backButton:YES];
    [self createViews];
}

-(void)createViews{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(Save:)];

    
    __weak typeof(self) weakSelf = self;
    UIView *CostCenterView = [[UIView alloc]init];
    CostCenterView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:CostCenterView];
    [CostCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    _txf_costCenter = [[UITextField alloc]init];
    [CostCenterView addSubview:[[SubmitFormView alloc]initBaseView:CostCenterView WithContent:_txf_costCenter WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"名称", nil) WithInfodict:@{@"value1":self.costCenter.costCenter} WithTips:Custing(@"请输入名称", nil) WithNumLimit:50]];
    
    
    UIView *CostCenterEnView = [[UIView alloc]init];
    CostCenterEnView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:CostCenterEnView];
    [CostCenterEnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CostCenterView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_costCenterEn = [[UITextField alloc]init];
    [CostCenterEnView addSubview:[[SubmitFormView alloc]initBaseView:CostCenterEnView WithContent:_txf_costCenterEn WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"英文名称", nil) WithInfodict:@{@"value1":self.costCenter.costCenterEn} WithTips:Custing(@"请输入英文名称", nil) WithNumLimit:50]];
    
    UIView *MgrView = [[UIView alloc]init];
    MgrView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:MgrView];
    [MgrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CostCenterEnView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_mgr = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:MgrView WithContent:_txf_mgr WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"负责人", nil) WithTips:Custing(@"请选择负责人", nil) WithInfodict:@{@"value1":self.costCenter.costCenterMgr}];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf chooseMgr];
    }];
    [MgrView addSubview:view];

}
-(void)chooseMgr{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.costCenter.costCenterMgrUserId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"6";
    contactVC.Radio = @"1";
    contactVC.arrClickPeople = array;
    contactVC.itemType = 99;
    contactVC.menutype = 4;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        self.costCenter.costCenterMgr = bul.requestor;
        self.costCenter.costCenterMgrUserId = [NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.txf_mgr.text= bul.requestor;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}


-(void)Save:(id)sender{
    if (self.txf_costCenter.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入名称", nil)];
        return;
    }else if (self.txf_costCenter.text.length >= 50){
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"名称不超过50位", nil)];
        return;
    }
    if ([NSString isEqualToNullAndZero:self.costCenter.idd]) {
        NSDictionary * dic =@{@"Id":self.costCenter.idd,@"costCenter":self.txf_costCenter.text,@"costCenterEn":self.txf_costCenterEn.text,@"costCenterMgrUserId":self.costCenter.costCenterMgrUserId,@"costCenterMgr":self.costCenter.costCenterMgr};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updatecostc] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        NSDictionary * dic =@{@"costCenter":self.txf_costCenter.text,@"costCenterEn":self.txf_costCenterEn.text,@"costCenterMgrUserId":self.costCenter.costCenterMgrUserId,@"costCenterMgr":self.costCenter.costCenterMgr};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",insertcostc] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];

    }
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        default:
            break;
    }
    
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
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
