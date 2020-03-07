//
//  TravelMainController.m
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelMainController.h"
#import "TravelMainModel.h"
#import "TravelMainCateCell.h"
#import "TravelMainCollHead.h"
#import "TravelBannerView.h"
#import "hotelVController.h"
#import "CtripMainController.h"
#import "JDWebViewController.h"
#import "CtripDetailListController.h"
#import "CtripHelpController.h"
#import "TravelReqFormController.h"
#import "DiDiOrderController.h"
#import "TravelOneController.h"
#import "DiDiTravelOrderController.h"
#import "HZHotelWebViewController.h"
#import "ByCarOrderController.h"

static NSString *const CellIdentifier = @"TravelMainCateCell";
static NSString *const HeadViewIdentifier = @"TravelMainCollHead";
@interface TravelMainController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GPClientDelegate>
@property (nonatomic,strong)TravelMainModel *model;
/**
 *  网格视图
 */
@property(nonatomic,strong)UICollectionView *collView;
/**
 *  网格规则
 */
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
/**
 *  网格cell
 */
@property(nonatomic,strong)TravelMainCateCell *cell;
//Banner
@property (strong, nonatomic) TravelBannerView *myBannersView;

@end

@implementation TravelMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"差旅", nil) backButton:NO];
    _model = [[TravelMainModel alloc]init];
    [TravelMainModel getShowModel:_model];
    [self createCollectionView];
}
//进入界面启动定时
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        self.navigationController.navigationBar.translucent = YES;
    }
    [self getCtripSetting];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)createCollectionView{
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
    }
    _layOut.minimumInteritemSpacing =0;
    _layOut.minimumLineSpacing =0;
    
    if (!_collView) {
        _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layOut];
    }
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.alwaysBounceVertical=YES;
    _collView.showsVerticalScrollIndicator = NO;
    _collView.backgroundColor =Color_White_Same_20;
    [_collView registerClass:[TravelMainCateCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collView registerClass:[TravelMainCollHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier];
    [self.view addSubview:_collView];
    [_collView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(iPhoneX ? @-83:@ -49);
    }];
    
}

//MARK:获取差旅设置
-(void)getCtripSetting{
    NSString *url=[NSString stringWithFormat:@"%@",GetCtripSetting];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
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
        {
            if ([responceDic[@"result"]isKindOfClass:[NSNull class]]) {
                self.userdatas.str_RelateTravelForm = @"0";
            }else{
                self.userdatas.str_RelateTravelForm=[[NSString stringWithFormat:@"%@",responceDic[@"result"][@"relateTravelForm"]]isEqualToString:@"1"]?@"1":@"0";
            }
            [TravelMainModel getShowModel:_model];
            [_collView reloadData];
        }
            break;
        default:
            break;
    }
}


//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Main_Screen_Width/3, 105);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size;
    if (section==0) {
        size=CGSizeMake(Main_Screen_Width, Main_Screen_Width*0.4+40);
    }else{
        size=CGSizeMake(Main_Screen_Width, 40);
    }
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        TravelMainCollHead *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        if (indexPath.section==0) {
            if (!_myBannersView) {
                _myBannersView = [TravelBannerView new];
                _myBannersView.tapActionBlock = ^(NSInteger index, NSDictionary *dict) {
                    if (dict) {
                        if ([weakSelf respondsToSelector:NSSelectorFromString(dict[@"action"])]) {
                            [weakSelf performSelector:NSSelectorFromString(dict[@"action"]) withObject:nil afterDelay:0];
                        }
                    }
                };
            }
            [headView configHeadViewWithDict:_model.titleArray[indexPath.section] WithView:_myBannersView];
            _myBannersView.curBannerList = _model.bannerArray;
            
        }else{
            [headView configHeadViewWithDict:_model.titleArray[indexPath.section]];
        }
        headView.RightBtnClickedBlock=^(NSString *str){
            [weakSelf LookDetail:str];
        };
        
        return headView;
    }else{
        return [[UICollectionReusableView alloc]init];
    }
}

