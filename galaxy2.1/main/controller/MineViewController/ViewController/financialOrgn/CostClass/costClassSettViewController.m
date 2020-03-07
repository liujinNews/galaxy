//
//  costClassSettViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "costClassSettViewController.h"
#import "ChooseCategoryCell.h"
@interface costClassSettViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *resultDict;
@property (nonatomic,assign)NSInteger int_showType;
@property (nonatomic,assign)NSInteger  int_showDes;
@end

@implementation costClassSettViewController
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
        NSArray *showType=@[Custing(@"仅显示二级费用类别", nil),Custing(@"显示一级和二级费用类别", nil),Custing(@"按照列表方式显示", nil)];
        NSArray *showDes=@[Custing(@"是", nil),Custing(@"否", nil)];
        [_dataArray addObject:showType];
        [_dataArray addObject:showDes];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"显示方式", nil) backButton:YES];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _int_showType=1;
    _int_showDes=0;
    [self getSettingInfo];
    
}
-(void)createTableView{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(saveSetCostClass:)];
    
    if (!_tableView) {
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
}
-(void)getSettingInfo {
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETEXPTYPESETTING];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
-(void)saveSetCostClass:(id)obj{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",SAVEEXPTYPESETTING];
    NSDictionary *par=@{@"ExpTypDisplayMode":[NSNumber numberWithInteger:_int_showType],@"IsShowExpenseDesc":[NSNumber numberWithInteger:_int_showDes]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:par Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:创建tableView

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealData];
            [self createTableView];
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:2.0];
            __weak typeof(self) weakSelf = self;
            [self performBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0];
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)dealData{
    NSDictionary *result=_resultDict[@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        if (![result[@"expTypDisplayMode"]isKindOfClass:[NSNull class]]) {
            _int_showType=[[NSString stringWithFormat:@"%@",result[@"expTypDisplayMode"]]integerValue];
        }
        if (![result[@"isShowExpenseDesc"]isKindOfClass:[NSNull class]]) {
            _int_showDes=[[NSString stringWithFormat:@"%@",result[@"isShowExpenseDesc"]]integerValue];
        }
    }
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr=self.dataArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 50);
    view.backgroundColor=Color_White_Same_20;
    UILabel *label=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, 50) text:section==0?Custing(@"添加费用时,选择费用类别页面显示方式", nil):Custing(@"选择费用类别,是否显示费用描述", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    label.numberOfLines=0;
    [view addSubview:label];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
    if (cell==nil) {
        cell=[[ChooseCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
    }
    [cell configCateShowTypeWith:self.dataArray index:indexPath showType:_int_showType showDes:_int_showDes];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row+1!=_int_showType) {
            _int_showType=indexPath.row+1;
            [_tableView reloadData];
        }
    }else{
        if (indexPath.row==0&&_int_showDes!=1) {
            _int_showDes=1;
            [_tableView reloadData];
        }else if (indexPath.row==1&&_int_showDes!=0){
            _int_showDes=0;
            [_tableView reloadData];
        }
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
