//
//  AppDelegate.m
//  iThunderLiXian
//
//  Created by Martian on 12-7-6.
//  Copyright (c) 2012年 Martian. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    python_task = [[NSTask alloc] init];
    [python_task setLaunchPath:@"/usr/bin/python"];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];    
    [python_task setArguments:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@/XunleiAPI/api_mini.py", resourcesPath]]];
    [python_task launch];
    
    main_view = [[MainView alloc] initWithWindowNibName:@"MainView"];
    [main_view showWindow:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *check_update = [RequestSender sendRequest:@"http://api.4321.la/analytics-thunder.php?ver=20120724"];
        dispatch_async( dispatch_get_main_queue(), ^{
            if ([check_update hasPrefix:@"Update"]) {
                [[NSAlert alertWithMessageText:@"更新" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"软件检测到新版本的发布，请从软件中运行“自动更新”以更新软件。"] runModal];
            }
        });
    });
}

- (BOOL) applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (!flag)
    {
		[main_view.window makeKeyAndOrderFront:self];
	}
	return YES;
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    [python_task terminate];
    
    //KILLALL ARIA2C
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObject:@"aria2c"]];
    [task launch];
    [task waitUntilExit];
}
@end
