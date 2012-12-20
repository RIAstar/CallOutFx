package net.riastar.components {

import flash.events.Event;
import flash.events.MouseEvent;

import mx.core.ClassFactory;
import mx.core.IFactory;

import net.riastar.components.supportClasses.IDropDownContainer;

import spark.components.Button;
import spark.components.supportClasses.DropDownController;
import spark.events.DropDownEvent;
import spark.events.PopUpEvent;
import spark.layouts.supportClasses.LayoutBase;


/**
 * Dispatched when the CallOut is opened.
 */
[Event(name="open", type="spark.events.DropDownEvent")]

/**
 * Dispatched when the CallOut is closed.
 */
[Event(name="close", type="spark.events.DropDownEvent")]


[DefaultProperty("calloutContent")]

/**
 * A Flex/Spark CallOutButton for web or desktop applications
 *
 * @author RIAstar
 */
public class CallOutButton extends Button implements IDropDownContainer {

    /* ----------------- */
    /* --- skinparts --- */
    /* ----------------- */

    [SkinPart(required="false")]
    /**
     * Creates the dropdown instance.
     *
     * @default If this SkinPart is not defined, this defaults to a ClassFactory of CallOuts.
     */
    public var dropDown:IFactory;


    /* ------------------ */
    /* --- properties --- */
    /* ------------------ */

    [Inspectable(category="General", enumeration="rollOver,mouseOver,click", defaultValue="rollOver")]
    /**
     * The event that will cause the CallOut to open.
     *
     * @default MouseEvent.ROLL_OVER
     */
    public var triggerEvent:String = MouseEvent.ROLL_OVER;


    /* ------------------------------------ */
    /* --- wrapped 'callout' properties --- */
    /* ------------------------------------ */

    private var _callout:CallOut;
    [Bindable("calloutChanged")]
    /**
     * The actual CallOut instance.
     */
    public function get callout():CallOut {
        return _callout;
    }
    protected function setCallout(value:CallOut):void {
        _callout = value;
        if (hasEventListener("calloutChanged")) dispatchEvent(new Event("calloutChanged"));
    }

    private var _calloutContent:Array;
    [ArrayElementType("mx.core.IVisualElement")]
    /**
     * The content to be shown in the CallOut.
     */
    public function get calloutContent():Array {
        return _calloutContent;
    }
    public function set calloutContent(value:Array):void {
        _calloutContent = value;
        if (callout) callout.mxmlContent = value;
    }

    private var _calloutLayout:LayoutBase;
    /**
     * A wrapper for the CallOut's <code>layout</code> property.
     */
    public function get calloutLayout():LayoutBase {
        return _calloutLayout;
    }
    public function set calloutLayout(value:LayoutBase):void {
        _calloutLayout = value;
        if (callout) callout.layout = value;
    }


    /* --------------------------- */
    /* --- internal properties --- */
    /* --------------------------- */

    private var dropDownController:DropDownController;


    /* -------------------- */
    /* --- construction --- */
    /* -------------------- */

    /**
     * Set up dropDownController event handlers.
     *
     * @private
     */
    override public function initialize():void {
        dropDownController = new DropDownController();
        dropDownController.closeOnResize = false;
        dropDownController.addEventListener(DropDownEvent.OPEN, handleDropDownOpen);
        dropDownController.addEventListener(DropDownEvent.CLOSE, handleDropDownClose);
        dropDownController.rollOverOpenDelay = 0;
        dropDownController.openButton = this;

        super.initialize();
    }

    /**
     * Set up the CallOut instance.
     *
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void {
        super.partAdded(partName, instance);

        if (partName == "dropDown") {
            var calloutInstance:CallOut = instance as CallOut;

            if (calloutInstance && dropDownController) {
                calloutInstance.id = "callout";
                dropDownController.dropDown = calloutInstance;

                calloutInstance.addEventListener(PopUpEvent.OPEN, handleCalloutOpen);
                calloutInstance.addEventListener(PopUpEvent.CLOSE, handleCalloutClose);

                calloutInstance.mxmlContent = _calloutContent;
                if (_calloutLayout) calloutInstance.layout = _calloutLayout;
            }
        }
    }

    /**
     * Create a default <code>dropDown</code> factory if none exist in the Skin.
     *
     * @private
     */
    override protected function attachSkin():void {
        super.attachSkin();
        if (!dropDown && !("dropDown" in skin)) dropDown = new ClassFactory(CallOut);
    }


    /* ---------------------- */
    /* --- event handlers --- */
    /* ---------------------- */

    /**
     * When the dropdown is first activated, the CallOut instance is created on the fly.
     * Opens the CallOut.
     *
     * @param event
     */
    private function handleDropDownOpen(event:DropDownEvent):void {
        if (!callout) setCallout(createDynamicPartInstance("dropDown") as CallOut);
        if (!callout) return;

        addEventListener(Event.REMOVED_FROM_STAGE, handleButtonRemoved);
        callout.open(this, false);
    }

    /**
     * Closes the CallOut per dropdownController request.
     *
     * @param event
     */
    private function handleDropDownClose(event:DropDownEvent):void {
        if (!callout) return;

        removeEventListener(Event.REMOVED_FROM_STAGE, handleButtonRemoved);
        callout.close();
    }

    /**
     * Notify possible listeners that the CallOut was opened.
     *
     * @param event
     */
    private function handleCalloutOpen(event:PopUpEvent):void {
        dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
    }

    /**
     * Make sure it's really closed and notify possible listeners that the CallOut was closed.
     *
     * @param event
     */
    private function handleCalloutClose(event:PopUpEvent):void {
        if (dropDownController.isOpen) closeDropDown();

        /*if (calloutDestructionPolicy == ContainerDestructionPolicy.AUTO)
         destroyCallout();*/

        dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
    }

    /**
     * If the Button is being removed from the stage while the CallOut is open, close it.
     *
     * @param event
     */
    private function handleButtonRemoved(event:Event):void {
        if (!isDropDownOpen) return;

        callout.visible = false;
        closeDropDown();
    }


    /* ----------------- */
    /* --- behaviour --- */
    /* ----------------- */

    public function get isDropDownOpen():Boolean {
        return dropDownController ? dropDownController.isOpen : false;
    }

    public function openDropDown():void {
        dropDownController.openDropDown();
    }

    public function closeDropDown():void {
        dropDownController.closeDropDown(false);
    }

}
}
