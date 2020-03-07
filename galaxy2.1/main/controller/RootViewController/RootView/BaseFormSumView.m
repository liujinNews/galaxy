//
//  BaseFormSumView.m
//  galaxy
//
//  Created by hfk on 2019/6/28.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BaseFormSumView.h"
#import "ExpenseSumDetailController.h"
#import "BaseFormSumCell.h"
#import "CurrencySumModel.h"
#import "ReimShareDeptSumModel.h"
#import "ReimShareDeptDetailController.h"

@interface BaseFormSumView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FormBaseModel *formModel;
@property (nonatomic, assign) NSInteger type;

@end

@implementation BaseFormSumView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        [self createTableView];
    }
    return self;
}

-(void)createTableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_White_Same_20;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
}
-(void)updateBaseFormSumViewWithData:(FormBaseModel *)formModel WithType:(NSInteger)type{
    self.formModel = formModel;
    self.type = type;
    NSInteger height = 0;
    if (self.type == 1) {
        height = 28 + self.formModel.arr_CurrencySum.count * 36;
    }else if (self.type == 2){
        height = 28 + self.formModel.arr_travelSum.count * 36;
    }else if (self.type == 3){
        height = 28 + self.formModel.arr_ShareDeptSumData.count * 36;
    }
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_tableView reloadData];
}
//MARK:tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1) {
        return self.formModel.arr_CurrencySum.count;
    }else if (self.type == 2){
        return self.formModel.arr_travelSum.count;
    }else if (self.type == 3){
        return self.formModel.arr_ShareDeptSumData.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 28)];
    
    UIImageView *ImgView = [GPUtils createImageViewFrame:CGRectMake(0, 0.5, 4, 27) imageName:@"Work_HeadBlue"];
    ImgView.backgroundColor = Color_Blue_Important_20;
    [view addSubview:ImgView];
    
    UILabel *titleLabel = [GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-24, 28) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    titleLabel.center = CGPointMake(Main_Screen_Width/2, 14);
    [view addSubview:titleLabel];
    if (self.type == 1) {
        titleLabel.text = Custing(@"原币汇总", nil);
    }else if (self.type == 2){
        titleLabel.text = Custing(@"费用类别汇总", nil);
    }else if (self.type == 3){
        titleLabel.text = Custing(@"费用分摊", nil);
    }
    view.backgroundColor = Color_White_Same_20;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseFormSumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseFormSumCell"];
    if (cell == nil) {
        cell = [[BaseFormSumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseFormSumCell"];
    }
    id model;
    if (self.type == 1) {
        model = self.formModel.arr_CurrencySum[indexPath.row];
    }else if (self.type == 2){
        model = self.formModel.arr_travelSum[indexPath.row];
    }else if (self.type == 3){
        model = self.formModel.arr_ShareDeptSumData[indexPath.row];
    }
    [cell configBaseFormSumCellWithModel:model WithType:self.type];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2){
        HasSubmitDetailModel *model = self.formModel.arr_travelSum[indexPath.row];
        ExpenseSumDetailController *vc = [[ExpenseSumDetailController alloc]init];
        vc.TaskId=self.formModel.str_taskId;
        vc.FlowCode=self.formModel.str_flowCode;
        vc.str_ProcId = self.formModel.str_procId;
        vc.str_FlowGuid = self.formModel.str_flowGuid;
        vc.str_UserId = self.formModel.personalData.OperatorUserId;
        vc.str_OwerId = self.formModel.personalData.RequestorUserId;
        vc.ExpenseType = model.expenseType;
        vc.ExpenseCat = model.expenseCat;
        userData *userdatas=[userData shareUserData];
        vc.str_TotalAmount = [userdatas.multiCyPayment isEqualToString:@"1"] ? model.invPmtAmount:model.amount;
        [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 3){
        ReimShareDeptSumModel *model = self.formModel.arr_ShareDeptSumData[indexPath.row];
        ReimShareDeptDetailController *vc = [[ReimShareDeptDetailController alloc]init];
        vc.FormDatas = self.formModel;
        vc.model = model;
        [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
