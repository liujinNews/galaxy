//
//  ReiStandardViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReiStandardViewController.h"
#import "InstructionsViewController.h"

@interface ReiStandardViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tbv_TableView;
@property (nonatomic, strong) NSArray *arr_ShowData;

@property (nonatomic, strong) NSDictionary *dic_request;

@end

@implementation ReiStandardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    if (self.dict) {
        [self setTitle:[NSString stringWithIdOnNO:self.dict[@"groupName"]] backButton:YES];
    }else{
        [self setTitle:Custing(@"报销标准", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    }
    [self requestGetStdAllowanceV2];
}

-(void)updateMainView{
    _tbv_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStylePlain];
    _tbv_TableView.delegate = self;
    _tbv_TableView.dataSource = self;
    _tbv_TableView.allowsMultipleSelection=NO;
    _tbv_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbv_TableView];
}

#pragma mark 创建无数据视图
-(void)createNOdataView{
    [self.view configBlankPage:EaseBlankNormalView hasTips:Custing(@"没有报销标准", nil) hasData:(_arr_ShowData.count!=0) hasError:NO reloadButtonBlock:nil];
}
//解析数据
-(void)disposeData{
    _arr_ShowData = _dic_request[@"result"];
    [_tbv_TableView reloadData];
}
//获取员工补贴标准列表
-(void)requestGetStdAllowanceV2 {
    NSDictionary *parameters = @{@"branchid":self.dict ? ([NSString isEqualToNullAndZero:self.dict[@"groupId"]] ? self.dict[@"groupId"]:@"0"):@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",StdGetAllSet] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
#pragma mark action
-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ForStand"];
    [self.navigationController pushViewController:INFO animated:YES];
}

#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum == 0) {
        if ([responceDic[@"result"]isKindOfClass:[NSArray class]]) {
            NSArray *arr = responceDic[@"result"];
            if (arr.count>0) {
                _dic_request = responceDic;
                [self updateMainView];
                [self disposeData];
            }
            [self createNOdataView];
        }else{
            [self createNOdataView];
        }
    }
}
//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
#pragma mark tableview
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_ShowData.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSDictionary *dic_data = _arr_ShowData[indexPath.section];
    NSInteger number = [dic_data[@"type"] integerValue];
    if (number == 1) {
        NSArray *Arr = dic_data[@"value1"];
        UIView *rootview = [[UIView alloc]init];
        NSInteger y = 0;
        for (int i = 0; i<Arr.count; i++) {
            NSDictionary *dic = Arr[i];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"所有城市,最高",nil),dic[@"housePrice1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                y = y +50;
                [rootview addSubview:view];
                rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市,最高",nil),dic[@"housePrice0"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市,最高",nil),dic[@"housePrice2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content1];
                    UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市,最高",nil),dic[@"housePrice3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content2];
                    UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"港澳台,最高",nil),dic[@"housePrice4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content3];
                    UILabel *lab_content4 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 120, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"国际城市,最高",nil),dic[@"housePrice5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content4];
                    view.frame = CGRectMake(0, y, Main_Screen_Width, 150);
                    y = y +150;
                    [view addSubview:[self createLineViewOfHeight:149.5]];
                    [rootview addSubview:view];
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    y = y +50;
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    [rootview addSubview:view];
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }
            }
        }
        [cell addSubview:rootview];
    }else if (number == 2) {
        NSInteger y = 0;
        if ([dic_data[@"value2"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = dic_data[@"value2"];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"所有城市,最高",nil),dic[@"housePrice1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                //                y = y+50;
                [cell addSubview:view];
            }else{
                NSInteger height = 0;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, height)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市,最高",nil),dic[@"housePrice0"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市,最高",nil),dic[@"housePrice2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content1];
                    UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市,最高",nil),dic[@"housePrice3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content2];
                    NSArray *arr = dic[@"StdAllowanceGlobalList"];
                    height = 90;
                    if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            NSDictionary *dic_std = arr[i];
                            UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90+(i*30), Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@%@%@",dic_std[@"Country"],Custing(@",最高",nil),dic[@"Amount1"],Custing(@"元/全天,",nil),dic[@"Amount"],Custing(@"元/半天",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content3];
                            height = height + 30;;
                        }
                        view.frame = CGRectMake(0, 0, Main_Screen_Width, height);
                        [view addSubview:[self createLineViewOfHeight:height-0.5]];
                        //                        y = y+height;
                    }else{
                        view.frame = CGRectMake(0, 0, Main_Screen_Width, height);
                        [view addSubview:[self createLineViewOfHeight:height-0.5]];
                        //                        y = y+height;
                    }
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    view.frame = CGRectMake(0, y, Main_Screen_Width, 50);
                    //                    y = y+50;
                }
                [cell addSubview:view];
            }
        }
        if ([dic_data[@"value2"] isKindOfClass:[NSArray class]]) {
            UIView *rootview = [[UIView alloc]init];
            NSArray *arr = dic_data[@"value2"];
            NSInteger y = 0;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    lab.numberOfLines = 0;
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"所有城市,最高",nil),dic[@"housePrice1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    y = y+50;
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    [rootview addSubview:view];
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }else{
                    NSInteger height = 0;
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, height)];
                    view.backgroundColor = Color_form_TextFieldBackgroundColor;
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市,最高",nil),dic[@"housePrice1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市,最高",nil),dic[@"housePrice2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content1];
                        UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市,最高",nil),dic[@"housePrice3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content2];
                        NSArray *arr = dic[@"stdAllowanceGlobalList"];
                        height = 90;
                        if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                            for (int i = 0; i<arr.count; i++) {
                                NSDictionary *dic_std = arr[i];
                                UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90+(i*30), Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@(%@)",dic_std[@"country"],Custing(@",最高",nil),dic_std[@"amount"],dic_std[@"currencyCode"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                                [view addSubview:lab_content3];
                                height = height + 30;
                            }
                        }
                        view.frame = CGRectMake(0, y, Main_Screen_Width, height);
                        [view addSubview:[self createLineViewOfHeight:height-0.5]];
                        [rootview addSubview:view];
                        y = y+height;
                        rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        view.frame = CGRectMake(0, y, Main_Screen_Width, 50);
                        [view addSubview:[self createLineViewOfHeight:49.5]];
                        y = y+50;
                        rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                    }
                    
                }
            }
            [cell addSubview:rootview];
        }
    }else if (number == 3) {
        NSArray *arr = dic_data[@"value3"];
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        NSInteger y = 0;
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [view addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"最高",nil),dic[@"amount"],Custing(@"元",nil),dic[@"unitStr"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            [rootview addSubview:view];
            height = i*50;
            y = height + 50;
            rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
        }
        [cell addSubview:rootview];
    }else if (number == 4) {
        NSArray *Arr = dic_data[@"value4"];
        UIView *rootview = [[UIView alloc]init];
        NSInteger y = 0;
        for (int i = 0; i<Arr.count; i++) {
            NSDictionary *dic = Arr[i];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@%@",Custing(@"所有城市,最高",nil),dic[@"amount"],Custing(@"元/",nil),dic[@"unitStr"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                [rootview addSubview:view];
                y = y + 50;
                rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 150)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市,最高",nil),dic[@"amount1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市,最高",nil),dic[@"amount2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content1];
                    UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市,最高",nil),dic[@"amount3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content2];
                    UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"港澳台,最高",nil),dic[@"amount4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content3];
                    UILabel *lab_content4 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 120, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"国际城市,最高",nil),dic[@"amount5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content4];
                    [view addSubview:[self createLineViewOfHeight:149.5]];
                    [rootview addSubview:view];
                    y = y + 150;
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    view.frame = CGRectMake(X(view), Y(view), Main_Screen_Width, 50);
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    [rootview addSubview:view];
                    y = y + 50;
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }
            }
        }
        [cell addSubview:rootview];
    }else if (number == 5){
        if ([dic_data[@"value5"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = dic_data[@"value5"];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"所有城市,", nil),Custing(@"一天餐补", nil),dic[@"amount"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    lab_content.numberOfLines = 0;
                    [view addSubview:lab_content];
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                [cell addSubview:view];
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:149.5]];
                NSInteger height = 0;
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"一线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount1"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount7"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"二线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount2"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount6"],Custing(@"元",nil)]font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content1];
                    UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"三线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount3"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content2];
                    view.frame = CGRectMake(0, 0, Main_Screen_Width, 90);
                    NSArray *arr = dic[@"StdAllowanceGlobalList"];
                    if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            NSDictionary *dic_std = arr[i];
                            UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60+(i*30), Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@,%@%@,%@%@(%@)",dic_std[@"country"],Custing(@"一天餐补",nil),dic_std[@"amount"],Custing(@"半天餐补", nil),dic_std[@"amount1"],dic_std[@"currencyCode"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content3];
                            height = 90+(i*30);
                            view.frame = CGRectMake(0, 0, Main_Screen_Width, height+30);
                        }
                    }
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                [cell addSubview:view];
            }
        }else if ([dic_data[@"value5"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = dic_data[@"value5"];
            UIView *rootview = [[UIView alloc]init];
            NSInteger y = 0;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                    view.backgroundColor = Color_form_TextFieldBackgroundColor;
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    lab.numberOfLines = 0;
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"所有城市,", nil),Custing(@"一天餐补", nil),dic[@"amount"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        lab_content.numberOfLines = 0;
                        [view addSubview:lab_content];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    [rootview addSubview:view];
                    y = y + 50;
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }else{
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 30)];
                    view.backgroundColor = Color_form_TextFieldBackgroundColor;
                    NSInteger height = 0;
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"一线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount1"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount7"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"二线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount2"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount6"],Custing(@"元",nil)]font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content1];
                        UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@%@,%@%@%@",Custing(@"三线城市,", nil),Custing(@"一天餐补", nil),dic[@"amount3"],Custing(@"元",nil),Custing(@"半天餐补", nil), dic[@"amount5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content2];
                        NSArray *arr = dic[@"stdAllowanceGlobalList"];
                        height = 90;
                        if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                            for (int i = 0; i<arr.count; i++) {
                                NSDictionary *dic_std = arr[i];
                                UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90+(i*30), Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@,%@%@,%@%@(%@)",dic_std[@"country"],Custing(@"一天餐补",nil),dic_std[@"amount"],Custing(@"半天餐补", nil),dic_std[@"amount1"],dic_std[@"currencyCode"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                                [view addSubview:lab_content3];
                                height = 90+(i*30+30);
                                
                            }
                        }
                        view.frame = CGRectMake(0, y, Main_Screen_Width, height);
                        [view addSubview:[self createLineViewOfHeight:height-0.5]];
                        [rootview addSubview:view];
                        y = y + height;
                        rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        view.frame = CGRectMake(0, y, Main_Screen_Width, 50);
                        [view addSubview:[self createLineViewOfHeight:49.5]];
                        [rootview addSubview:view];
                        y = y + 50;
                        rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                    }
                }
            }
            [cell addSubview:rootview];
        }
    }else if (number == 6) {
        NSDictionary *dic = dic_data[@"value6"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
        view.backgroundColor = Color_form_TextFieldBackgroundColor;
        [view addSubview:[self createLineViewOfHeight:49.5]];
        UILabel *lab_content = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"标准费用%@元/公里",dic[@"amount"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab_content];
        [cell addSubview:view];
    }else if (number == 7) {
        NSArray *arr = dic_data[@"value7"][@"stdSelfDriveDto"];
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width - 24, 50) text:[NSString stringWithFormat:@"%@%@%@,%@%@%@",dic[@"mileageFrom"],Custing(@"<行程里程<=", nil),dic[@"mileageTo"],Custing(@"补贴标准",nil),dic[@"amount"],Custing(@"元/公里",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            height = i*30;
            [rootview addSubview:view];
            rootview.frame = CGRectMake(0, 0, Main_Screen_Width, height+30);
        }
        [cell addSubview:rootview];
    }else if (number == 8) {
        NSArray *arr = [dic_data[@"value8"] isKindOfClass:[NSArray class]] ? dic_data[@"value8"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        for (int i =0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [view addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@%@",Custing(@"最高",nil),[dic[@"class2"] integerValue] == 1?Custing(@"经济舱",nil):[dic[@"class2"] integerValue] ==2?Custing(@"商务舱",nil):Custing(@"头等舱",nil),Custing(@"折扣",nil),[NSString isEqualToNull:dic[@"discount"]]?dic[@"discount"]:@"0"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            [rootview addSubview:view];
        }
        [cell addSubview:rootview];
    }else if (number == 9) {
        UIView *rootview = [[UIView alloc]init];
        NSInteger y = 0;
        NSArray *arr = dic_data[@"value9"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([NSString isEqualToNull:dic[@"amount"]]&&[dic[@"amount"] integerValue]!=0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 50)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"全天", nil),dic[@"amount"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                }
                y = y + 50;
                [rootview addSubview:view];
                rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, Main_Screen_Width, 90)];
                view.backgroundColor = Color_form_TextFieldBackgroundColor;
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                lab.numberOfLines = 0;
                [view addSubview:lab];
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"早餐", nil),dic[@"amount1"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"午餐", nil),dic[@"amount2"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content1];
                    UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"晚餐", nil),dic[@"amount3"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content2];
                    [view addSubview:[self createLineViewOfHeight:89.5]];
                    view.frame = CGRectMake(0, y, Main_Screen_Width, 90);
                    [rootview addSubview:view];
                    y = y + 90;
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }else{
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    view.frame = CGRectMake(0, y, Main_Screen_Width, 50);
                    [rootview addSubview:view];
                    y = y + 50;
                    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, y);
                }
            }
        }
        [cell addSubview:rootview];
    }else if (number == 10) {
        NSArray *arr = [dic_data[@"value10"] isKindOfClass:[NSArray class]] ? dic_data[@"value10"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [view addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"最高",nil),dic[@"amount"],Custing(@"元",nil),dic[@"unit"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            [rootview addSubview:view];
        }
        [cell addSubview:rootview];
    }else if (number == 11) {
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        NSArray *arr = dic_data[@"value11"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [view addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"最高",nil),dic[@"amount"],Custing(@"元",nil),dic[@"unit"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            height = i*50;
            [rootview addSubview:view];
            rootview.frame = CGRectMake(0, 0, Main_Screen_Width, height+50);
        }
        [cell addSubview:rootview];
    }else if (number == 12) {
        NSArray *arr = [dic_data[@"value12"] isKindOfClass:[NSArray class]] ? dic_data[@"value12"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, Main_Screen_Width, 50)];
            view.backgroundColor = Color_form_TextFieldBackgroundColor;
            [view addSubview:[self createLineViewOfHeight:49.5]];
            UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, 120, 50) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dic[@"mileageFrom"]],[NSString stringWithFormat:@"%@",dic[@"mileageTo"]]] WithCompare:Custing(@"<年龄<=", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(120+27, 0, Main_Screen_Width-120-27-12, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"补贴标准", nil), dic[@"amount"],Custing(@"元",nil),dic_data[@"unit"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [view addSubview:lab_content];
            [rootview addSubview:view];
        }
        [cell addSubview:rootview];
    }else if (number == 13) {
        NSArray *arr = [dic_data[@"value13"] isKindOfClass:[NSArray class]] ? dic_data[@"value13"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, 90, 50) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            if ([dict[@"type"] integerValue] == 0) {
                lab.text = Custing(@"工作日", nil);
            }else if ([dict[@"type"] integerValue] == 1){
                lab.text = Custing(@"双休日", nil);
            }else if ([dict[@"type"] integerValue] == 2){
                lab.text = Custing(@"法定节假日", nil);
            }else if ([dict[@"type"] integerValue] == 3){
                lab.text = Custing(@"公司节假日", nil);
            }
            [rootview addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(90 + 20, height, Main_Screen_Width - 90 - 20 - 12, 50) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            if ([dict[@"isLimit"] integerValue] == 0) {
                lab_content.text = Custing(@"无限制", nil);
            }else{
                lab_content.text = [NSString stringWithFormat:@"%@:%@",Custing(@"用车时段", nil),[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"fromTime"]],[NSString stringWithFormat:@"%@",dict[@"toTime"]]] WithCompare:@"-"]];
            }
            [rootview addSubview:lab_content];
            height += 50;
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }else if (number == 14){
        NSArray *arr = [dic_data[@"value14"] isKindOfClass:[NSArray class]] ? dic_data[@"value14"]:[NSArray array];
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dict[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdLocations"] isKindOfClass:[NSArray class]]) {
                UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [rootview addSubview:lab_content];
                height += 50;
            }else{
                if ([dict[@"stdLocations"] count] == 1) {
                    NSDictionary *dic = dict[@"stdLocations"][0];
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [rootview addSubview:lab_content];
                    height += 50;
                }else{
                    lab.frame = CGRectMake(12, height, XBHelper_Title_Width, 30);
                    for (NSDictionary *dic in dict[@"stdLocations"]) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 30) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [rootview addSubview:lab_content];
                        height += 30;
                    }
                }
            }
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }
    
    else if (number == 15){
        NSArray *arr = [dic_data[@"value15"] isKindOfClass:[NSArray class]] ? dic_data[@"value15"]:[NSArray array];
        NSArray *arr1 = [dic_data[@"value18"] isKindOfClass:[NSArray class]] ? dic_data[@"value18"]:[NSArray array];
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dict[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdOverseass"] isKindOfClass:[NSArray class]]) {
                UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [rootview addSubview:lab_content];
                height += 50;
            }else{
                if ([dict[@"stdOverseass"] count] == 1) {
                    NSDictionary *dic = dict[@"stdOverseass"][0];
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [rootview addSubview:lab_content];
                    height += 50;
                }else{
                    lab.frame = CGRectMake(12, height, XBHelper_Title_Width, 30);
                    for (NSDictionary *dic in dict[@"stdOverseass"]) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 30) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [rootview addSubview:lab_content];
                        height += 30;
                    }
                }
            }
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        for (NSDictionary *dict in arr1) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dict[@"jobTitle"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdOverseass"] isKindOfClass:[NSArray class]]) {
                UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [rootview addSubview:lab_content];
                height += 50;
            }else{
                if ([dict[@"stdOverseass"] count] == 1) {
                    NSDictionary *dic = dict[@"stdOverseass"][0];
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [rootview addSubview:lab_content];
                    height += 50;
                }else{
                    lab.frame = CGRectMake(12, height, XBHelper_Title_Width, 30);
                    for (NSDictionary *dic in dict[@"stdOverseass"]) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 30) text:[NSString stringWithFormat:@"%@：%@%@/%@",dic[@"objectName"],dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [rootview addSubview:lab_content];
                        height += 30;
                    }
                }
            }
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }else if (number == 16) {
        NSArray *arr = [dic_data[@"value19"] isKindOfClass:[NSArray class]] ? dic_data[@"value19"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dict[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];

            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab_content.numberOfLines = 0;
            if ([dict[@"stdTrains"] isKindOfClass:[NSArray class]] && [dict[@"stdTrains"] count] > 0) {
                lab_content.text = [NSString stringWithFormat:@"%@",dict[@"stdTrains"][0][@"seatName"]];
            }
            [rootview addSubview:lab_content];
            height += 50;
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }else if (number == 17) {
        NSArray *arr = [dic_data[@"value20"] isKindOfClass:[NSArray class]] ? dic_data[@"value20"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, 120, 50) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"requestor"]],[NSString stringWithFormat:@"%@",dict[@"requestorDept"]]] WithCompare:@"/"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];
            
            UILabel *lab_content = [GPUtils createLable:CGRectMake(120 + 27, height, Main_Screen_Width - 120 - 12 -27, 50) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab_content.numberOfLines = 0;
            NSString *content1 = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"carModel"]],[NSString stringWithFormat:@"%@",dict[@"carNo"]]] WithCompare:@"/"];
            NSString *content2 = [NSString stringWithFormat:@"%@%@",[NSString stringWithIdOnNO:dict[@"fuelConsumption"]],Custing(@"元/公里", nil)];
            lab_content.text = [GPUtils getSelectResultWithArray:@[content1,content2] WithCompare:@"   "];
            [rootview addSubview:lab_content];
            height += 50;
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }else if (number == 18 || number == 19){
        NSArray *arr;
        if (number == 18) {
            arr = [dic_data[@"value21"] isKindOfClass:[NSArray class]] ? dic_data[@"value21"]:[NSArray array];
        }else if (number == 19){
            arr = [dic_data[@"value22"] isKindOfClass:[NSArray class]] ? dic_data[@"value22"]:[NSArray array];
        }
        UIView *rootview = [[UIView alloc]init];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *title = [GPUtils createLable:CGRectMake(12, height, Main_Screen_Width/2-24 , 30) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"country"]],[NSString stringWithFormat:@"%@",dict[@"cityName"]]] WithCompare:@"/"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [rootview addSubview:title];
            UILabel *title1 = [GPUtils createLable:CGRectMake(Main_Screen_Width/2, height, Main_Screen_Width/2-12 , 30) text:[GPUtils getSelectResultWithArray:@[Custing(@"旺季期间：", nil),[NSString stringWithFormat:@"%@",dict[@"highSeason"]],Custing(@"月", nil)] WithCompare:@""] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [rootview addSubview:title1];
            height += 30;
            if ([dict[@"stdHotelInstitutionAmountDtos"]isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in dict[@"stdHotelInstitutionAmountDtos"]) {
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [rootview addSubview:lab];
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 27 - 12, 50) text:[NSString stringWithFormat:@"%@%@%@/%@,%@%@%@/%@",Custing(@"旺季", nil),dic[@"amount2"],Custing(@"元",nil),Custing(@"天", nil),Custing(@"淡季", nil),dic[@"amount"],Custing(@"元",nil),Custing(@"天", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [rootview addSubview:lab_content];
                    height += 50;
                    [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
                }
            }
        }
        rootview.frame = CGRectMake(0, 0, Main_Screen_Width, height);
        [cell addSubview:rootview];
    }else if (number == 20) {
        NSArray *arr = [dic_data[@"value23"] isKindOfClass:[NSArray class]] ? dic_data[@"value23"]:[NSArray array];
        UIView *rootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count * 50)];
        NSInteger height = 0;
        for (NSDictionary *dict in arr) {
            UILabel *lab = [GPUtils createLable:CGRectMake(12, height, XBHelper_Title_Width, 50) text:Custing(dict[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab.numberOfLines = 0;
            [rootview addSubview:lab];
            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width + 27, height, Main_Screen_Width - XBHelper_Title_Width - 42, 50) text:[NSString stringWithFormat:@"%@%@/%@",Custing(@"最高", nil),dict[@"amount"],dict[@"unit"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            lab_content.numberOfLines = 0;
            [rootview addSubview:lab_content];
            height += 50;
            [rootview addSubview:[self createLineViewOfHeight:height-0.5]];
        }
        [cell addSubview:rootview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height = 0;
    NSInteger reheight = 0;
    NSDictionary *dic_data = _arr_ShowData[indexPath.section];
    NSInteger number = [dic_data[@"type"] integerValue];
    NSInteger y = 0;
    if (number == 1) {
        NSArray *Arr = dic_data[@"value1"];
        for (int i = 0; i<Arr.count; i++) {
            NSDictionary *dic = Arr[i];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                y = y +50;
            }else{
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    y = y +150;
                }else{
                    y = y +50;
                }
            }
        }
        return y;
    }else if (number == 2) {
        if ([dic_data[@"value2"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = dic_data[@"value2"];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                y = y+50;
            }else{
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    NSArray *arr = dic[@"stdAllowanceGlobalList"];
                    height = 90;
                    if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            height = height + 30;;
                        }
                        y = y+height;
                    }
                }else{
                    y = y+50;
                }
            }
            return y;
        }
        if ([dic_data[@"value2"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = dic_data[@"value2"];
            NSInteger y = 0;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                    y = y+50;
                }else{
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        NSArray *arr = dic[@"stdAllowanceGlobalList"];
                        height = 90;
                        if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                            for (int i = 0; i<arr.count; i++) {
                                height = height + 30;
                            }
                        }
                        y = y+height;
                    }else{
                        y = y+50;
                    }
                    
                }
            }
            return y;
        }
    }else if (number == 3) {
        NSArray *arr = dic_data[@"value3"];
        for (int i =0; i<arr.count; i++) {
            height = i*50;
            reheight = height+50;
        }
        return reheight;
    }else if (number == 4) {
        NSArray *Arr = dic_data[@"value4"];
        NSInteger y = 0;
        for (int i = 0; i<Arr.count; i++) {
            NSDictionary *dic = Arr[i];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                y = y + 50;
            }else{
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    y = y + 150;
                }else{
                    y = y + 50;
                }
            }
        }
        return y;
    }else if (number == 5) {
        if ([dic_data[@"value5"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = dic_data[@"value5"];
            if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                return 50;
            }else{
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    NSArray *arr = dic[@"StdAllowanceGlobalList"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count>0) {
                        for (int i = 0; i < arr.count; i++) {
                            height = 60+(i*30);
                            reheight = height + 30;
                        }
                    }
                    return reheight;
                }else{
                    return 30;
                }
            }
        }
        if ([dic_data[@"value5"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = dic_data[@"value5"];
            NSInteger y = 0;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                    y = y + 50;
                }else{
                    NSInteger height = 0;
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        NSArray *arr = dic[@"stdAllowanceGlobalList"];
                        height = 90;
                        if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                            for (int i = 0; i<arr.count; i++) {
                                height = 90+(i*30+30);
                                
                            }
                        }
                        y = y + height;
                    }else{
                        y = y + 50;
                    }
                }
            }
            return y;
        }
    }else if (number == 6) {
        return 50;
    }else if (number == 7) {
        NSArray *arr = dic_data[@"value7"][@"stdSelfDriveDto"];
        for (int i =0; i<arr.count; i++) {
            height = i*50;
            reheight = height+50;
        }
        return reheight;
    }else if (number == 8) {
        NSArray *arr = [dic_data[@"value8"] isKindOfClass:[NSArray class]] ? dic_data[@"value8"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 9) {
        NSInteger y = 0;
        NSArray *arr = dic_data[@"value9"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([NSString isEqualToNull:dic[@"amount"]]&&[dic[@"amount"] integerValue]!=0) {
                y = y + 50;
            }else{
                if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                    y = y + 90;
                }else{
                    y = y + 50;
                }
            }
        }
        return y;
    }else if (number == 10) {
        NSArray *arr = [dic_data[@"value10"] isKindOfClass:[NSArray class]] ? dic_data[@"value10"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 11) {
        NSArray *arr = dic_data[@"value11"];
        for (int i =0; i<arr.count; i++) {
            height = i*50;
            reheight = height+50;
        }
        return reheight;
    }else if (number == 12) {
        NSArray *arr = [dic_data[@"value12"] isKindOfClass:[NSArray class]] ? dic_data[@"value12"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 13) {
        NSArray *arr = [dic_data[@"value13"] isKindOfClass:[NSArray class]] ? dic_data[@"value13"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 14){
        NSArray *arr = [dic_data[@"value14"] isKindOfClass:[NSArray class]] ? dic_data[@"value14"]:[NSArray array];
        for (NSDictionary *dict in arr) {
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdLocations"] isKindOfClass:[NSArray class]]) {
                reheight += 50;
            }else{
                if ([dict[@"stdLocations"] count] == 1) {
                    reheight += 50;
                }else{
                    reheight += (30 * [dict[@"stdLocations"] count]);
                }
            }
        }
        return reheight;
    }else if (number == 15){
        NSArray *arr = [dic_data[@"value15"] isKindOfClass:[NSArray class]] ? dic_data[@"value15"]:[NSArray array];
        NSArray *arr1 = [dic_data[@"value18"] isKindOfClass:[NSArray class]] ? dic_data[@"value18"]:[NSArray array];
        for (NSDictionary *dict in arr) {
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdOverseass"] isKindOfClass:[NSArray class]]) {
                reheight += 50;
            }else{
                if ([dict[@"stdOverseass"] count] == 1) {
                    reheight += 50;
                }else{
                    reheight += (30 * [dict[@"stdOverseass"] count]);
                }
            }
        }
        for (NSDictionary *dict in arr1) {
            if ([dict[@"isLimit"] integerValue] == 0 || ![dict[@"stdOverseass"] isKindOfClass:[NSArray class]]) {
                reheight += 50;
            }else{
                if ([dict[@"stdOverseass"] count] == 1) {
                    reheight += 50;
                }else{
                    reheight += (30 * [dict[@"stdOverseass"] count]);
                }
            }
        }
        return reheight;
    }else if (number == 16){
        NSArray *arr = [dic_data[@"value19"] isKindOfClass:[NSArray class]] ? dic_data[@"value19"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 17){
        NSArray *arr = [dic_data[@"value20"] isKindOfClass:[NSArray class]] ? dic_data[@"value20"]:[NSArray array];
        return arr.count * 50;
    }else if (number == 18 || number == 19){
        NSArray *arr;
        if (number == 18) {
            arr = [dic_data[@"value21"] isKindOfClass:[NSArray class]] ? dic_data[@"value21"]:[NSArray array];
        }else if (number == 19){
            arr = [dic_data[@"value22"] isKindOfClass:[NSArray class]] ? dic_data[@"value22"]:[NSArray array];
        }
        for (NSDictionary *dict in arr) {
            reheight += 30;
            if ([dict[@"stdHotelInstitutionAmountDtos"]isKindOfClass:[NSArray class]]) {
                reheight += (50 * [dict[@"stdHotelInstitutionAmountDtos"] count]);
            }
        }
        return reheight;
    }else if (number == 20){
        NSArray *arr = [dic_data[@"value23"] isKindOfClass:[NSArray class]] ? dic_data[@"value23"]:[NSArray array];
        return arr.count * 50;
    }
    return reheight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = _arr_ShowData[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    view.backgroundColor = Color_White_Same_20;

    UIImageView *ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image = [UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor = Color_Blue_Important_20;
    [view addSubview:ImgView];

    UILabel *titleLabel= [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-15, 27) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dic[@"expenseCat"]],[NSString stringWithFormat:@"%@",dic[@"expenseType"]]] WithCompare:@"/"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:titleLabel];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
