//
//  cCTravelAndDayViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "addTravelAndDayCateryViewController.h"
#import "addTravelAndDayCateryData.h"
#import "addTravelAndDayCateryCell.h"

#import "cCTravelAndDayViewController.h"

@interface cCTravelAndDayViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)NSString * paramValue;
@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property (nonatomic,strong)NSMutableArray * cateryArray;
@property (nonatomic,strong)UITableView * tableView;


@end

@implementation cCTravelAndDayViewController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.paramValue = type;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestIsTravelOrDayData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(self.paramValue, nil) backButton:YES];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * submitBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 45 - NavigationbarHeight, Main_Screen_Width,45) action:@selector(pushAddCostClass:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"编辑", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [submitBtn setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview: submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    //tableView
    self.cateryArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(submitBtn.top);
    }];
}

#pragma mark - <UItableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cateryArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    addTravelAndDayCateryData * data = self.cateryArray[indexPath.row];
    NSInteger heghts = 58 + data.sizes.height;
    NSLog(@"%ld",(long)heghts);
    return heghts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addTravelAndDayCateryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"addTravelAndDayCateryCell"];
    if (cell==nil) {
        cell=[[addTravelAndDayCateryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTravelAndDayCateryCell"];
    }
    addTravelAndDayCateryData * data = self.cateryArray[indexPath.row];
    [cell configTravelAndDayCateryCellInfo:data];
    
    return cell;
}

-(void)requestIsTravelOrDayData {
    
    NSDictionary * dic;
    if ([self.paramValue isEqualToString:@"出差申请"]) {
        dic=@{@"Type":@"7"};
    }else if ([self.paramValue isEqualToString:@"差旅费"]) {
        dic=@{@"Type":@"1"};
    }else if ([self.paramValue isEqualToString:@"日常费"]){
        dic=@{@"Type":@"2"};
    }else if ([self.paramValue isEqualToString:@"专项费"]){
        dic=@{@"Type":@"3"};
    }else if ([self.paramValue isEqualToString:@"付款"]){
        dic=@{@"Type":@"4"};
    }else if ([self.paramValue isEqualToString:@"合同"]){
        dic=@{@"Type":@"6"};
    }else if ([self.paramValue isEqualToString:@"税额Add"]){
        dic=@{@"Type":@"5"};
    }
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETCATEList] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0://
            [self.cateryArray removeAllObjects];
            [addTravelAndDayCateryData GetTravelAndDayCateryDictionary:responceDic Array:self.cateryArray];
            if (self.cateryArray.count == 0) {
                [self createNOdataView];
            }
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//添加费用类别
-(void)pushAddCostClass:(UIButton *)btn {
    [self removeNodateViews];
    addTravelAndDayCateryViewController * ctravel = [[addTravelAndDayCateryViewController alloc]initWithType:@{@"title":self.paramValue,@"listName":@"交通费"}];
    [self.navigationController pushViewController:ctravel animated:YES];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)/3, Main_Screen_Width, 132)];
        _noDateView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_noDateView];
        
        UILabel *title=[GPUtils createLable:CGRectMake(Main_Screen_Width/2-110, 0, 220, 50) text:nil font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentCenter];
        
        NSString *mes;
        if ([self.paramValue isEqualToString:@"出差申请"]) {
            mes=Custing(@"您还没有设置出差申请的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"差旅费"]) {
            mes=Custing(@"您还没有设置差旅费的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"日常费"]){
            mes=Custing(@"您还没有设置日常费的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"专项费"]){
            mes=Custing(@"您还没有设置专项费的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"付款"]){
            mes=Custing(@"您还没有设置付款的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"合同"]){
            mes=Custing(@"您还没有设置合同的费用类别赶快添加吧", nil);
        }else if ([self.paramValue isEqualToString:@"税额Add"]){
            mes=Custing(@"您还没有设置税额的费用类别赶快添加吧", nil);
        }
        
        title.text =mes;
        title.numberOfLines = 0;
        [_noDateView addSubview:title];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-41/4, 60, 41/2, 134/2)];
        nodataView.image=[UIImage imageNamed:@"costClassAddTAD"];
        [_noDateView addSubview:nodataView];
        
    }
}

//MARK:移除筛选无数据视图
-(void)removeNodateViews{
    if (_noDateView&&_noDateView!=nil) {
        [_noDateView removeFromSuperview];
        _noDateView=nil;
    }
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
