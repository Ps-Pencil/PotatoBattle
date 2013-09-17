//
//  AIScene.h
//  PotatoBattle-coco
//
//  Created by pspencil on 16/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Result.h"
@interface AIScene : CCLayer {
    NSMutableArray *Positions, *Hits, *OtherPositions, *OtherHits;
    int numOfHits;
}
+(CCScene*) sceneWithPositions: (NSMutableArray* ) positions andHits: (NSMutableArray*) hits andOtherPositions: (NSMutableArray*)otherPositions andOtherHits: (NSMutableArray*) otherHits;
@end
