//
//  moreCostClassViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "cCTravelAndDayViewController.h"
#import "costClassSettViewController.h"
#import "moreCostClassViewController.h"

@interface moreCostClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * costArray;
@end

@implementation moreCostClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.costArray = [NSMutableArray array];
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0001"]) {
        [self.costArray addObject:@[@{@"costType":Custing(@"出差申请", nil)}]];
    }
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0002"]) {
        [self.costArray addObject:@[@{@"costType":Custing(@"差旅费", nil)}]];
    }
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0003"]){
        [self.costArray addObject:@[@{@"costType":Custing(@"日常费", nil)}]];
    }
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0010"]){
        [self.costArray addObject:@[@{@"costType":Custing(@"专项费", nil)}]];
    }
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0009"]){
        [self.costArray addObject:@[@{@"costType":Custing(@"付款", nil)}]];
    }
    if ([self.userdatas.arr_XBFlowcode containsObject:@"F0013"]){
        [self.costArray addObject:@[@{@"costType":Custing(@"合同", nil)}]];
    }
    [self.costArray addObject:@[@{@"costType":Custing(@"税额Add", nil)}]];
    [self.costArray addObject:@[@{@"costType":Custing(@"显示方式", nil)}]];
    
    [self setTitle:Custing(@"费用类别", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.costArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *itemArray = self.costArray[section];
    return [itemArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,10.0)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UIImageView * lView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        lView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lView];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45.5, Main_Screen_Width, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-75, 46) text:[self.costArray[indexPath.section][indexPath.row] objectForKey:@"costType"] font:[UIFont systemFontOfSize:16.0f] textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [self.costArray[indexPath.section][indexPath.row] objectForKey:@"costType"];
    if ([name isEqualToString:Custing(@"出差申请", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"出差申请"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"差旅费", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"差旅费"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"日常费", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"日常费"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"专项费", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"专项费"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"付款", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"付款"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"合同", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"合同"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"税额Add", nil)]) {
        cCTravelAndDayViewController * ctravel = [[cCTravelAndDayViewController alloc]initWithType:@"税额Add"];
        [self.navigationController pushViewController:ctravel animated:YES];
    }else if ([name isEqualToString:Custing(@"显示方式", nil)]) {
        costClassSettViewController * sett = [[costClassSettViewController alloc]init];
        [self.navigationController pushViewController:sett animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
