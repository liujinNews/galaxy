//
//  AnnouncementLookController.m
//  galaxy
//
//  Created by hfk on 2018/2/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AnnouncementLookController.h"
#import "AnnouncementListModel.h"

@interface AnnouncementLookController ()<GPClientDelegate,UIScrollViewDelegate>

@property (nonatomic,assign)BOOL isSupport;
@property (nonatomic,strong)UIButton *Supportbtn;
@property (nonatomic,strong)UILabel *SupportLal;
/**
 查看数据
 */
@property (nonatomic,strong)AnnouncementListModel *EditFormData;

@end

@implementation AnnouncementLookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"公告详情", nil) backButton:YES];
    [self getIsSupport];
}
-(void)getIsSupport{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETNOTICESINFO];
    NSDictionary *parameters=@{@"Id":_str_LookId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _Supportbtn.userInteractionEnabled=YES;
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
        {
            if (![responceDic[@"result"]isKindOfClass:[NSNull class]]) {
                NSDictionary *dict=responceDic[@"result"];
                _EditFormData = [[AnnouncementListModel alloc]init];
                [_EditFormData setValuesForKeysWithDictionary:dict];
                _isSupport=[[NSString stringWithFormat:@"%@",_EditFormData.support]floatValue]==1?YES:NO;
                [self updateViews];
            }
        }
            break;
        case 1:
        {
            if ([responceDic[@"result"] floatValue]>0) {
                _isSupport=!_isSupport;
                [_Supportbtn setImage:[UIImage imageNamed:_isSupport?@"Work_Announcement_Support":@"Work_Announcement_UnSupport"] forState:UIControlStateNormal];
                if (_isSupport) {
                    _EditFormData.supportCount=[NSString stringWithFormat:@"%ld",[_EditFormData.supportCount integerValue]+1];
                }else{
                    if ([_EditFormData.supportCount integerValue]-1>0) {
                        _EditFormData.supportCount=[NSString stringWithFormat:@"%ld",[_EditFormData.supportCount integerValue]-1];
                    }else{
                        _EditFormData.supportCount=@"0";
                    }
                }
                _SupportLal.text=_EditFormData.supportCount;
            }
        }
            break;
        default:
            break;
    }
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    _Supportbtn.userInteractionEnabled=YES;
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)updateViews{
    
    UIScrollView *scrollView = UIScrollView.new;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *bottom=[[UIView alloc]init];
    bottom.backgroundColor=Color_form_TextFieldBackgroundColor;
    [scrollView addSubview:bottom];
    [bottom makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UILabel *subjectLal=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    subjectLal.numberOfLines=0;
    [bottom addSubview:subjectLal];
    NSString *subject=[NSString stringWithIdOnNO:_EditFormData.subject];
    NSInteger height=[self getLabelSizeHeightWithString:subject];
    subjectLal.text=subject;
    [subjectLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom);
        make.left.equalTo(bottom).offset(@12);
        make.right.equalTo(bottom).offset(@-12);
        make.height.equalTo(@(height));
    }];
    
    UILabel *timeLal=[GPUtils createLable:CGRectZero text:[GPUtils getSelectResultWithArray:@[_EditFormData.publishedDate,_EditFormData.author] WithCompare:@" "] font:Font_Same_12_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentLeft];
    [bottom addSubview:timeLal];
    [timeLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subjectLal.bottom);
        make.left.equalTo(bottom).offset(@12);
        make.right.equalTo(bottom).offset(@-12);
        make.height.equalTo(@14);
    }];
    
    
    UILabel *bodyLal=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    bodyLal.numberOfLines=0;
    [bottom addSubview:bodyLal];
    NSString *body=[NSString stringWithIdOnNO:_EditFormData.body];
    NSInteger height1=[self getLabelSizeHeightWithString:body];
    bodyLal.text=body;
    [bodyLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLal.bottom);
        make.left.equalTo(bottom).offset(@12);
        make.right.equalTo(bottom).offset(@-12);
        make.height.equalTo(@(height1));
    }];
    
    UIView *View_AttachImg=[[UIView alloc]init];
    [bottom addSubview:View_AttachImg];
    [View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyLal.bottom).offset(@10);
        make.left.width.equalTo(bottom);
        make.height.equalTo(@0);
    }];
    
    if ([NSString isEqualToNull:_EditFormData.attachment]) {
        NSMutableArray *arr_totalFileArray=[NSMutableArray array];
        NSMutableArray *arr_imagesArray=[NSMutableArray array];
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",_EditFormData.attachment]];
        for (NSDictionary *dict in array) {
            [arr_totalFileArray addObject:dict];
        }
        [GPUtils updateImageDataWithTotalArray:arr_totalFileArray WithImageArray:arr_imagesArray WithMaxCount:10];
        
        EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:View_AttachImg withEditStatus:2 withModel:nil];
        view.maxCount=10;
        [View_AttachImg addSubview:view];
        [view updateWithTotalArray:arr_totalFileArray WithImgArray:arr_imagesArray];
    }

    UIView *line=[[UIView alloc]init];
    line.backgroundColor=Color_GrayLight_Same_20;
    [bottom addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_AttachImg.bottom);
        make.left.equalTo(bottom).offset(@12);
        make.right.equalTo(bottom);
        make.height.equalTo(@0.5);
    }];

    UILabel *readCountLab=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [bottom addSubview:readCountLab];
    NSString *readCount=[GPUtils getSelectResultWithArray:@[Custing(@"阅读", nil),[NSNumber numberWithFloat:[_EditFormData.visitPplCount floatValue]>0?[_EditFormData.visitPplCount floatValue]:0]] WithCompare:@" "];
    readCountLab.text=readCount;
    NSInteger width=[self getLabelSizeWidthWithString:readCount];
    [readCountLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(@10);
        make.left.equalTo(bottom).offset(@12);
        make.size.equalTo(CGSizeMake(width, 20));
    }];
    
    
    
    _Supportbtn=[GPUtils createButton:CGRectZero action:@selector(SupportClick:) delegate:self];
    [_Supportbtn setImage:[UIImage imageNamed:_isSupport?@"Work_Announcement_Support":@"Work_Announcement_UnSupport"] forState:UIControlStateNormal];
    [bottom addSubview:_Supportbtn];
    [_Supportbtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom);
        make.left.equalTo(readCountLab.right);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    _SupportLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%ld",[_EditFormData.supportCount integerValue]>0?[_EditFormData.supportCount integerValue]:0] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [bottom addSubview:_SupportLal];
    [_SupportLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(@10);
        make.left.equalTo(self.Supportbtn.right);
        make.size.equalTo(CGSizeMake(100, 20));
    }];
    
    [bottom makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(readCountLab.bottom).offset(@15);
    }];
    
}
-(CGFloat)getLabelSizeHeightWithString:(NSString *)str{
    CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    return size.height+20;
}
-(CGFloat)getLabelSizeWidthWithString:(NSString *)str{
    CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    return size.width;
}

-(void)SupportClick:(UIButton *)btn{
    _Supportbtn.userInteractionEnabled=NO;
    NSString *url=[NSString stringWithFormat:@"%@",PRAISENOTICES];
    NSDictionary *parameters=@{@"Id":[NSString isEqualToNull:_EditFormData.Id]?[NSString stringWithFormat:@"%@",_EditFormData.Id]:@"0",@"SupportCount":_isSupport?@"-1":@"1"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
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
