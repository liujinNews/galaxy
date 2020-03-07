//
//  ReimShareDeptDetailController.m
//  galaxy
//
//  Created by hfk on 2019/7/1.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ReimShareDeptDetailController.h"

@interface ReimShareDeptDetailController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arr_ShareData;
/**
 *  消费记录tableView
 */
@property (nonatomic, strong) UITableView *ShareTableView;
@property (nonatomic, strong) UIView *ShareHeadView;

@end

@implementation ReimShareDeptDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:[NSString stringIsExist:self.model.RequestorDept] backButton:YES];
    self.arr_ShareData = [NSMutableArray array];
    [self createttTableView];
    [self requestShareDetail];
    
}
-(void)createttTableView{
    _ShareTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _ShareTableView.backgroundColor = Color_White_Same_20;
    _ShareTableView.delegate = self;
    _ShareTableView.dataSource = self;
    _ShareTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_ShareTableView];
    [_ShareTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//MARK:获取分摊数据
-(void)requestShareDetail{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"RequestUserId":self.FormDatas.personalData.RequestorUserId,
                                 @"RequestorDeptId":[NSString isEqualToNull:self.model.RequestorDeptId] ? self.model.RequestorDeptId:@"0",
                                 @"TaskId":self.FormDatas.str_taskId
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:GETPAYMENTSHAREDETAIL Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responceDic[@"result"]) {
                    ReimShareModel *model = [[ReimShareModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.arr_ShareData addObject:model];
                }
                [_ShareTableView reloadData];
            }
        }
            break;
        default:
            break;
    }
    
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_ShareData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self createHeadViewWithSection:section];
    return _ShareHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.arr_ShareData.count - 1) {
        return 60;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.arr_ShareData.count - 1) {
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 60)];
        foot.backgroundColor = Color_WhiteWeak_Same_20;
        
        UIView *SegmentLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        SegmentLineView.backgroundColor = Color_White_Same_20;
        [foot addSubview:SegmentLineView];

        UILabel *title = [GPUtils createLable:CGRectMake(12, 10, XBHelper_Title_Width, 50) text:Custing(@"合计金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [foot addSubview:title];

        NSString *totalAmount = @"";
        for (ReimShareModel *model in self.arr_ShareData) {
            totalAmount = [GPUtils decimalNumberAddWithString:totalAmount with:[NSString stringWithFormat:@"%@",model.Amount]];
        }
        UILabel *amount = [GPUtils createLable:CGRectMake(12 + 15 + XBHelper_Title_Width, 10, Main_Screen_Width - 12 - 15 - 12 - XBHelper_Title_Width, 50) text:[GPUtils transformNsNumber:totalAmount] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        [foot addSubview:amount];
        
        return foot;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReimShareCell ReimShareCellHeightWithArray:self.FormDatas.arr_ShareForm WithModel:self.arr_ShareData[indexPath.section]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReimShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReimShareCell"];
    if (cell == nil) {
        cell = [[ReimShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReimShareCell"];
    }
    [cell configReimShareCellWithArray:self.FormDatas.arr_ShareForm withDetailsModel:self.arr_ShareData[indexPath.section] withindex:indexPath.section withCount:self.arr_ShareData.count];
    return cell;
}
//MARK:创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _ShareHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    _ShareHeadView.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UILabel *titleLabel = [GPUtils createLable:CGRectMake(0, 0, 180, 18) text:[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用分摊", nil),(long)section+1] font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    titleLabel.center = CGPointMake(90+12, 15);
    [_ShareHeadView addSubview:titleLabel];
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
