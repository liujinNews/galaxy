//
//  PerformanceTypeController.m
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceTypeController.h"
#import "PerformanceTypeModel.h"
#import "PerformanceNewController.h"
@interface PerformanceTypeController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@property(nonatomic,strong)NSMutableArray *resultArray;

@property (nonatomic,strong)OtherReimTypeChooseCell *cell;

@end

@implementation PerformanceTypeController

-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray=[NSMutableArray array];
    }
    return _resultArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"选择考评表", nil) backButton:YES];
    [self createTypeTable];
    [self requestPerType];
    _requestType=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType==YES) {
        [self requestPerType];
    }
    _requestType=YES;
}
//MARK:创建tableView
-(void)createTypeTable{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor=Color_White_Same_20;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}
//MARK:请求专项报销类别
-(void)requestPerType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GETPERTYPE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
            [_tableView reloadData];
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
            PerformanceTypeModel *model=[[PerformanceTypeModel alloc]init];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"OtherReimTypeChooseCell"];
    if (_cell==nil) {
        _cell=[[OtherReimTypeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherReimTypeChooseCell"];
    }
    [_cell configPerformanceCellWithRows:indexPath.row WithResultArray:self.resultArray];
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceTypeModel *model=self.resultArray[indexPath.row];
    PerformanceNewController *vc=[[PerformanceNewController alloc]init];
    vc.FormDatas.str_TypeId=[NSString isEqualToNull:model.Id]?[NSString stringWithFormat:@"%@",model.Id]:@"";
    if ([self.userdatas.language isEqualToString:@"ch"]) {
        vc.FormDatas.str_TypeName=[NSString isEqualToNull:model.name]?[NSString stringWithFormat:@"%@",model.name]:@"";
    }else{
        vc.FormDatas.str_TypeName=[NSString isEqualToNull:model.nameEn]?[NSString stringWithFormat:@"%@",model.nameEn]:@"";
    }
    vc.FormDatas.str_flowGuid = self.flowGuid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)createNOdataView{
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有考评表哦", nil) hasData:(_resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
