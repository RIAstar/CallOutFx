package net.riastar.components {

import flash.geom.ColorTransform;
import flash.geom.Point;

import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.utils.PopUpUtil;

import spark.components.SkinnablePopUpContainer;


use namespace mx_internal;


public class CallOut extends SkinnablePopUpContainer {

    [SkinPart(required="false")]
    public var arrow:IVisualElement;

    override public function updatePopUpPosition():void {
        if (!owner || !systemManager) return;

        var position:Point = calculatePopUpPosition();
        var ownerComponent:UIComponent = owner as UIComponent;
        var color:ColorTransform = ownerComponent ? ownerComponent.$transform.concatenatedColorTransform : null;

        PopUpUtil.applyPopUpTransform(owner, color, systemManager, this, position);
    }

    protected function calculatePopUpPosition():Point {
        //start from owner's global position
        var pos:Point = owner.parent.localToGlobal(new Point(owner.x, owner.y));

        pos.x += owner.width / 2 - width / 2;
        pos.y += owner.height;

        return pos;
    }

}
}
