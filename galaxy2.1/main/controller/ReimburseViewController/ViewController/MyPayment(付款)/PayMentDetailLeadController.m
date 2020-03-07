//
//  PayMentDetailLeadController.m
//  galaxy
//
//  Created by hfk on 2019/6/21.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "PayMentDetailLeadController.h"
#import "ReimImportCustomCell.h"

@interface PayMentDetailLeadController ()<UISearchBarDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar * searchbar;
@property (nonatomic, strong) NSString *searchAim;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DoneBtnView * dockView;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation PayMentDetailLeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"导入费用明细", nil) backButton:YES];
    self.resultArray = [NSMutableArray array];
    [self createViews];
    [self requestData];
}
-(void)createViews{
    _searchAim = @"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    //    判断iOS的版本是否大于13.0
      if (@available(iOS 13.0, *)) {
          UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
          backGroundView.alpha = 0;
          self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
          self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
          self.searchbar.searchTextField.placeholder = Custing(@"搜索费用类别", nil);
          UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
          
          [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
      } else {
          // Fallback on earlier versions
          [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
          self.searchbar.placeholder = Custing(@"搜索费用类别", nil);
      }
    self.searchbar.delegate = self;
//    self.searchbar.placeholder = Custing(@"搜索费用类别", nil);
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    
    self.dockView = [[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled = YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        [weakSelf requestImport];
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchbar.bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.dockView.top);
    }];
}
#pragma mark network
//请求数据
-(void)requestData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameter = @{@"UserId":self.dict_parameter[@"UserId"],
                                @"OwnerUserId":self.dict_parameter[@"OwnerUserId"],
                                @"TaskId":self.dict_parameter[@"TaskId"],
                                @"ExpenseType":_searchAim,
                                };
    [[GPClient shareGPClient]REquestByPostWithPath:GETIMPORTPAYEXPLIST Parameters:parameter Delegate:self SerialNum:0 IfUserCache:NO];
}
-(void)requestImport{
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dict in self.resultArray) {
        NSMutableArray *arr = dict[@"array"];
        for (NSMutableDictionary *data in arr) {
            if ([data[@"checked"]floatValue] == 1) {
                PaymentExpDetail *model = [[PaymentExpDetail alloc]init];
                [model setValuesForKeysWithDictionary:data];
                model.ExpId = [NSString stringWithFormat:@"%@",data[@"id"]];
                [array addObject:model];
            }
        }
    }
    if (array.count <= 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少选择一条费用明细", nil) duration:2.0];
        return;
    }
    if (self.importDetailBackBlock) {
        self.importDetailBackBlock(array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self dealDateWithDict:responceDic];
            [self.tableView reloadData];
            [self createNOdataView];
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:数据处理
-(void)dealDateWithDict:(NSDictionary *)responceDic{
    if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
        NSString *date = nil;
        NSMutableDictionary *dataDic;
        NSMutableArray *dataArr;
        [self.resultArray removeAllObjects];
        for (NSDictionary *dict in responceDic[@"result"]) {
            NSMutableArray *array = self.dict_parameter[@"ExpIds"];
            if (![array containsObject:[NSString stringWithFormat:@"%@",dict[@"id"]]]) {
                NSString *dataDate = [NSString stringIsExist:dict[@"expenseDate"]];
                if ([dataDate isEqualToString:date]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [dic setObject:@"0" forKey:@"checked"];
                    [dataArr addObject:dic];
                }else{
                    dataDic = [NSMutableDictionary dictionary];
                    dataArr = [NSMutableArray array];
                    [dataDic setObject:dataDate forKey:@"date"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [dic setObject:@"0" forKey:@"checked"];
                    [dataArr addObject:dic];
                    [dataDic setObject:dataArr forKey:@"array"];
                    [self.resultArray addObject:dataDic];
                }
                date = dataDate;
            }
        }
    }
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *dict = self.resultArray[section];
    NSMutableArray *arr = dict[@"array"];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.resultArray[section];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25)];
    headView.backgroundColor=Color_White_Same_20;
    UILabel *titleLabel = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width - 24, 25) text:dict[@"date"] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [headView addSubview:titleLabel];
    UIView *linedown=[[UIView alloc]initWithFrame:CGRectMake(0,24.5, Main_Screen_Width,0.5)];
    linedown.backgroundColor=Color_GrayLight_Same_20;
    [headView addSubview:linedown];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = self.resultArray[indexPath.section];
    NSMutableArray *arr = dict[@"array"];
    NSMutableDictionary *data = arr[indexPath.row];
    return  [ReimImportCustomCell cellHeightWithObj:data];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReimImportCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReimImportCustomCell"];
    if (cell==nil) {
        cell=[[ReimImportCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReimImportCustomCell"];
    }
    NSMutableDictionary *dict = self.resultArray[indexPath.section];
    NSMutableArray *arr = dict[@"array"];
    NSMutableDictionary *data = arr[indexPath.row];
    [cell configCellWithDict:data WithIsLast:indexPath.row == arr.count-1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = self.resultArray[indexPath.section];
    NSMutableArray *arr = dict[@"array"];
    NSMutableDictionary *data = arr[indexPath.row];
    [data setObject:[[NSString stringWithFormat:@"%@",data[@"checked"]]isEqualToString:@"1"] ? @"0":@"1" forKey:@"checked"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//MARK: UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        _searchAim = @"";
        [self requestData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim = searchBar.text;
    [self requestData];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有费用明细哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
