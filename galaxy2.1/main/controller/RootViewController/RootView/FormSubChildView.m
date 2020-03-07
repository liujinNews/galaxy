//
//  FormSubChildView.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormSubChildView.h"
#import "FormSubChildModel.h"
#import "TravelPeopleCell.h"
#import "TravelInfoCell.h"
#import "FeeBudgetCell.h"
#import "AddTravelPeopleInfoController.h"
#import "AddTravelInfoController.h"
#import "AddFeeBudgetController.h"
@interface FormSubChildView ()<UITableViewDelegate,UITableViewDataSource>

//1出差人员 2出行信息 3费用预算
@property (nonatomic, assign) NSInteger type;
//1新建 2查看
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *showDealArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UILabel *lab_money;

@end


@implementation FormSubChildView

-(instancetype)initWithType:(NSInteger)type withStatus:(NSInteger)status{
    self = [super init];
    
    if (self) {
        
        [self setClipsToBounds:YES];
        _type = type;
        _status = status;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        if (_type == 2) {
            [_tableView registerNib:[UINib nibWithNibName:@"TravelInfoCell" bundle:nil] forCellReuseIdentifier:@"TravelInfoCell"];
        }
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(0);
        }];
        _tableView.tableHeaderView = [self headView];

        _addView = [[UIView alloc]init];
        _addView.clipsToBounds = YES;
        _addView.backgroundColor =Color_form_TextFieldBackgroundColor;
        [self addSubview:_addView];
        [_addView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(0);
        }];
        [self updateFootView];
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.addView.bottom);
        }];
    }
    return self;
}
-(void)refresh{
    self.showDealArray = [[FormSubChildModel sharedManager]getShowDealArrayWithSetArray:self.showSetArray withDataArray:self.showDataArray WithType:self.type];
    float height = 0;
    NSString *total=@"0";
    if (self.type == 1) {
        height += 60;
        for (FormSubChildModel *model in self.showDealArray) {
            height += ([TravelPeopleCell cellHeightWithObj:model]+0.5);
        }
        [_addView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.status == 1 ? 50:0);
        }];
    }else if (self.type == 2){
        height += 60;
        for (FormSubChildModel *model in self.showDealArray) {
            height += ([TravelInfoCell cellHeightWithObj:model]+0.5);
        }
        [_addView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.status == 1 ? 50:0);
        }];
    }else if (self.type == 3){
        height += 60;
        for (FormSubChildModel *model in self.showDealArray) {
            height += ([FeeBudgetCell cellHeightWithObj:model]+0.5);
            total = [GPUtils decimalNumberAddWithString:total with:model.str_param2];
        }
        [_addView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.status == 1 ? 50:0);
        }];
    }
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_tableView reloadData];
    
    if (self.budgetTotalAmountBlock) {
        self.budgetTotalAmountBlock(total);
    }
}
#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showDealArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        return [TravelPeopleCell cellHeightWithObj:self.showDealArray[indexPath.section]];
    }else if (self.type ==2){
        return [TravelInfoCell cellHeightWithObj:self.showDealArray[indexPath.section]];
    }else if (self.type ==3){
        return [FeeBudgetCell cellHeightWithObj:self.showDealArray[indexPath.section]];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        TravelPeopleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TravelPeopleCell"];
        if (cell==nil) {
            cell=[[TravelPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelPeopleCell"];
        }
        FormSubChildModel *model = self.showDealArray[indexPath.section];
        [cell configCellWith:model withStatus:self.status];
        __weak typeof(self) weakSelf = self;
        [cell setDeleteBtnClickedBlock:^(id sender) {
            [weakSelf.showDataArray removeObjectAtIndex:indexPath.section];
            [weakSelf refresh];
        }];
        return cell;
    }else if (self.type == 2){
        TravelInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TravelInfoCell"];
        if (cell==nil) {
            cell=[[TravelInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelInfoCell"];
        }
        FormSubChildModel *model = self.showDealArray[indexPath.section];
        [cell configCellWith:model withStatus:self.status];
        __weak typeof(self) weakSelf = self;
        [cell setDeleteBtnClickedBlock:^(id sender) {
            [weakSelf.showDataArray removeObjectAtIndex:indexPath.section];
            [weakSelf refresh];
        }];
        return cell;
    }else if (self.type == 3){
        FeeBudgetCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FeeBudgetCell"];
        if (cell==nil) {
            cell=[[FeeBudgetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeeBudgetCell"];
        }
        FormSubChildModel *model = self.showDealArray[indexPath.section];
        [cell configCellWith:model withStatus:self.status];
        __weak typeof(self) weakSelf = self;
        [cell setDeleteBtnClickedBlock:^(id sender) {
            [weakSelf.showDataArray removeObjectAtIndex:indexPath.section];
            [weakSelf refresh];
        }];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [[UIView alloc]init];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =Color_form_TextFieldBackgroundColor;
        if (section != 0) {
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
            lineview.backgroundColor =Color_GrayLight_Same_20;
            [view addSubview:lineview];
        }
        return view;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.status == 1) {
        [self gotoAddDetail:indexPath];
    }
}

-(UIView *)headView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 60)];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    line.backgroundColor =Color_White_Same_20;
    [headView addSubview:line];
    UILabel *title = [GPUtils createLable:CGRectMake(12, 10, 200, 50) text:[self getHeadTitle] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [headView addSubview:title];
    
    return headView;
}
-(void)updateFootView{
    if (self.type == 1&&self.status==1) {
        [self createAddView];
    }else if (self.type == 2&&self.status==1){
        [self createAddView];
    }else if (self.type == 3&&self.status==1){
        [self createAddView];
    }
}

-(NSString *)getHeadTitle{
    if (_type == 1) {
        return Custing(@"出差人员信息", nil);
    }else if (_type ==2){
        return Custing(@"出行信息", nil);
    }else if (_type ==3){
        return Custing(@"费用预算", nil);
    }
    return nil;
}

-(void)createAddView{
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_addView withTitle:Custing(@"添加", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf gotoAddDetail:nil];
    }];
    [_addView addSubview:view];
    
    [_addView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0);
    }];
}

