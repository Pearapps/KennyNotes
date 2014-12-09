//
//  KPATreeNode.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPATreeNode.h"

@interface KPATreeNode ()

@property (nonatomic, strong) NSMutableArray *childrenArray;

@end

@implementation KPATreeNode
@dynamic children, isLeaf;

+ (KPATreeNode *)treeNodeWithDataObject:(id)dataObject {
    return [[self alloc] initWithDataObject:dataObject];
}

+ (KPATreeNode *)treeNodeWithDataObject:(id)dataObject andParent:(KPATreeNode *)parent {
    return [[self alloc] initWithDataObject:dataObject andParent:parent];
}

- (instancetype)initWithDataObject:(id)dataObject {
    self = [super init];
    if (!self) { return nil; }
    self.dataObject = dataObject;
    return self;
}

- (instancetype)initWithDataObject:(id)dataObject andParent:(KPATreeNode *)parent {
    KPATreeNode *treeNode = [self initWithDataObject:dataObject];
    [parent addChild:treeNode];
    return treeNode;
}

- (void)addChild:(KPATreeNode *)node {
    if (self.requiresUniqueTreeNodes) { if ([self.children containsObject:node]) { return; } }
    node.parentNode = self;
    [[self childrenArray] addObject:node];
}

- (void)removeChild:(KPATreeNode *)node {
    [[self childrenArray] removeObject:node];
}

- (void)addChildren:(NSArray *)nodes {
    [nodes makeObjectsPerformSelector:@selector(setParentNode:) withObject:self];
    
    if (self.requiresUniqueTreeNodes) {
        for (KPATreeNode *node in nodes) {
            if (![self.children containsObject:node]) { [self.childrenArray addObject:node]; }
        }
        return;
    }
    
    [[self childrenArray] addObjectsFromArray:nodes];
}

- (void)sortChildrenWithComparator:(NSComparator)comparisonBlock {
    [_childrenArray sortUsingComparator:comparisonBlock];
}

- (void)removeChildren:(NSArray *)nodes {
    [[self childrenArray] removeObjectsInArray:nodes];
}

- (void)enumerateAllDescendingNodesWithBlock:(KPAObjectBlock)block {
    if (self.isLeaf) { return; }
    
    for (KPATreeNode *treeNode in _childrenArray) {
        block(treeNode);
        [treeNode enumerateAllDescendingNodesWithBlock:block];
    }
}

- (BOOL)isLeaf {
    return (!_childrenArray || _childrenArray.count == 0);
}

- (NSMutableArray *)childrenArray {
    if (!_childrenArray) {
        _childrenArray = [NSMutableArray new];
    }
    return _childrenArray;
}

- (NSArray *)children {
    return _childrenArray;
}

@end