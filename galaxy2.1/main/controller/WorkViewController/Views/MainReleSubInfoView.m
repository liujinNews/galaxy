//
//  MainReleSubInfoView.m
//  galaxy
//
//  Created by hfk on 2018/12/14.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "MainReleSubInfoView.h"
#import "ReleInvoiceRegCell.h"
#import "ReleStatementCell.h"
#import "ReleRemittanceCell.h"

@interface MainReleSubInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *flowCode;
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bool_isOpen;

@end

@implementation MainReleSubInfoView

-(instancetype)initWithFlowCode:(NSString *)flowcode{
    self = [super init];
    
    if (self) {
        [self setClipsToBounds:YES];

        _flowCode = flowcode;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        if ([_flowCode isEqualToString:@"F0030"]) {
            [_tableView registerClass:[ReleInvoiceRegCell class] forCellReuseIdentifier:@"ReleInvoiceRegCell"];
        }else if ([_flowCode isEqualToString:@"F0031"]){
            [_tableView registerClass:[ReleStatementCell class] forCellReuseIdentifier:@"ReleStatementCell"];
        }else if ([_flowCode isEqualToString:@"F0032"]){
            [_tableView registerClass:[ReleRemittanceCell class] forCellReuseIdentifier:@"ReleRemittanceCell"];
        }
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(0);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableView.bottom);
        }];
    }
    return self;

}

-(void)updateView:(NSMutableArray *)array{

    self.showDataArray = [NSMutableArray arrayWithArray:array];
    
    self.bool_isOpen = NO;
    
    NSInteger height = [self getViewHeight];
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_tableView reloadData];
}
#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showDataArray) {
        return self.showDataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.flowCode isEqualToString:@"F0030"]) {
        return [ReleInvoiceRegCell cellHeight];
        
    }else if ([self.flowCode isEqualToString:@"F0031"]){
        return [ReleStatementCell cellHeight];
        
    }else if ([self.flowCode isEqualToString:@"F0032"]){
        return [ReleRemittanceCell cellHeight];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *View_head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    View_head.backgroundColor = Color_White_Same_20;

    UIImageView *ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26.3)];
    ImgView.image = [UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor = Color_Blue_Important_20;
    [View_head addSubview:ImgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center = CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    titleLabel.font = Font_Important_15_20 ;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = Color_Unsel_TitleColor;
    [View_head addSubview:titleLabel];
    
    if ([self.flowCode isEqualToString:@"F0030"]) {
        titleLabel.text = Custing(@"已登记发票信息", nil);
    }else if ([self.flowCode isEqualToString:@"F0031"]){
        titleLabel.text = Custing(@"结算单信息", nil);
    }else if ([self.flowCode isEqualToString:@"F0032"]){
        titleLabel.text = Custing(@"已请款信息", nil);
    }
    if (self.showDataArray.count > 1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth = size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        UIButton *LookMore = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 0, btnWidth, 27)];
        LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        LookMore.titleLabel.font = Font_Important_15_20;
        [LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [LookMore addTarget:self action:@selector(LookMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        [View_head addSubview:LookMore];

    }
    return View_head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.flowCode isEqualToString:@"F0030"]) {
        ReleInvoiceRegCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleInvoiceRegCell" forIndexPath:indexPath];
        NSDictionary *dict = self.showDataArray[indexPath.row];
        [cell configCellWithInfoDict:dict];
        if (self.serialNoBtnClickedBlock) {
            cell.serialNoBtnClickedBlock = self.serialNoBtnClickedBlock;
        }
        return cell;
    }else if ([self.flowCode isEqualToString:@"F0031"]){
        ReleStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleStatementCell" forIndexPath:indexPath];
        NSDictionary *dict = self.showDataArray[indexPath.row];
        [cell configCellWithInfoDict:dict];
        if (self.serialNoBtnClickedBlock) {
            cell.serialNoBtnClickedBlock = self.serialNoBtnClickedBlock;
        }
        return cell;
    }else if ([self.flowCode isEqualToString:@"F0032"]){
        ReleRemittanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleRemittanceCell" forIndexPath:indexPath];
        NSDictionary *dict = self.showDataArray[indexPath.row];
        [cell configCellWithInfoDict:dict];
        if (self.serialNoBtnClickedBlock) {
            cell.serialNoBtnClickedBlock = self.serialNoBtnClickedBlock;
        }
        return cell;
    }
    return [UITableViewCell new];
}

-(void)LookMoreClick:(UIButton *)btn{
    self.bool_isOpen = !self.bool_isOpen;
    [btn setImage: self.bool_isOpen ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.bool_isOpen ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    
    NSInteger height = [self getViewHeight];
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

-(CGFloat)getViewHeight{
    NSInteger height = 0;
    if (self.showDataArray.count > 0) {
        height = 27;
        NSInteger count = self.bool_isOpen ? self.showDataArray.count:1;
        if ([self.flowCode isEqualToString:@"F0030"]) {
            height += count * [ReleInvoiceRegCell cellHeight];
            
        }else if ([self.flowCode isEqualToString:@"F0031"]){
            height += count * [ReleStatementCell cellHeight];
            
        }else if ([self.flowCode isEqualToString:@"F0032"]){
            height += count * [ReleRemittanceCell cellHeight];
        }
    }
    return height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
