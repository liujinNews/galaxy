//
//  EditTypeInfoViewController.m
//  galaxy
//
//  Created by hfk on 2019/5/27.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "EditTypeInfoViewController.h"
#import "costCenterData.h"

@interface EditTypeInfoViewController ()<GPClientDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSString *type;

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;

@property (nonatomic, strong) UITextField *txf_type;
@property (nonatomic, strong) UITextField *txf_typeEn;


@end

@implementation EditTypeInfoViewController

-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(Save:)];
    [self createBaseView];
   if ([self.type isEqualToString:@"travelType"]){
       [self createTravelTypeView];
       if (self.EditInfo && [self.EditInfo isKindOfClass:[costCenterData class]]) {
           costCenterData *model = (costCenterData *)self.EditInfo;
           [self setTitle:Custing(@"修改出差类型", nil) backButton:YES ];
           _txf_type.text = [NSString stringWithIdOnNO:model.travelType];
           _txf_typeEn.text = [NSString stringWithIdOnNO:model.travelTypeEn];
       }else{
           [self setTitle:Custing(@"新增出差类型", nil) backButton:YES ];

       }
    }

}
-(void)createBaseView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

-(void)createTravelTypeView{
    
    UIView *TypeView = [[UIView alloc]init];
    TypeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:TypeView];
    [TypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_type = [[UITextField alloc]init];
    [TypeView addSubview:[[SubmitFormView alloc]initBaseView:TypeView WithContent:_txf_type WithFormType: formViewEnterText WithSegmentType:lineViewNone WithString:Custing(@"出差类型", nil) WithInfodict:nil WithTips:Custing(@"请输入出差类型", nil) WithNumLimit:20]];
    
    UIView *TypeEnView = [[UIView alloc]init];
    TypeEnView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:TypeEnView];
    [TypeEnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TypeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_typeEn =[[UITextField alloc]init];
    [TypeEnView addSubview:[[SubmitFormView alloc]initBaseView:TypeEnView WithContent:_txf_typeEn WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"出差类型英文", nil) WithInfodict:nil WithTips:Custing(@"请输入出差类型英文", nil) WithNumLimit:200]];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(TypeEnView.bottom);
    }];
}

-(void)Save:(UIButton *)btn{
    [self keyClose];
    if ([self.type isEqualToString:@"travelType"]){
        if (self.txf_type.text.length <= 0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入出差类型名称", nil)];
            return;
        }
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"TravelType":self.txf_type.text,
                                                                                    @"TravelTypeEn":_txf_typeEn.text
                                                                                    
                                                                                    }];
        if (self.EditInfo && [self.EditInfo isKindOfClass:[costCenterData class]]) {
            costCenterData *model = (costCenterData *)self.EditInfo;
            [dict setObject:model.idd forKey:@"id"];
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",TRAVELTYPEUPDATE] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
        }else{
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",TRAVELTYPEADD] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
        }
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"新增成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
