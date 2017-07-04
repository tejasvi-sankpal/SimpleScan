//
//  UIColor+UIColor_TPAdditions.m
//  Touchpoint
//
//  Created by vanee.virdi on 04/04/16.
//  Copyright © 2016 innoplexus. All rights reserved.
//

#import "UIColor+UIColor_TPAdditions.h"

@implementation UIColor (UIColor_TPAdditions)


//Black
+ (UIColor*)loginNavThemeColor{
    UIColor* navigationBarColor = [UIColor colorWithRed:(float)0/255 green:(float)128/255 blue:(float)128/255 alpha:1.0];
    //rgb 68 74 89
    
    return navigationBarColor;
}

//White
+ (UIColor*)loginNavTextColor{
    UIColor* loginNavTextColor = [UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:1.0];
    return loginNavTextColor;
}





@end


//UIColor* navigationBarColor = [UIColor colorWithRed:(float)/255 green:(float)/255 blue:(float)/255 alpha:1.0];
//return navigationBarColor;
