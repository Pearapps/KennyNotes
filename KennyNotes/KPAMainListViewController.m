//
//  KPAMainListViewController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/25/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAMainListViewController.h"
#import "KPAListViewController.h"
#import "MSCellAccessory.h"
#import "KPASettingsViewController.h"
#import "KPAKit.h"
#import "KPATag.h"
#import "KPATagController.h"
#import "KPATagCacheController.h"

@interface KPAMainListViewController ()

@property (nonatomic, strong) KPATagCacheController *cacheController;

@end

@implementation KPAMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cacheController = [KPATagCacheController new];
    self.tableView.separatorColor = [UIColor grayColor];
    self.title = @"KennyNotes";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor kpa_systemBlue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetTheme:) name:KPADidSetThemeNotificationName object:nil];
    [[KPAThemeController controller] themeViewController:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cacheController clear];
    [self.tableView reloadData];
}

- (void)didSetTheme:(id)notification {
    [[KPAThemeController controller] themeViewController:self];
    [[self tableView] reloadData];
}

- (void)settings {
    KPASettingsViewController *settings = [[KPASettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:settings] animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) { return YES; }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSNumber *tagID = [self.cacheController allTagIDs][indexPath.row];
        KPATag *tagToDelete = [KPATag instanceWithPrimaryKey:tagID];
        [[KPATagController controller] removeAndDeleteTagFromAllNotes:tagToDelete];
        [self.cacheController clear];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadSectionIndexTitles];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) { return [self.cacheController allTagIDs].count; }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if ([self.cacheController allTagIDs].count == 0) { // We don't want title if not enough tags
            return @"";
        }
        return @"Tags";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.selectedBackgroundView.backgroundColor = [[KPAThemeController controller] currentCellSelectionColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [[KPAThemeController controller] currentCellColor];
    
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [self colorOfTitleTextAtIndexPath:indexPath];
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[self colorOfTitleTextAtIndexPath:indexPath]];
        [[cell textLabel] setText:[self titleOfCellForIndexPath:indexPath]];
    } else {
        NSNumber *tagID = [self.cacheController allTagIDs][indexPath.row];
        
        KPATag *t = [KPATag instanceWithPrimaryKey:tagID];
        
        [[cell textLabel] setText:t.name];
        cell.textLabel.textColor = [[KPAThemeController controller] currentCellTextColor];
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[[KPAThemeController controller] currentCellTextColor]];
    }
    
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (indexPath.section > 0) {
        [self.navigationController pushViewController:[[KPAListViewController alloc] initWithTag:[KPATag instanceWithPrimaryKey:[self.cacheController allTagIDs][indexPath.row]]] animated:YES];
    } else {
        [self.navigationController pushViewController:[[KPAListViewController alloc] initWithIsArchived:(indexPath.row == 1)] animated:YES];
    }
}

- (NSString *)titleOfCellForIndexPath:(NSIndexPath *)path {
    if (path.row == 0) {
        return @"All Notes";
    } else {
        return @"Archived";
    }
}

- (UIColor *)colorOfTitleTextAtIndexPath:(NSIndexPath *)path {
    if (path.row == 0) {
        return [UIColor greenColor];
    } else {
        return [UIColor orangeColor];
    }
}

@end