-(void)gotoAddDetail:(NSIndexPath *)index{
    if (self.type == 1) {
        AddTravelPeopleInfoController *vc =[[AddTravelPeopleInfoController alloc]init];
        if (index) {
            vc.model = [self.showDataArray[index.section] copy];
            vc.type = 1;
        }
        vc.arr_Main = self.showSetArray;
        __weak typeof(self) weakSelf = self;
        vc.SaveBackBlock = ^(TravelPeopleInfoModel *model, NSInteger type) {
            if (type == 1) {
                [weakSelf.showDataArray replaceObjectAtIndex:index.section withObject:model];
            }else{
                [weakSelf.showDataArray addObject:model];
            }
            [weakSelf refresh];
        };
        [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 2){
        AddTravelInfoController *vc =[[AddTravelInfoController alloc]init];
        if (index) {
            vc.model = [self.showDataArray[index.section] copy];
            vc.type = 1;
        }
        vc.arr_Main = self.showSetArray;
        __weak typeof(self) weakSelf = self;
        vc.SaveBackBlock = ^(TravelInfoModel *model, NSInteger type) {
            if (type == 1) {
                [weakSelf.showDataArray replaceObjectAtIndex:index.section withObject:model];
            }else{
                [weakSelf.showDataArray addObject:model];
            }
            [weakSelf refresh];
        };
        [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 3){
        AddFeeBudgetController *vc =[[AddFeeBudgetController alloc]init];
        if (index) {
            vc.model = [self.showDataArray[index.section] copy];
            vc.type = 1;
        }
        vc.arr_Main = self.showSetArray;
        __weak typeof(self) weakSelf = self;
        vc.SaveBackBlock = ^(FeeBudgetInfoModel *model, NSInteger type) {
            if (type == 1) {
                [weakSelf.showDataArray replaceObjectAtIndex:index.section withObject:model];
            }else{
                [weakSelf.showDataArray addObject:model];
            }
            [weakSelf refresh];
        };

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
