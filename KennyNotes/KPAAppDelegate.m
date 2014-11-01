//
//  KPAAppDelegate.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAAppDelegate.h"
#import "KPAListViewController.h"
#import "FCModel/FCModel.h"
#import "KPAMainListViewController.h"
#import "KPAKit.h"

@implementation KPAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    [FCModel openDatabaseAtPath:[documentsPath stringByAppendingPathComponent:@"notesDB.sqlite3"] withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        [db beginTransaction];
        
        if (*schemaVersion < 1) {
            BOOL success = [db executeUpdate:@"CREATE TABLE KPANote (noteID INTEGER PRIMARY KEY, note TEXT, truncatedNote TEXT, encodedImageIDs TEXT, creationTime REAL, updatedTime REAL, isArchived INTEGER NOT NULL DEFAULT 0);"];
            
            if (!success) {
                [db rollback];
                // TODO
                NSLog(@"failed");
                return;
            }
            
            success = [db executeUpdate:@"CREATE TABLE KPATag (tagID INTEGER PRIMARY KEY, name TEXT NOT NULL);"];
            
            if (!success) {
                [db rollback];
                // TODO
                NSLog(@"failed");
                return;
            }
            
            success = [db executeUpdate:@"CREATE TABLE tagRegistry (tagID INTEGER, noteID INTEGER, isArchived INTEGER NOT NULL DEFAULT 0);"];

            if (!success) {
                [db rollback];
                // TODO
                NSLog(@"failed");
                return;
            }
            
            *schemaVersion = 1;
        }
        
        [db commit];
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    KPAMainListViewController *main = [[KPAMainListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:main];
    navController.view.autoresizesSubviews = YES;
    main.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    navController.navigationBar.tintColor = [UIColor kpa_systemBlue];
    
    [[KPAThemeController controller] themeViewController:main];
    
    [navController pushViewController:[[KPAListViewController alloc] initWithIsArchived:NO] animated:NO];
    
    [self.window setRootViewController:navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
