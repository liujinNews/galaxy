//
//  MessageViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MessageViewController.h"
#import "XFSegementView.h"
#import "PeopleIndexViewController.h"
#import "ConversationListViewController.h"


@interface MessageViewController ()<TouchLabelDelegate>

@property (nonatomic, strong) ConversationListViewController *messageindex;//消息视图控制器
@property (nonatomic, strong) PeopleIndexViewController *peopleindex;//联系人视图控制器
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
@property (nonatomic, assign) BOOL requestType;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestType = NO;
    if ([self.userdatas.companyId integerValue]==5850||![self.userdatas.arr_XBCode containsObject:@"AddressBook"]) {
        [self setTitle:Custing(@"消息", nil) backButton:NO];
        [self goToMessage];
    }else{
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(75, 0, Main_Screen_Width-150, 44)];
        _segementView.titleArray = @[Custing(@"消息", nil),Custing(@"通讯录",nil)];
        _segementView.titleFont = 16;
        if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType == 0) {
            _segementView.titleColor = Color_form_TextFieldBackgroundColor;
            [_segementView.scrollLine setBackgroundColor:Color_form_TextFieldBackgroundColor];
            _segementView.scrollLineColor = Color_Yellow_Weak_20;
            _segementView.titleSelectedColor = Color_Yellow_Weak_20;
        }else{
            [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
            _segementView.titleSelectedColor = Color_Blue_Important_20;
            if (self.userdatas.SystemType==1) {
                _segementView.titleColor = Color_form_TextFieldBackgroundColor;
                _segementView.titleSelectedColor = Color_form_TextFieldBackgroundColor;
                [_segementView.scrollLine setBackgroundColor:Color_form_TextFieldBackgroundColor];
            }
        }
        _segementView.touchDelegate = self;
        _segementView.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = _segementView;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self goToMessage];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userdatas.multCompanyId=@"0";
//    if (_requestType) {
//        if (_messageindex) {
////            [self goToMessage];
//            if (_segementView) {
//                [_segementView selectLabelWithIndex:0];
//            }
//        }else if(_peopleindex){
//            self.definesPresentationContext = YES;
////        [self goToPeople];
//            if (_segementView) {
//                [_segementView selectLabelWithIndex:1];
//            }
//        }
//    }
//    _requestType = YES;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 方法
//将联系人视图显示出来
-(void)goToPeople
{
    [self keyClose];
    if (_messageindex) {
        [_messageindex.view removeFromSuperview];
    }
    self.view.frame = CGRectMake(0, NavigationbarHeight, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49);
    if (!_peopleindex) {
        _peopleindex = [[PeopleIndexViewController alloc]init];
    }
    _peopleindex.view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49);
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.view addSubview:_peopleindex.view];
}

//将消息视图显示出来
-(void)goToMessage
{
    [self keyClose];
    if (_peopleindex) {
        [_peopleindex.view removeFromSuperview];
    }
    self.view.frame = CGRectMake(0, NavigationbarHeight, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49);
//    _navBarHairlineImageView.hidden = YES;
    if (!_messageindex) {
        _messageindex = [[ConversationListViewController alloc]init];
    }
    [self.navigationController.navigationBar setShadowImage:nil];
    _messageindex.view.frame =  CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49);
    [_messageindex requestGetMessageList];
    [self.view addSubview:_messageindex.view];
    
}

#pragma mark - 代理
-(void)touchLabelWithIndex:(NSInteger)index
{
    [self keyClose];
    if (index == 1) {
        [self goToPeople];
    }else{
        [self goToMessage];
    }

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
