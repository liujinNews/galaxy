//
//  FormChildTableView.m
//  galaxy
//
//  Created by hfk on 2018/4/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormChildTableView.h"

@interface FormChildTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**
 类型 1:关联合同
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)updateReletContractView{
    
}

#pragma mark -- uitableviewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((indexPath.row==0)&&(indexPath.section==1))||((indexPath.row==0)&&(indexPath.section==2))?30.5:50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *_headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    //    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    //    ImgView.backgroundColor=Color_Blue_Important_20;
    [_headView addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+102, 13.5);
    titleLabel.font=Font_Same_12_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_GrayDark_Same_20;
    [_headView addSubview:titleLabel];
    
    NSDictionary *dic = _meItemArray[section];
    titleLabel.text = dic[@"date"];
    
    _headView.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [_headView addSubview:lineUp];
    
    UIView *downUp=[[UIView alloc]initWithFrame:CGRectMake(0,26.5, Main_Screen_Width,0.5)];
    downUp.backgroundColor=Color_GrayLight_Same_20;
    [_headView addSubview:downUp];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
