package net.riastar.components.supportClasses {

/**
 * An interface to be implemented by any component that composes a dropdown of some kind.
 *
 * @author RIAstar
 */
public interface IDropDownContainer {

    /**
     * @return Whether the dropdown is currently open.
     */
    function get isDropDownOpen():Boolean;

    /**
     * Opens the dropdown if it isn't already open.
     */
    function openDropDown():void;

    /**
     * Closes the dropdown if it isn't already closed.
     */
    function closeDropDown():void;

}
}
