//
//  BillPayViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/17.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BillPayViewController.h"
#import "BudgetStatisticsTableViewCell.h"
#import "NSDate+Change.h"
@interface BillPayViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,UIPickerViewDataSource,UIPickerViewDelegate,chooseTravelDateViewDelegate>

@property (nonatomic, strong) NSString *select_date;

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;

@property (nonatomic, strong) NSDictionary *dic_request;

@property(nonatomic,strong)UIPickerView * pickerView;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框
@property(nonatomic,strong)NSMutableArray * arr_dateArray;//年份数组
@property(nonatomic,strong)NSMutableArray * arr_mounthArray;//月份数组

@end

@implementation BillPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"我的支出", nil)  backButton:YES];
    _lab_amound.text = Custing(@"报销金额:", nil);
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initContentView];
    [self requestGetMyCostByYearAndMonth:@{@"year":[NSString stringWithYear:[NSDate date]],@"month":[NSDate getCurrentPreviousMonth]}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - function
-(void)initContentView
{
    _select_date = [NSString stringWithDate:[NSDate date]];
    _tbv_contenttebleview.dataSource = self;
    _tbv_contenttebleview.delegate = self;
    _tbv_contenttebleview.rowHeight = 79;
    _tbv_contenttebleview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbv_contenttebleview.backgroundColor = Color_White_Same_20;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    
    
    _select_date = [NSString stringWithDate:[calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0]];
    
    _select_date = [_select_date substringToIndex:7];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"历史", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right:)];
    
    _arr_dateArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<5; i++) {
        [_arr_dateArray addObject:[NSString stringWithFormat:@"%d",[[_select_date substringToIndex:4]intValue]-4+i]];
    }
    _arr_mounthArray = [NSMutableArray arrayWithArray:@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"]];
}

-(void)updateHeaderView
{
    _lab_date.text = [NSString stringWithFormat:@"%@%@",[_select_date stringByReplacingOccurrencesOfString:@"/" withString:Custing(@"年_", nil)],Custing(@"月:_",nil)];
    _lab_cound.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:_dic_request[@"result"][@"totalAmount"]]];
}

-(void)requestGetMyCostByYearAndMonth:(NSDictionary *)dic
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetMyCostByYearAndMonth] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//初始化数据
-(void)dealWithData{
    NSDictionary *result = _dic_request[@"result"];
    _Arr_mainFld = result[@"details"];
    [_tbv_contenttebleview reloadData];
}

#pragma mark - action
-(void)btn_right:(UIButton *)btn
{
    STNewPickView *picker = [[STNewPickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STNewPickModel *firstModel, STNewPickSubModel *secondModel, NSInteger type) {
        [weakSelf requestGetMyCostByYearAndMonth:@{@"year":firstModel.Type,@"month":secondModel.Type}];
        weakSelf.select_date = [NSString stringWithFormat:@"%@/%@",firstModel.Type,secondModel.Type];
    }];
    
    picker.int_compRows=2;
    picker.typeTitle=Custing(@"时间选择", nil);
    picker.DateSourceArray=[NSMutableArray arrayWithArray:[STNewPickModel getYearMonthDataArray]];
    STNewPickModel *model=[[STNewPickModel alloc]init];
    model.Type = [NSString isEqualToNull:_select_date]?[_select_date substringAtRange:NSMakeRange(0, 4)]:[NSString stringWithYear:[NSDate date]];
    picker.first_Model=model;
    
    STNewPickSubModel *sub=[[STNewPickSubModel alloc]init];
    sub.Type = [NSString isEqualToNull:_select_date]?[_select_date substringAtRange:NSMakeRange(5, _select_date.length-5)]:[NSString stringWithMonth:[NSDate date]];
    picker.second_Model=sub;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}

-(void)sureData:(UIButton *)btn
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self requestGetMyCostByYearAndMonth:@{@"year":[NSString stringWithYear:[NSDate date]],@"month":[NSString stringWithMonth:[NSDate date]]}];
    [self.datelView remove];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum==0) {
        [YXSpritesLoadingView dismiss];
        _dic_request = responceDic;
        [self dealWithData];
        [self updateHeaderView];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//弹窗代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        _select_date = [NSString stringWithFormat:@"%@%@",[_arr_dateArray objectAtIndex:row], [_select_date substringWithRange:NSMakeRange(4, 3)]] ;
    }
    if (component==1) {
        _select_date = [NSString stringWithFormat:@"%@%@", [_select_date substringToIndex:5],[_arr_mounthArray objectAtIndex:row]] ;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return _arr_dateArray.count;
    }
    else
    {
        return _arr_mounthArray.count;
    }
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [_arr_dateArray objectAtIndex:row];
    }
    else
    {
        return [_arr_mounthArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Arr_mainFld.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetStatisticsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BudgetStatisticsTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetStatisticsTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    NSLog(@"%ld",(long)indexPath.row);
    cell.type = 3;
    cell.dic = _Arr_mainFld[indexPath.row];
    cell.img_right.hidden = YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
