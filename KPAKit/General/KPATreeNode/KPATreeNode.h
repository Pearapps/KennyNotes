//
//  KPATreeNode.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPAKitDefinitions.h"

@interface KPATreeNode : NSObject

+ (KPATreeNode *)treeNodeWithDataObject:(id)dataObject andParent:(KPATreeNode *)parent;
+ (KPATreeNode *)treeNodeWithDataObject:(id)dataObject;

- (instancetype)initWithDataObject:(id)dataObject andParent:(KPATreeNode *)parent;
- (instancetype)initWithDataObject:(id)dataObject;

- (void)addChild:(KPATreeNode *)node;
- (void)removeChild:(KPATreeNode *)node;

- (void)addChildren:(NSArray *)nodes;
- (void)removeChildren:(NSArray *)nodes;

- (void)enumerateAllDescendingNodesWithBlock:(KPAObjectBlock)block;

- (void)sortChildrenWithComparator:(NSComparator)comparisonBlock;

@property (nonatomic, weak) KPATreeNode *parentNode;
@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, strong) id dataObject;

@property (nonatomic, readonly) BOOL isLeaf;

@property (nonatomic, assign) BOOL requiresUniqueTreeNodes;

@end
