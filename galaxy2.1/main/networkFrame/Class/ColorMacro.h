//
//  ColorMacro.h
//  MyDemo
//
//  Created by wilderliao on 15/10/23.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#ifndef MyDemo_ColorMacro_h
#define MyDemo_ColorMacro_h

#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_Font_Lightgray  0x999999

#endif
