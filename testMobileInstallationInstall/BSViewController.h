//
//  BSViewController.h
//  testMobileInstallationInstall
//
//  Created by Kryhear  on 12-6-28.
//  Copyright (c) 2012年 Q2Q Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSViewController : UIViewController
- (void)showAlertMessage:(NSString *)msg Title:(NSString *)title;
- (BOOL)InstallIPA:(NSString *)ipaPath MobileInstallionPath:(NSString *)frameworkPath;
    // ipaPath是要安装的IPA包路径
    // frameworkPath是MobileInstallion的路径
    // 一般来说Mac OSX应该是/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation
    // 真机设备则是/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation
typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *backpath);
@end
