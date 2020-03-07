//
//  XBColorSupport.m
//  galaxy
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "XBColorSupport.h"

@implementation XBColorSupport



//适配暗黑模式  背景颜色
+ (UIColor *)supportBackGroundColorWithHString:(NSString *)hString{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#101006"];
            }else{
                return [GPUtils colorHString:hString];
            }
        }];
        return color;
    } else {
        // Fallback on earlier versions
        return [GPUtils colorHString:hString];
    }
}
//适配暗黑模式 FormTextFieldColor
+ (UIColor *)supportFormTextFieldColorWithHString:(NSString *)hString{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor labelColor];
            }else{
                return [GPUtils colorHString:hString];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:hString];
    }
}
//适配暗黑模式  FormTextFieldBackgroundColor
+ (UIColor *)supportFormTextFieldBackgroundColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#1c1c1e"];
            }else{
                return [UIColor whiteColor];
            }
        }];
        return color;
    }else{
        return [UIColor whiteColor];
    }
}

//用于重要级文字信息、内页标题信息，如导航名称、大板块标题、类目名称等
+ (UIColor *)supportImportantTextColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#e7e7e7"];
            }else{
                return [GPUtils colorHString:@"#282828"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#282828"];
    }
}



//模块上的阴影颜色  [GPUtils colorHString:@"#cccccc"]
+ (UIColor *)supportModuleShadowTextColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#333333"];
            }else{
                return [GPUtils colorHString:@"#cccccc"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#cccccc"];
    }
}


//用于普通级段落信息，如用户名、设置内标签文字信息
+ (UIColor *)supportOrdinaryParagraphTextColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#666666"];
            }else{
                return [GPUtils colorHString:@"#999999"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#999999"];
    }
}

//适配暗黑模式  UnselectedTabbarTitleColor
+ (UIColor *)supportUnselectedTabbarTitleColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#e7e7e7"];
            }else{
                return [UIColor blackColor];
            }
        }];
        return color;
    }else{
        return [UIColor blackColor];
    }
}
//适配暗黑模式  TabbarBackgroundColor
+ (UIColor *)supportTabbarBackgroundColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#1c1c1e"];
            }else{
                return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            }
        }];
        return color;
    }else{
        return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
}
//separatorStyleColor
+ (UIColor *)supportSeparatorColor{
    if (@available(iOS 13.0, *)) {
          UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                  return [GPUtils colorHString:@"#3d3c41"];
              }else{
                  return [GPUtils colorHString:@"#dddddd"];
              }
          }];
          return color;
      }else{
          return [GPUtils colorHString:@"#dddddd"];
      }
}

//#define Color_CellDark_Same_28       [GPUtils colorHString:@"#282828"]
+ (UIColor *)supportCellDarkSameWithStr:(NSString *)hString{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#e7e7e7"];
            }else{
                return [GPUtils colorHString:@"#282828"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#282828"];
    }
}

//模块上的淡蓝色阴影颜色
//#define Color_ClearBlue_Same_20       [GPUtils colorHString:@"#f2fbff"]
+ (UIColor *)supportClearBlueWithStr:(NSString *)hString{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#0d0400"];
            }else{
                return [GPUtils colorHString:@"#f2fbff"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#f2fbff"];
    }
}
//黑体  //[GPUtils colorHString:@"2d2d26"]
+ (UIColor *)supportBlackStyleColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#e2e2d9"];
            }else{
                return [GPUtils colorHString:@"#1d1d26"];
            }
        }];
        return color;
    }else{
        return [GPUtils colorHString:@"#1d1d26"];
    }
}

+ (UIColor *)darkColor{
    if (@available(iOS 13.0, *)) {
           UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return [UIColor whiteColor];
               }else{
                   return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
               }
           }];
           return color;
       }else{
           return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
       }
}
//浅灰色
+ (UIColor *)lightDarkColor{
    if (@available(iOS 13.0, *)) {
           UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
               }else{
                   return [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
               }
           }];
           return color;
       }else{
           return [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
       }
}
//定制背景色
+ (UIColor *)customBackgroundColor{
    if (@available(iOS 13.0, *)) {
           UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return [UIColor blackColor];
               }else{
                   return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1];
               }
           }];
           return color;
       }else{
           return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1];
       }
}

//筛选模块
//[GPUtils colorHString:@"#eeeeee"]
+ (UIColor *)supportScreeningModuleColor{
    if (@available(iOS 13.0, *)) {
              UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                  if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                      return [GPUtils colorHString:@"#2d2d2f"];
                  }else{
                      return [GPUtils colorHString:@"#eeeeee"];
                  }
              }];
              return color;
          }else{
              return [GPUtils colorHString:@"#eeeeee"];
          }
}

//[GPUtils colorHString:ColorBlack]  筛选列表
+ (UIColor *)supportScreenListColor{
    if (@available(iOS 13.0, *)) {
                 UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                     if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                         return [UIColor whiteColor];
                     }else{
                         return [GPUtils colorHString:@"#1d1d26"];
                     }
                 }];
                 return color;
             }else{
                 return [GPUtils colorHString:@"#1d1d26"];
             }
}
//[UIColor colorWithWhite:0 alpha:0.6];
+ (UIColor *)supportBgAlpha{
    if (@available(iOS 13.0, *)) {
                    UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                            return [UIColor colorWithWhite:1 alpha:0];
                        }else{
                            return [UIColor whiteColor];
                        }
                    }];
                    return color;
                }else{
                    return [UIColor whiteColor];
                }
}
//[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]
+ (UIColor *)supportimgLine{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [GPUtils colorHString:@"#3d3c41"];
                
            }else{
                return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
                
            }
            
        }];
        return color;
        
    }else{
        return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        
    }
}


//219 220 224
+ (UIColor *)supportLineColor{
    if (@available(iOS 13.0, *)) {
          UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                  return [UIColor blackColor];
                  
              }else{
                  return [UIColor colorWithRed:219/255.0 green:220/255.0 blue:224/255.0 alpha:1];
                  
              }
              
          }];
          return color;
          
      }else{
          return [UIColor colorWithRed:219/255.0 green:220/255.0 blue:224/255.0 alpha:1];
          
      }
}
//242 242 242
+ (UIColor *)supportImgView242Color{
    if (@available(iOS 13.0, *)) {
          UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                  return [GPUtils colorHString:@"#1c1c1e"];
                  
              }else{
                  return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
                  
              }
              
          }];
          return color;
          
      }else{
          return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
          
      }
}
// 85 85 85
+ (UIColor *)supportLab85Color{
    if (@available(iOS 13.0, *)) {
          UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                  return [UIColor whiteColor];
                  
              }else{
                  return [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                  
              }
              
          }];
          return color;
          
      }else{
          return [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
          
      }
}
//66 66 66
+ (UIColor *)supportLab66Color{
    if (@available(iOS 13.0, *)) {
          UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
              if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                  return [UIColor whiteColor];
                  
              }else{
                  return [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
                  
              }
              
          }];
          return color;
          
      }else{
          return [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
          
      }
}
@end