#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _model.IconArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array=_model.IconArray[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict=_model.IconArray[indexPath.section][indexPath.row];
    [_cell configCollectCellWithDict:dict];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=_model.IconArray[indexPath.section][indexPath.row];
    if ([self respondsToSelector:NSSelectorFromString(dict[@"action"])]) {
        [self performSelector:NSSelectorFromString(dict[@"action"]) withObject:nil afterDelay:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        if (scrollView.contentOffset.y<=NavigationbarHeight) {
            scrollView.bounces = NO;
        }else{
            scrollView.bounces = YES;
        }
        CGFloat offset = scrollView.contentOffset.y;
        if (offset > -64) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Festival_NavBar"] forBarMetrics:UIBarMetricsDefault] ;
            //                [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            //                [self.navigationController.navigationBar setTranslucent:NO];
            self.tabBarController.navigationController.hidesBarsOnSwipe = YES;
            self.tabBarController.navigationController.navigationBar.alpha = fabs(offset)/80 *1.0;
            if (fabs(offset)/80 *1.0 >=1) {
                self.navigationController.navigationBar.translucent = NO;
            }else{
                self.navigationController.navigationBar.translucent = YES;
            }
        }
        else{
            self.navigationController.navigationBar.translucent = YES;
            //                [self.navigationController.navigationBar setTranslucent:YES];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.tabBarController.navigationController.navigationBar.alpha = 0.0;
        }
    }
}

//MARK:查看订单详情
-(void)LookDetail:(NSString *)str{
    if ([str isEqualToString:Custing(@"滴滴出行单", nil)]){
        DiDiTravelOrderController *vc = [[DiDiTravelOrderController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:Custing(@"我的订单", nil)]) {
        CtripDetailListController *vc=[[CtripDetailListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:Custing(@"出差需求单", nil)]){
        TravelReqFormController *vc=[[TravelReqFormController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:Custing(@"出行需求", nil)]){
        ByCarOrderController *vc = [[ByCarOrderController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//MARK:collection点击
//携程机票
-(void)GotoCtripFlight{
    if ([self.userdatas.arr_XBCode containsObject:@"Ctrip"]) {
        CtripMainController * Ctrip = [[CtripMainController alloc]initWithType:@"FlightSearch"];
        [self.navigationController pushViewController:Ctrip animated:YES];
    }
}
//携程酒店
-(void)GotoCtripHotel{
    if ([self.userdatas.arr_XBCode containsObject:@"Ctrip"]) {
        CtripMainController * Ctrip = [[CtripMainController alloc]initWithType:@"HotelSearch"];
        [self.navigationController pushViewController:Ctrip animated:YES];
    }
}
//携程火车票
-(void)GotoCtripTrain{
    CtripMainController * Ctrip = [[CtripMainController alloc]initWithType:@"TrainSearch"];
    [self.navigationController pushViewController:Ctrip animated:YES];
}
-(void)GotoCtripBus{
    CtripMainController * Ctrip = [[CtripMainController alloc]initWithType:@"CarSearch"];
    [self.navigationController pushViewController:Ctrip animated:YES];
}
-(void)GotoCtripHelp{
    CtripHelpController *vc=[[CtripHelpController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:滴滴
-(void)GotoDiDi{
    DiDiOrderController *vc = [[DiDiOrderController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:机票
- (void)GoToPlane{
    TravelOneController *vc = [[TravelOneController alloc] init];
    vc.type = @"10";
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:酒店
- (void)GoToHotel{
    TravelOneController *vc = [[TravelOneController alloc] init];
    vc.type = @"4";
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:火车票
- (void)GoToTrain{
    TravelOneController *vc = [[TravelOneController alloc] init];
    vc.type = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:用车
- (void)GoToCar{
    TravelOneController *vc = [[TravelOneController alloc] init];
    vc.type = @"20";
    [self.navigationController pushViewController:vc animated:YES];
}

//华住酒店
-(void)GotoHuazhuHotel{
    if ([self.userdatas.arr_XBCode containsObject:@"HuaZhu"]) {
        hotelVController * hotel = [[hotelVController alloc]init];
        [self.navigationController pushViewController:hotel animated:YES];
//        HZHotelWebViewController * hotel = [[HZHotelWebViewController alloc]init];
//        [self.navigationController pushViewController:hotel animated:YES];
    }
}
//电脑办公
-(void)GotoJDoffice{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 1;
    [self.navigationController pushViewController:jd animated:YES];
}
//文具耗材
-(void)GotoJDstationery{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 2;
    [self.navigationController pushViewController:jd animated:YES];
}
//家用电器
-(void)GotoJDelectric{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 3;
    [self.navigationController pushViewController:jd animated:YES];
}
//手机数码
-(void)GotoJDdigital{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 4;
    [self.navigationController pushViewController:jd animated:YES];
}
//图书
-(void)GotoJDbook{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 5;
    [self.navigationController pushViewController:jd animated:YES];
}
//更多
-(void)GotoJDmore{
    JDWebViewController *jd = [[JDWebViewController alloc]init];
    jd.type = 6;
    [self.navigationController pushViewController:jd animated:YES];
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
