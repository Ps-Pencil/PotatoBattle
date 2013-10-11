//
//  CombatScene.h
//  PotatoBattle-coco
//
//  Created by pspencil on 7/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Result.h"
@interface CombatScene : CCLayerColor {
    bool fired1[10][10], fired2[10][10];
    int config1[10][10], config2[10][10];
    int numOfHits;
    CCSprite* cellCover;
    NSMutableArray* prev;
    NSMutableArray* rects;
    NSMutableArray* otherpos;
    NSMutableArray* otherhits;
    CCMenuItemSprite* goBtn;
    CCLabelTTF* proceedText;
    
}
+ (CCScene *) sceneWithParameters: (NSMutableArray *)positions andHits:(NSMutableArray *)hits andOtherPositions: (NSMutableArray* )otherPositions andOtherHits: (NSMutableArray*) otherHits;
@end
