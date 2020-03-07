//
//  OtherReimTypeController.m
//  galaxy
//
//  Created by hfk on 2016/11/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "OtherReimTypeController.h"

@interface OtherReimTypeController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@property(nonatomic,strong)NSMutableArray *resultArray;
/**
 *  tableView头视图
 */
@property(nonatomic,strong)UIView *headView;
@property (nonatomic,strong)OtherReimTypeChooseCell *cell;

@end

@implementation OtherReimTypeController
-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray=[NSMutableArray array];
    }
    return _resultArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"专项费用报销", nil) backButton:YES];
    [self requestCategory];
    _requestType=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (_requestType==YES) {
        [self requestCategory];
    }
    _requestType=YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建tableView
-(void)createChooseTypeTable{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//MARK:请求专项报销类别
-(void)requestCategory{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GETOtherExpType];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //    //临时解析用的数据
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    //    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 0:
            [self dealWithData];
            if (!_tableView) {
                [self createChooseTypeTable];
            }else{
                [_tableView reloadData];
            }
            [self createNOdataView];
            break;
        default:
            break;
    }
    
}
-(void)dealWithData{
    NSArray *array=_resultDict[@"result"];
    [self.resultArray removeAllObjects];
    if (array.count!=0) {
        for (NSDictionary *dic in array) {
            OtherReimTypeChooseModel *model=[[OtherReimTypeChooseModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.resultArray addObject:model];
        }
    }
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self createHeadViewWithSection:section];
    return _headView;}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"OtherReimTypeChooseCell"];
    if (_cell==nil) {
        _cell=[[OtherReimTypeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherReimTypeChooseCell"];
    }
    [_cell configCellWithRows:indexPath.row WithResultArray:self.resultArray];
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherReimViewController *vc = [[OtherReimViewController alloc]init];
    OtherReimTypeChooseModel *model = self.resultArray[indexPath.row];
    vc.FormDatas.str_expenseCode = [NSString stringWithFormat:@"%@",model.expenseCode];
    vc.FormDatas.str_expenseIcon = [NSString stringWithFormat:@"%@",model.expenseIcon];
    vc.FormDatas.str_expenseType = [NSString stringWithFormat:@"%@",model.expenseType];
    vc.FormDatas.str_parentCode = [NSString stringWithFormat:@"%@",model.parentCode];
    vc.FormDatas.str_flowGuid = self.flowGuid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_headView addSubview:ImgView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-30, 18) text:Custing(@"选择报销类别", nil) font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+Main_Screen_Width/2-4, 13.5);
    [_headView addSubview:titleLabel];
    
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, 26.5, Main_Screen_Width, 0.5)];
    downView.backgroundColor=Color_LineGray_Same_20;
    [_headView addSubview:downView];
    _headView.backgroundColor=Color_White_Same_20;
}
-(void)createNOdataView{
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有专项费用类别哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
