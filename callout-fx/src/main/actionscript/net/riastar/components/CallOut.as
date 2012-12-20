package net.riastar.components {

import flash.geom.ColorTransform;
import flash.geom.Point;

import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.utils.PopUpUtil;

import spark.components.SkinnablePopUpContainer;


use namespace mx_internal;

/**
 * A Flex/Spark CallOut for web or desktop applications
 *
 * @author RIAstar
 */
public class CallOut extends SkinnablePopUpContainer {

    /* ----------------- */
    /* --- skinparts --- */
    /* ----------------- */

    [SkinPart(required="false")]
    /**
     * An optional visual element that links the CallOut visually to its owner.
     */
    public var arrow:IVisualElement;


    /* ----------------- */
    /* --- behaviour --- */
    /* ----------------- */

    /**
     * Implements SkinnablePopUpContainer's "abstract" method.
     *
     * @private
     */
    override public function updatePopUpPosition():void {
        if (!owner || !systemManager) return;

        var position:Point = calculatePopUpPosition();
        var ownerComponent:UIComponent = owner as UIComponent;
        var color:ColorTransform = ownerComponent ? ownerComponent.$transform.concatenatedColorTransform : null;

        PopUpUtil.applyPopUpTransform(owner, color, systemManager, this, position);
    }

    /**
     * Calculates the CallOut's global position.
     * By default the CallOut is positioned below and horizontally centered to its owner.
     *
     * @return The CallOut's position.
     */
    protected function calculatePopUpPosition():Point {
        //start from owner's global position
        var pos:Point = owner.parent.localToGlobal(new Point(owner.x, owner.y));

        pos.x += owner.width / 2 - width / 2;
        pos.y += owner.height;

        return pos;
    }

}
}
