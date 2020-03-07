//
//  BillInfoListController.m
//  galaxy
//
//  Created by hfk on 2017/6/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "BillInfoListController.h"
#import "BillInfoListCell.h"
#import "BillInfoViewController.h"
#import "LookBillInfoViewController.h"
@interface BillInfoListController ()
/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  请求数据数组
 */
@property(nonatomic,strong)NSMutableArray *meItemArray;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;
@property (nonatomic, strong) UIView *dockView;//底部视图

@end

@implementation BillInfoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"开票信息", nil) backButton:YES];
    [self createTableView];
    if (_CanDeal) {
        [self createAddBtn];
        [self requestList];
    }else{
        [self dealWithData];
    }
    _requestType=@"1";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [self requestList];
    }
    _requestType=@"0";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建tableView
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    if (_CanDeal) {
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view.bottom).offset(@-50);
        }];
    }else{
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}
-(void)createAddBtn{
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 50)action:@selector(AddInfo:) delegate:self];
    btn.backgroundColor =Color_Blue_Important_20;
    [btn setTitle:Custing(@"添加", nil) forState:UIControlStateNormal];
    btn.titleLabel.font=Font_filterTitle_17 ;
    [btn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:btn];
}
//MARK:获取数据
-(void)requestList
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GetCoCardList];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stri);
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
        case 0://获取列表
            [self dealWithData];
            break;
        case 1:
            [self requestList];
            break;
        default:
            break;
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)dealWithData{
    self.meItemArray = [NSMutableArray array];
    if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
        NSArray *arr=_resultDict[@"result"];
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                [self.meItemArray  addObject:dict];
            }
        }
    }
    [self createNOdataView];
    [_tableView reloadData];
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meItemArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,0.01)];
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
    NSDictionary *dict=_meItemArray[indexPath.row];
    return [BillInfoListCell cellHeightWithObj:dict];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillInfoListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BillInfoListCell"];
    if (cell==nil) {
        cell=[[BillInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillInfoListCell"];
    }
    cell.dict=_meItemArray[indexPath.row];
    if (indexPath.row<_meItemArray.count-1) {
        cell.HasLine=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=_meItemArray[indexPath.row];
    if (_CanDeal) {
        BillInfoViewController *bill = [[BillInfoViewController alloc]init];
        bill.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        [self.navigationController pushViewController:bill animated:YES];
    }else{
        LookBillInfoViewController *look = [[LookBillInfoViewController alloc]init];
        look.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        [self.navigationController pushViewController:look animated:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _CanDeal;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"删除");
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSDictionary *dict=weakSelf.meItemArray[indexPath.row];
        NSString *url=[NSString stringWithFormat:@"%@", DeleteCoCard];
        NSDictionary *parameters = @{@"Id":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@""};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:weakSelf SerialNum:1 IfUserCache:NO];

    }];
    return @[deleteRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    return UITableViewCellEditingStyleDelete;//删除cell
    
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
}
//MARK:新增开票信息
-(void)AddInfo:(UIButton *)btn{
    BillInfoViewController *bill = [[BillInfoViewController alloc]init];
    bill.Id=@"";
    [self.navigationController pushViewController:bill animated:YES];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有开票信息哦", nil) hasData:(_meItemArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
