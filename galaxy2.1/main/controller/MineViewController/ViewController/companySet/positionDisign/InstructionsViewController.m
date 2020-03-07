//
//  InstructionsViewController.m
//  galaxy
//
//  Created by hfk on 2017/2/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *InfoArray;

@end

@implementation InstructionsViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"使用说明", nil) backButton:YES];
    if ([self.status isEqualToString:@"costCenterInfo"]) {//成本中心
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"成本中心可以设置为部门、员工、项目；", nil)},@{@"title":@"",@"Info":Custing(@"预算可以按照成本中心，成本中心和费用类别组合设置；", nil)},@{@"title":@"",@"Info":Custing(@"每个员工对应一个默认成本中心，在员工管理中维护；", nil)},@{@"title":@"",@"Info":Custing(@"填写报销单时，自动带出员工默认成本中心，但是可以选择其他成本中心；", nil)}]];
    }else if ([self.status isEqualToString:@"currency"]){//币种
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":Custing(@"可以设置多币种吗？", nil),@"Info":Custing(@"可以，点击“开启币种和汇率”即可；", nil)},@{@"title":Custing(@"报销单上可以选择多币种吗？", nil),@"Info":Custing(@"可以，报销单添加消费记录时，选择币种和汇率；", nil)},@{@"title":Custing(@"可以设置本位币吗？", nil),@"Info":Custing(@"不可以，系统默认本位币是“人民币”；", nil)}]];
    }else if ([self.status isEqualToString:@"costClass"]){//费用类别
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"一级费用类别必须设置二级费用类别，否则费用类别无法正常显示；", nil)},@{@"title":@"",@"Info":Custing(@"系统提供的费用类别，只能禁用和启用；", nil)},@{@"title":@"",@"Info":Custing(@"自定义的费用类别，可以修改和删除；", nil)},@{@"title":@"",@"Info":Custing(@"二级费用类别可以同时设置为差旅费和日常费；二级费用类别不可以同时设置为（差旅费和日常费）、专项费、对公付款", nil)}]];
    }else if ([self.status isEqualToString:@"powerSet"]){//设置权限
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":Custing(@"如果系统管理员离职，系统管理员权限可以转让吗？", nil),@"Info":Custing(@"可以，系统管理员可以把权限转让给其他同事。", nil)},@{@"title":Custing(@"可以添加多个系统管理员吗？", nil),@"Info":Custing(@"可以", nil)}]];
    }else if ([self.status isEqualToString:@"ProjectManagement"]){//项目
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"每个项目都有一个项目负责人；", nil)},@{@"title":@"",@"Info":Custing(@"可以设置项目负责人审批的流程“差旅报销、日常报销、专项费用报销、借款、付款”；", nil)}]];
    }else if ([self.status isEqualToString:@"editLeavelInfo"]){//设置级别
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"住宿标准和补贴标准是根据员工级别设置的。", nil)},@{@"title":@"",@"Info":Custing(@"在员工管理中可以为每个员工设置一个级别。", nil)},]];
    }else if ([self.status isEqualToString:@"HRStandard"]){//住宿标准
      
    }else if ([self.status isEqualToString:@"editPositionInfo"]){//设置职位
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":Custing(@"因为要优化层级审批流程，职位设置如:", nil),@"Info":Custing(@"销售经理和市场经理统称“部门经理”\n销售总监和市场总监统称“部门总监”", nil)}]];
    }else if ([self.status isEqualToString:@"borrowRecord"]){//收款
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"员工借款记录来自“出差申请中的预支金额”；", nil)},@{@"title":@"",@"Info":Custing(@"员工借款记录来自“差旅报销时冲销的金额”；", nil)},@{@"title":@"",@"Info":Custing(@"员工借款记录来自“预支审批的借款金额”；", nil)},@{@"title":@"",@"Info":Custing(@"财务经理或出纳有权限手工输入员工本次还款金额。", nil)}]];
    }else if ([self.status isEqualToString:@"ForStand"]){//补贴标准
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"住宿标准按照员工级别和城市等级进行设置。", nil)},@{@"title":@"",@"Info":Custing(@"补贴标准按照员工级别和补贴类型进行设置，补贴类型在“费用类别—补贴”下维护。", nil)},@{@"title":@"",@"Info":Custing(@"住宿标准控制，在添加消费记录时，控制住宿费不能超标。", nil)},@{@"title":@"",@"Info":Custing(@"补贴标准控制，在添加消费记录时，自动带出补贴金额。", nil)}]];
    }else if ([self.status isEqualToString:@"agent"]){//代理人设置
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":Custing(@"什么是代理人？", nil),@"Info":Custing(@"授权代理人可以帮我提交和审批单据。", nil)},@{@"title":Custing(@"代理人拥有哪些权限？", nil),@"Info":Custing(@"预订机票、酒店、火车票；\n填写消费信息；\n提交出差申请、差旅报销、日常报销、付款、借款等申请单据；\n审批报销单据。", nil)}]];
    }else if ([self.status isEqualToString:@"procurrementInfo"]){//采购类型
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"采购申请单中使用到“采购类型”。", nil)}]];
    }else if ([self.status isEqualToString:@"payoffWayInfo"]){//支付方式
        _InfoArray=[NSMutableArray arrayWithArray:@[@{@"title":@"",@"Info":Custing(@"采购申请单和付款中使用到“支付方式”。", nil)}]];
    }
    if (_InfoArray.count!=0) {
        [self createTableView];
    }
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _InfoArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict=_InfoArray[indexPath.section];
    CGSize size=CGSizeZero;
    CGSize size1=CGSizeZero;
    if (![dict[@"title"]isEqualToString:@""]) {
        size = [dict[@"title"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    }
    if (![dict[@"Info"]isEqualToString:@""]) {
        size1 = [dict[@"Info"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    }
    return 20+size1.height+size.height+5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"InfoViewCell"];
    if (_cell==nil) {
        _cell=[[InfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoViewCell"];
    }
    NSDictionary *dict=_InfoArray[indexPath.section];
    [_cell configViewInfoWithDict:dict withIndex:indexPath];
    return _cell;
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
