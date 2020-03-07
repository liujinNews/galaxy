//
//  TravelCarDetailView.m
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "TravelCarDetailView.h"
#import "TravelCarDetailCell.h"
#import "TravelCarDetail.h"

@interface TravelCarDetailView ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  头部视图
 */
@property (nonatomic, strong) UIView *DetailHeadView;
/**
 *  费用明细tableView
 */
@property (nonatomic, strong) UITableView *TravelCarTableView;
/**
 *  子表cell
 */
@property (nonatomic,strong)TravelCarDetailCell *TravelCarDetailCell;

@property(nonatomic,strong)NSMutableArray *formData;
@property(nonatomic,assign)NSInteger editType;

@end

@implementation TravelCarDetailView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = Color_White_Same_20;
    }
    return self;
}
-(void)updateTravelCarDetailViewWithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType{
    _formData = formData;
    _editType = editType;
    [self setUI];
    [self updateUI];
}

-(void)setUI{
    
    _DetailHeadView = [[UIView alloc]init];
    _DetailHeadView.backgroundColor = Color_WhiteWeak_Same_20;
    [self addSubview:_DetailHeadView];
    [_DetailHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
    
    _TravelCarTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _TravelCarTableView.backgroundColor = Color_White_Same_20;
    _TravelCarTableView.delegate = self;
    _TravelCarTableView.dataSource = self;
    _TravelCarTableView.scrollEnabled = NO;
    _TravelCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_TravelCarTableView];
    [_TravelCarTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.DetailHeadView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
}
-(void)updateUI{
    if (self.editType == 1) {
        SubmitFormView *view1 = [[SubmitFormView alloc]initAddBtbWithBaseView:_DetailHeadView withTitle:Custing(@"添加", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:1];
        __weak typeof(self) weakSelf = self;
        [view1 setFormClickedBlock:^(MyProcurementModel *model) {
            [weakSelf AddDetailsClick:nil];
        }];
        [_DetailHeadView addSubview:view1];
        
        UILabel *lab = [GPUtils createLable:CGRectMake(12, 10, 200, 50) text:Custing(@"添加用车需求单", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [_DetailHeadView addSubview:lab];
    }else{
        [_DetailHeadView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@27);
        }];
        
        _DetailHeadView.backgroundColor = Color_White_Same_20;

        UIImageView *ImgView = [GPUtils createImageViewFrame:CGRectMake(0, 0.5, 4, 26) imageName:@"Work_HeadBlue"];
        ImgView.backgroundColor = Color_Blue_Important_20;
        [_DetailHeadView addSubview:ImgView];
        
        UILabel *titleLabel = [GPUtils createLable:CGRectMake(0, 0, 180, 18) text:Custing(@"用车需求单", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
        titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
        [_DetailHeadView addSubview:titleLabel];
    }
    [self updateTableView];
}
//MARK:更新分摊明细详情视图
-(void)updateTableView{
    
    NSInteger height = 0;
    for (TravelCarDetail *model in self.formData) {
        height += [TravelCarDetailCell cellHeightWithModel:model];
    }
    [_TravelCarTableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height + (self.editType == 1 ? 60:27)));
    }];
    [_TravelCarTableView reloadData];
}

-(void)AddDetailsClick:(id)obj{
    if (self.TravelCarDetailBackClickedBlock) {
        self.TravelCarDetailBackClickedBlock(1, 0, [TravelCarDetail new]);
    }
}

//MARK:-tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.formData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelCarDetail *model = self.formData[indexPath.row];
    return  [TravelCarDetailCell cellHeightWithModel:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCarDetailCell"];
    if (cell == nil) {
        cell = [[TravelCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelCarDetailCell"];
    }
    TravelCarDetail *model = self.formData[indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.TravelCarDetailBackClickedBlock) {
        TravelCarDetail *model = self.formData[indexPath.row];
        self.TravelCarDetailBackClickedBlock(2, indexPath.row, model);
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.editType == 1;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.formData removeObjectAtIndex:indexPath.row];
        [self updateTableView];
    }];
    return @[deleteRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;//删除cell
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
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
