//
//  FormChildTableView.m
//  galaxy
//
//  Created by hfk on 2018/4/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormChildTableView.h"
#import "ReleContractCell.h"
#import "ContractRelectInfoCell.h"

@interface FormChildTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**
 类型 1:关联合同 2:合同付款、收票和开票信息
 */
@property (nonatomic, assign) NSInteger type;


@end

@implementation FormChildTableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_form_TextFieldBackgroundColor;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)updateReletContractViewWithArray:(NSMutableArray *)array{
    self.dataArray=array;
    self.type=1;
    NSInteger heigt=27;
    for (NSDictionary *dict in self.dataArray) {
        heigt+=([ReleContractCell cellHeightWithObj:dict]+0.5);
    }
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heigt));
    }];
    [_tableView reloadData];
}

-(void)updateContractReletInfoViewWithArray:(NSMutableArray *)array{
    self.dataArray=array;
    self.type=2;
    
    NSInteger height=(95+40)*self.dataArray.count;
    for (NSMutableArray *arr in self.dataArray) {
        height+=((arr.count-1)*40);
    }
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [_tableView reloadData];
}
#pragma mark -- uitableviewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type==1||self.type==2) {
        return self.dataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type==1) {
        return 1;
    }else if (self.type==2){
        NSMutableArray *arr=self.dataArray[section];
        return arr.count-1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==1) {
        NSDictionary *dict=self.dataArray[indexPath.section];
        return [ReleContractCell cellHeightWithObj:dict];
    }else if (self.type==2){
        return 40;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type==1) {
        if (section==0) {
            return 27;
        }else{
            return 0.5;
        }
    }else if (self.type==2){
        return 95;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type==1) {
        if (section==0) {
            UIView *View_head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
            View_head.backgroundColor=Color_White_Same_20;
            
            UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
            ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
            ImgView.backgroundColor=Color_Blue_Important_20;
            [View_head addSubview:ImgView];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
            titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
            titleLabel.font=Font_Important_15_20 ;
            titleLabel.textAlignment=NSTextAlignmentLeft;
            titleLabel.textColor=Color_Unsel_TitleColor;
            titleLabel.text=Custing(@"关联合同", nil);
            [View_head addSubview:titleLabel];
            return View_head;
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            view.backgroundColor =[UIColor clearColor];
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
            lineview.backgroundColor =Color_GrayLight_Same_20;
            [view addSubview:lineview];
            return view;
        }
    }else if (self.type==2){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 95)];
        view.backgroundColor = Color_White_Same_20;
    
        UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 85)];
        contentView.backgroundColor=Color_BorrowLine_Same_20;
        [view addSubview:contentView];
        
        UILabel * content1=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [contentView addSubview:content1];
        
        UILabel * content2=[GPUtils createLable:CGRectMake(12, 45, 65, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [contentView addSubview:content2];

        UILabel * content3=[GPUtils createLable:CGRectMake(86, 45, 75, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [contentView addSubview:content3];

        UILabel * content4=[GPUtils createLable:CGRectMake(165, 45, Main_Screen_Width-12-165, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [contentView addSubview:content4];

        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
        line1.backgroundColor=Color_LineGray_Same_20;
        [contentView addSubview:line1];

        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 84.5, Main_Screen_Width, 0.5)];
        line2.backgroundColor=Color_LineGray_Same_20;
        [contentView addSubview:line2];

        NSMutableArray *arr=self.dataArray[section];
        NSDictionary *dict=arr.lastObject;
        if ([dict[@"Key"]floatValue]==1) {
            content1.text=Custing(@"已付款明细", nil);
            content2.text=Custing(@"序号", nil);
            content3.text=Custing(@"付款日期", nil);
            content4.text=Custing(@"已付款金额", nil);
        }else if ([dict[@"Key"]floatValue]==2){
            content1.text=Custing(@"已回款明细", nil);
            content2.text=Custing(@"序号", nil);
            content3.text=Custing(@"回款日期", nil);
            content4.text=Custing(@"已回款金额", nil);
        }else if ([dict[@"Key"]floatValue]==3){
            content1.text=Custing(@"已开票明细", nil);
            content2.text=Custing(@"单号", nil);
            content3.text=Custing(@"开票日期", nil);
            content4.text=Custing(@"已开票金额", nil);
        }
        return view;
    }
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.type==2) {
        return 40;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.type==2) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        view.backgroundColor=Color_BorrowLine_Same_20;
        NSMutableArray *arr=self.dataArray[section];
        NSDictionary *dict=arr.lastObject;
        NSString *title;
        if ([dict[@"Key"]floatValue]==1) {
            title=Custing(@"未付款金额", nil);
        }else if ([dict[@"Key"]floatValue]==2){
            title=Custing(@"未回款金额", nil);
        }else if ([dict[@"Key"]floatValue]==3){
            title=Custing(@"未开票金额", nil);
        }
        UILabel *titlelab=[GPUtils createLable:CGRectMake(12, 0, 120, 40) text:title font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:titlelab];
        UILabel *amount=[GPUtils createLable:CGRectMake(140, 0, Main_Screen_Width-12-140, 40) text:[GPUtils transformNsNumber:dict[@"Amount"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [view addSubview:amount];
        return view;
    }
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==1) {
        ReleContractCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReleContractCell"];
        if (cell==nil) {
            cell=[[ReleContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReleContractCell"];
        }
        NSDictionary *dict=self.dataArray[indexPath.section];
        [cell configCellWithDict:dict];
        return cell;
    }else if (self.type==2){
        ContractRelectInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContractRelectInfoCell"];
        if (cell==nil) {
            cell=[[ContractRelectInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContractRelectInfoCell"];
        }
        NSMutableArray *arr=self.dataArray[indexPath.section];
        NSDictionary *dict=arr[indexPath.row];
        NSDictionary *tipDict=arr.lastObject;
        [cell configCellWithDict:dict withIndex:indexPath.row+1 withTipDict:tipDict];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==1) {
        NSDictionary *dict=self.dataArray[indexPath.section];
        if (self.cellClick) {
            self.cellClick([NSString stringWithFormat:@"%@",dict[@"taskId"]]);
        }
    }else if (self.type==2){
        NSMutableArray *arr=self.dataArray[indexPath.section];
        NSDictionary *dict=arr[indexPath.row];
        NSDictionary *tipDict=arr.lastObject;
        if ([tipDict[@"Key"]floatValue]==3&&self.cellClick) {
            self.cellClick([NSString stringWithFormat:@"%@",dict[@"taskId"]]);
        }
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
