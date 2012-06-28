//
//  BSViewController.m
//  testMobileInstallationInstall
//
//  Created by Kryhear  on 12-6-28.
//  Copyright (c) 2012年 Q2Q Corp. All rights reserved.
//

#import "BSViewController.h"
#import "SVProgressHUD.h"
#include <dlfcn.h>
@implementation BSViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[self view] setBackgroundColor:[UIColor blackColor]];
    //本测试在模拟器和真机设备（JB）均可成功安装
    //模拟器的MobileInstallation大概路径应该是
    //"/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation"
    //但是由于缺乏访问权限，测试时已经将MobileInstallation拷贝在资源文件中，另外模拟器测试时用app_simulator.ipa，真机用app.ipa
    if ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Simulator"]) {
        [SVProgressHUD showInView:self.view status:@"模拟器安装中..."];
        [self InstallIPA:[[NSBundle mainBundle] pathForResource:@"HelloIPA_simulator" ofType:@"ipa"] MobileInstallionPath:[[NSBundle mainBundle] pathForResource:@"MobileInstallation" ofType:@""]];
    }
    else {
        [SVProgressHUD showInView:self.view status:@"真机安装中..."];
        [self InstallIPA:[[NSBundle mainBundle] pathForResource:@"HelloIPA" ofType:@"ipa"] MobileInstallionPath:@"/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation"];
    }
    
    UILabel *helloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [helloLabel setText:@"Hello, ZXZY!"];
    [helloLabel setBackgroundColor:[UIColor blackColor]];
    [helloLabel setTextColor:[UIColor redColor]];
    [helloLabel setTextAlignment:UITextAlignmentCenter];
    [helloLabel setFont:[UIFont boldSystemFontOfSize:47]];
    [helloLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:helloLabel];
    [helloLabel release];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoBtn setFrame:CGRectMake(270, 410, 50, 50)];
    [infoBtn addTarget:self action:@selector(showInfo) forControlEvents:64];
    [infoBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:infoBtn];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)showInfo {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"关于本程序" message:@"用于测试MobileInstall安装IPA。\n任 何 建 议 疑 问 联 系\nkryhear@me.com\nkryhear.github.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

-(BOOL)InstallIPA:(NSString *)ipaPath MobileInstallionPath:(NSString *)frameworkPath
{
    void *lib = dlopen([frameworkPath UTF8String], RTLD_LAZY);
    if (lib)
    {
        MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        if (pMobileInstallationInstall)
        {
            NSString* temp = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"Temp_" stringByAppendingString:ipaPath.lastPathComponent]];
            if (![[NSFileManager defaultManager] copyItemAtPath:ipaPath toPath:temp error:nil]) {
                [self showAlertMessage:@"检查要安装的IPA路径是否正确!" Title:@"复制IPA文件失败"];
                [SVProgressHUD dismiss];
                return NO;
            }
            int ret = pMobileInstallationInstall(temp, [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"], 0, ipaPath);
            [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
            if (ret == 0)   {
                [self showAlertMessage:@"请退出桌面确定是否有个HelloIPA的程序！" Title:@"安装成功"];
                [SVProgressHUD dismiss];
                return YES;
            }
            else {
                [self showAlertMessage:@"若为真机，确定该设备已经jailbreak！" Title:@"安装失败"];
                [SVProgressHUD dismiss];
                return NO;
            }
        }
    }
    else {
        [self showAlertMessage:@"检查MobileInstallation.framework路径是否正确！" Title:@"无法连接到MobileInstallation"];
        [SVProgressHUD dismiss];
        return NO;
    }
    return NO;
}

- (void)showAlertMessage:(NSString *)msg Title:(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
