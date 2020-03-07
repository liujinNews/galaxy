//
//  DetailProbleViewController.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "DetailProbleViewController.h"

@interface DetailProbleViewController ()<UIWebViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextView * aboutUSTV;


@end

@implementation DetailProbleViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"常见问题", nil) backButton:YES ];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSString * biaoti = [NSString stringWithFormat:@"%@",[self.detailDict objectForKey:@"question"]];
    NSString * neirong = [NSString stringWithFormat:@"%@",[self.detailDict objectForKey:@"answer"]];

    
    UIView * titleHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 10)];
    titleHeadView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:titleHeadView];
    
    UIView * titleleftView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 45, 25)];
    titleleftView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:titleleftView];
    UIImageView * titleIm = [[UIImageView alloc]initWithImage:GPImage(@"my_CProblems")];
    titleIm.frame = CGRectMake(15, 3, 19, 19);
    titleIm.backgroundColor = [UIColor clearColor];
    [titleleftView addSubview:titleIm];
    
    UIView * titleReightView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width-15, 20, 15, 25)];
    titleReightView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:titleReightView];
    
    UIView * titleFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, Main_Screen_Width, 10)];
    titleFootView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:titleFootView];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(45, 20, WIDTH(titleHeadView)-60, 25) text:biaoti font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:titleLbl];
    titleLbl.numberOfLines = 0;
    CGSize size1 = [biaoti sizeCalculateWithFont:titleLbl.font constrainedToSize:CGSizeMake(titleLbl.frame.size.width, 10000) lineBreakMode:titleLbl.lineBreakMode];
    NSInteger height1 = size1.height+5;

    if (height1>18.0f) {
        titleleftView.frame = CGRectMake(0, 20, 45, height1);
        titleReightView.frame = CGRectMake(Main_Screen_Width-15, 20, 15, height1);
        titleFootView.frame = CGRectMake(0, 20+height1, Main_Screen_Width, 10);
        titleLbl.frame = CGRectMake(45, 20, WIDTH(titleHeadView)-60, height1);
    }else{
        height1 = 25;
    }
    
    
    
    UILabel * emailLa = [GPUtils createLable:CGRectMake(45, 50+height1, WIDTH(titleHeadView)-60, 25) text:neirong font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    emailLa.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:emailLa];
    emailLa.numberOfLines=0;
    CGSize size2 = [neirong sizeCalculateWithFont:emailLa.font constrainedToSize:CGSizeMake(emailLa.frame.size.width, 10000) lineBreakMode:emailLa.lineBreakMode];
    NSInteger height2 = size2.height+5;
    
    if (![NSString isEqualToNull:neirong]){
        emailLa.text = @"";
    }else{
        emailLa.frame = CGRectMake(45, 50+height1, WIDTH(self.view)-60, 25);
        if (height2>18.0f) {
            emailLa.frame = CGRectMake(45, 50+height1, WIDTH(self.view)-60, height2);
            emailLa.textAlignment = NSTextAlignmentLeft;
        }else{
            height2 = 25;
        }
        
    }
    UIView * contenteHView = [[UIView alloc]initWithFrame:CGRectMake(0, 40+height1, Main_Screen_Width, 10)];
    contenteHView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:contenteHView];
    
    
    UIView * contenteView = [[UIView alloc]initWithFrame:CGRectMake(0, 50+height1, 45, height2)];
    contenteView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:contenteView];
    
    UIView * contenteFView = [[UIView alloc]initWithFrame:CGRectMake(0, 50+height1+height2, Main_Screen_Width, 10)];
    contenteFView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:contenteFView];
    
    UIView * contenteRView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width-15, 50+height1, 15, height2)];
    contenteRView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:contenteRView];
    
    UIImageView * aboutIm = [[UIImageView alloc]initWithImage:GPImage(@"my_CAnswer")];
    aboutIm.frame = CGRectMake(15, 3, 19, 19);
    aboutIm.backgroundColor = [UIColor clearColor];
    [contenteView addSubview:aboutIm];
    
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
