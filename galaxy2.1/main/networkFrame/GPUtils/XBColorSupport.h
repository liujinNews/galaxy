//
//  XBColorSupport.h
//  galaxy
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XBColorSupport : NSObject

//适配暗黑模式  背景颜色
+ (UIColor *)supportBackGroundColorWithHString:(NSString *)hString;
//适配暗黑模式 labelColor
+ (UIColor *)supportFormTextFieldColorWithHString:(NSString *)hString;
//适配暗黑模式  FormTextFieldBackgroundColor
+ (UIColor *)supportFormTextFieldBackgroundColor;

//用于重要级文字信息、内页标题信息，如导航名称、大板块标题、类目名称等
+ (UIColor *)supportImportantTextColor;

//模块上的阴影颜色
+ (UIColor *)supportModuleShadowTextColor;
//用于普通级段落信息，如用户名、设置内标签文字信息
+ (UIColor *)supportOrdinaryParagraphTextColor;
//适配暗黑模式  UnselectedTabbarTitleColor
+ (UIColor *)supportUnselectedTabbarTitleColor;
//适配暗黑模式  TabbarBackgroundColor
+ (UIColor *)supportTabbarBackgroundColor;

//适配暗黑模式 separatorStyleColor
+ (UIColor *)supportSeparatorColor;

//#define Color_CellDark_Same_28       [GPUtils colorHString:@"#282828"]
+ (UIColor *)supportCellDarkSameWithStr:(NSString *)hString;

//模块上的淡蓝色阴影颜色
//#define Color_ClearBlue_Same_20       [GPUtils colorHString:@"#f2fbff"]
+ (UIColor *)supportClearBlueWithStr:(NSString *)hString;

//黑体  //[GPUtils colorHString:@"2d2d26"]
+ (UIColor *)supportBlackStyleColor;

//深灰色
+ (UIColor *)darkColor;
//浅灰色
+ (UIColor *)lightDarkColor;

//定制背景色
+ (UIColor *)customBackgroundColor;
//筛选模块
//[GPUtils colorHString:@"#eeeeee"]
+ (UIColor *)supportScreeningModuleColor;

//[11GPUtils colorHString:ColorBlack]  筛选列表
+ (UIColor *)supportScreenListColor;
//[UIColor colorWithWhite:0 alpha:0.6];
+ (UIColor *)supportBgAlpha;
//[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]
+ (UIColor *)supportimgLine;
//219 220 224
+ (UIColor *)supportLineColor;
//242 242 242
+ (UIColor *)supportImgView242Color;
// 85 85 85
+ (UIColor *)supportLab85Color;

//66 66 66
+ (UIColor *)supportLab66Color;
@end

NS_ASSUME_NONNULL_END
