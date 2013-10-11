//
//  PlayScene.h
//  PotatoBattle-coco
//
//  Created by pspencil on 6/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayScene : CCLayerColor {
    bool dragged;
    CCSprite* selSprite;
    float scale;
    CCSprite* state;
    CCLabelTTF* words;
}
+(CCScene *) scene;
@end
