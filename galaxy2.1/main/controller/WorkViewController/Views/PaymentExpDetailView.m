//
//  PaymentExpDetailView.m
//  galaxy
//
//  Created by hfk on 2018/11/14.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PaymentExpDetailView.h"

@interface PaymentExpDetailView ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  费用明细视图
 */
@property (nonatomic, strong) UIView *ShareDetailView;
@property (nonatomic, strong) UIImageView *ShareDetailClickImg;
/**
 *  费用明细tableView
 */
@property (nonatomic, strong) UITableView *PaymentExpTableView;
@property (nonatomic, strong) UIView *PaymentExpHeadView;
/**
 *  子表cell
 */
@property (nonatomic,strong)PaymentExpDetailCell *PaymentExpCell;
/**
 *  增加明细按钮视图
 */
@property(nonatomic,strong)UIView *AddDetailsView;
/**
 *  判断明细是否打开
 */
@property(nonatomic,assign)BOOL  isOpenShare;

@property(nonatomic,strong)NSMutableArray *formData;
@property(nonatomic,assign)NSInteger editType;


@end

@implementation PaymentExpDetailView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = Color_White_Same_20;
    }
    return self;
}

-(void)updatePaymentExpMainViewWithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType{
    _formData = formData;
    _editType = editType;
    [self setUI];
    [self updateUI];
}
-(void)setUI{
    
    _ShareDetailView = [[UIView alloc]init];
    _ShareDetailView.backgroundColor = Color_WhiteWeak_Same_20;
    [self addSubview:_ShareDetailView];
    [_ShareDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
    
    _PaymentExpTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _PaymentExpTableView.backgroundColor = Color_White_Same_20;
    _PaymentExpTableView.delegate = self;
    _PaymentExpTableView.dataSource = self;
    _PaymentExpTableView.scrollEnabled = NO;
    _PaymentExpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_PaymentExpTableView];
    [_PaymentExpTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ShareDetailView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
    
    _AddDetailsView = [[UIView alloc]init];
    _AddDetailsView.backgroundColor = Color_White_Same_20;
    [self addSubview:_AddDetailsView];
    [_AddDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PaymentExpTableView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
}
-(void)updateUI{
    
    [_ShareDetailView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    [_ShareDetailView addSubview:[self createLineView]];
    
    UILabel *title = [GPUtils createLable:CGRectMake(0,0,70, 50) text:Custing(@"费用明细", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title.center = CGPointMake(12+35, 10+25);
    title.numberOfLines = 2;
    [_ShareDetailView addSubview:title];
    
    UIButton *btn = [GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(LookPaymentExpDetailClick:) delegate:self];
    [_ShareDetailView addSubview:btn];
    
    _ShareDetailClickImg = [GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    _ShareDetailClickImg.center = CGPointMake(Main_Screen_Width-12-10, 10+25);
    [_ShareDetailView addSubview:_ShareDetailClickImg];
    
    if (_editType == 1) {
        SubmitFormView *view = [[SubmitFormView alloc]initAddBtbWithBaseView:_AddDetailsView withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model) {
            [weakSelf AddDetailsClick:nil];
        }];
        [_AddDetailsView addSubview:view];
        
        NSString *leadTitle = Custing(@"导入明细", nil);
        CGSize size = [[NSString stringWithFormat:@" %@",leadTitle] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 50) lineBreakMode:NSLineBreakByCharWrapping];
        UIButton *Lead = [GPUtils createButton:CGRectMake(0, 0, size.width+20, 50) action:@selector(leadDetail:) delegate:self title:leadTitle font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
        [_AddDetailsView addSubview:Lead];
    }
    
    _isOpenShare = YES;
    [self updateTableView];
}
//MARK:更新分摊明细详情视图
-(void)updateTableView{
    if (_isOpenShare == NO) {
        
        _ShareDetailClickImg.image = [UIImage imageNamed:@"skipImage"];
        
        [_PaymentExpTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [_AddDetailsView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(60);
        }];
        
    }else if(_isOpenShare == YES){
        
        _ShareDetailClickImg.image = [UIImage imageNamed:@"share_Open"];
        
        NSInteger height = 0;
        for (PaymentExpDetail *model in self.formData) {
            height += [PaymentExpDetailCell cellHeightWithModel:model withEditType:self.editType];
        }

        [_PaymentExpTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        
        if (self.editType == 1) {
            [_AddDetailsView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@50);
            }];
        }
        
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height + 60 + (self.editType == 1 ? 50:0)));
        }];
    }
    [_PaymentExpTableView reloadData];
}

-(void)LookPaymentExpDetailClick:(id)obj{
    _isOpenShare = !_isOpenShare;
    [self updateTableView];
}

-(void)AddDetailsClick:(id)obj{
    if (self.PaymentExpBackClickedBlock) {
        self.PaymentExpBackClickedBlock(1, 0, [PaymentExpDetail new]);
    }
}
-(void)leadDetail:(id)sender{
    if (self.PaymentLeadClickedBlock) {
        self.PaymentLeadClickedBlock();
    }
}
-(UIView *)createLineView{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor = Color_White_Same_20;
    return view;
}

//MARK:-tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _formData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentExpDetail *model = self.formData[indexPath.row];
    return [PaymentExpDetailCell cellHeightWithModel:model withEditType:self.editType];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentExpDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentExpDetailCell"];
    if (cell == nil) {
        cell = [[PaymentExpDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaymentExpDetailCell"];
    }
    cell.index = indexPath.row;
    cell.editType = self.editType;
    PaymentExpDetail *model = self.formData[indexPath.row];
    [cell configCellWithPaymentExpDetail:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.PaymentExpBackClickedBlock) {
        PaymentExpDetail *model = self.formData[indexPath.row];
        __weak typeof(self) weakSelf = self;
        self.PaymentExpBackClickedBlock(weakSelf.editType == 3 ? 4:2, indexPath.row, model);
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
        PaymentExpDetail *model = self.formData[indexPath.row];
        [self.formData removeObjectAtIndex:indexPath.row];
        self.PaymentExpBackClickedBlock(3, indexPath.row, model);
        [self updateTableView];
    }];
    return @[deleteRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;//删除cell
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
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
